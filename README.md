# MTO Platform

[中文介绍](#中文介绍)

**Author: Yanchi Li**

**Email: int_lyc@cug.edu.cn**

## Introduction

The Multi-Task Optimization Platform (MTO Platform) is inspired by [PlatEMO](https://github.com/BIMK/PlatEMO) and designed to facilitate experiments on multi-task optimization algorithms.

Environment: **Matlab >= R2020b**

### Related Websites
[http://www.bdsc.site/websites/MTO/index.html](http://www.bdsc.site/websites/MTO/index.html)

[http://www.bdsc.site/websites/ETO/ETO.html](http://www.bdsc.site/websites/ETO/ETO.html)

## Guide

### Run MTO Platform

- matlab run **MTO.m**

### Add your own algorithm

- Inherit the **Base/Algorithm** class from the Algorithms folder to implement a new algorithm class and put it in the Algorithms folder or its subfolders
- Implement the inherited virtual functions according to the annotations of each virtual function in the Algorithm class.
- *Refer to the MFEA algorithm implementation*

### Add your own problem

- Inherit the **Base/Problem** class from the Problem folder to implement a new problem class and put it in the Problem folder or its subfolders
- Implement the inherited virtual functions according to the annotations of each virtual function in the Problem class.
- *Refer to the CEC2017_MTSO problem implementation*

### Use App Designer to modify the GUI interface

- Open the **GUI/MTO_Platform.mlapp** project file with App Designer in matlab and modify the GUI interface.
- Export to MTO.m file after modification


## Module

### I. Test Module

![Test Module Tasks](./Readme_Figure/MTO-Platform%20Test%20Module.png)
![Test Module Convergence](./Readme_Figure/MTO-Platform%20Test%20Module%202.png)

1. Algorithm selection
    - Select an algorithm to be displayed in the Algorithm Tree
    - Open the Algorithm and it will show the algorithm parameter settings. *double click to modify it*
2. Problem selection
    - Select a problem and display it in the Problem Tree
    - Open the Problem Node to display the problem parameter settings. *double click to modify it*
3. 1-dimensional image of the problem
    - Select Tasks Figure (1D) in the upper right corner of the Axes area on the Test Module right.
    - For each selected problem, draw the image of all the tasks of the problem independent variable in 1D. *To facilitate the observation of inter-task characteristics, the adaptation value of each task is normalized to show*
4. Convergence graph
    - Select Convergence in the upper right corner of the Axes area on the right
    - After selecting the algorithm and task, click the Start button, the convergence image of the algorithm on each task of the problem will be plotted in the Axes area

### II. Experiment Module

![Experiment Module Table](./Readme_Figure/MTO-Platform%20Experiment%20Module.png)
![Experiment Module Figure](./Readme_Figure/MTO-Platform%20Experiment%20Module%202.png)

1. parameter settings
    - Run Times: Number of independent runs
    - Parallel：Parallel execution

2. Algorithm selection
    - After selecting an algorithm in Algorithms, click Add button, it will add the algorithm to Selected Algorithms, you can expand the algorithm and double click to modify the parameters or algorithm name, double-click to modify the parameters or algorithm name. *Multi-selectable, right-click to select all, can be added repeatedly*
    - Select the algorithm in Selected Algorithms and click the Delete button to delete the selected algorithm. *Multi-selectable, right-click to select all*

3. Problem Selection
    - After selecting the problem in Problems, click Add button, it will add the problem to Selected Problems, you can expand the problem and double click to modify the parameters or problem name.  *Multi-selectable, right-click to select all, can be added repeatedly*
    - Select the problem in Selected Problems and click the Delete button to delete the selected problem. *Multi-selectable, right-click to select all*. 

4. Start/Pause/Stop
    - After selecting the algorithm and problem, click Start button to start running.
    - In the process of running, click Pause button to pause, and then click Resume button to continue.
    - In the process of running, click Stop button to stop running.
  
5. Table Statistics
    - Select Table on the right side to display the experimental data
    - Display data
      - Reps
      - Fitness
      - Score
      - Time Used
    - Data type
      - Mean
      - Mean (Std)
      - Median
      - Median (Std)
    - Precision
      - %.2d
      - %.4d
    - Statistical test (for Fitness)
      - None
      - Rank sum test
      - Signed rank test
    - Highlight data
      - None
      - Highlight best
      - Highlight best worst
    - Save the data, click the Save button to save the current table content

6. Convergence graph
    - Select Figure on the right side to display the experimental convergence graph
    - Y-axis type
      - log(fitness)
      - fitness
    - Problem selection, select a task of a problem, display the convergence graph of each algorithm of the task
    - Save all data, select the save file type, click Save All Firuge button to save the convergence graphs of all tasks. *You can modify **drawFigure.m** in the GUI/Utils folder to adjust the drawing details*.

7. Read/Save Data
    - To save data, click the Save Data button to save the data of the currently running experiment
    - Read data, click Load Data button, read the saved experimental data, and display the data


### III. Data Process Module

1. Read data
    - Click the Load Data button, read the saved experimental data, add to the Data Tree. *Multi-selectable, can be added repeatedly*
    - Expand the data in the Data Tree can display the specific content of the data, *can modify the name of the data*

2. Delete Data
    - Select the data in Data Tree and click Delete Data button to delete. Click the Delete Data button to delete. *Multi-selectable, right-click to select all*

3. Save Data
    - Select the data in the Data Tree and click the Save Data button to save it. *Multi-selectable*

4. Data split
    - Split by number of independent runs, select more than 1 data in the Data Tree, click the Reps Split button to split the selected data by each independent run and add it to the Data Tree.
    - Split by Algorithms, select more than 1 data item in the Data Tree, click the Algorithms Split button to split the selected data by algorithms and add them to the Data Tree.
    - Split by Problem, select more than 1 data item in the Data Tree, click on the Problems Split button to split the selected data by problem and add it to the Data Tree.

5. Data Merge
    - Merge by independent runs, select 2 or more data in Data Tree, *provided that all settings are the same except the number of runs*, click the Reps Merge button to merge the selected data by the number of independent runs and add them to the Data Tree.
    - Merge by Algorithm, select more than 2 data items in Data Tree, *provided that all settings are the same except Algorithm*, click Algorithms Merge button to merge the selected data by algorithm and add them to Data Tree.
    - Merge by Problem, select more than 2 data items in Data Tree, *provided all settings are the same except Problem*, click the Problems Merge button to merge the selected data by problem and add them to Data Tree.


---


# 中文介绍

**作者: 李延炽**

**邮箱: int_lyc@cug.edu.cn**

## 简介

多任务优化平台(Multi-Task Optimization Platform)是受[PlatEMO](https://github.com/BIMK/PlatEMO)的启发，为方便进行多任务优化算法的实验而设计。

运行环境: **Matlab >= R2020b**

### 相关网站
[http://www.bdsc.site/websites/MTO/index.html](http://www.bdsc.site/websites/MTO/index.html)

[http://www.bdsc.site/websites/ETO/ETO.html](http://www.bdsc.site/websites/ETO/ETO.html)

## 使用方法

### 运行MTO Platform

- matlab运行**MTO.m**文件

### 加入自己的算法

- 继承Algorithms文件夹下的**Base/Algorithm**类实现新的算法类，并放入Algorithms文件夹或其子文件夹内
- 按照Algorithm类中的各虚函数的注释实现继承的虚函数。
- *可参考MFEA算法的实现*

### 加入自己的问题

- 继承Problem文件夹下的**Base/Problem**类实现新的问题类，并放入Problem文件夹或其子文件夹内
- 按照Problem类中的各虚函数的注释实现继承的虚函数。
- *可参考CEC2017_MTSO问题的实现*

### 使用App Designer修改GUI界面

- 使用matlab的App Designer打开**GUI/MTO_Platform.mlapp**工程文件，进行GUI界面的修改
- 修改完后导出为MTO.m文件


## 功能

### 一、测试模块

![Test Module Tasks](./Readme_Figure/MTO-Platform%20Test%20Module.png)
![Test Module Convergence](./Readme_Figure/MTO-Platform%20Test%20Module%202.png)

1. 算法选择
    - 选取一个算法，显示在Algorithm Tree中
    - 打开Algorithm会显示算法参数设置。*双击修改*
2. 问题选择
    - 选取一个问题，显示在Problem Tree中
    - 打开Problem Node会显示问题参数设置。*双击修改*
3. 问题1维图像
    - 在右侧Axes区域右上角选择Tasks Figure (1D)
    - 每选取一个问题，就绘制该问题自变量在1维上所有任务的图像。*为方便观察任务间特征，将每个任务的适应值归一化展示*
4. 收敛图
    - 在右侧Axes区域右上角选择Convergence
    - 选取算法和任务后，点击Start按钮，会在Axes区域绘制该算法在该问题每个任务上的收敛图像

### 二、实验模块

![Experiment Module Table](./Readme_Figure/MTO-Platform%20Experiment%20Module.png)
![Experiment Module Figure](./Readme_Figure/MTO-Platform%20Experiment%20Module%202.png)

1. 参数设置
    - Run Times: 独立运行次数
    - Parallel: 并行执行

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
    - 右侧选取Table，显示实验数据
    - 显示数据
      - Reps 独立运行次数
      - Fitness 目标值/适应值
      - Score 多任务分数
      - Time Used 运行时间
    - 数据类型
      - Mean 平均
      - Mean (Std) 平均 (标准差)
      - Median 中位数
      - Median (Std) 中位数 (标准差)
    - 精度
      - %.2d
      - %.4d
    - 统计测试 (Fitness)
      - None
      - Rank sum test 秩和检验
      - Signed rank test 符号秩检验
    - 高亮数据
      - None 无高亮
      - Highlight best 高亮最优值
      - Highlight best worst 高亮最优值和最差值
    - 保存数据，点击Save按钮，保存当前表格内容

6. 收敛图
    - 右侧选取Figure，显示实验收敛图
    - Y轴类型
      - log(fitness)
      - fitness
    - 问题选择，选择某一问题的某个任务，显示该任务各算法的收敛图
    - 保存所有数据，选取保存文件类型，点击Save All Firuge按钮保存所有任务的收敛图。*可修改GUI/Utils文件夹下的**drawFigure.m**调整绘制细节*

7. 读取/保存数据
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

