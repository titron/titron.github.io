---
layout: post
title:  "使用A/D转换器时的注意事项"
categories: basic
tags: circuit ADC
author: David
---

* content
{:toc}

注：以下内容选自Renesas SH7269 HW(Hardware Manual，硬件手册)。

在使用A/D转换器时，必须注意以下几点。

## 模块待机模式的设定

能通过待机控制寄存器设定允许或者禁止A/D转换器的运行，初始值为停止A/D转换器的运行。

能通过解除模块待机模式，使寄存器变为可存取的状态。

## 模拟电压的设定

如果在超过以下电压的设定范围使用A/D转换模块，就会给A/D转换器的可靠性带来不良影响。

* 模拟输入电压的范围

在A/D转换过程中，必须将模拟输入引脚ANn的外加电压设定在AVSS ≤ ANn ≤ AVCC的范围内 （n=0～7）。

* AVCC和AVSS输入电压

AVCC和AVSS的输入电压必须为（PVCC－0.3V） ≤ AVCC ≤ PVCC，AVSS = VSS。

而且，在不使用A/D转换器时或者在软件待机模式中，不能将AVCC引脚和AVSS引脚置为开路。不使用时，必须将AVCC连接到电源（PVCC）并且将AVSS接地 （VSS）。

* AVref的设定范围

AVref引脚的基准电压范围必须为3.0V ≤ AVref ≤ AVCC。

## 电路板设计的注意事项
在设定电路板时，必须尽量将数字电路和模拟电路分开，不能使数字电路的信号线和模拟电路的信号线交叉或者靠近。

否则，会因电感等引起模拟电路的误动作并且给A/D转换值带来不良影响。必须通过模拟接地（AVSS）将模拟输入信号（AN0～AN3）、模拟基准电压（AVref）、模拟电源（AVCC）必须通过模拟接地 （AVSS）和数字电路分开，并且模拟接地 （AVSS）必须和电路板上稳定的数字接地 （VSS）进行单点连接。

## 模拟输入引脚的处理
为了防止过大电涌等异常电压对模拟输入引脚 （AN0～AN7）的破坏，必须连接如下图所示的保护电路。

此图的电路还有RC过滤器功能，能抑制由噪声引起的误差。

图中的电路是设计例子，必须在考虑实际的使用条件的基础上决定电路常数。

![图1 模拟输入引脚的保护电路例子](https://github.com/titron/titron.github.io/raw/master/img/2019-10-16-ADC_pin_protect.png) 

模拟输入引脚的等效电路如下图所示，模拟输入引脚的规格如表1所示。

![图2 模拟输入引脚的等效电路](https://github.com/titron/titron.github.io/raw/master/img/2019-10-16-ADC_equivalent_circuit.png) 

![表1 模拟输入引脚的规格](https://github.com/titron/titron.github.io/raw/master/img/2019-10-16-ADC_spec.png) 

## 容许信号源阻抗
对于信号源阻抗不超过5k欧姆的输入信号，本LSI的模拟输入能保证转换精度。

这是为了在采样时间内，对A/D转换器的采样&保持电路的输入电容进行充电而制定的规格。

在传感器的输出阻抗超过5k欧姆时，可能发生充电不足并且不能保证A/D转换精度的情况。

在单通道模式中进行转换并且外接大电容的情况下，因为输入负载实际上只有3k欧姆的内部输入电阻，所以信号源阻抗可忽略不计。

但是，由于形成低通滤波器，因此可能无法跟踪大微分系数的模拟信号（例如，大于等于5mV/us）（图3）。

在转换高速模拟信号时或者在扫描模式中进行转换时，必须插入一个低阻抗的缓冲器。

![图3 模拟输入电路的例子](https://github.com/titron/titron.github.io/raw/master/img/2019-10-16-ADC_sample.png) 

## 对绝对精度的影响
由于附加电容会导致与GND的耦合，因此，如果在GND中有噪声，就可能降低绝对精度，所以AVSS等必须与电稳定的GND连接。

另外，必须注意：在安装电路板上滤波器电路不要干扰数字信号也不要充当天线。

## 深度待机模式时的A/D转换
要转移到深度待机模式时，必须将ADST位清 “0”， 禁 止A/D转换。如果本LSI在允许A/D转换的状态下变为深度待机模式，就不保证A/D的引脚状态。

## 使用扫描模式或者多通道模式时的注意事项
如果在扫描模式和多通道模式停止后立即开始转换，就可能产生错误的转换结果。
要连续进行转换时，必须在将ADST位置 “0”后经过1个通道的A/D转换时间 （1个通道的转换时间因分频寄存器的设定而不同），然后开始转换 （ADST位为 “1”）

