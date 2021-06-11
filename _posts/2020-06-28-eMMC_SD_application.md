---
layout: post
title:  "eMMC、SD应用笔记"
categories: hardware
tags: eMMC, SD
author: David
---

* content
{:toc}

---
参考：
1. JEDEC Standard, Embedded Multi-Media Card(eMMC) Electrical Standard (5.01), JESD84-B50.1
2. JEDEC Standard, Embedded MultiMediaCard(e•MMC)e•MMC/Card Product Standard, High Capacity, including Reliable Write, Boot,
Sleep Modes, Dual Data Rate, Multiple Partitions Supports, Security Enhancement, Background Operation and High Priority
Interrupt (MMCA, 4.41), JESD84-A441

eMMC真正的存储media还是NAND Flash,而NAND又分为SLC、MLC和TLC。

目前市场上主流的eMMC还是以MLC的NAND为主，而TLC的eMMC也在逐漸的增加。

目前市场上的MLC，擦除次数大概在3000~5000cycle。

而SLC的擦除次数则在25000~40000cycle。

所以，SLC要比MLC效率高，更稳定。

### Signals

* CLK

时钟。一个周期内，传输1bit或2bit。

* DS(Data Strobe)

仅仅存在于HS400 mode。2 bit传输（上升沿+下降沿）。

* CMD

双向，用于传输command（host->device）和response（host<-device）。

有两种mode：
open-drain：initialization mode

push-pull：fastcommand transfer


* D0~D7（8-bit）/D0~D3（4-bit）/D0（1-bit）

注意：
由于涉及到高速信号应用，layout时，CLK/CMD/DX信号，要进行长度匹配（等长），阻抗匹配（50欧姆）。

### Protocol

![Figure 1——Multiple-block read operation](https://github.com/titron/titron.github.io/raw/master/img/2020-06-28-emmc-sd_multiBlock_read.png)

![Figure 2——Multiple-block write operation](https://github.com/titron/titron.github.io/raw/master/img/2020-06-28-emmc-sd_multiBlock_write.png)

![Figure 3——No response and No data operation](https://github.com/titron/titron.github.io/raw/master/img/2020-06-28-emmc-sd_no_response_data.png)


### Bus Speed Modes

![Figure 4——Bus Speed Mode](https://github.com/titron/titron.github.io/raw/master/img/2020-06-28-emmc-sd_bus_speed_mode.png)


### Device Registers

和Device有关的6个寄存器：

* OCR

定义了VDD电压和访问mode。

* CID

定义了Device ID。

* CSD

定义了data format，data transfer speed，Max\_read/write\_current@ VDDmin/VDDmax等等。

* EXT_CSD

定义Device属性和可选择的mode。共有512 bytes。

* 高320 bytes——定义了device的capability，不能被host修改。
* 低192 bytes——定义了mode，host可以通过SWITCH命令进行修改。
               如，byte 179定义了可以boot的partition，byte 177定义了boot时的bus width。

* RCA

* DSR

### Boot

eMMC、SD卡的分区：

![Figure 5——Memory partition](https://github.com/titron/titron.github.io/raw/master/img/2020-06-28-emmc-sd_memory_partition.png)

通过Extend CSD register [179] bit[5:3] 可以选择boot的区域有：partition 1/2，user area。

* 0x0 : Device not boot enabled (default)
* 0x1 : Boot partition 1 enabled for boot
* 0x2 : Boot partition 2 enabled for boot
* 0x3–0x6 : Reserved
* 0x7 : User area enabled for boot

### Power-up

![Figure 6——Power-up](https://github.com/titron/titron.github.io/raw/master/img/2020-06-28-emmc-sd_powerup.png)

细节请参考下文中“High-speed eMMC bus function”的“Bus initialization”。

![Figure 7——eMMC voltage combination](https://github.com/titron/titron.github.io/raw/master/img/2020-06-28-emmc-sd_voltage_combination.png)


### High-speed eMMC bus function

参考A.6 High-speed eMMC bus function的操作步骤。
共包括3个主要步骤：

* Bus initialization
* Switching to high-speed mode
* Changing the data bus width