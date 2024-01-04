---
layout: post
title:  "MAC/PHY（MII/RMII/GMII/RGMII）基本介绍"
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

