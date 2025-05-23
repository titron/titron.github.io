---
layout: post
title:  "介绍几种SOC启动用的flash及连接方式"
categories: experience
tags: memory R-Car
author: David
---

* content
{:toc}

---

通过设置MD[4:1]，R-Car支持从以下几种方式进行启动：

— External ROM (Area 0, local bus)

— HyperFlash ROM (Max. 320Mbps per pin)

— Serial Flash ROM

— eMMC

— USB download

— SCIF and HSCIF (R-Car V3H only) as serial downloader

这里只介绍其中的几种连接方式：

— [eMMC](https://palliatory66.rssing.com/chan-60693167/all_p6.html)

— Serial Flash ROM

— HyperFlash ROM

| 项目 | eMMC | serial flash | Hyper flash |
|---|---|---|---|
| 容量 | 大 || |
| 成本 |  | 低 ||
| 寿命 | MLC的eMMC擦除次数大概在3000~5000cyclec，而SLC的擦除次数则在25000~40000cycle | 长达20年 ||
| 带宽 |  |  | 读带宽~333MBps |
| 用途 | 用于各种消费品，如相机，手机等 | 存储执行code，用于DVD players, DSL modems, routers, hard-disk drives, printers。上电后，代码从serial flash被copy到RAM，并开始执行 ||
| 连接 | ![eMMC与soc的连接](https://github.com/titron/titron.github.io/raw/master/img/2021-04-19-flash_connect_emmc.png) | ![serial flash与soc的连接](https://github.com/titron/titron.github.io/raw/master/img/2021-04-19-flash_connect_serial_flash.png) | ![hyperFlash与soc的连接](https://github.com/titron/titron.github.io/raw/master/img/2021-04-19-flash_connect_hyperflash2.png) |


They deliver the highest read bandwidth at 333MB/s, over five times faster than Quad SPI NOR flash with one-third the number of pins of parallel NOR flash. 

参考：
1. [eMMC原理4:总线协议](https://palliatory66.rssing.com/chan-60693167/all_p6.html)
2. [eMMC接口介绍](https://zhuanlan.zhihu.com/p/163535210)