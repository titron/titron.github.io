---
layout: post
title:  "QNX Hypervisor中的一些概念"
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

## 一些术语：

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

## 文件后缀

.build

QNX hypervisor host domain或QNX guest的buildfile。

.img

bootable image文件。可能是一个hypervisor host domain, 一个guest, 或 一个host domain及一个或多个guests。

.qvmconf

VM配置文件; 由VM的qvm process instance解析。


下图是QNX hypervisor架构和配置（以访问virtual、physical的device）：
![QNX hypervisor architecture](https://github.com/titron/titron.github.io/raw/master/img/2020-04-27-Overview_Hypervisor.png)  
  
  
## 两类设备（Device）

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

## VM vs Guest OS

打个比方：

就像VirtualBox里面建立虚拟机一样。

Guest OS是运行于硬件上的软件，这里，VM就相当于该“硬件”。

虽然VM仍然是运行于hypervisor host上的一个qvm process instance，是软件。


### VM assembly and configuration

qvm process instance做以下动作:

* 读、剖析、验证*.qvmconf文件
* 建立一个转换表（stage tables）(ARM: Stage 2 page tables, x86: Extended Page Tables (EPT)).
* 创建 (assembles) 并配置VM:

  分配RAM (r/w)及ROM (r only)给guests
  
  为每个虚拟CPU开启一个thread
  
  启动passthrough设备
  
  定义并配置虚拟设备vdevs
  

## guest中断 <-> 实际的中断

详细描述参考[这里](http://www.qnx.com/developers/docs/7.0.0/index.html#com.qnx.doc.hypervisor.user/topic/perform/irqs.html)。

过多的中断会显著降低guest的性能。

在使用hypervisor的系统中，虽然guest可以配置中断控制器硬件，但是，还是由hypervisor来管理硬件以完成guest的需求。所以说，当硬件device产生中断给guest时，hypervisor总是要介入的，这意味着需要至少有一次打断guest的执行，来允许hypervisor查看中断并决定怎么处理这个中断。

即使设备中断被配置成pass-through中断，hypervisor还是会管理中断控制器硬件。hypervisor必须屏蔽中断，把它传递给guest（通过更新vCPU线程thread），最后，再打开中断（物理EOI）。

hypervisor介入中断传递给guest的过程（即使是pass-through中断），好处：

*（从系统角度看）可以防止发生中断风暴（interrupt storm）
* 允许（guest失效时）正确的清除挂起的中断

在虚拟系统中，如果硬件不提供特殊支持的话，hypervisor接管所有的事情。hypervisor捕获中断，并更新相应的vCPU thread结构体（中断相关信息）。这是纯软件的方法。然后，hypervisor会请求至少一个guest退出并引入最大的开销（？）。

许多ARM及x86平台提供了虚拟化支持，以**减少中断的传递过程**。

如何利用硬件的这些辅助特性呢？注意以下几点：
* 硬件Features
* BSP支持features（包含、使能、配置必要的模块及features）
* VM配置（包含、配置必要的features）
* guest配置（包含、配置必要的features）

**ARM**

针对ARM平台，hypervisor提供了2种技术用于减少guest的退出然后去处理中断。

- Interrupt enable

如果硬件允许，hypervisor可以设置guest的IRQ请求bit，即便guest disabled中断。设置该bit不会导致guest 退出。

- GIC hardware assist

许多ARM平台（with GICv2）及很多最近较新的GIC硬件会提供硬件辅助功能，用于中断的处理。

当发生中断时，这些GIC 硬件辅助不会消除guest exit，但是，在guest中断（interrupt delivery）传输（pass-through，vdev）上，会帮着guest操作虚拟GIC 状态。

**x86（略）**

**LAPIC 硬件辅助（略）**

**（ARM GIC）Virtual Interrupt Handling**








