---
layout: post
title:  "Linux设备驱动开发 学习笔记（4）——电源管理"
categories: basic
tags: Linux, Driver
author: David
---

* content
{:toc}

---
基于宋宝华《Linux设备驱动开发详解-基于最新的Linux4.0内核》。

---

电源管理的唯一目标是 **省电** 。


CMOS电路中的功耗与电压的平方成正比，与频率成正比：P∝fV^2


![Linux内核电源管理的整体架构](https://github.com/titron/titron.github.io/raw/master/img/2020-2-12-linux_ddd_pm_block.png)

图中，有两处频率变换的地方：

* **CPUFreq**——针对CPU/SOC来说。该子系统位于drivers/cpufreq目录下。
* **DevFreq**——针对外围设备/模块来说。该子系统位于drivers/devfreq目录下。

CPUFreq的核心层位于drivers/cpufrq/cpufreq.c：

* 为各个SOC的CPUFreq驱动实现提供了一套统一的接口
* 实现了一套notifier机制，用于在CPUFreq的策略和频率改变的时候想其他模块发出通知

每个SOC的具体CPUFreq驱动实例只需要实现电压、频率表，以及从硬件层面完成这些变化。

SOC CPUFreq驱动只是设定了CPU的频率参数，以及提供了设置频率的途径。

一个SOC的CPUFreq驱动实例（drivers/cpufreq/s3c64xx-cpufreq.c）：

```c
...
static struct s3c64xx_dvfs s3c64xx_dvfs_table[] = {
	[0] = { 1000000, 1150000 },
	[1] = { 1050000, 1150000 },
	[2] = { 1100000, 1150000 },
	[3] = { 1200000, 1350000 },
	[4] = { 1300000, 1350000 },
};

static struct cpufreq_frequency_table s3c64xx_freq_table[] = {
	{ 0, 0,  66000 },
	{ 0, 0, 100000 },
	{ 0, 0, 133000 },
	{ 0, 1, 200000 },
	{ 0, 1, 222000 },
	{ 0, 1, 266000 },
	{ 0, 2, 333000 },
	{ 0, 2, 400000 },
	{ 0, 2, 532000 },
	{ 0, 2, 533000 },
	{ 0, 3, 667000 },
	{ 0, 4, 800000 },
	{ 0, 0, CPUFREQ_TABLE_END },
};

static int s3c64xx_cpufreq_set_target(struct cpufreq_policy *policy,
				      unsigned int index)
{
...
		ret = regulator_set_voltage(vddarm,
					    dvfs->vddarm_min,
					    dvfs->vddarm_max);
...

	ret = clk_set_rate(policy->clk, new_freq * 1000);

...
}

#ifdef CONFIG_REGULATOR
static void s3c64xx_cpufreq_config_regulator(void)
{
...

	cpufreq_for_each_valid_entry(freq, s3c64xx_freq_table) {
		dvfs = &s3c64xx_dvfs_table[freq->driver_data];
		found = 0;

		for (i = 0; i < count; i++) {
			v = regulator_list_voltage(vddarm, i);
			if (v >= dvfs->vddarm_min && v <= dvfs->vddarm_max)
				found = 1;
		}

...
}
#endif

static int s3c64xx_cpufreq_driver_init(struct cpufreq_policy *policy)
{
...
	policy->clk = clk_get(NULL, "armclk");
...
		s3c64xx_cpufreq_config_regulator();
...
		regulator_put(vddarm);
		clk_put(policy->clk);
...
}

static struct cpufreq_driver s3c64xx_cpufreq_driver = {
	.flags		= CPUFREQ_NEED_INITIAL_FREQ_CHECK,
	.verify		= cpufreq_generic_frequency_table_verify,
	.target_index	= s3c64xx_cpufreq_set_target,
	.get		= cpufreq_generic_get,
	.init		= s3c64xx_cpufreq_driver_init,
	.name		= "s3c",
};

static int __init s3c64xx_cpufreq_init(void)
{
	return cpufreq_register_driver(&s3c64xx_cpufreq_driver);
}
module_init(s3c64xx_cpufreq_init);

```

究竟频率依据哪种标准，进行何种变化，完全有CPUFreq的策略（policy）决定：
![CPUFreq的策略及实现方法](https://github.com/titron/titron.github.io/raw/master/img/2020-2-12-linux_ddd_pm_policy.png)

![CPUFreq的策略及调频](https://github.com/titron/titron.github.io/raw/master/img/2020-2-12-linux_ddd_pm_adjfreq.png)

用户空间可通过/sys/devices/system/cpu/cpux/cpufreq节点来设置CPUFreq（采用userspace策略），则运行如下命令：

```bash
\# echo userspace > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

\# echo 700000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed

```

CPUFreq子系统主要会发出两种通知（notifier）：

* **策略变化**时，发出3次通知
- CPUFREQ_ADJUST：所有注册的notifier可以根据硬件或温度的情况去修改范围（policy->min & max）
- CPUFREQ_INCOMPATIBLE：除非前面的策略设定可能会导致硬件出错，否则，被注册的notifier不能改变范围等设定
- CPUFREQ_NOTIFY：所有注册的notifier都会被告知新的策略已经被设置

* **频率变化**时，发出2次通知
- CPUFREQ_PRECHANGE：准备变更
- CPUFREQ_POSTCHANGE：已经完成变更

* **其他**
- CPUFREQ_SUSPENDCHANGE：挂起系统
- CPUFREQ_RESUMECHANG：恢复系统

除了CPU以外，一些非CPU设备也支持多个操作频率和电压，存在多个OPP。Linux 3.2之后的内核也支持针对这种非CPU设备的DVFS，该套子系统为DEVFreq，位于drivers/devfreq目录。

某个domain所支持的<频率，电压>对的集合被称为Operating Performance Point，缩写为OPP。

一个OPP实例：

```c
static struct omap_opp_def __initdata omap44xx_opp_def_list[]={
	/* MPU OPP1 - OPP50 */
	OPP_INITIALIZER("mpu", true, 300000000, OMAP4430_VDD_MPU_OPP50_UV),
	...
}

...

int __init omap4_opp_init(void)
{
...
	r = omap_init_opp_table(omap44xx_opp_def_list,
			ARRAY_SIZE(omap44xx_opp_def_list));
...
}
device_initcall(omap4_opp_init);
int __init omap_init_opp_table(struct omap_opp_def *opp_def, u32 opp_def_size)
{
...
	for(i = 0; i< opp_def_size;i++,opp_def++){
	...
	r = opp_add(dev, opp_def->freq, opp_def->u_volt);
	...
	}
	return 0;
}

```

下面两个API分别用于获取与某OPP对应的电压和频率：

unsigned long opp\_get\_voltage(struct opp *opp);

unsigned long opp\_get\_freq(struct opp *opp);

当某个CPUFreq驱动想将CPU设置为某一频率的时候，它可能会同时设置电压，其代码流程为：

```c
soc_switch_to_freq_voltage(freq)
{
	/* do thing */
	rcu_read_lock();
	opp = opp_find_freq_ceil(dev, &freq);
	v = opp_get_voltage(opp);
	rcu_read_unlock();
	if(v)
		regulator_set_voltage(..,v);

	/* do other things */
}
```

big.LITTLE架构的设计旨在为适当的作业分配恰当的处理器。

：
![Linux挂起到RAM流程](https://github.com/titron/titron.github.io/raw/master/img/2020-2-12-linux_ddd_pm_suspendToRAM.png)