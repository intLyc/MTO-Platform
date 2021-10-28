# MTO Platform

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

- matlab运行**MTO_Platform_exported.m**文件

### 加入自己的算法

- 继承Algorithm文件夹下的**Algorithm**类实现新的算法类，并放入Problem文件夹或其子文件夹内
- 按照Algorithm类中的各虚函数的注释实现继承的虚函数。
- *可参考MFEA算法的实现*

### 加入自己的问题

- 继承Problem文件夹下的**Problem**类实现新的问题类，并放入Problem文件夹或其子文件夹内
- 按照Problem类中的各虚函数的注释实现继承的虚函数。
- *可参考CI_H问题的实现*

### 使用App Designer修改GUI界面

- 使用matlab的App Designer打开**MTO_Platform.mlapp**工程文件，进行GUI界面的修改
- 修改完后导出为MTO_Platform_exported.m文件


## 功能

### 一、测试模块

![Test Module Tasks](./Readme_Figure/MTO-Platform%20Test%20Module.png)
![Test Module Convergence](./Readme_Figure/MTO-Platform%20Test%20Module%202.png)

1. 参数设置
    - Pop Size: 种群大小
    - End Type: 终止条件 (Iteration 迭代次数 / Evaluation 评价次数)
    - End Num: 终止条件的最大值
2. 算法选择
    - 选取一个算法，显示在Algorithm Tree中
    - 打开Algorithm Node会显示算法参数设置。*双击修改*
3. 问题选择
    - 选取一个问题，显示在Problem Tree中
    - 打开Problem Node会显示问题参数设置。*双击修改*
4. 问题1维图像
    - 在右侧Axes区域右上角选择Tasks Figure (1D)
    - 每选取一个问题，就绘制该问题自变量在1维上所有任务的图像。*为方便观察任务间特征，将每个任务的适应值归一化展示*
5. 收敛图
    - 在右侧Axes区域右上角选择Convergence
    - 选取算法和任务后，点击Start按钮，会在Axes区域绘制该算法在该问题每个任务上的收敛图像

### 二、实验模块

![Experiment Module Table](./Readme_Figure/MTO-Platform%20Experiment%20Module.png)
![Experiment Module Figure](./Readme_Figure/MTO-Platform%20Experiment%20Module%202.png)

1. 参数设置
    - Run Times: 独立运行次数
    - Pop Size: 种群大小
    - End Type: 终止条件 (Iteration 迭代次数 / Evaluation 评价次数)
    - End Num: 终止条件的最大值 

2. 算法选择
    - 在Algorithms中选择算法后，点击Add按钮，会将算法添加到Selected Algorithms Tree中，可以展开算法，双击修改参数或算法名称。*可多选，右键全选，可重复添加*
    - 在Selected Algorithms中选择算法，点击Delete按钮删除所选算法。*可多选，右键全选*

3. 问题选择
    - 在Problems中选择问题后，点击Add按钮，会将问题添加到Selected Problems Tree中，可以展开问题，双击修改参数或问题名称。*可多选，右键全选，可重复添加*
    - 在Selected Problems中选择问题，点击Delete按钮删除所选问题。*可多选，右键全选* 

4. 开始/暂停/终止
    - 选取算法和问题后，点击Start按钮开始运行
    - 在运行过程中，点击Pause按钮暂停，再点击Resume继续
    - 在运行过程中，点击Stop按钮终止
  
5. 表格统计
    - 右侧选取Table，显示实验数据
    - 显示数据，选择 [ Reps / Fitness / Time Used ] 显示 [ 当前独立运行次数 / 适应值 / 运行时间 ]
    - 数据类型，选取Fitness后，选择 [ Mean / Mean (Std) / Median/ Median (Std) ] 显示 [ 平均值 / 平均值 (标准差) / 中值 / 中值 (标准差) ]
    - 统计测试，选取Fitness后，选择 [ None / Rank sum test / Signed rank test ] 显示 [ 无统计测试 / 秩和检验 / 符号秩检验 ]
    - 高亮数据，选择 [ None / Highlight best / Highlight best worst ] 显示 [ 无高亮 / 高亮最优值 / 高亮最优值和最差值 ]
    - 保存数据，点击Save按钮，保存当前表格内容。*无法保存高亮*

6. 收敛图
    - 右侧选取Figure，显示实验收敛图
    - Y轴类型，选择 [ log(fitness) / fitness ] 修改Y轴类型为 [ 适应值对数 / 适应值 ]
    - 问题选择，选择某一问题的某个任务，显示该任务各算法的收敛图
    - 保存所有数据，选取保存文件类型，点击Save All Firuge按钮保存所有任务的收敛图。*可修改Utils文件夹下的drawFigure.m调整绘制细节*

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

