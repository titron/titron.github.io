---
layout: post
title:  "Ethernet TSN protocol lists"
categories: basic
tags: automotive, Ethernet, TSN
author: David
---

* content
{:toc}

---

### TSN 主要的目标
是致力于构建真正统一的高性能网络基础设施，为各类流量提供协调共存的平台，通过提供统一网络基础设施，支持在多应用融合的网络上传输不同优先级的数据包。这样的网络同时可支持 *高带宽*、*实时通讯*、*高可靠性*和*高性能*的应用

![TSN vs Layers](https://github.com/titron/titron.github.io/raw/master/img/2024-12-06-tsn_layer.png)
![TSN profiles](https://github.com/titron/titron.github.io/raw/master/img/2024-12-06-tsn_profiles.png)
![TSN Applications](https://github.com/titron/titron.github.io/raw/master/img/2024-12-06-tsn_application.png)


### Ethernet TSN protocol lists

|802.1xxx|缩写|TSN IEEE802.1xxxxx|Name|中文名称|
|-|-|-|-|-|
|802.1AS|gPTP|IEEE 802.1AS-2011|gPTP (generic Precise Timing Protocol)|定时和同步|
|802.1Qci||IEEE 802.1Qci-2017|Per Stream Filtering & Policing (Qci)|每（逐）流过滤和监管（控）|
|802.1Qbv|TAS|IEEE 802.1Qbv-2015|Time Aware Shaper (Qbv)|分时调度——预定流量的增强功能|
|802.1Qat|SRP|IEEE 802.1Qat-2010|SRP (Stream Reservation Protocol – in Q section 35)||
|802.1Qav|CBS|IEEE 802.1Qav-2009|Credit based shaper (in Q-2014 section 34)|信用整形——保留流量，时间敏感流的转发和排队增强|
|802.1Qbu&3br||IEEE 802.1Qbu-2016 & IEEE 802.3br-2016|Preemption (Qbu & 3br)|帧抢占|
|802.1CB||IEEE 802.1CB-2017|Frame Replication & Elimination|帧复制和消除可靠性|
|||IEEE 1722-2011|AVTP (Audio Video Transport Protocol)||
|||IEEE 1722.1-2013|AVDECC (Audio Video Discovery, Enumeration, Connection management, and Control)||
|802.1BA||IEEE 802.1BA-2009|Audio Video Bridging(AVB) System||
|||IEEE 802.1AS-Rev|Enhanced Generic Precise Timing Protocol||
|||IEEE 802.1Qch-2017|Cyclic Queuing & Forwarding (Qch)|循环队列与转发|
|||IEEE 802.1Qcc|Stream Reservation Protocol Enhancements|流预留协议的增强|
|||IEEE 802.1Qcr|Asynchronous Traffic Shaping (Qcr)||

### AVB/TSN Link Layer Abbreviations

| Abbreviation | Description |
|-|-|
| ARP | Address Resolution Protocol (ARP) |
| RARP | reverse Address Resolution Protocol (RARP) |
| EAPOL | EAP over LAN (EAPoL) |
| NDP | Neighbor Discovery Protocol |
| SRP | Stream Reservation Protocol |
| MAC Control | Media Access Control |
| MACsec | Media Access Control Security |
| MKA | MACsec Key Agreement |

### others in Application Layer and Internet Layer

| Abbreviation | Description |
|-|-|
| DHCP | Dynamic Host Configuration Protocol |
| ICMP |Internet Control Message Protocol |
| IGMP |Internet Group Management Protocol |

### TSN三个信号：capture、pps 和 match

capture、pps 和 match 信号通常与时间同步、时间戳记录和事件调度相关。以下是它们的主要作用：

1. PPS（Pulse Per Second，秒脉冲信号）

作用：

PPS 是一个精确的周期性脉冲信号（每秒一次），用于实现高精度的时间同步。在TSN中，它通常作为外部时钟源（如GPS`或原子钟）的输入，确保网络中所有设备的时间基准严格对齐。

应用场景：

同步设备的本地时钟（如IEEE 802.1AS协议）。

校准本地时钟的漂移，确保全网设备的时间误差在微秒甚至纳秒级。

触发周期性任务（如定时发送关键数据帧）。

2. Capture（捕获信号）

作用：

Capture 信号用于在特定事件发生时记录当前时间戳。例如，当数据帧到达或离开网络接口时，硬件会自动捕获此时的时间戳，用于后续的时间敏感计算（如延迟测量或时钟偏差调整）。

应用场景：

记录数据帧的发送/接收时间，用于计算网络传输延迟。

在时间同步协议（如PTP, Precision Time Protocol）中，记录事件（如Sync报文发送/接收）的精确时间。

调试和验证TSN网络的实时性。

3. Match（匹配信号）

作用：

Match 信号用于触发预定的时间敏感操作。当设备的本地时间与预设的调度时间匹配时，硬件会生成此信号，触发特定动作（如打开/关闭传输窗口、发送关键数据等）。

应用场景：

在时间感知调度（如IEEE 802.1Qbv）中，控制时间敏感流量的发送时机。

触发周期性任务（如工业控制中的实时指令下发）。

实现确定性传输，避免数据帧冲突。

*三者的协同工作*

在TSN系统中，这三个信号通常协同工作：

PPS 提供全局时间基准，确保所有设备同步。

Capture 在关键事件发生时记录时间戳，用于同步校准或性能分析。

Match 根据预设的调度表触发动作，确保时间敏感操作（如数据传输）严格按计划执行。

这种机制使得TSN能够满足工业自动化、汽车网络等场景中对低延迟、高可靠性和确定性的严苛要求。

补充说明

这些信号的具体实现可能因硬件（如FPGA、TSN交换机芯片）或协议（如IEEE 802.1AS、802.1Qbv）而有所不同，但核心逻辑一致。

在设计中，通常通过硬件加速（而非软件）处理这些信号，以最小时间抖动（jitter）。
