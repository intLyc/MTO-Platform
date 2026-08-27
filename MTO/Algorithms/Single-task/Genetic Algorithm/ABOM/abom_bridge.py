"""MATLAB-facing stateful runner for task-free online ABOM updates."""

from __future__ import annotations

from typing import Any, Callable, TypeVar

try:
    import numpy as np
    import torch
    from torch import nn

    from abom_net import ABOMNet
except ImportError as exc:
    raise ImportError(
        "ABOM requires Python 3.10+ and the packages in requirements.txt"
    ) from exc


_T = TypeVar("_T")


class ABOMRunner:
    """Own one ABOM population and differentiable model for one MToP task."""

    def __init__(
        self,
        population_size: int,
        num_dims: int,
        initial_population: Any,
        lower_bounds: Any,
        upper_bounds: Any,
        seed: int,
        learning_rate: float = 1e-3,
        weight_decay: float = 1e-5,
        dropout_c: float = 0.95,
        dropout_m: float = 0.95,
    ) -> None:
        self.population_size = int(population_size)
        self.num_dims = int(num_dims)
        self.learning_rate = float(learning_rate)
        self.weight_decay = float(weight_decay)
        self.dropout_c = float(dropout_c)
        self.dropout_m = float(dropout_m)

        if self.population_size < 2 or self.population_size % 2 != 0:
            raise ValueError("population_size must be positive and even")
        if self.num_dims < 1:
            raise ValueError("num_dims must be positive")
        if not np.isfinite(self.learning_rate) or self.learning_rate <= 0.0:
            raise ValueError("learning_rate must be finite and positive")
        if not np.isfinite(self.weight_decay) or self.weight_decay < 0.0:
            raise ValueError("weight_decay must be finite and nonnegative")
        if not 0.0 <= self.dropout_c < 1.0:
            raise ValueError("dropout_c must be in [0, 1)")
        if not 0.0 <= self.dropout_m < 1.0:
            raise ValueError("dropout_m must be in [0, 1)")

        self._lower_bounds = self._validate_bounds(lower_bounds, "lower_bounds")
        self._upper_bounds = self._validate_bounds(upper_bounds, "upper_bounds")
        if np.any(self._upper_bounds <= self._lower_bounds):
            raise ValueError("upper_bounds must be greater than lower_bounds")

        parents = self._validate_population(initial_population, "initial_population")
        if np.any(parents < self._lower_bounds) or np.any(parents > self._upper_bounds):
            raise ValueError("initial_population must lie within the task bounds")
        self._parents = parents.copy()
        self._generation = 0
        self._raw_output: torch.Tensor | None = None

        # The paper sets d_A=d and d_M to the largest power of two no larger
        # than d. A per-run generator controls variable swapping.
        attention_dim = self.num_dims
        hidden_dim = 1 << (self.num_dims.bit_length() - 1)
        self._generator = torch.Generator(device="cpu")
        self._generator.manual_seed(int(seed))
        self._lower_tensor = torch.from_numpy(self._lower_bounds).reshape(
            1, 1, self.num_dims
        )
        self._upper_tensor = torch.from_numpy(self._upper_bounds).reshape(
            1, 1, self.num_dims
        )

        # nn.Dropout uses PyTorch's process-global CPU RNG. Preserve a private
        # state per task so sequential MToP tasks remain independently seeded.
        previous_state = torch.random.get_rng_state()
        try:
            torch.manual_seed(int(seed))
            self._model = ABOMNet(
                num_dims=self.num_dims,
                attention_dim=attention_dim,
                hidden_dim=hidden_dim,
                dropout_c=self.dropout_c,
                dropout_m=self.dropout_m,
                generator=self._generator,
            ).double()
            for name, parameter in self._model.named_parameters():
                if "weight" in name:
                    nn.init.xavier_uniform_(parameter)
                elif "bias" in name:
                    nn.init.zeros_(parameter)
            self._dropout_rng_state = torch.random.get_rng_state()
        finally:
            torch.random.set_rng_state(previous_state)

    def _validate_population(self, values: Any, name: str) -> np.ndarray:
        population = np.asarray(values, dtype=np.float64)
        expected = (self.population_size, self.num_dims)
        if population.shape != expected:
            raise ValueError(f"{name} has shape {population.shape}; expected {expected}")
        if not np.all(np.isfinite(population)):
            raise ValueError(f"{name} must contain only finite values")
        return population

    def _validate_bounds(self, values: Any, name: str) -> np.ndarray:
        bounds = np.asarray(values, dtype=np.float64).reshape(-1)
        if bounds.shape != (self.num_dims,):
            raise ValueError(
                f"{name} has shape {bounds.shape}; expected ({self.num_dims},)"
            )
        if not np.all(np.isfinite(bounds)):
            raise ValueError(f"{name} must contain only finite values")
        return bounds

    def _with_dropout_rng(self, operation: Callable[[], _T]) -> _T:
        previous_state = torch.random.get_rng_state()
        try:
            torch.random.set_rng_state(self._dropout_rng_state)
            result = operation()
            self._dropout_rng_state = torch.random.get_rng_state()
            return result
        finally:
            torch.random.set_rng_state(previous_state)

    def ask(self) -> np.ndarray:
        """Generate a bounded offspring population and retain its graph."""
        if self._raw_output is not None:
            raise RuntimeError("ask() was called twice without a matching tell()")

        parents = torch.from_numpy(self._parents).unsqueeze(0)
        fitness_rank = torch.arange(
            self.population_size, dtype=torch.float64
        ).reshape(1, self.population_size, 1)

        self._model.train()
        self._raw_output = self._with_dropout_rng(
            lambda: self._model(parents, fitness_rank)
        )
        offspring = torch.maximum(
            torch.minimum(self._raw_output.detach(), self._upper_tensor),
            self._lower_tensor,
        )
        offspring_np = offspring.squeeze(0).cpu().numpy()
        if not np.all(np.isfinite(offspring_np)):
            self._raw_output = None
            raise FloatingPointError("ABOM generated non-finite offspring")
        return np.asarray(offspring_np, dtype=np.float64)

    def tell(self, selected_population: Any) -> float:
        """Adapt ABOM toward MToP's elitist survivor population."""
        if self._raw_output is None:
            raise RuntimeError("tell() was called before ask()")

        selected = self._validate_population(selected_population, "selected_population")
        if np.any(selected < self._lower_bounds) or np.any(selected > self._upper_bounds):
            raise ValueError("selected_population must lie within the task bounds")
        target_best = torch.from_numpy(selected[0]).reshape(1, 1, self.num_dims)
        target_best = target_best.repeat(1, self.population_size, 1)

        # Match the released ABOM: AdamW is reconstructed at every generation,
        # and the unbounded network output is trained toward the best survivor.
        optimizer = torch.optim.AdamW(
            self._model.parameters(),
            lr=self.learning_rate,
            weight_decay=self.weight_decay,
        )
        optimizer.zero_grad(set_to_none=True)
        loss = nn.functional.smooth_l1_loss(
            self._raw_output, target_best, beta=1.0, reduction="sum"
        )
        if not bool(torch.isfinite(loss)):
            self._raw_output = None
            raise FloatingPointError("ABOM produced a non-finite adaptation loss")
        loss.backward()
        optimizer.step()

        for parameter in self._model.parameters():
            if not bool(torch.all(torch.isfinite(parameter))):
                self._raw_output = None
                raise FloatingPointError("ABOM produced non-finite model parameters")

        self._parents = selected.copy()
        self._generation += 1
        self._raw_output = None
        return float(loss.detach().cpu())

    def parents(self) -> np.ndarray:
        """Return the current sorted survivor population for diagnostics."""
        return self._parents.copy()

    def generation(self) -> int:
        return self._generation


__all__ = ["ABOMRunner"]
