---
layout: post
title:  "一阶全响应电路应用理解又加深了"
categories: experience
tags: circuit ADC
author: David
---

* content
{:toc}

使用A/D转换采集按键的值，如图：

![ADC Key电路](https://github.com/titron/titron.github.io/raw/master/img/2019-10-16-ADC_key.png)

现象：

第一次上电采样值是正确的，再次采样，会出现采样值偏高的情况。

分析：

由A/D部分等效电路可知，改电路相当于一阶全响应电路，采样处电压应该如下图中的曲线2：

![一阶全响应电路Uc-t变化曲线](https://github.com/titron/titron.github.io/raw/master/img/2019-10-16-ADC_RCcurve.png)

如果两次按键时间较短，会导致等效电容放电时间不够，会采集到较大电压值。

措施：

延长A/D采样时间。

结论：

以前见过一个利用一阶电路零状态响应的产品（给电容充电，检查电容的电压），今天自己应用，有切身体会了。