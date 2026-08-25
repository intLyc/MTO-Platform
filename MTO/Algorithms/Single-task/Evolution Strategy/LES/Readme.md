# LES

This directory integrates the `LearnedES` implementation from
[`evosax`](https://github.com/RobertTLange/evosax) with MToP.

MATLAB owns objective evaluation, function-evaluation accounting, boundary
penalties, and lexicographic constraint handling. The Python runner owns only
the learned `ask`/`tell` state. For an unconstrained finite population, MATLAB
passes boundary-penalized objective values so LES retains both its rank and
z-score fitness features. If constraints are violated or an evaluation is not
finite, `RankWithBoundaryHandling` is converted to finite ordinal fitness so
`Inf`/`NaN` cannot destabilize the learned update.

Before the JAX update, the bridge applies a positive affine normalization to
each generation's finite fitness values. LES uses only improvement, rank, and
z-score fitness features, so this preserves its inputs while preventing
float32 cancellation when a high-dimensional problem has a large objective
offset but very small within-generation variance.

The bridge explicitly loads `2023_03_les_v1.pkl` from the installed evosax
package. evosax 0.2.0 also bundles `2023_10_les_v2.pkl` and otherwise selects
that later checkpoint by default.

The bridge also contains a narrowly scoped compatibility fallback for loading
the v1 checkpoint on recent JAX releases. It discards only the legacy
pickled `named_shape` metadata and restores the original JAX class immediately
after loading.

## Python setup

Python 3.10 or newer is required. Python 3.11 is recommended for a conservative
MATLAB/JAX setup.

```bash
python -m pip install -r requirements.txt
```

Before starting an MToP run, point MATLAB at that interpreter. MATLAB may need
to be restarted if a different Python interpreter is already loaded.

```matlab
pyenv('Version', '/path/to/python');
```

For MATLAB versions that support it, `ExecutionMode` set to `OutOfProcess` can
isolate MATLAB from JAX native libraries.
