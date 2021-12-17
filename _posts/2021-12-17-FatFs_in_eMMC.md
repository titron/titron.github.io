---
layout: post
title:  "实现FatFs访问eMMC"
categories: hardware, software
tags: FatFs, eMMC, FAT16, FAT32, GBR, GPT, BPB
author: David
---

* content
{:toc}

---

包括以下内容：
1. eMMC基础
2. 分区与格式化eMMC基础
3. MBR、GPT基础
4. FAT基础
5. FatFs基础
6. 移植FatFs及SDHI/eMMC驱动
7. 验证FatFs在eMMC上工作正常


## 1. eMMC基础

大多数eMMC存在以下分区：
- UDA, User Data Area，用于存储数据
- Boot，Boot Area，通常有2个boot分区，用于启动
- RPMB, Replay Protected Memory Block, 具有安全特性的分区，通常用于存储一些有防止非法篡改需求的数据

每个分区都是单独编址，起始地址都是0x00000000.

![eMMC分区](https://github.com/titron/titron.github.io/raw/master/img/2021-12-17-fatfs_emmc_emmc_memory_organization.png)

要想访问访问某个分区，首先需要通过EXT_CSD[179]的[2:0]来选择分区。

![选择eMMC分区](https://github.com/titron/titron.github.io/raw/master/img/2021-12-17-fatfs_emmc_select_partition.png)

使用FlashWriter可以查看不同分区的实际大小：

```
Flash writer for R-Car H3/M3/M3N Series V1.09 Apr.17,2019				
>em_w				
EM_W Start --------------				
---------------------------------------------------------				
Please select,eMMC Partition Area.				
 0:User Partition Area   : 30535680 KBytes				
  eMMC Sector Cnt : H'0 - H'03A3DFFF				
 1:Boot Partition 1      : 32640 KBytes				
  eMMC Sector Cnt : H'0 - H'0000FEFF				
 2:Boot Partition 2      : 32640 KBytes				
  eMMC Sector Cnt : H'0 - H'0000FEFF
```

## 2. 分区与格式化eMMC基础

在Android或者Linux启动后，终端查看现有分区状态以及各分区类型。

![查看现有eMMC分区](https://github.com/titron/titron.github.io/raw/master/img/2021-12-17-fatfs_emmc_partition_blkid.png)

如果没有现成的FAT分区，要想在eMMC上使用FatFs文件系统，首先需要进行分区（命令：fdisk），然后将分区格式化为Fat分区（命令：mkfs.fat）。

* 分区命令：fdisk

（读者可以自行查询该命令的具体使用。）

* 格式化命令：mkfs.fat 或者 mkfs.vfat
  
  Android BSP中缺省没有该命令。

  用户可以从[这里](https://github.com/dosfstools/dosfstools/releases/download/v4.2/dosfstools-4.2.tar.gz
)下载，然后编译。

然后，在Ubuntu虚拟机下将编译好的mkfs.fat  push 到板载android下的/data目录。

```
$ adb root
$ adb push mkfs.fat /data
```

然后，重新给板子上电，启动Android，终端下：

```
console:/data # ./mkfs.fat /dev/block/mmcblk0p10
mkfs.fat 4.2+git (2021-01-31)

console:/data # blkid
/dev/block/mmcblk0p10: SEC_TYPE="msdos" UUID="8D0B-CB9B" TYPE="vfat"
/dev/block/mmcblk0p12: LABEL="/" UUID="6edfb94d-d96c-4819-9eaf-b1ef6845c12a" TYPE="ext4"
/dev/block/mmcblk0p14: LABEL="vendor" UUID="a4ee7a24-223f-4461-9c46-03e5607855de" TYPE="ext4"
/dev/block/mmcblk0p16: LABEL="product" UUID="076206b9-a1be-48ab-974d-06c351ebe192" TYPE="ext4"
/dev/block/mmcblk0p18: UUID="2de4cd99-a81f-48de-a702-a2aa5adcc298" TYPE="ext4"

```

## 3. MBR、GPT基础

MBR、GPT都是在User Data Area上实现的。

* 先介绍几个术语：

LBA——Logical block addressing , here you can look it as sector, which size is 512 Bytes
     please refer https://en.wikipedia.org/wiki/Logical_block_addressing

MBR——Master Boot Record
     The data structure that resides on the LBA 0 of a hard disk and defines the partitionson the disk."

GPT——GUID Partition Table	

A data structure that describes one or more partitions. 	

"It consists of a GPTHeaderand, typically, at least one GPTPartition Entry."	
	
"There are two GUID partition tables:"	
（1）the Primary Partition Table (located in LBA 1 of the disk) and 
（2）"a Backup Partition Table(located in the last LBA of the disk). The Backup Partition Table is a copy of the Primary Partition Table."

EFI——Extensible Firmware Interface
	"An interface between the operating system (OS) andthe platform firmware."

UEFI——Unified Extensible Firmware Interface. 
	"The interface between the operating system(OS) and the platform firmware defined by this specification."

BPB——BIOS Parameter Block 
	"The first block (sector) of a partition. It defines the type and location of the FAT FileSystem on a drive."

FAT——File Allocation Table 	

A table that is used to identify the clusters that make up a disk file. 	

"File allocationtables come in three flavors: "	

_FAT12, which uses 12 bits for cluster numbers; 

_"FAT16, which uses 16 bits;"

_"FAT32, which allots 32 bits but only uses 28 (the other 4 bitsare reserved for future use)."

GPTHeader——
	The header in a GUID Partition Table (GPT). 	
	"Among other things, it contains thenumber of GPT Partition Entries and the first and last LBAs that can be used for the entries."	

GPT Partition Entry——
	"A data structure that characterizes a Partition in the GPT disk layout. Among otherthings, it specifies the starting and ending LBA of the partition."

* eMMC空间分布图：                	

![每个eMMC分区都是从地址0x0000开始](https://github.com/titron/titron.github.io/raw/master/img/2021-12-17-fatfs_emmc_select_partition2.png)

这里，需要重点关注LBA0:

![LBA0解析](https://github.com/titron/titron.github.io/raw/master/img/2021-12-17-fatfs_emmc_UDA_LBA0.png)
![LBA0解析-分区类型是0xEE,即GPT分区](https://github.com/titron/titron.github.io/raw/master/img/2021-12-17-fatfs_emmc_UDA_LBA0_0xEE.png)
![LBA1解析](https://github.com/titron/titron.github.io/raw/master/img/2021-12-17-fatfs_emmc_UDA_LBA1_EFI_PART.png)
![LBAn解析](https://github.com/titron/titron.github.io/raw/master/img/2021-12-17-fatfs_emmc_UDA_LBAn.png)
![FAT分区的第一个sector解析](https://github.com/titron/titron.github.io/raw/master/img/2021-12-17-fatfs_emmc_UDA_FAT_sector0.png)

针对Android，不同分区，用途不同，参见下表。

|分区名|描述及存储的img|
|:-|:-|
|misc|For recovery storage bootloader message, reserve|
|psr||
|vbmeta_a|To store the verify boot's meta data|
|vbmeta_b|To store the verify boot's meta data|
|dtb_a|dtbo.img|
|dtb_b||
|dtbo_a||
|dtbo_b|dtbo.img|
|boot_a|boot.img|
|boot_b|boot.img|
|metadata|meta data of OTA update, remount, etc|
|system_a||
|system_b||
|vendor_a|vendor_boot.img|
|vendor_b|vendor_boot.img|
|product_a||
|product_b||
|userdata|system.img, system_ext.img, vendor.img, product.img
|

以上分区信息也可以在u-boot下用命令显示：
```
=> mmc dev 1
=> mmc part

Partition Map for MMC device 1  --   Partition Type: EFI							
Part    Start LBA       End LBA         Name					
        Attributes					
        Type GUID					
        Partition GUID					
  1     0x00000400      0x000007ff      "misc"					
        attrs:  0x0000000000000000					
        type:   ebd0a0a2-b9e5-4433-87c0-68b6b72699c7					
        guid:   00042021-0408-4601-9dcc-a8c51255994f					
  2     0x00000800      0x00000bff      "pst"					
        attrs:  0x0000000000000000					
        type:   ebd0a0a2-b9e5-4433-87c0-68b6b72699c7					
        guid:   8ef917d1-2c6f-4bd0-a5b2-331a19f91cb2
......
 18     0x00bd6c00      0x03a3dfde      "userdata"			
        attrs:  0x0000000000000000			
        type:   ebd0a0a2-b9e5-4433-87c0-68b6b72699c7			
        guid:   7bfe05ed-d33c-41cc-adaf-be8e55b00591			
=>
```


## 4. FAT基础

FAT分区的第一sector内容解析参考上图，根据不同的内容可以区分不同的分区类型：FAT16,FAT32,NTFS.

![FAT16与FAT32](https://github.com/titron/titron.github.io/raw/master/img/2021-12-17-fatfs_emmc_FAT16_32.png)
![FAT16/FAT32/NTFS](https://github.com/titron/titron.github.io/raw/master/img/2021-12-17-fatfs_emmc_FAT16_32_NTFS.png)
![DBR](https://github.com/titron/titron.github.io/raw/master/img/2021-12-17-fatfs_emmc_DBR.png)
![FDT](https://github.com/titron/titron.github.io/raw/master/img/2021-12-17-fatfs_emmc_FDT.png)



## 5. FatFs基础

FatFs官方链接：[http://elm-chan.org/fsw/ff/00index_e.html](http://elm-chan.org/fsw/ff/00index_e.html
)

这里，简要列出其特性：

* DOS/Windows Compatible FAT/exFAT Filesystem.
* Platform Independent. Easy to port.
* Very Small Footprint for Program Code and Work Area.
* Various Configuration Options to Support for:
* Long File Name in ANSI/OEM or Unicode.
* exFAT Filesystem, 64-bit LBA and GPT for Huge Storages.
* Thread Safe for RTOS.
* Multiple Volumes. (Physical Drives and Partitions)
* Variable Sector Size.
* Multiple Code Pages Including DBCS.
* Read-only, Optional APIs, I/O Buffer and etc...

![FatFs APIs](https://github.com/titron/titron.github.io/raw/master/img/2021-12-17-fatfs_emmc_apis.png)

## 6. 移植FatFs及SDHI/eMMC驱动

移植后的FatFs目录：

![FatFs 目录](https://github.com/titron/titron.github.io/raw/master/img/2021-12-17-fatfs_emmc_fatfs_dir.png)

移植后的FatFs目录：

![sdhi/emmc目录](https://github.com/titron/titron.github.io/raw/master/img/2021-12-17-fatfs_emmc_driver_dir.png)

## 7. 验证FatFs在eMMC上工作正常

* 新建文件
过程：
```
f_open
f_write
f_close
```

在Android终端下验证新文件：

```
console:/ # su
console:/ # cd data/user
console:/data/user # ls
0 test_myfat
console:/data/user # mount -t vfat /dev/block/mmcblk0p10 test_myfat/
console:/data/user # cd test_myfat/
console:/data/user/test_myfat # ls
test.txt
console:/data/user/test_myfat # ls -l
total 4
-rwx------ 1 root root 4096 2020-01-01 00:00 test.txt
console:/data/user/test_myfat # od -c test.txt
0000000   H   e   l   l   o   !   2   1   1   2   0   8  \n  \0  \0  \0
0000020 020 021 022 023 024 025 026 027 030 031 032 033 034 035 036 037
0000040       !   "   #   $   %   &   '   (   )   *   +   ,   -   .   /
0000060   0   1   2   3   4   5   6   7   8   9   :   ;   <   =   >   ?
0000100   @   A   B   C   D   E   F   G   H   I   J   K   L   M   N   O
0000120   P   Q   R   S   T   U   V   W   X   Y   Z   [   \   ]   ^   _
0000140   `   a   b   c   d   e   f   g   h   i   j   k   l   m   n   o
0000160   p   q   r   s   t   u   v   w   x   y   z   {   |   }   ~ 177
0000200 200 201 202 203 204 205 206 207 210 211 212 213 214 215 216 217
…

```

* 读现有文件

过程：

```
f_open
f_read
f_close
```

用调试器，验证读取到buffer的数据：
![用调试器验证read现有文件](https://github.com/titron/titron.github.io/raw/master/img/2021-12-17-fatfs_emmc_verify_read.png)
