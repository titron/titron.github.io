---
layout: post
title:  "NOR flash v.s. NAND flash"
categories: hardware
tags: memory
author: David
---

* content
{:toc}

---

两者都是电可擦写的。

NAND flash 和 NOR flash 均使用 floating gate MOSFETs。

### 两者的详细对比

| 比较项目 | NAND flash | NOR flash |
|---|---|---|
| Gate | bit line 和 word lines 之间装配的是一个NAND 门 | bit line 和 word lines 之间装配的是一个NOR门 |
| 读/写 | 读/写基于page（页）| 需要额外的地址线读/写，random-access，所以可用于XIP（execute in place） |
| 接口引脚 | 少 | 总线连接 |
| 主要应用 | File storage |	Code execution |
| 容量 | High |	Low |
| 出厂时是否允许坏块 | 允许 | 不允许 |
| Cost per bit | Low | |
| Active power | Low | |
| Standby power | | Low |
| Write speed | Fast | |
| Read speed | | Fast |
| Execute in place (XIP) | No | Yes |
| Reliability | | High |
| 主要生产厂家 | 主要NAND flash生产厂家（截至2019）：
* Samsung Electronics – 34.9%
* Kioxia – 18.1%
* Western Digital Corporation – 14%
* Micron Technology – 13.5%
* SK Hynix – 10.3%
* Intel – 8.7% ||
| 车用优势 || ![车用Nor FLASH的优缺点](https://github.com/titron/titron.github.io/raw/master/img/2021-04-19-flash_norflash_vs_nandflash_2.jpg) |
| lauterBach 支持 | [lauterBach支持的最新NAND flash controller列表](https://www.lauterbach.com/ylistnand.html) | [lauterBach支持的最新NOR flash器件列表](https://www.lauterbach.com/ylist.html) |


### 常见的应用组合

用小容量的NOR Flash存储启动代码，比如uboot，系统启动后,初始化对应的硬件，包括SDRAM等，然后将NAND Flash上的Linux 内核读取到内存中，做好该做的事情后，就跳转到SDRAM中去执行内核了。

这样的好处是由于NAND 本身有坏块的可能性，所以为了保障启动万无一失，很多要求高级安全的产品，标注必须从NOR Flash启动uboot，而且从NOR启动还有一个好处就是启动速度快，NAND Flash的优点是容量大，但是读取速度不快，比不上NOR Flash，比如一些对于开机速度有要求的产品应用，比如车载液晶仪表，这类产品为了快速启动一般都是NOR FLASH+EMMC的配置，当然像瑞萨、cypress等平台直接上hyperflash那就更快了。


参考：

1. [flash介绍](https://en.wikipedia.org/wiki/Flash_memory)

2. [智能座舱之存储篇第三篇---NAND Flash 一眼就看明白了](https://zhuanlan.zhihu.com/p/340496845)