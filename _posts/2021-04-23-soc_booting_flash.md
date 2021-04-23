---
layout: post
title:  "介绍几种SOC启动用的flash及连接方式"
categories: hardware
tags: memory
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

— eMMC

— Serial Flash ROM

— HyperFlash ROM

### 1. eMMC

其特点：

容量大，易于与host连接，eMMC标准是开放的。

用途：

用于各种消费品，如相机，手机等。

连接：

![eMMC与soc的连接](https://github.com/titron/titron.github.io/raw/master/img/2021-04-19-flash_connect_emmc.png)

其中，

CLK——MCC clock

CMD——Command in / response out 

DAT——Data input / output

### 2. serial flash

特点：

成本低，引脚少，低功耗，寿命长达20年。

用途：

存储执行code，用于DVD players, DSL modems, routers, hard-disk drives, printers。

上电后，代码从serial flash被copy到RAM，并开始执行。

连接：

![serial flash与soc的连接](https://github.com/titron/titron.github.io/raw/master/img/2021-04-19-flash_connect_serial_flash.png)

其中，

SS - Slave select

MOSI - Master output, slave input 

MISO - Master input, slave output 

SCLK - Serial clock

### 3. Hyper flash


