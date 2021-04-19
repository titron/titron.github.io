---
layout: post
title:  "NOR Flash vs NAND Flash"
categories: hardware
tags: memory
author: David
---

* content
{:toc}

---

[原帖](https://zhuanlan.zhihu.com/p/340496845)

常见的应用组合就是，用小容量的Nor Flash存储启动代码，比如uboot，系统启动后,初始化对应的硬件，包括SDRAM等，然后将Nand Flash上的Linux 内核读取到内存中，做好该做的事情后，就跳转到SDRAM中去执行内核了。

这样的好处是由于NAND 本身有坏块的可能性，所以为了保障启动万无一失，很多要求高级安全的产品，标注必须从NOR Flash启动uboot，而且从NOR启动还有一个好处就是启动速度快，NAND Flash的优点是容量大，但是读取速度不快，比不上NOR Flash，比如一些对于开机速度有要求的产品应用，比如车载液晶仪表，这类产品为了快速启动一般都是NOR FLASH+EMMC的配置，当然像赛普拉斯平台直接上hyperflash那就更快了。



 ![NAND FLASH 搭配NOR FLASH的优缺点](https://github.com/titron/titron.github.io/raw/master/img/2021-04-19-norflash_vs_nandflash_1.jpg)

 ![车用Nor FLASH的优缺点](https://github.com/titron/titron.github.io/raw/master/img/2021-04-19-norflash_vs_nandflash_2.jpg)
