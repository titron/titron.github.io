---
layout: post
title:  "Linux设备驱动开发 学习笔记（6）——文件系统与设备文件"
categories: Software
tags: Linux Driver
author: David
---

* content
{:toc}

---
基于宋宝华《Linux设备驱动开发详解-基于最新的Linux4.0内核》。

---

一切都是文件。

Linux 2.4内核的文件系统是devfs。

Linux 2.6以后的内核文件系统是udev。udev完全在用户态工作。

![Linux设备驱动与整个软硬件系统的关系](https://github.com/titron/titron.github.io/raw/master/img/2020-02-12-linux_ddd_devfile_block.png)

从图中可以看出，这里有两处不同的文件操作：Linux文件操作，C库文件操作。

Linux用户控件的文件编程有两种方法，即，通过Linxu API和通过C库函数访问文件。用户空间看不到设备驱动，能看到的只有与设备对应的文件。

Linux文件系统目录结构：

* ...
* /dev——设备文件存储目录，应用程序通过对这些文件的读写和控制以访问实际的设备。
* /mnt——挂载目录。
* /proc——操作系统运行时，进程及内核信息存放在这里。
* /var——/var/log目录被用来存放系统日志。
* /sys——Linux 2.6以后的内核所支持的sysfs文件系统被映射在此目录上。<br> Linux设备驱动模型中的总线、驱动、和设备都可以在sysfs文件系统中找到对应的节点。         
* ...


![文件系统与设备驱动之家的关系](https://github.com/titron/titron.github.io/raw/master/img/2020-02-12-linux_ddd_devfile_vfs.png)

在设备驱动程序的设计中，有两个结构体需要关系：

* file——系统中每个打开的文件在内核空间都有一个关联的struct file。
* inode——VFS inode是Linux管理文件系统的最基本单位，也是文件系统连接任何子目录、文件的桥梁。

Documents目录下的devices.txt文件描述了Linux设备号的分配情况：

* 主设备号——与驱动对应。同一类设备一般使用相同的主设备号。
* 次设备号——描述使用该驱动的设备的序号。

Linux设计中的一个基本观点是：机制与策略分离。

Linux 2.6以后的内核引入了sysfs文件系统，sysfs被看出是与proc、devfs、devpty同类别的文件系统，该文件系统是一个虚拟的文件系统。sysfs的一个目的就是战士设备驱动模型中各组件的层次关系，其顶级目录包括block、bus、devices、class、fs、kernel、power和firmware等。

在Linux内核中，分别使用（结构体的定义位于include/linux/device.h）

* bus_type——描述总线
* device_driver——描述驱动
* device——描述设备

![Linux设备驱动的主机驱动、外设驱动分离](https://github.com/titron/titron.github.io/raw/master/img/2020-02-19-linux_ddd_sw_sep.png)

设备和驱动分离，并通过总线进行匹配。

在Linux内核中，设备和驱动是分开注册的。bus_type的match()把两者联系在一起，一旦配对成功，xxx\_driver的probe()就被执行。

udev的工作过程如下：

* step 1：当内核检测到系统中出现了新设备后，内核会通过*netlink*套接字方式发送uevent。从而动态创建设备文件节点。

* step 2：udev获取内核发送的信息，进行规制的匹配。

udev规则文件：

* “#”开头——注释行
* 匹配关键字——ACTION、KERNEL、BUS、SUBSYSTEM、ATTR、NAME、SYMLINK、OWNER、GROUP、IMPORT、MODE


在嵌入式系统中，也可以用udev的轻量级版本mdev，mdev集成于busybox中。在编译busybox的时候，选中mdev相关项目即可。

Android也没有采用udev，它采用的是uold。uold的机制和udev是一样的。




一些目录：

* /proc/devices——可以获知系统中注册的设备。
* /dev——设备文件存储目录，应用程序通过对这些文件的读写和控制以访问实际的设备。
* var/log——存放系统日志。
* /sys——Linux 2.6以后的内核所支持的sysfs文件系统被映射在此目录上。<br> Linux设备驱动模型中的总线、驱动、和设备都可以在sysfs文件系统中找到对应的节点。         

