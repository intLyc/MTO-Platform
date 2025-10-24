# 🧭 MTO Platform User Guide

[→ 中文指南](./User-Guide-CN.md)

[![](https://img.shields.io/badge/Matlab-%3E%3DR2022b-blue)](#)
[![](https://img.shields.io/badge/License-Academic-green)](#)

## Quick Start

### Run MTO Platform

- **GUI:** `mto`
- **Command-Line Examples:**
```matlab
mto({MFEA, MFDE},{CMT1, CMT2})
mto({MFEA, MFDE},{CMT1, CMT2}, 5, true, 100, false, 'MTOData.mat', 2333)
mto({MFEA, MFDE},{CMT1, CMT2}, 'Reps', 5, 'Par_Flag', true)
````

### Add Your Algorithm

1. Inherit the **Algorithm.m** class in the `Algorithms` folder.
2. Implement the method:

```matlab
function run(Algo, Prob)
```

3. Add labels in the second line:

```
<Multi-task/Many-task/Single-task> <Multi-objective/Single-objective> <None/Competitive/Constrained>
```

4. Refer to `MFEA` or `MO-MFEA` implementations for guidance.

### Add Your Problem

1. Inherit the **Problem.m** class in the `Problem` folder.
2. Implement the method:

```matlab
function Tasks = setTasks()
```

1. Add labels in the second line:

```
<Multi-task/Many-task/Single-task> <Multi-objective/Single-objective> <None/Competitive/Constrained>
```

4. Refer to `CEC17_MTSO` or `MTMO_Instance1` for examples.

### Add Your Metric

1. Inherit the **Metric.m** class in the `Metric` folder.
2. Add labels in the second line: `<Metric>`
3. Refer to `Obj.m` and `IGD.m` implementations.

---

## Modules

### 1. Test Module

<img src="./ReadmeFigure/MTO-Platform%20Test%20Module.png" width="300px">
<img src="./ReadmeFigure/MTO-Platform%20Test%20Module%202.png" width="300px">
<img src="./ReadmeFigure/MTO-Platform%20Test%20Module%203.png" width="300px">
<img src="./ReadmeFigure/MTO-Platform%20Test%20Module%204.png" width="300px">

* **Algorithm selection:** select and open an algorithm to modify parameters (double-click).
* **Problem selection:** select and open a problem to modify parameters.
* **Run:** click **Start**.
* **View figures:**

  * 1D Task Figure (normalized / real)
  * 2D Task Figure (normalized / real)
  * 2D Feasible Region
  * Convergence plot
  * Pareto Front

### 2. Experiment Module

<img src="./ReadmeFigure/MTO-Platform%20Experiment%20Module.png" width="300px">
<img src="./ReadmeFigure/MTO-Platform%20Experiment%20Module%202.png" width="300px">
<img src="./ReadmeFigure/MTO-Platform%20Experiment%20Module%203.png" width="300px">

1. **Parameters:**

   * Repetitions: number of independent runs
   * Data Length: convergence data length
   * Save Dec: save decision variables flag
   * Parallel: parallel execution flag

2. **Algorithm selection:**

   * Click **Add** to add algorithms to Selected Algorithms
   * Expand and double-click to edit parameters or algorithm names
   * Multi-selectable; right-click to select all

3. **Problem selection:**

   * Click **Add** to add problems to Selected Problems
   * Expand and double-click to edit parameters or problem names
   * Multi-selectable; right-click to select all

4. **Start / Pause / Stop**

   * Click **Start** to run experiments
   * **Pause** and **Resume** to control running
   * **Stop** to terminate

5. **Table Statistics:**

   * Display metrics and draw convergence plots / Pareto front
   * Data type: Mean, Mean&Std, Std, Median, Best, Worst
   * Statistical test: None, Wilcoxon, Friedman
   * Highlight data: None, Highlight best, Highlight best & worst
   * Click **Save** to save table data

6. **Read / Save Data**

   * Click **Save Data** to store experiment results
   * Click **Load Data** to read saved data

### 3. Data Process Module

1. **Read Data:** click **Load Data** to add data to Data Tree
2. **Delete Data:** select and click **Delete Data**
3. **Save Data:** select and click **Save Data**
4. **Data Split:** by Reps, Algorithms, Problems
5. **Data Merge:** by Reps, Algorithms, Problems

---

## Tips

* Multi-task / many-task problems can be handled via selected algorithms
* Parallel flag is only effective for independent repetitions
* Always save your data after Metric calculations
