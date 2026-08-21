# MaT-Gym: Many-Task Gymnasium Benchmark

**MaT-Gym** is designed for **Many-Task Reinforcement Learning (RL)** and **Evolutionary Multitasking** research. It bridges the numerical optimization capabilities of MATLAB with the extensive environment suite of Python's `gymnasium`.

## Key Features

* **18 Diverse Tasks**: Includes Classic Control, Box2D, and MuJoCo environments (e.g., `Ant-v5`, `Humanoid-v5`, `BipedalWalker-v3`).
* **Dynamic MLP Architecture**: The neural network policy depth and width are configurable via MATLAB hyperparameters.
* **Numerical Stability**: Implements **Welford’s Online Algorithm** for real-time observation normalization (z-score).
* **Controlled Randomness**: Random seeds are generated in MATLAB and passed to Python to ensure experimental reproducibility.
* **Vectorized Execution**: Supports `SyncVectorEnv` for high-throughput parallel evaluation of populations.

## Installation & Requirements

### Python Environment

1. Ensure you have Python 3.8+ installed.
2. Install the required dependencies:
    ```bash
    pip install -r requirements.txt
    ```

### MATLAB Configuration (`pyenv`)

To allow MATLAB to call the Python scripts, you must configure the Python interpreter within MATLAB.

1. **Locate your Python Executable**:
   * Windows: `where python`
   * Linux/macOS: `which python`


2. **Set the Python Environment in MATLAB**:
    Run the following commands in the MATLAB Command Window:
    ```matlab
    % Replace with your actual path
    py_path = 'C:\Path\To\Your\Python\python.exe'; 
    % Configure pyenv
    pyenv('Version', py_path);
    % Verify configuration
    pe = pyenv;
    fprintf('Using Python version %s\n', pe.Version);
    ```

## Save Trained Policies

The shared `HandlePolicySearchResult.m` utility in the parent `Policy Search` directory handles progress output and final policy saving for both `MaT_Gym` and `MaT_Brax` problems. The current MToP `Algorithm` base class already calls it, so no additional modification is required when using the provided base class.

For an older or customized `Algorithm` base class, add the following call near the end of `notTerminated`, after the generation state and status callback have been updated:

```matlab
drawnow('limitrate');
Algo.Check_Status_Fn();

HandlePolicySearchResult(Algo, Prob);
```

Ensure the MToP directories, including `MTO/Problems/Policy Search`, are on the MATLAB path. The helper safely returns without doing anything for unrelated problem classes.

During a `MaT_Gym` run, the helper prints the best reward found for each task. When `Algo.FE >= Prob.maxFE`, it saves:

* Real-valued policy parameters in `<ProblemFolder>/Data/<AlgorithmName>/<AlgorithmName>_Dec_<timestamp>.mat` as `Dec`.
* Observation mean/std and network architecture in `<ProblemFolder>/Data/<AlgorithmName>/<AlgorithmName>_Normalizer_<timestamp>.mat` as `normalizer`.

These files can be used to reconstruct and render the trained policies. The helper is intended for the single-objective `MaT_Gym` and `MaT_Brax` problem classes; multi-objective policy-search problems require their own Pareto-set saving logic.
