---
layout: post
title:  "对比LIN CAN FlexRay总线检查错误的位置"
categories: experience
tags: LIN CAN FlexRay
author: David
---

* content
{:toc}

* 应用场合

| 总线 | 应用场合 |
|---|---|
| LIN | 前照灯、空调-主控、雨刷器、电动车窗、后雨刷器、尾灯、车门、座椅、后视镜、雨量传感器、转向信号 |
| CAN | 导航/车载音箱、EPS（电动力转向）、仪表板、发动机、毫米波雷达、制动、加速踏板、BCM（车身控制模块）、车门-主控、线控转向-中央电控单元、安全带、悬架。	<br> 需要500kbps的速率：ABS（制动防抱死系统）ETM（电子气节门模块）	TCM（变速器控制模块）ECM（发动机控制模块）<br> 需要125kbps的速率：DMM（车门主控模块）CCM（温度控制模块）DIM（驾驶员信息模块） |
| FlexRay | 制动、星形耦合器 |

* 检查错误

总线中，送信方检测回环的目的：检测线上有突然的位改变，如ESD，闪电，强噪声等造成bit翻转。

同样，受信方要想检测该情况，用checksum（LIN），CRC（CAN）,填充位（CAN）。
有关检查错误的对比：

![总线check Burst Error Position](https://github.com/titron/titron.github.io/raw/master/img/2019-10-18-bus_vs_burstErr.png) 

* 检查填充位

![总线check Burst Error Position](https://github.com/titron/titron.github.io/raw/master/img/2019-10-18-bus_vs_stuff.png) 

综上：

| 总线 | 检查突然的bit error的位置 |
|---|---|
| LIN | Parity Error <br> checksum Error <br> 连续9bit “L” <br> 连续9bit “H” |
| CAN | CRC Error <br> 连续5bit “L” Stuff Error <br> 连续5bit “H” Stuff Error |
| CAN-FD | 除上述CAN所说的检测位置外，还增加了 Header CRC Error |
| FlexRay | Header CRC Error <br> CRC Error <br> 连续9bit “L” <br> 连续9bit “H”  |
