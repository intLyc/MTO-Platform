# MTO Platform

**作者: 李延炽**

**Email: int_lyc@cug.edu.cn**

# 简介

多任务优化平台(Multi-Task Optimization Platform)是受[PlatEMO](https://github.com/BIMK/PlatEMO)的启发，为方便进行多任务优化算法的实验而设计。

运行环境：**Matlab >= R2020b**

# 使用方法

### 运行MTO Platform

matlab运行**MTO_Platform_exported.m**文件

### 加入自己的算法

继承Algorithm文件夹下的**Algorithm**类实现新的算法类，并放入Problem文件夹或其子文件夹内，按照Algorithm类中的各虚函数的注释实现继承的虚函数。
*可参考MFEA算法的实现*

### 加入自己的问题

继承Problem文件夹下的**Problem**类实现新的问题类，并放入Problem文件夹或其子文件夹内，按照Problem类中的各虚函数的注释实现继承的虚函数。
*可参考CI_H问题的实现*

### 使用App Designer修改GUI界面

使用matlab的App Designer模块打开**MTO_Platform.mlapp**工程文件，进行GUI界面的修改，修改完后导出为MTO_Platform_exported.m文件

# 功能

## 一、测试模块

1. 参数设置
2. 算法选择
3. 问题选择
4. 问题1维图像
5. 收敛图

## 二、实验模块

1. 参数设置
2. 算法选择
3. 问题选择
4. 表格统计
5. 收敛图
6. 读取/保存数据

## 三、数据处理模块

1. 读取数据
2. 删除数据
3. 保存数据
4. 数据分割
5. 数据合并
