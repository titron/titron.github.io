---
layout: post
title:  "DDR/LPDDR4概念解释-package、die、channel"
categories: hardware
tags: DDR, LPDDR4
author: David
---

* content
{:toc}

---
参考:

[1 Architectural Options for LPDDR4 Implementation in YourNext Chip Design](https://www.jedec.org/sites/default/files/files/Marc_Greenberg_Mobile_and_IOT.pdf)

[2 LPDDR4 vs DDR4 vs LPDDR4x: Which One is Better?](https://www.hardwaretimes.com/lpddr4-vs-ddr4-vs-lpddr4x-which-one-is-better/)

[3 LPDDR4 与 DDR4 与 LPDDR4x 内存：有何不同？](https://blog.csdn.net/weixin_42238387/article/details/120576832)



| DDR/LPDDR4 | die/package | channel(command/address bus、data bus)/die |
|---|---|---|
| DDR2<br>DDR3<br>DDR4 | 1 | 1 |
| LPDDR2<br>LPDDR3<br> | 1或2 | 1 |
| LPDDR4 | 1 | 2 |
| LPDDR4 | 2 | 4 |
