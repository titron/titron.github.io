---
layout: post
title:  "fatload命令解释"
categories: software
tags: fatload, ext4load
author: David
---

* content
{:toc}

---

U-Boot在RAM中运行code，所以，要进行以下2步：
- 从 media(Ethernet, flash, USB, MMC) 中读取Image和dtb到RAM
- 跳到RAM的第一条指令

所以，u-boot下设置环境变量：
```bash
setenv bootcmd 'ext4load mmc 1:1 0x48080000 Image;ext4load mmc 1:1 0x48000000 xxxxxx.dtb;booti 0x48080000 - 0x48000000'
```
将上述命令分行显示如下：
```bash
fatload mmc 1:1 0x48080000 Image;
fatload mmc 1:1 0x48000000 xxxxxx.dtb;
booti 0x48080000 - 0x48000000
```
对以上命令的解释：
- Image 是kernel
- xxxxxx.dtb 是编译后的设备树
- 从eMMC中读取命令如下（FAT格式 或者ext4格式）
```bash
fatload mmc <dev>[:partition] <loadAddress> <bootfilename>
ext4load mmc <dev>[:partition] <loadAddress> <bootfilename>
```
- booti命令如下
```bash
bootm <address of kernel> <address of ramdisk> <address of dtb>
```
如果kernel中已经配置了，可以忽略ramdisk、dtb，这时，相应位置用“ - ”占位.

参考：
[What does fatload mmc and bootm means in the uboot?](https://stackoverflow.com/questions/60368553/what-does-fatload-mmc-and-bootm-means-in-the-uboot)