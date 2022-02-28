---
layout: post
title:  "为什么开关电源DC-DC会有multiphase（多相）的输出"
categories: hardware
tags: power, buck, boost, DC-DC，LDO
author: David
---

* content
{:toc}

---

为什么有的开关电源DC-DC会有multiphase的输出？

答：减少输出纹波（ripple）。

原理说明：

开关电源DC-DC的纹波是由于开关动作形成的。

如何减少这些纹波的影响呢？

方法（1）就是有些DC-DC手册中所描述的，必须在DC-DC的输出端添加足够大的**电容**进行平滑滤波，以产生接近直流的电压。

方法（2）DC-DC本身的多个开关工作在不同的相位，每路电源的开关信号彼此错相，然后把这些开关**并联**使用，从而减少或者消除纹波（下降幅度与相数成比例）。这种DC-DC的名称就是multiphase 输出。同时满足了高效率、低纹波的要求。phase数量越多，纹波越小。

有关“Multiphase Buck Converts”，这里有个视频解释的很清楚[（科普）A primer to：Multiphase Buck Converts【英语英字】](https://www.bilibili.com/video/BV1Y54y197L1/)


下表列出DC-DC和LDO的特点：

| DC-DC | LDO |
| --- | --- |
| 效率高（一般都在90%以上） | 效率低（效率的简单估计方法：输出电压/输入电压*%） |
| 纹波大（multiphase输出的可以减少纹波），需要接足够的电容进行滤波平滑输出 | 纹波小 |
| - | 发热大，要处理好散热 |
| 有buck（降压）、boost（升压）、buck-boost三种 | - |




