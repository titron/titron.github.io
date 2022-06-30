---
layout: post
title:  "Linux设备驱动开发 学习笔记（9）——芯片级移植"
categories: software
tags: Linux, Driver
author: David
---

* content
{:toc}

---
基于宋宝华《Linux设备驱动开发详解-基于最新的Linux4.0内核》。

---
为了让Linux在一个全新的SoC上运行，需要提供大量的底层支撑：

* 定时器节拍
* 中断控制器
* SMP启动
* CPU热插拔
* GPIO
* 时钟
* pinctrl
* DMA

![Linux芯片级移植](https://github.com/titron/titron.github.io/raw/master/img/2020-03-16-linux_ddd_port_all.png)

## 定时器节拍
当前Linux多采用无节拍(根据系统的运行情况，以事件驱动的方式动态决定下一个节拍在何时产生)方案，并支持高精度定时器，内核的配置一般会使能NO\_HZ和HIGH\_RES\_TIMERS。

实现：clock\_event\_device、clocksource。
```c
...
static struct irqaction xxx_timer_irq = {
	.name = "xxx_tick",
	.flags = IRQF_TIMER,
	.irq = 0,
	.handler = xxx_timer_interrupt,
	.dev_id = &xxx_clockevent,
}
```

对于多核处理器来说，一般的做法是给每个核分配一个独立的定时器，各个核根据自身的运行情况动态的设置自己时钟中断发生的时刻。

处理器间通讯，通过IPI（Internal Processor Interrupt）广播到其他核。在R-Car SoC，是通过MFIS（Multifunctional Interface）实现。

## 中断控制器
芯片供应商需要提供以下API的底层支持：

```c
request_irq()
enable_irq() /* 与具体中断控制器有关 */
disable_irq() /* 与具体中断控制器有关 */
local_irq_enable() /* 与具体中断控制器无关 */
local_irq_disable() /* 与具体中断控制器无关 */
```

指令：

CPSID/CPSIE—— >= Arm v6

MRS/MSR—— < Arm v6

![Linux 中断](https://github.com/titron/titron.github.io/raw/master/img/2020-03-16-linux_ddd_port_int.png)

在内核中，通过irq_chip结构体来描述中断控制器。

```c
struct irq_chip{
	...
	void (*irq_ack)(struct irq_data *data); /* 清中断 */
	void (*irq_mask)(struct irq_data *data); /* mask */
	...
	void (*irq_unmask)(struct irq_data *data); /* unmask */
	...
	int (*irq_set_type)(struct irq_data *data, unsigned int flow_type);	 /* 设置触发方式 */
}
```

对于有多个中断控制器的，其之间可能是级联的。

![Linux 多个中断控制器](https://github.com/titron/titron.github.io/raw/master/img/2020-03-16-linux_ddd_port_multiInt.png)

drivers/pinctrl/sirf/pinctrl-sirf.c中，显示了如何实现级联：

```c
static int sirfsoc_gpio_probe(struct device_node *np)
{
...

	gpiochip_set_chained_irqchip(&sgpio->chip.gc,
	&sirfsoc_irq_chip,
	bank->parent_irq,           /* 上一级中断号 */
	sirfsoc_gpio_handle_irq);   /* 上一级中断服务程序 */
...
}
...
static void sirfsoc_gpio_handle_irq(unsigned int irq, struct irq_desc *desc)
{
...

	if((status & 0x01) && (ctrl & SIRFSOC_GPIO_CTL_INTR_EN_MASK))
	{
		generic_handle_irq(irq_find_mapping(gc->irqdomain,
			idx+bank->id * SIRFSOC_GPIO_BANK_SIZE));
	}

...
}

```

以上，假设，中断服务程序为deva\_isr()。

如果GPIO0_5中断发生的时候，内核的调用顺序是：

```c
sirfsoc_gpio_handle_irq()
->
generic_handle_irq()
->
deva_isr().
```

## SMP

![一个典型的多核Linux启动过程](https://github.com/titron/titron.github.io/raw/master/img/2020-03-16-linux_ddd_port_multProcessBoot.png)

每个CPU都有一个自身的ID。

一般在上电时，ID不是0的CPU将自身置于WFI或WFE状态，并等待CPU0给其发CPU核间中断或事件（一般通过SEV指令）以唤醒它。

```bash
#echo 0 > /sys/devices/system/cpu/cpu1/online #卸载CPU1，并将CPU1上的任务全部迁移到其他CPU中

#echo 1 > /sys/devices/system/cpu/cpu1/online #再次启动CPU1。之后，CPU1会主动参与系统中各个CPU之间要运行任务的负载均衡工作

```
CPU0唤醒其他CPU的动作在内核中被封装为一个smp_operations的结构体。

```c
struct smp_operations{
	...
	void (*smp_init_cpus)(void);
	void (*smp_prepare_cpus)(void);
	void (*smp_secondary_init)(void);
	void (*smp_boot_secondary)(void);
	...
}
```
![CPU0唤醒其他CPU的过程](https://github.com/titron/titron.github.io/raw/master/img/2020-03-16-linux_ddd_port_cpu0wup.png)

## GPIO

在dirvers/gpio下实现了通用的基于gpiolib的GPIO驱动，其中定义了一个通用的用于描述底层GPIO控制器的gpio_chip结构体。

```c
struct gpio_chip{
	...
	int (*request)(..);
	int (*free)(..);

	int (*direction_input)(..);
	int (*direction_output)(..);

	void (*set)(...);

	...

}
```


## 时钟
clk结构体：

```c
struct clk_init_data{
	const char *name;
	const struct clk_ops *ops;
	const char **parent_name;
	u8 num_parenets;
	unsigned long flags;
}

struct clk_ops{
	int (*prepare)(...);
	...
	int (*enable)(...);
	int (*disable)(...);
	...
	int (*set_rate)(...);
	...
}

struct clk_hw{
	struc clk *clk;
	const struct clk_init_data *init;
}

struct clk{
	const char *name;
	const struc clk_ops *ops;
	struct clk_hw *hw;
	...
}

```

## pinctrl
配置一个或一组引脚的功能和特性

* 枚举并命名pin控制器可控制的所有引脚
* 提供引脚复用的能力
* 提供配置引脚的能力，如驱动能力、上拉下拉、开漏等

## DMA

dmaengine是一套通用的DMA驱动框架，为具体使用DMA通道的设备驱动提供一套通用的API，而且也定义了用具体的DMA	控制器实现这一套API的方法。

使用DMA引擎的过程可分为几步：
```c
...
desc = dmaengine_prep_dma_cyclic(...); /* 初始化描述符 */
...
prtd->cookie = dmaengine_submit(desc); /* 将该描述符插入dmaengine驱动的传输队列 */
...
dma_async_issue_pending(prtd_dma_chan); /* DMA传输开始 */
```


