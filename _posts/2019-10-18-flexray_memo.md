---
layout: post
title:  "FlexRay总线学习笔记"
categories: hardware system
tags: FlexRay
author: David
---

* content
{:toc}

* 概述

当前，从速度上看，FlexRay总线处于比较尴尬的位置：比其低速上，用CAN（CAN-FD,CAN-XL）总线更广泛，而且，新的规范已经逼近甚至超过FlexRay；比其高速上，ethernet发展迅速。

![FlexRay backbone架构例](https://github.com/titron/titron.github.io/raw/master/img/2019-10-18-flexray_backbone.png) 

FlexRay通信系统并非仅仅是一个通信协议，它还包括一种特殊设计的高速收发器，并定义了FlexRay节点不同部件间的硬件和软件接口。

FlexRay利用两条独立的物理线路进行通信，每条的数据速率为10Mbps。两条通信线路主要用来实现冗余，因此消息传输具有容错能力，也可利用两条线路来传输不同消息，这样数据吞吐量可加倍。这也是FlexRay的精华所在（提出了解决硬件可靠性的方法：双通信通道，有源星型连接器）。

与其它时间触发通信协议相同，作为数据时间确定性优点的叙述，不考虑通信受干扰，从而需要出错重发的情况，是不完整的。

重发的实行需通过调度在其它动态时间槽内安排，此时数据时间确定性就会有很大的变化。

当然，有两个通道同时送同一数据，出错的概率就会减少，但是，由于节点位置，电缆位置相同，通信口又在同一芯片上，接同一个电源，受干扰与出错的机会相差不会太大。 



FlexRay的重要目标应用之一是线控操作(如线控转向、线控刹车等)，即利用容错的电气/电子系统取代机械/液压部分。

和CAN一样，需要终端电阻。

* timing

| Timing |	Min	| Max | Comments |
|---|---|---|---|
| 传播延时（Propogation Delay） |  | 2500ns |  |
| 切断（Truncation） | 100ns | 1350ns | 依赖于active stars的数目 |
| 标识符长度变化 |	-1200ns | 900ns	|  |
| 检测唤醒时间 | 1us |	4us	|  |
| 检测唤醒空闲 | 1us |	4us |  |
| 唤醒信号的判断 |	48us | 140us |  |
| 共模扼流圈 |  | 2欧姆 |  |
| 直流负载 | 40欧姆 | 55欧姆 |  |
| 级联的active star个数 |  | 2 |  |
| 低电压（Vcc）检测时间 |  | 1000ms |  |
| 低电压（Vcc）检测阈值 | 2V |  |  |
| 低电压（Vbat）检测时间 |  | 1000ms |  |
| 低电压（Vbat）检测阈值 | 2V |	5.5V |  |
| 低电压（Vio）检测时间 |  | 1000ms |  |
| 低电压（Vio）检测阈值 | 0.75V	|  |  |

传播延时从发送节点的字节起始序列BSS开始计时，计至接收节点接收到BSS。该值最大值为2500ns。

* 设计FlexRay网络

以下3个因素需要考虑：

【1】 总线通讯速率

【2】 通信循环的长度(单位:毫秒)

【3】 静态与动态部分的比例

使用FlexRay的通信是在周期循环中进行的。

一个通信循环始终包括静态部分和网络闲置时间（NIT）。

协议内部流程需要网络闲置时间，并且，在这个时段内，集群的节点之间不进行任何通信。 

通信循环的静态部分基于TDMA（时分多址）技术。该技术将固定时槽分配给各个节点，在这个时槽内，允许节点传输数据。所有时槽大小相同，并且是从1开始向上编号。将1个或1个以上时槽固定分配给每个节点。每个节点只有在属于自己的时间片里面才能发送消息，即使某个节点当前无消息可发，该时间片依然会保留（也就造成了一定的总线资源浪费）。

在动态部分使用FTDMA方法，会轮流问询每个节点有没有消息要发，有就发，没有就跳过。

静态部分用于发送需要经常性发送的重要性高的数据，动态部分用于发送使用频率不确定、相对不重要的数据。

![FlexRay frame结构](https://github.com/titron/titron.github.io/raw/master/img/2019-10-18-flexray_frame.png) 

![FlexRay frame结构详细描述](https://github.com/titron/titron.github.io/raw/master/img/2019-10-18-flexray_frame_d.png) 

![FlexRay slot](https://github.com/titron/titron.github.io/raw/master/img/2019-10-18-flexray_slot.png) 

![FlexRay slot detail](https://github.com/titron/titron.github.io/raw/master/img/2019-10-18-flexray_slot_d.png) 

![FlexRay timing](https://github.com/titron/titron.github.io/raw/master/img/2019-10-18-flexray_timing.png)

![FlexRay Message Cycle](https://github.com/titron/titron.github.io/raw/master/img/2019-10-18-flexray_msg_cycle.png)


* 关于唤醒

有效的唤醒事件是：收到至少两个连续的唤醒标识符。

![FlexRay wakeup](https://github.com/titron/titron.github.io/raw/master/img/2019-10-18-flexray_wup.png)

* 启动例

启动时，node仅发送startup帧。
startup帧：sync帧，null帧。

【1】node #2 not-ready， Transceiver is ready

![FlexRay node 2-NG](https://github.com/titron/titron.github.io/raw/master/img/2019-10-18-flexray_s1.png)

【2】node #2 ready， Transceiver is ready

![FlexRay node 2-ok flow](https://github.com/titron/titron.github.io/raw/master/img/2019-10-18-flexray_s2.png)

![FlexRay node 2-ok wave](https://github.com/titron/titron.github.io/raw/master/img/2019-10-18-flexray_s2_w.png)
