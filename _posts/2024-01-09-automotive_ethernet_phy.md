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

目前，车载以太网涉及的相关物理层技术标准如下所示：

![不同速率的车载以太网标准](https://github.com/titron/titron.github.io/raw/master/img/2024-01-09-automotive_ethernet_spec.png)

| Speed | Simple | details |
|-|-|-|
| 100BASE-T1 | 100 Megabit Baseband One Pair | 100BASE-T1 - uses single unshielded twisted pair cables with a maximum length of 15 meters. The bridge, composed of 4 resistors, separates, transmits, and receives directions on each side of the link. |
| 1000BASE-T1 | 1 Gigabit Baseband One Pair | 1000BASE-T1 - with the emergence of connected and autonomous vehicles and more sophisticated infotainment systems, the information exchanged within a vehicle has grown rapidly. 100BASE-T1 has been introduced as the definition of a Gigabit Ethernet technology for automotive use. |
| 1000BASE-RH | Gigabit Ethernet Over Plastic Optical Fiber | 1000BASE-RH - uses Polymeric Optical Fiber (POF). POF is immune to any EMC problem, and it also provides galvanic isolation. |
| 10BASE-T1S | 10 Megabit Baseband One Pair and a multidrop bus architecture | 10BASE-T1S technology provides a 10 Mbps, multidrop transmission medium that can include up to at least eight transceiver nodes. The transceiver nodes connect to a common mixing segment of up to at least 25m. |
| MultiGBASE-T1 | a set of new PHYs with 2.5, 5 and 10 Gbps One Pair | MultiGBASE-T1 - a set of new PHYs with 2.5, 5 and 10 Gbps supported over Shielded Twisted Single Pairs (STSP) to support high bitrate and external communication for AI evaluation. |