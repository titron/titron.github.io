---
layout: post
title:  "车载以太网标准"
categories: basic
tags: ethernet, automotive
author: David
---

* content
{:toc}

---

[（转）原文 1](https://zhuanlan.zhihu.com/p/567444858)

[（转）原文 2](https://www.guardknox.com/automotive-ethernet/)

### 车载以太网的相关物理层技术标准
目前，车载以太网涉及的相关物理层技术标准如下所示：

![不同速率的车载以太网标准](https://github.com/titron/titron.github.io/raw/master/img/2024-01-09-automotive_ethernet_spec.png)

| Speed | Simple | PHY(e.g.) | details |
|-|-|-|-|
| 100BASE-TX | 100 Megabit Baseband Two Pairs | KSZ8061 | (RJ45) |
| 100BASE-T1 | 100 Megabit Baseband One Pair | RTL9000 | 100BASE-T1 - uses single unshielded twisted pair cables with a maximum length of 15 meters. The bridge, composed of 4 resistors, separates, transmits, and receives directions on each side of the link. |
| 1000BASE-T1 | 1 Gigabit Baseband One Pair | 88Q2112 | 1000BASE-T1 - with the emergence of connected and autonomous vehicles and more sophisticated infotainment systems, the information exchanged within a vehicle has grown rapidly. |
| 1000BASE-RH | Gigabit Ethernet Over Plastic Optical Fiber | KD1053 | 1000BASE-RH - uses Polymeric Optical Fiber (POF). POF is immune to any EMC problem, and it also provides galvanic isolation. |
| 2500BASE-T1 | 2.5 Gigabit Baseband One Pair | 88Q4364 | 2500BASE-T1 - with the emergence of connected and autonomous vehicles and more sophisticated infotainment systems, the information exchanged within a vehicle has grown rapidly. |
| 10BASE-T1S | 10 Megabit Baseband One Pair and a multidrop bus architecture | LAN8650 | 10BASE-T1S technology provides a 10 Mbps, multidrop transmission medium that can include up to at least eight transceiver nodes. The transceiver nodes connect to a common mixing segment of up to at least 25m. 100R nominal differential impedance is used. Nodes includes "Drop Nodes" and "End Nodes". |
| MultiGBASE-T1 | a set of new PHYs with 2.5, 5 and 10 Gbps One Pair |  | MultiGBASE-T1 - a set of new PHYs with 2.5, 5 and 10 Gbps supported over Shielded Twisted Single Pairs (STSP) to support high bitrate and external communication for AI evaluation. |

### 命名方法
[命名方法](https://en.wikipedia.org/wiki/Fast_Ethernet)：
The 100 in the media type designation refers to the transmission speed of 100 Mbit/s, while the BASE refers to baseband signaling. The letter following the dash (T or F) refers to the physical medium that carries the signal (twisted pair or fiber, respectively), while the last character (X, 4, etc.) refers to the line code method used. Fast Ethernet is sometimes referred to as 100BASE-X, where X is a placeholder for the FX and TX variants.

### 总线map表格
![100BASE-T1](https://github.com/titron/titron.github.io/raw/master/img/2024-01-09-automotive_ethernet_spec_100base-T1.png)

![1000BASE-T1](https://github.com/titron/titron.github.io/raw/master/img/2024-01-09-automotive_ethernet_spec_1000base-T1-RH.png)

![multi giga](https://github.com/titron/titron.github.io/raw/master/img/2024-01-09-automotive_ethernet_spec_Multi-Gig.png)