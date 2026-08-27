"""Differentiable evolutionary operators used by ABOM.

The architecture follows the official ABOM implementation released for
Wang et al., "Task-free Adaptive Meta Black-box Optimization" (ICLR 2026).
"""

from __future__ import annotations

import math

import torch
from torch import Tensor, nn


class MutationOperator(nn.Module):
    """Variable-wise self-attention mutation."""

    def __init__(self, hidden_num: int) -> None:
        super().__init__()
        self.hidden_num = int(hidden_num)
        self.query = nn.Linear(1, self.hidden_num, bias=False)
        self.key = nn.Linear(1, self.hidden_num, bias=False)

    def forward(self, x: Tensor) -> Tensor:
        batch_size, pop_size, num_dims = x.shape
        values = x.reshape(batch_size * pop_size, num_dims, 1)
        expanded = x.unsqueeze(-1)
        query = self.query(expanded).reshape(
            batch_size * pop_size, num_dims, self.hidden_num
        )
        key = self.key(expanded).reshape(
            batch_size * pop_size, num_dims, self.hidden_num
        )
        attention = torch.softmax(
            torch.bmm(query, key.transpose(1, 2)) / math.sqrt(self.hidden_num),
            dim=-1,
        )
        mutated = torch.bmm(attention, values)
        return mutated.reshape(batch_size, pop_size, num_dims)


class CrossoverOperator(nn.Module):
    """Population-wise attention over decisions and fitness ranks."""

    def __init__(self, num_dims: int, attention_dim: int) -> None:
        super().__init__()
        self.attention_dim = int(attention_dim)
        self.query_x = nn.Linear(num_dims, attention_dim)
        self.key_x = nn.Linear(num_dims, attention_dim)
        self.query_f = nn.Linear(1, attention_dim)
        self.key_f = nn.Linear(1, attention_dim)

    def forward(self, x: Tensor, fitness_rank: Tensor) -> Tensor:
        scores_x = torch.bmm(
            self.query_x(x), self.key_x(x).transpose(-2, -1)
        ) / math.sqrt(self.attention_dim)
        scores_f = torch.bmm(
            self.query_f(fitness_rank),
            self.key_f(fitness_rank).transpose(-2, -1),
        ) / math.sqrt(self.attention_dim)
        attention = torch.softmax(scores_x + scores_f, dim=-1)
        return torch.bmm(attention, x)


class FeedForwardOperator(nn.Module):
    """Dimension-preserving MLP used after each attention operator."""

    def __init__(self, num_dims: int, hidden_dim: int) -> None:
        super().__init__()
        self.layers = nn.Sequential(
            nn.Linear(num_dims, hidden_dim, bias=False),
            nn.Tanh(),
            nn.Linear(hidden_dim, num_dims, bias=False),
        )

    def forward(self, x: Tensor) -> Tensor:
        return self.layers(x)


class ResidualOperator(nn.Module):
    """Attention operator followed by an MLP, dropout, and a residual step."""

    def __init__(
        self,
        operator: nn.Module,
        num_dims: int,
        hidden_dim: int,
        dropout: float,
        is_crossover: bool,
    ) -> None:
        super().__init__()
        self.operator = operator
        self.ffn = FeedForwardOperator(num_dims, hidden_dim)
        self.dropout = nn.Dropout(dropout)
        self.is_crossover = bool(is_crossover)

    def forward(
        self, x: Tensor, fitness_rank: Tensor, original_x: Tensor
    ) -> Tensor:
        if self.is_crossover:
            transformed = self.operator(x, fitness_rank)
        else:
            transformed = self.operator(original_x)
        return x + self.dropout(self.ffn(transformed))


def variable_swap(x: Tensor, generator: torch.Generator) -> Tensor:
    """Swap coordinates between paired halves of an even-sized population."""
    half = x.shape[1] // 2
    first = x[:, :half, :]
    second = x[:, half:, :]
    mask = torch.rand(
        x.shape[0], half, x.shape[2],
        dtype=x.dtype, device=x.device, generator=generator,
    ) > 0.5
    first_swapped = torch.where(mask, second, first)
    second_swapped = torch.where(mask, first, second)
    return torch.cat((first_swapped, second_swapped), dim=1)


class ABOMBlock(nn.Module):
    """One crossover--mutation--variable-swap block."""

    def __init__(
        self,
        num_dims: int,
        attention_dim: int,
        hidden_dim: int,
        dropout_c: float,
        dropout_m: float,
        generator: torch.Generator,
    ) -> None:
        super().__init__()
        self.generator = generator
        self.crossover = ResidualOperator(
            CrossoverOperator(num_dims, attention_dim),
            num_dims,
            hidden_dim,
            dropout_c,
            True,
        )
        self.mutation = ResidualOperator(
            MutationOperator(attention_dim),
            num_dims,
            hidden_dim,
            dropout_m,
            False,
        )

    def forward(self, parents: Tensor, fitness_rank: Tensor) -> Tensor:
        offspring = self.crossover(parents, fitness_rank, parents)
        offspring = self.mutation(offspring, fitness_rank, parents)
        return variable_swap(offspring, self.generator)


class ABOMNet(nn.Module):
    """Stack of differentiable ABOM evolutionary blocks."""

    def __init__(
        self,
        num_dims: int,
        attention_dim: int,
        hidden_dim: int,
        dropout_c: float,
        dropout_m: float,
        generator: torch.Generator,
        num_layers: int = 1,
    ) -> None:
        super().__init__()
        self.blocks = nn.ModuleList(
            ABOMBlock(
                num_dims,
                attention_dim,
                hidden_dim,
                dropout_c,
                dropout_m,
                generator,
            )
            for _ in range(num_layers)
        )

    def forward(self, parents: Tensor, fitness_rank: Tensor) -> Tensor:
        offspring = parents
        for block in self.blocks:
            offspring = block(offspring, fitness_rank)
        return offspring


__all__ = ["ABOMNet"]
