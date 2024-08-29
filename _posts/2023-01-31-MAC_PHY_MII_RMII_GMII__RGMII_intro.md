---
layout: post
title:  "MAC/PHY（MII/RMII/GMII/RGMII/SGMII/USXGMII）基本介绍"
categories: basic
tags: ethernet MAC PHY
author: David
---

* content
{:toc}

---

*参考*
[1. 以太网详解（一）-MAC/PHY/MII/RMII/GMII/RGMII基本介绍（转）](https://www.cnblogs.com/erhu-67786482/p/13683979.html)

[2. MII、GMII、RMII、RGMII、SGMII、XGMII](https://blog.csdn.net/liuxd3000/article/details/106012523)

[3. USXGMII是什么？](https://blog.csdn.net/highman110/article/details/132619001)


| 指标 | GMII | RGMII | SGMII | USXGMII |
|-|-|-|-|-|
| 全称 | Gigabit Media Independent Interface | Reduced GMII | Serial Gigabit Media Independent Interface | 10 Gigabit Media Independent Interface |
| 简介 | 是一种并行接口，用于连接MAC层和物理层 | 是GMII（Gigabit Media Independent Interface）的简化版本，数据位宽为4位 | 数据线和时钟线各为一根，双向共四根线，相比GMII的8位数据线和多根控制线，大大减少了引脚数量 | 是一种高速以太网接口标准，支持10G以太网的数据传输。它由IEEE标准802.3定义，用于连接网络设备如交换机和路由器 |
| 信号线（部分参见下表） | 使用8根数据线来传送数据 | 接口的数据线和时钟线各为一根，双向共四根线，相比GMII的8位数据线和多根控制线，大大减少了引脚数量 | 链路由收发各一对差分对组成，用来在单端口或多端口PHY和MAC之间传递数据帧和link速率等控制信息 |
| 速率 | 适用于10/100/1000 Mbps的传输速率，时钟频率为125 MHz | 支持10/100/1000Mbps三种通信速率。在10/100Mbps模式下，数据线采用单沿采样，而在1000Mbps模式下，数据线采用双沿采样。RGMII接口的时钟频率在1000Mbps传输速率下为125MHz。 | SGMII的时钟频率为625 MHz，在时钟信号的上升沿和下降沿均采样，适用于MAC侧没有时钟的情况。 | serdes的最大速率由外部端口最大速率决定，一般有5G和10G两种serdes速率 |
| 是否双工 | | | | 支持全双工传输，并且可以配置为单端口或多端口模式。|
| 应用场合 | | 适合成本敏感的应用 | 适合需要高密度连接的应用 | 适用于10G以太网传输，支持多端口配置，适合高性能网络设备 |




*释义*

| interface | name | transfer data lines | signal |
|-|-|-|-|
| MII | media independant interface | 4根 | TX_CLK/TX_ER/TX_EN/TXD[3:0]/<BR>RX_CLK/RX_ER/RX_DV/RXD[3:0]/<BR>CRS/COL/<BR>MDC/MDIO |
| RMII | reduced MII | 并行，2根 | REF_CLK(50MHz)/<BR>TX_EN/TXD[1:0]/<BR>RX_EN/RXD[1:0]/<BR>CRS_DV/<BR>MDC/MDIO |
| SMII | Serial MII | 串行 | REF_CLK(125MHz)/<BR>TXD/RXD/<BR>SYNC/<BR>MDC/MDIO |
| GMII | Gigabit MII | 并行，8根 | GTX_CLK/<BR>TX_CLK/TX_ER/TX_EN/TX[7:0]/<BR>RX_CLK/RX_DV/RX_ER/RX[7:0]/<BR>CRS/COL/<BR>MDC/MDIO |
| RGMII | reduced Gigabit MII | 并行，4根 | TX_CLK(125MHz)/TX_CTL/TXD[3:0]/<BR>RX_CLK(125MHz)/RX_CTL/RXD[3:0]/<BR>MDC/MDIO |
| SGMII | Serial Gigabit MII | 串行 |
| XGMII | X-对应罗马数字10，10GMII速 |


*以图释义*
![CPU-MAC-PHY block](https://github.com/titron/titron.github.io/raw/master/img/2023-01-31-MAC_PHY_1.jpg)
![CPU-MAC-PHY internal](https://github.com/titron/titron.github.io/raw/master/img/2023-01-31-MAC_PHY_2.jpg)
![CPU-MAC-PHY MAC internal](https://github.com/titron/titron.github.io/raw/master/img/2023-01-31-MAC_PHY_3.jpg)
![CPU-MAC-PHY PHY internal](https://github.com/titron/titron.github.io/raw/master/img/2023-01-31-MAC_PHY_4.jpg)


