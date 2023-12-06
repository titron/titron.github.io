---
layout: post
title:  "AUTOSAR Classic v.s. Adaptive"
categories: basic
tags: AUTOSAR architecture automotive
author: David
---

* content
{:toc}

---

[来自知乎的解释](https://zhuanlan.zhihu.com/p/130668798)

| | Classic  Platform AUTOSAR（CP） | Adaptive Platform AUTOSAR（AP） |
|-|-|-|
| 应用场合 | 传统ECU，如发动机控制器、电机控制器、整车控制器、BMS控制器等 | 未来会更多的应用于如ADAS、自动驾驶等需求高计算能力、高带宽通信、分布式部署的下一代汽车应用领域中 |
| 软件结构 | 在最高抽象级别上将运行在控制器上的软件分为三层：<br><br>Application: 不依赖于硬件<br><br>runtime environment(RTE): 软件模块间通过RTE交互，并通过RTE访问BSW，RTE体现了application的所有接口<br><br>basic software(BSW)：分为3大层（服务层（又细分为不同的服务组件，比如系统服务、存储服务、通信服务等）、ECU抽象层、MCU抽象层）和复杂驱动 | 定义了一个ARA运行环境（AUTOSAR Runtime for Adaptive Applications）<br><br>分为两种接口类型：service和APIs<br><br>由多个功能栈（功能集群：Service & Foundation）组成<br><br>AUTOSAR RTE在运行时动态链接服务和客户端 |
| 主要特点 | 基于C语言面向过程开发<br><br>FOA架构（function-oriented architecture）<br><br><font color=red>基于信号</font>的静态配置通信方式（LIN\CAN...通信矩阵）<br><br>硬件资源的连接关系局限于线束的连接<br><br>静态的服务模块，模块和配置在发布前进行静态编译、链接<br><br>大部分代码静态运行在ROM，所有application共用一个地址空间<br><br>OSEK OS | 基于C++语言面向对象开发<br><br>SOA架构（service-oriented architecture）<br><br><font color=red>基于服务</font>的SOA动态通信方式（SOME/IP…）<br><br>硬件资源间的连接关系虚拟化，不局限于通信线束的连接关系（互联网）<br><br>服务可根据应用需求动态加载，可通过配置文件动态加载配置，并可进行单独更新<br><br>application加载到RAM运行，每个application独享（虚拟）一个地址空间<br><br>POSIX-basedOS（Linux\PikeOS…），兼容性广，可移植性高 |
| 软件更新 | 满足传统ECU替代或增强电气系统的功能, 其软件在整个车辆寿命中往往不会发生明显变化 | 随着外部系统的不断发展或改进的功能，要求车辆中的软件能够不断被更新 |

