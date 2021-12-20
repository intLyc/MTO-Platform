# MTO Platform

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