# LES

This directory integrates the `LearnedES` implementation from
[`evosax`](https://github.com/RobertTLange/evosax) with MToP.

MATLAB owns objective evaluation, function-evaluation accounting, boundary
penalties, and lexicographic constraint handling. The Python runner owns only
the learned `ask`/`tell` state. `RankWithBoundaryHandling` is converted to a
finite ordinal fitness before calling Python, so failed or infeasible objective
values cannot introduce `Inf`/`NaN` into the learned update.

The checkpoint bundled with evosax is an independently meta-trained
reimplementation. It is not the original checkpoint used for the ICLR 2023
paper and may produce different numerical results.

The bridge also contains a narrowly scoped compatibility fallback for loading
the evosax 0.2.0 checkpoint on recent JAX releases. It discards only the legacy
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
