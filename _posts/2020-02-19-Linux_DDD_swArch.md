---
layout: post
title:  "Linux设备驱动开发 学习笔记（6）——软件架构思想"
categories: basic
tags: Linux, Driver
author: David
---

* content
{:toc}

---
基于宋宝华《Linux设备驱动开发详解-基于最新的Linux4.0内核》。

---

软件工程思想与原则：

* 将软件进行分层设计
* 高内聚，低耦合，信息屏蔽
* 让正确的代码出现在正确的位置

实际的Linux驱动中，Linux内核尽量做的更多，以便于底层的驱动可以做的更少。而且，也特别强调了驱动的跨平台特性。

ARM Linux 3.x的目标：一个映像适用于多个硬件。

驱动只管驱动，设备只管设备，总线则负责匹配设备和驱动，而驱动则以标准途径拿到板级信息。

![Linux设备和驱动的分离](https://github.com/titron/titron.github.io/raw/master/img/2020-02-19-linux_ddd_sw_drvbus.png)

![Linux设备驱动的主机驱动、外设驱动分离](https://github.com/titron/titron.github.io/raw/master/img/2020-02-19-linux_ddd_sw_sep.png)

需关心总线、设备、驱动着3个实体。总线将设备和驱动绑定。在系统每注册一个设备的时候，会寻找与之匹配的驱动；相反的，在系统每注册一个驱动的时候，会寻找与之匹配的设备，而匹配有总线完成。

主机端只负责产生总线上的传输波形，而外设端只是通过标准的API来让主机端以适当的波形访问自身。涉及到4个软件模块：

* 主机端的驱动
* 连接主机和外设的纽带
* 外设端的驱动
* 板级逻辑



与本身依附于PCI、USB、I2C、SPI等设备不同，针对 在SOC系统中集成的独立外设控制器、挂接在SOC内存空间的外设等，Linux发明了一种虚拟的总线——platform总线，相应的设备称为platform\_device，而驱动称为platform\_driver。

在设备驱动中引入platform的概念至少有以下好处：

* 使得设备被挂接在一个总线上，符合Linux2.6以后内核的设备模型。其结果是使配套的sysfs节点、设备电源管理都成为可能。
* 隔离BSP和驱动。
* 让一个驱动支持多个设备实例。

匹配platform\_device和platform\_driver有4种可能：

* 基于设备树风格的匹配
* 基于ACPI风格的匹配
* 匹配ID表
* 匹配platform\_device设备名和驱动的名字