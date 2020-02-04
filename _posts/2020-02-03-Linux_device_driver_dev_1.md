---
layout: post
title:  "Linux device driver development"
categories: Software
tags: Linux Driver
author: David
---

* content
{:toc}

学习 宋宝华 的《Linux设备驱动开发详解-基于最新的Linux4.0内核》笔记——（1）：

### 概述

驱动工程师必须按照相应的架构设计驱动。

| 操作系统 | 驱动特点 |
| --- | --- |
| 无 | 每一种设备驱动都会定义一个软件模块，包含.h文件和.c文件. <br> .h文件 - 定义该设备驱动的数据结构并声明外部函数。<br> .c文件 - 进行驱动的具体实现。|
| 有 | 需要将驱动融入内核。<br> 设计面向操作系统内核的接口，该接口有操作系统规定。 |

操作系统的作用：
多任务并发；提供内存管理机制（让每个进程都可以独立的访问4GB的内存空间）。

操作系统通过给驱动制造麻烦来达到给上层应用提供便利的目的。

Linux驱动针对的对象是存储器和外设，分为3个基础大类：

* 字符设备 - 串行顺序访问（open/close/read/write）；
* 块设备 - 任意顺序访问（open/close/read/write）；
* 网络设备 - 数据包，套接字接口；

Linux设备驱动需要的基础：硬件基础、c语言基础、Linux内核基础、多任务并发控制和同步基础。

有效的帮助文档：Linux内核源代码中包含的Documention目录。

Linux源代码阅读交叉索引：

* [http://lxr.free-electrons.com](http://lxr.free-electrons.com)
* [http://lxr.oss.org.cn](http://lxr.oss.org.cn)

### 硬件基础

NOR Flash的特点是 可芯片内执行（eXecute In Place, XIP），程序可以直接在NOR内运行。

NAND Flash以块方式进行访问，不支持芯片内执行。

DRAM以电荷形式进行存储，数据存储在电容器中，由于电容器会因漏电而出现电荷丢失，所以DRAM器件需要定期刷新。

与SDRAM相比，DDR SDRAM同时利用了时钟脉冲的上升沿和下降沿传输数据，因此，在时钟频率不变的情况下，数据传输频率加倍。

USB传输速度：

* 低速： 1.5M bit/s
* 全速：12M bit/s
* 高速：480M bit/s
* 超高速：5.0G bit/s

USB 2.0的bulk模式只支持1个数据流。

USB 3.0增加的Bulk Streams模式，可以支持多个数据流，每个数据流被分配一个Stream ID（SID），每个SID与一个主机缓冲区对应。


以太网MAC和PHY之间采用MII（媒体独立接口）连接。

以太网隔离变压器是处于以太网PHY与连接器之间的磁性组件，作用：信号传输，阻抗匹配，波形修复，信号杂波抑制，高电压隔离。

SD/SDIO的传输模式：

* SPI模式
* 1位模式
* 4位模式

CPLD由完全可编程的与或门阵列以及宏单元构成。“与或”阵列完成组合逻辑功能，触发器完成时序逻辑功能。

FPGA基于LUT（查找表）工艺。查找表本质上是一片RAM。

芯片手册阅读：

* Overview/Features --- 必读
* MemoryMap --- 必读
* IPs/外设 --- 详细阅读
* Electrical Data（电气特性） --- 必读

### Linux内核及编程

Linux内核是一个演变而不是一个设计。一直朝着3个方向发展：

* 支持更多的CPU，硬件体系架构和外部设备
* 支持更广泛领域的应用
* 提供更好的性能

Linux 2.6以后，总线、设备、驱动三者之间因为一定的联系性而实现对设备的控制。

Linux 2.6以后，内核模块从.o变为.ko。

Linux内核源代码：

* arch: 各平台的板级支持在这里
* documentation：内核各部分的通用解释和注释
* drivers：设备驱动程序
* init：内核初始化代码。start_kernel()位于init/main.c文件中
* script：用于配置内核的脚本文件
* security：一个SELinux模块
* ...

内核一般要做到drivers与arch的软件架构分离，驱动中不包含板级信息，让驱动跨平台。同时，内核的通用部分（如kernel，fs，ipc，net等）则与具体的硬件（arch和drivers）剥离。

Linux内核的组成：

* 内存管理
* 进程调度
* 进程间通信
* 虚拟文件系统
* 网络接口

绝大多数进程（以及进程中的多个进程）是由用户空间的应用创建的。

内核空间和用户空间的具体界限是可以调整的，在内核配置选项Kernel Features--->Memory split，可以设置界限为2GB或者3GB。

Linux内核的内存管理底层的Buddy算法，用于管理每个页的占用情况，内核空间的slab以及用户空间的C库的二次管理。

Kswapd（交换进程）是Linux中用于页面回收的内核线程，采用最近最少使用（LRU）算法进行内存回收。

在Linux中网络接口可分为网络协议和网络驱动程序。

ARM处理器的7种工作模式：

* 用户模式（usr）
* 快速中断模式（fiq）
* 外部中断模式（irq）
* 管理模式（svc）
* 数据访问中止模式（abt）
* 系统模式（sys）
* 未定义指令中止模式（und）  

