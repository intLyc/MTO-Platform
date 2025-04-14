
# User Guide

[-> In Chinese <-](#中文指南)

### Run MTO Platform

- GUI: mto
- Command line: mto(AlgoCell, ProbCell, Reps, Par_Flag, Results_num, Save_Dec, Save_Name)
- Example: mto({'MFEA','AT-MFEA'},{'CEC17_MTSO1_CI_HS','CEC17_MTSO2_CI_MS'},30,true,50,false,'MTODataSave')

### Add your algorithm

- Inherit the **Algorithm.m** class from the Algorithms' folder to implement a new algorithm class and put it in the Algorithms folder or its subfolders
- Implement the method function data = run().
- Add labels to the second line. <Multi-task/Many-task/Single-task> <Multi-objective/Single-objective> <None/Competitive/Constrained>
- *Refer to the MFEA or MO-MFEA algorithm implementation*

### Add your problem

- Inherit the **Problem.m** class from the Problem folder to implement a new problem class and put it in the Problem folder or its subfolders
- Implement the method function Tasks = setTasks()
- Add labels to the second line. <Multi-task/Many-task/Single-task> <Multi-objective/Single-objective> <None/Competitive/Constrained>
- *Refer to the CEC17_MTSO or MTMO_Instance1 problem implementation*

### Add your metric

- Inherit the **Metric.m** class from the Metric folder to implement a new metric class and put it in the Metric folder or its subfolders
- Add labels to the second line. <Metric>
- *Refer to the Obj.m and IGD.m metric implementation*

## Module

### I. Test Module

<img src="./ReadmeFigure/MTO-Platform%20Test%20Module.png" width="300px">
<img src="./ReadmeFigure/MTO-Platform%20Test%20Module%202.png" width="300px">
<img src="./ReadmeFigure/MTO-Platform%20Test%20Module%203.png" width="300px">
<img src="./ReadmeFigure/MTO-Platform%20Test%20Module%204.png" width="300px">

1. Algorithm selection
    - Select an algorithm to be displayed in the Algorithm Tree
    - Open the Algorithm, and it will show the algorithm parameter settings. *Double-click to modify*
2. Problem selection
    - Select a problem and display it in the Problem Tree
    - Open the Problem Node to display the problem parameter settings. *Double-click to modify*
3. Run
    - Click the Start button
4. Check the figure
    - Task Figure 1D (unified / real)
    - Task Figure 2D (unified / real)
    - Feasible Region 2D
    - Obj Convergence
    - Pareto Front

### II. Experiment Module

<img src="./ReadmeFigure/MTO-Platform%20Experiment%20Module.png" width="400px">
<img src="./ReadmeFigure/MTO-Platform%20Experiment%20Module%202.png" width="400px">
<img src="./ReadmeFigure/MTO-Platform%20Experiment%20Module%203.png" width="400px">

1. parameter settings
    - No. of Runs: Number of independent run times
    - No. of Results: Number of save results
    - Parallel：Parallel execution

2. Algorithm selection
    - After selecting an algorithm in Algorithms, click Add button, it will add the algorithm to Selected Algorithms, you can expand the algorithm and double-click to modify the parameters or algorithm name, double-click to modify the parameters or algorithm name. *Multi-selectable, right-click to select all, can be added repeatedly*
    - Select the algorithm in Selected Algorithms and click the Delete button to delete the selected algorithm. *Multi-selectable, right-click to select all*

3. Problem Selection
    - After selecting the problem in Problems, click Add button, it will add the problem to Selected Problems, you can expand the problem and double-click to modify the parameters or problem name.  *Multi-selectable, right-click to select all, can be added repeatedly*
    - Select the problem in Selected Problems and click the Delete button to delete the selected problem. *Multi-selectable, right-click to select all*.

4. Start/Pause/Stop
    - After selecting the algorithm and problem, click the Start button to start running.
    - In the process of running, click the Pause button to pause, and then click the Resume button to continue.
    - In the process of running, click the Stop button to stop running.
  
5. Table Statistics
    - Display data with metric
    - Draw Metric Convergence. *Select table cell first.*
    - Draw Pareto Front Results. *Select table cell first.*
    - Data type
      - Mean
      - Mean&Std
      - Std
      - Median
      - Best
      - Worst
    - Statistical test
      - None
      - Wilcoxon Rank-sum test
      - Wilcoxon Signed-rank test
      - Friedman test (mean value)
      - Friedman test (all reps value)
    - Highlight data
      - None
      - Highlight best
      - Highlight best worst
    - Save the data, click the blue Save button to save the current table content

6. Read/Save Data
    - To save data, click the Save Data button to save the data of the currently running experiment
    - Read data, click the Load Data button, read the saved experimental data, and display the data

### III. Data Process Module

1. Read data
    - Click the Load Data button, read the saved experimental data, and add it to the Data Tree. *Multi-selectable, can be added repeatedly*
    - Expand the data in the Data Tree can display the specific content of the data, *can modify the name of the data*

2. Delete Data
    - Select the data in Data Tree and click the Delete Data button to delete. Click the Delete Data button to delete. *Multi-selectable, right-click to select all*

3. Save Data
    - Select the data in the Data Tree and click the Save Data button to save it. *Multi-selectable*

4. Data split
    - Split by the number of independent runs, select more than 1 data in the Data Tree, click the Reps Split button to split the selected data by each independent run and add it to the Data Tree.
    - Split by Algorithms, select more than 1 data item in the Data Tree, click the Algorithms Split button to split the selected data by algorithms and add them to the Data Tree.
    - Split by Problem, select more than 1 data item in the Data Tree, click on the Problems Split button to split the selected data by problem and add it to the Data Tree.

5. Data Merge
    - Merge by independent runs, select 2 or more data in Data Tree, *provided that all settings are the same except the number of runs*, click the Reps Merge button to merge the selected data by the number of independent runs and add them to the Data Tree.
    - Merge by Algorithm, select more than 2 data items in Data Tree, *provided that all settings are the same except Algorithm*, click Algorithms Merge button to merge the selected data by the algorithm and add them to the Data Tree.
    - Merge by Problem, select more than 2 data items in Data Tree, *provided all settings are the same except Problem*, click the Problems Merge button to merge the selected data by problem and add them to the Data Tree.

---

# 中文指南

### 运行MTO Platform

- GUI界面: mto
- 命令行: mto(AlgoCell, ProbCell, Reps, Par_Flag, Results_num, Save_Dec, Save_Name)
- 示例: mto({'MFEA','AT-MFEA'},{'CEC17_MTSO1_CI_HS','CEC17_MTSO2_CI_MS'},30,true,50,false,'MTODataSave')

### 加入自己的算法

- 继承Algorithms文件夹下的**Algorithm.m**类实现新的算法类，并放入Algorithms文件夹或其子文件夹内
- 实现 function data = run()
- 在文件的第2行添加标签 <Multi-task/Many-task/Single-task> <Multi-objective/Single-objective> <None/Competitive/Constrained>
- *可参考 MFEA、MO-MFEA 算法的实现*

### 加入自己的问题

- 继承Problem文件夹下的**Problem.m**类实现新的问题类，并放入Problem文件夹或其子文件夹内
- 实现 function Tasks = setTasks()
- 按照Problem类中的各虚函数的注释实现继承的虚函数
- 在文件的第2行添加标签 <Multi-task/Many-task/Single-task> <Multi-objective/Single-objective> <None/Competitive/Constrained>
- *可参考 CEC17_MTSO、MTMO_Instance1 问题的实现*

### 加入自己的指标

- 继承Metric文件夹下的**Metric.m**类实现新的指标类，并放入Metric文件夹或其子文件夹内
- 在文件的第2行添加标签 <Metric>，对应于列表数据展示和图像数据展示
- *可参考 Obj.m、IGD.m 的实现*

## 功能

### 一、测试模块

<img src="./ReadmeFigure/MTO-Platform%20Test%20Module.png" width="300px">
<img src="./ReadmeFigure/MTO-Platform%20Test%20Module%202.png" width="300px">
<img src="./ReadmeFigure/MTO-Platform%20Test%20Module%203.png" width="300px">
<img src="./ReadmeFigure/MTO-Platform%20Test%20Module%204.png" width="300px">

1. 算法选择
    - 选取一个算法，显示在Algorithm Tree中
    - 打开Algorithm会显示算法参数设置。*双击修改*
2. 问题选择
    - 选取一个问题，显示在Problem Tree中
    - 打开Problem Node会显示问题参数设置。*双击修改*
3. 算法运行
    - 点击Start按钮开始运行
4. 查看图像
    - 问题1维图像（归一化/原始）
    - 问题2维图像（归一化/原始）
    - 可行域2维图像
    - 收敛图，运行完后显示
    - Pareto前沿，运行完后显示

### 二、实验模块

<img src="./ReadmeFigure/MTO-Platform%20Experiment%20Module.png" width="400px">
<img src="./ReadmeFigure/MTO-Platform%20Experiment%20Module%202.png" width="400px">
<img src="./ReadmeFigure/MTO-Platform%20Experiment%20Module%203.png" width="400px">

1. 参数设置
    - No. of Runs: 独立运行次数
    - No. of Results: 结果保存次数
    - Parallel: 是否开启并行

2. 算法选择
    - 在Algorithms中选择算法后，点击Add按钮，会将算法添加到Selected Algorithms中，可以展开算法，双击修改参数或算法名称。*可多选，右键全选，可重复添加*
    - 在Selected Algorithms中选择算法，点击Delete按钮删除所选算法。*可多选，右键全选*

3. 问题选择
    - 在Problems中选择问题后，点击Add按钮，会将问题添加到Selected Problems中，可以展开问题，双击修改参数或问题名称。*可多选，右键全选，可重复添加*
    - 在Selected Problems中选择问题，点击Delete按钮删除所选问题。*可多选，右键全选*

4. 开始/暂停/终止
    - 选取算法和问题后，点击Start按钮开始运行
    - 在运行过程中，点击Pause按钮暂停，再点击Resume继续
    - 在运行过程中，点击Stop按钮终止
  
5. 表格统计
    - 显示数据，由Metric计算
    - 绘制Metric收敛图，*先从表格中选取数据*
    - 绘制Pareto前沿结果，*先从表格中选取数据*
    - 数据类型
      - Mean 平均目标值
      - Mean&Std 平均目标值 (标准差)
      - Std 目标值标准差
      - Median 目标值中位数
      - Best 最优目标值
      - Worst 最差目标值
    - 统计测试
      - None
      - Wilcoxon Rank-sum test / Wilcoxon 秩和检验
      - Wilcoxon Signed-rank test / Wilcoxon 符号秩检验
      - Friedman test (mean) / Friedman 检验 (均值作为观测)
      - Friedman test (reps) / Friedman 检验 (独立运行数据作为观测)
    - 高亮数据
      - None 无高亮
      - Highlight best 高亮最优值
      - Highlight best worst 高亮最优值和最差值
    - 保存数据，点击Save按钮，保存当前表格内容

6. 读取/保存数据
    - 保存数据，点击Save Data按钮，保存当前运行实验的数据
    - 读取数据，点击Load Data按钮，读取保存的实验数据，并显示数据

### 三、数据处理模块

1. 读取数据
    - 点击Load Data按钮，读取保存的实验数据，加入Data Tree。*可多选，可重复添加*
    - 在Data Tree中展开数据可显示数据具体内容，*可修改数据名称*

2. 删除数据
    - 选取Data Tree中的数据，点击Delete Data按钮进行删除。*可多选，右键全选*

3. 保存数据
    - 选取Data Tree中的数据，点击Save Data按钮进行保存。*可多选，右键全选*

4. 数据分割
    - 按独立运行次数分割，在Data Tree中选取1条以上的数据，点击Reps Split按钮，可将选取的数据按照每次独立运行分割，并添加到Data Tree中
    - 按算法分割，在Data Tree中选取1条以上的数据，点击Algorithms Split按钮，可将选取的数据按照算法运行分割，并添加到Data Tree中
    - 按问题分割，在Data Tree中选取1条以上的数据，点击Problems Split按钮，可将选取的数据按照问题分割，并添加到Data Tree中

5. 数据合并
    - 按独立运行次数合并，在Data Tree中选取2条以上的数据，*前提是除运行次数外其他设置相同*，点击Reps Merge按钮，可将选取的数据按照独立运行次数合并，并添加到Data Tree中
    - 按算法合，在Data Tree中选取2条以上的数据，*前提是除算法外其他设置相同*，点击Algorithms Merge按钮，可将选取的数据按照算法合并，并添加到Data Tree中
    - 按问题合并，在Data Tree中选取2条以上的数据，*前提是除问题外其他设置相同*，点击Problems Merge按钮，可将选取的数据按照问题合并，并添加到Data Tree中
