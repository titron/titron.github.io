---
layout: post
title:  "Linux设备驱动开发 学习笔记（8）——中断与时钟"
categories: Software
tags: Linux Driver
author: David
---

* content
{:toc}

---
基于宋宝华《Linux设备驱动开发详解-基于最新的Linux4.0内核》。

---

Linux在中断处理中引入了顶半部与底半部分分离的机制

* 顶半部（Top Half）——处理紧急的硬件操作
* 底半部（Bottom Half）——处理不紧急的耗时操作。

  底半部的机制主要有：tasklet、工作队列、软中断、线程化irq

如果中断要处理的工作很少，完全可以在顶半部全部完成。

3种类型的中断：

* SGI(Software General Interrupt)——用于多核的核间通讯
* PPI(Private Peripheral Interrupt)——某个CPU私有外设的中断
* SPI(Shared Peripheral Interrupt)——共享外设的中断。这类中断可以路由到任何一个CPU。

Linux内核周期性任务实现：

* 定时器——支持tickless和NO_HZ模式，也包含对hrtimer的支持（到微秒级别精度）定时器：
* 快捷机制——利用工作队列和定时器实现

Linux内核延时：

* 短延时——纳秒、微秒、毫秒
* 长延时——比较jiffies
* 睡着延时——在等待的时间到来之前，进程处于睡眠状态，CPU资源被其他进程使用。推荐使用这种延时。

相关中断函数解释：
```

request_irq()		/* 申请中断 */

dev_request_irq()	/* 申请中断，申请的是内核managed的资源 */

free_irq()			/* 释放中断 */

disable_irq_nosync()	/* 立即返回 */

disable_irq()		/* 等待目前的处理完成再返回 */ 


```


一些目录：

* /proc/interrupts——可以获得系统中中断的统计信息，并能攻击出每个中断号上的中断在每个CPU上发生的次数

