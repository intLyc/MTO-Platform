# ABOM

This directory integrates the task-free Adaptive Meta Black-box Optimization
Model (ABOM) with MToP.

ABOM is a population-based optimizer rather than an evolution strategy.
Accordingly, the MATLAB layer follows MToP's GA/DE lifecycle: MToP initializes
and evaluates populations, performs elitist survivor selection, handles
constraints, and counts function evaluations. The Python runner owns only the
differentiable crossover and mutation operators and their online AdamW update.
Each task has an independent ABOM model; no information is transferred between
tasks.

The network architecture and update follow the official implementation of:

> C. Wang, L. Jiao, L. Li, J. Zhao, G. Wang, F. Liu, and S. Yang,
> "Task-free Adaptive Meta Black-box Optimization," ICLR 2026.

Official paper: <https://openreview.net/forum?id=AufVSUgMUo>

Official source used as the implementation reference (commit
`79a2baec700ce0abc6cf7d4cba1e897989d80516`):
<https://github.com/xiaofangxd/ABOM>

## Fidelity and MToP adaptation

- Crossover and mutation dropout rates default to `0.95`.
- AdamW uses learning rate `1e-3` and weight decay `1e-5`.
- The attention dimension is the problem dimension.
- The MLP hidden dimension is the largest power of two no larger than the
  problem dimension.
- As in the released code, a new AdamW optimizer is constructed for each
  online update and Smooth-L1 loss is summed over the offspring population.
- Decisions are represented in MToP's normalized `[0,1]^D` space and clipped
  before evaluation. MToP's selected population is returned to Python as the
  next parent population and as the online learning target.

## Python setup

Python 3.10 or newer with PyTorch support is required. Install the dependencies
into the same interpreter used by MATLAB:

```bash
python -m pip install -r requirements.txt
```

Then configure MATLAB before starting MToP:

```matlab
pyenv('Version', '/path/to/python');
```
