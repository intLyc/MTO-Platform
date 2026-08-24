"""Small MATLAB-facing wrapper around evosax's LearnedES implementation."""

from __future__ import annotations

from typing import Any

try:
    import jax
    import jax.numpy as jnp
    import numpy as np
    from evosax.algorithms import LearnedES
except ImportError as exc:  # Give MATLAB a useful setup error.
    raise ImportError(
        "LES requires Python 3.10+ and the packages in requirements.txt"
    ) from exc


def _build_learned_es(population_size: int, solution: Any) -> LearnedES:
    """Construct LearnedES, including compatibility for its legacy checkpoint.

    The checkpoint bundled with evosax 0.2.0 pickled JAX abstract values that
    contain the since-removed ``named_shape`` field. Newer JAX releases reject
    that field while unpickling. The fallback ignores only that obsolete field
    during construction and restores JAX immediately afterwards.
    """
    try:
        return LearnedES(population_size=population_size, solution=solution)
    except TypeError as exc:
        if "named_shape" not in str(exc):
            raise

    from jax._src import core  # Imported only for the checkpoint fallback.

    original_update = core.ShapedArray.update

    def compatible_update(self: Any, **kwargs: Any) -> Any:
        kwargs.pop("named_shape", None)
        return original_update(self, **kwargs)

    core.ShapedArray.update = compatible_update
    try:
        return LearnedES(population_size=population_size, solution=solution)
    finally:
        core.ShapedArray.update = original_update


class LESRunner:
    """Own one evosax LearnedES ask/tell state for a single MToP task."""

    def __init__(
        self,
        population_size: int,
        num_dims: int,
        initial_mean: Any,
        initial_std: float,
        seed: int,
    ) -> None:
        self.population_size = int(population_size)
        self.num_dims = int(num_dims)
        if self.population_size < 2:
            raise ValueError("population_size must be at least two")
        if self.num_dims < 1:
            raise ValueError("num_dims must be positive")
        if not np.isfinite(initial_std) or float(initial_std) <= 0.0:
            raise ValueError("initial_std must be finite and positive")

        mean = np.asarray(initial_mean, dtype=np.float32).reshape(-1)
        if mean.shape != (self.num_dims,):
            raise ValueError(
                f"initial_mean has shape {mean.shape}; expected ({self.num_dims},)"
            )
        if not np.all(np.isfinite(mean)):
            raise ValueError("initial_mean must contain only finite values")

        solution = jnp.zeros((self.num_dims,), dtype=jnp.float32)
        self._strategy = _build_learned_es(
            population_size=self.population_size, solution=solution
        )
        self._params = self._strategy.default_params.replace(
            std_init=float(initial_std)
        )

        self._key = jax.random.key(int(seed))
        self._key, init_key = jax.random.split(self._key)
        self._state = self._strategy.init(
            init_key,
            jnp.asarray(mean),
            self._params,
        )
        self._last_population = None
        self._has_told = False

    def ask(self) -> np.ndarray:
        """Sample and retain a population until MATLAB returns its ranking."""
        if self._last_population is not None:
            raise RuntimeError("ask() was called twice without a matching tell()")

        self._key, ask_key = jax.random.split(self._key)
        population, self._state = self._strategy.ask(
            ask_key,
            self._state,
            self._params,
        )
        self._last_population = population
        return np.asarray(jax.device_get(population), dtype=np.float64)

    def tell(self, shaped_fitness: Any, best_improved: bool) -> np.ndarray:
        """Update LES using finite MToP fitness values (lower is better)."""
        if self._last_population is None:
            raise RuntimeError("tell() was called before ask()")

        fitness = np.asarray(shaped_fitness, dtype=np.float64).reshape(-1)
        if fitness.shape != (self.population_size,):
            raise ValueError(
                "shaped_fitness has shape "
                f"{fitness.shape}; expected ({self.population_size},)"
            )
        if not np.all(np.isfinite(fitness)):
            raise ValueError("shaped_fitness must contain only finite values")

        # LES internally computes a float32 z-score. Directly standardizing
        # objectives with a large offset and small within-generation variance
        # can suffer catastrophic cancellation (observed on 1000-D Griewank).
        # A positive affine transform preserves both ranks and z-scores while
        # keeping the internal variance calculation numerically well scaled.
        fitness_min = float(np.min(fitness))
        fitness_max = float(np.max(fitness))
        with np.errstate(over="ignore", invalid="ignore"):
            fitness_span = fitness_max - fitness_min
        if np.isfinite(fitness_span) and fitness_span > 0.0:
            fitness = (fitness - fitness_min) / fitness_span
        elif fitness_max > fitness_min:
            # The span can overflow even when every value is finite. Preserve
            # strict ordering as a safe fallback in this extreme case.
            order = np.argsort(fitness, kind="stable")
            ordinal = np.empty(self.population_size, dtype=np.float64)
            ordinal[order] = np.arange(self.population_size, dtype=np.float64)
            fitness = ordinal / max(1, self.population_size - 1)
        else:
            fitness = np.zeros(self.population_size, dtype=np.float64)
        fitness = fitness.astype(np.float32)

        # MToP performs the authoritative boundary/constraint comparison. LES's
        # first fitness feature asks whether a candidate beats the historical
        # best. A sentinel just above the current minimum marks the minimum
        # member(s) as improving when the MToP archive changed; otherwise no
        # member is marked. This works for raw, negative, and ordinal fitness.
        if self._has_told:
            current_min = float(np.min(fitness))
            next_value = float(
                np.nextafter(np.float32(current_min), np.float32(np.inf))
            )
            best_sentinel = (
                next_value
                if bool(best_improved) and np.isfinite(next_value)
                else current_min
            )
            self._state = self._state.replace(
                best_fitness_shaped=jnp.asarray(best_sentinel, dtype=jnp.float32)
            )

        self._key, tell_key = jax.random.split(self._key)
        self._state, _ = self._strategy.tell(
            tell_key,
            self._last_population,
            jnp.asarray(fitness),
            self._state,
            self._params,
        )
        self._last_population = None
        self._has_told = True
        return np.asarray(jax.device_get(self._state.mean), dtype=np.float64)

    def mean(self) -> np.ndarray:
        """Return the current search mean for diagnostics."""
        return np.asarray(jax.device_get(self._state.mean), dtype=np.float64)

    def std(self) -> np.ndarray:
        """Return the current diagonal search standard deviation."""
        return np.asarray(jax.device_get(self._state.std), dtype=np.float64)


__all__ = ["LESRunner"]
