---
layout: post
title:  "SENT总线简介"
categories: basic
tags: bus
author: David
---

* content
{:toc}

---

[(转载)SENT信号介绍](https://zhuanlan.zhihu.com/p/87250091)


SENT - Single Edge Nibble Transmission（单边半字传输协议）。

![SENT name](https://github.com/titron/titron.github.io/raw/master/img/2024-01-17-SENT_name.png)


SENT总线是比CAN或Lin更便捷、可靠、经济的车载数据通讯解决方案，现在是SAE J2716标准，应用在整车传感器、执行器及Drive-by-wire线控等子系统中，目前越来越多的传感器都已支持SENT类型的信号。

### 特点：

1. 点对点的、单向传输（数据只能从传感器到ECU）的方案：

2、单线数据传输（信号线，电源，地），总共3线；

3、由帧来传输数据，或者数据包的形式，每一帧由不同宽度的脉冲即半字节组成，数据的传输可以分为快速通道和慢速通道。

4、无需接收器和集成发射器，因此相比CAN或Lin成本更低，且具有不错的传输精度和速度，数字数据传输速度可达30kb/s。

重要的信号用快速通道以实现高频率的更新，比如压力等，

对于非关键的信号，如诊断等可以放在慢速通道传输（快速通道是每一帧传输一个完整的信号，慢速通道需要多帧来传输一个完整的信号，即更新频率不同）。


具有很好的EMC 特性并节省线束和插针结头，且能传输故障代码从而使传感器系统具有很强的故障诊断能力。

可在局部系统中取代CAN和LIN，但却不能替代CAN或是Lin 因为SENT是连续单向传输的，CAN和Lin都是双向传输。

### 信号帧：

![SENT frame](https://github.com/titron/titron.github.io/raw/master/img/2024-01-17-SENT_frame.png)

SENT信号通过两个下降沿周期之间的一系列脉冲序列来传输，

SENT报文以一个同步脉冲开始，该脉冲与后续的下降沿之间的时间间隔等效于56个时钟节拍；

同步脉冲之后，状态/通信半字节按照SENT格式传送；

随后紧接着就是6个含有传感器数据的Data Nibbles，数据通过4个数据位为一个单元来传输，或称“半字节”（一个半字节即一个Nibble）；

在每条报文的尾部会提供一个检验脉冲并插入一个固定长度不超过1ms的暂停脉冲，因此SENT报文的长度会随着半字节的值而有不同。


SENT信号每一帧主要包含如下五部分：

![SENT frame format](https://github.com/titron/titron.github.io/raw/master/img/2024-01-17-SENT_frame_5parts.jpg)

1 Synchronization/calibration pulse （包含56个 clock ticks）。

2 一个Nibble（即4个Bits）的Status and Serial Communication pulse （12~27clock ticks）。

3 连续6个Nibbles的data pulses （每个Nibble：12~27 clock ticks）。

4 一个Nibble（即4个Bits）的 CRC及checksum pulse（12~27 clock ticks）。

5 一个可选的 pause pulse。

上面也说了一个半字节代表4个Bits（即一个Nibble），由于一个半字节可以表示0000~1111数值范围，因此可通过6个Nibble的大小来表示传感器数据，而每个Nibble的大小可通过时钟节拍tick的个数来表示，根据协议每个Nibble大小由12~27个ticks来表示，如下：

![SENT frame format-tick](https://github.com/titron/titron.github.io/raw/master/img/2024-01-17-SENT_frame_nibble_tick.jpg)

![SENT frame format-tick-no-offset](https://github.com/titron/titron.github.io/raw/master/img/2024-01-17-SENT_frame_nibble_tick_no_offset.jpg)

一个时钟节拍tick表示时间单位，其范围为3~10us，一般为3us。

时钟节拍大小的确定楼主以一个例子为例说明：SENT信号传输时会有一时钟计时每个脉冲所占用的时间，例如同步脉冲在此例总共耗用了840us，由于每个同步脉冲由56个ticks组成，那么可得每个时钟节拍为15us。

![SENT frame format-tick-calculation](https://github.com/titron/titron.github.io/raw/master/img/2024-01-17-SENT_frame_nibble_tick_cal.jpg)

### 总结

一帧SENT报文包含1个同步脉冲、8个Nibbles和1个可选暂停脉冲。SENT协议有SENT 2008和SENT 2010两种，SENT 2008一帧数据结尾会包括1个校验位，而SENT 2010一帧数据结尾除了包含1个校验位还有1个可变暂停位。

![SENT frame format-transmission](https://github.com/titron/titron.github.io/raw/master/img/2024-01-17-SENT_frame_tx.jpg)