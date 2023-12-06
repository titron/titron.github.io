---
layout: post
title:  "从ethernet或eMMC启动kernel以及文件系统"
categories: experience
tags: boot kernel rootfs ethernet TFTP-server NFS-server eMMC
author: David
---

* content
{:toc}

---


***平台：R-Car V4H WhitHawk all in 1***

### 1. 网络 - 启动kernel以及文件系统

#### 1.1 在ubuntu虚拟机上，安装并构建TFTP server、NFS server。

#### 1.2 copy Image、dtb、文件系统
copy以下文件到TFTP server文件存放目录下：

   * Image
   * r8a779g0-whitehawk.dtb

copy以下文件到NFS server文件存放目录下：
   * rcar-image-adas-v4h.tar.bz2

#### 1.3 更改环境变量参数
在u-boot命令终端，更改环境变量参数：
```bash
=> setenv ethaddr xx:xx:xx:xx:xx:xx
=> setenv ipaddr 192.168.0.20
=> setenv serverip 192.168.0.1
=> setenv bootargs 'rw root=/dev/nfs nfsroot=192.168.0.1:/export/rfs,nfsvers=3 ip=192.168.0.20:::::eth0 cma=560M@0x80000000 clk_ignore_unused'
=> setenv bootcmd 'tftp 0x48080000 Image;tftp 0x48000000 r8a779g0-whitehawk.dtb;booti 0x48080000 - 0x48000000'
=> saveenv
```

#### 1.4 boot log
```bash
N:ICUMX Loader Rev.0.21.1
N:Built : 11:46:15, Apr 19 2023
N:PRR is R-Car V4H Ver2.0
N:Boot device is QSPI Flash(40MHz)
...
U-Boot 2022.01 (Apr 23 2023 - 17:07:21 +0000)

CPU:   Renesas Electronics R8A779G0 rev 2.0
Model: Renesas White Hawk CPU and Breakout boards based on r8a779g0
DRAM:  7.9 GiB
RAM Configuration:
Bank #0: 0x048000000 - 0x0bfffffff, 1.9 GiB
Bank #1: 0x480000000 - 0x4ffffffff, 2 GiB
Bank #2: 0x600000000 - 0x6ffffffff, 4 GiB

MMC:   mmc@ee140000: 0
Loading Environment from MMC... OK
In:    serial@e6540000
Out:   serial@e6540000
Err:   serial@e6540000
Net:
Dummy RTOS Program
Dummy RTOS Program boot end
eth0: ethernet@e6800000
Hit any key to stop autoboot:  0
ethernet@e6800000 Waiting for PHY auto negotiation to complete.......... done
Using ethernet@e6800000 device
TFTP from server 192.168.0.1; our IP address is 192.168.0.20
Filename 'Image'.
Load address: 0x48080000
Loading: #################################################################
         #################################################################
         #################################################################
...
         ###############################
         1.7 MiB/s
done
Bytes transferred = 33839616 (2045a00 hex)
Using ethernet@e6800000 device
TFTP from server 192.168.0.1; our IP address is 192.168.0.20
Filename 'r8a779g0-whitehawk.dtb'.
Load address: 0x48000000
Loading: #########
         2.5 MiB/s
done
Bytes transferred = 121766 (1dba6 hex)
Moving Image from 0x48080000 to 0x48200000, end=4a2d0000
## Flattened Device Tree blob at 48000000
   Booting using the fdt blob at 0x48000000
   Loading Device Tree to 0000000057fdf000, end 0000000057fffba5 ... OK

Starting kernel ...

[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x414fd0b1]
...
[   15.925227] systemd[1]: Detected architecture arm64.

Welcome to Poky (Yocto Project Reference Distro) 3.1.11 (dunfell)!

[   15.989781] systemd[1]: Set hostname to <v4x>.
...

Poky (Yocto Project Reference Distro) 3.1.11 v4x ttySC0

v4x login:

```

### 2. eMMC - 启动kernel以及文件系统

#### 2.1 需要能够成功从网络启动（如前面“1. 网络 - 启动kernel以及文件系统”所述）

#### 2.2 在“/dev/mmcblk0”创建分区partition（如果没有分区的情况下）
```bash
$ fdisk /dev/mmcblk0
n for new partition
p for primary
1 for partition one
use defaults
a for boot-able
w for write and exit
```
#### 2.3 格式化分区，格式选择：ext4
```bash
$ mkfs.ext4 /dev/mmcblk0p1
```
#### 2.4 解压缩rootfs到“/dev/mmcblk0p1”
```bash
# mount
root@v4x:/# mount /dev/mmcblk0p1 /mnt

# 在虚拟机上，提前copy
#   (1) Image
#   (2) r8a779g0-whitehawk.dtb
#   (3）rcar-image-adas-v4h.tar.bz2
# 到nfstserver存放的文件目录下
root@v4x:/# ls
Image  boot  etc   lib    mnt   r8a779g0-whitehawk.dtb       run   sys  usr
bin    dev   home  media  proc  rcar-image-adas-v4h.tar.bz2  sbin  tmp  var

# extract
root@v4x:/# tar xvf rcar-image-adas-v4h.tar.bz2 -C /mnt
root@v4x:/# cd mnt/
root@v4x:/mnt# ls
bin  boot  dev  etc  home  lib  lost+found  media  mnt  proc  run  sbin  sys  tmp  usr  var
```
#### 2.5 解压缩rootfs完成后，copy kernel image 和dtb image
```bash
root@v4x:/mnt# cp ../Image boot/
root@v4x:/mnt# cp ../r8a779g0-whitehawk.dtb boot/
```
#### 2.6 重新启动，进入u-boot控制端，更改环境变量参数
```bash
=> setenv bootargs 'console=ttySC0,115200 rootfstype=ext4 root=/dev/mmcblk0p1 rw rootwait'
=> setenv bootcmd 'ext4load mmc 0 0x48080000 boot/Image;ext4load mmc 0 0x48000000 boot/r8a779g0-whitehawk.dtb;booti 0x48080000 - 0x48000000'
=> saveenv
=> run bootcmd
```

#### 2.7 boot log:
```bash
N:ICUMX Loader Rev.0.21.1
N:Built : 11:46:15, Apr 19 2023
N:PRR is R-Car V4H Ver2.0
N:Boot device is QSPI Flash(40MHz)
...
MMC:   mmc@ee140000: 0
Loading Environment from MMC... OK
In:    serial@e6540000
Out:   serial@e6540000
Err:   serial@e6540000
Net:
Dummy RTOS Program
Dummy RTOS Program boot end
eth0: ethernet@e6800000
Hit any key to stop autoboot:  0
33839616 bytes read in 188 ms (171.7 MiB/s)
121766 bytes read in 2 ms (58.1 MiB/s)
Moving Image from 0x48080000 to 0x48200000, end=4a2d0000
## Flattened Device Tree blob at 48000000
   Booting using the fdt blob at 0x48000000
   Loading Device Tree to 0000000057fdf000, end 0000000057fffba5 ... OK

Starting kernel ...

[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x414fd0b1]
...
[    6.679449] Marvell 88Q2110 e6810000.ethernet-ffffffff:00: attached PHY driver [Marvell 88Q2110] (mii_bus:phy_addr=e6810000.ethernet-ffffffff:00, irq=POLL)

Poky (Yocto Project Reference Distro) 3.1.11 v4x ttySC0

v4x login:

```


