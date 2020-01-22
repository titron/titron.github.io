---
layout: post
title:  "DDR Layout的两种topology: Fly-by vs T-topology"
categories: hardware
tags: LPDDR4 Layout Fly-by T-topology
author: David
---

* content
{:toc}

原文请参考[这里](http://www.icd.com.au/articles/DDR3-4_Topology_PCBD_Apr2016.pdf)。

| 优缺点 | Fly-by | T-topology |  
|---|---|---|
| 图 | ![fly-by-topology](https://github.com/titron/titron.github.io/raw/master/img/2019-10-24-ddr_flyby_top.png) | ![T-topology](https://github.com/titron/titron.github.io/raw/master/img/2019-10-24-ddr_t_top.png) |
| 特点 | 起源于JEDEC的DDR3规范，用于差分clock,address,command,control信号  | 对于Fly-by的改进  |
| 优点 | 减少线长及数量，从而减少了信号的反射，从而保证了信号完整性和时序； <br>减少了address和数据之间同时切换噪声（SSN）；<br>对于single-die的DDR，布线容易； | 当DDR采用multi-die封装时，绕线容易；  |
| 缺点 | 当使用大容量DDR（*DDP,QDP）时，第一个node需要额外绕线（绕等长线），所以，不适合multi-die的DDR  | 由于信号线较长，所以容易引起信号过冲等信号反射现象  |


* 缩写

DDP: Double Die Package

QDP: Quad Die Package