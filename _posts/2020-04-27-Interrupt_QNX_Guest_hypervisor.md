---
layout: post
title:  "QNX Hypervisor中Guest的中断"
categories: Software
tags: QNX Hypervisor Guest Interrupt
author: David
---

* content
{:toc}

---
参考：

1. [QNX Hypervisor 2.0](http://www.qnx.com/developers/docs/7.0.0/#com.qnx.doc.hypervisor.nonsafety.user/topic/about.html)
2. [ARM Generic Interrupt Controller Architecture Specification](https://static.docs.arm.com/ihi0069/c/IHI0069C_gic_architecture_specification.pdf)

一些术语：

* device

实际的硬件。相比较于vdev来说。

* guest

包括guest OS及运行于上的应用。

一个qvm process instance 负责一个guest

guest运行于qvm之上。

* host

大多数场合，host指的是hypervisor或其他运行于hypervisor上的东西。

* hypervisor
简单来说，指的是QHS / QNX Hypervisor. 

QHS - “QNX Hypervisor for Safety”.

QNX Hypervisor - QNX Hypervisor for Safety 2.0 Safety.

* qvm

qvm (or qvm process)是hypervisor的一个process。

由hypervisor启动qvm process instances; 每个qvm process instance 代表一个虚拟机(VM)，guest运行于上。

A qvm process就会运行于hypervisor host domain允许的level上，而且这个level比guest host的level低。

* vdev

hypervisor上虚拟出来的任何device. 例如：中断控制（虚拟出来的），或以太网控制器(para-virtualized)。

* VM

就是一个qvm process instance，guest运行于其上，VM是guest的host。


下图是QNX hypervisor架构和配置（以访问virtual、physical的device）：
![QNX hypervisor architecture](https://github.com/titron/titron.github.io/raw/master/img/2020-04-27-Overview_Hypervisor.png)  
  
  
有两类设备（Device）:

1. Virtual device
对于这类设备，Guest访问（被分配的）虚拟地址设备(virtual 或 para-virtual)。
qvm process instance请求适当的特权级别更改，并将执行请求传递给所请求的设备。 

2. Pass-through device
对于这类设备，Guest可以直接访问实际的物理设备。
qvm process instance什么都不做。


guest interrupt入口（entry）需要在VM configuration（.qvmconf文件）中声明，例如下所示：

例1：vdev pl011 loc 0x1c090000 intr gic:37

例2：pass loc 0xe6055400,0x050,rwn intr gic:42 # GPIO6

其中，entry格式描述如下：
1. 有名字
2. 有中断号
- x86平台，自动分配，只标上“apic”就可以了。

  例1（x86平台）：
  vdev ioapic 
  loc 0xf8000000
  intr apic 
  name myioapic
  
- ARM平台，自动分配，也可以指明中断号，标上“gic”。

  例2（ARM平台）：
  vdev pl011 
  loc 0x1c090000 
  intr gic:37


.qvmconf文件中，中断号需要是惟一的（也可以不指定，系统会自动分配）：intr gic:xxx （xxx是唯一的，不能重复）


那么，guest中断和实际的中断之间是怎么样的一条路径呢？







