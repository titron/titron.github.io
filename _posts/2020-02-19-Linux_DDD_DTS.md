---
layout: post
title:  "Linux设备驱动开发 学习笔记（5）——设备树"
categories: software
tags: Linux, Driver
author: David
---

* content
{:toc}

---


基于宋宝华《Linux设备驱动开发详解-基于最新的Linux4.0内核》。

[这个帖子对Linux驱动的发展历史解释的很详细](https://www.eet-china.com/mp/a108935.html?utm_source=EETC%20Forum%20Alert&utm_medium=Email&utm_campaign=2022-02-23)

---

设备树（Device Tree）是一种描述硬件的数据结构。

有自己的独立语法。由一系列被命名的节点（node）和属性（Property）组成。

节点本身可包含子节点。

基本上就是画一颗电路板上CPU、总线、设备组成的树，Booloader会将这棵树传递给内核，然后内核可以识别这棵树，并根据它展开出Linux内核中的platform_device、i2c_client、spi_device等设备，而这些设备用到的内存、IRQ等资源，也被传递给了内核，内核会将这些资源绑定给展开的相应的设备。

设备树源文件.dts，编译后得到.dtb，BootLoader在引导Linux内核的时候会将.dtb地址告诉内核。之后，内核会展开设备树并创建和注册相关的设备。

* DTS —— 文件.dts是一种ASCII文本格式的设备树描述。一个.dts文件对应一个ARM设备。可以包括.dtsi文件。.dtsi文件 —— 相当于C语言中的.h文件。SOC公用的部分或多个设备共同的部分放在这里。

	一般放在arch/arm/boot/dts/目录中。

* DTC —— 将.dts编译为.dtb的工具。

	源代码一般放在scripts/dtc/目录中。

	如果内核使能了设备树，DTC会被编译出来。对应于scripts/dtc/Makefile中的“hostprogs-y := dtc”。

* DTB —— 是.dts被DTC编译后的二进制格式的设备树描述。

	.dtb文件可以单独存放在一个很小的区域，也可以直接和zImage绑定在一起做出一个映像文件（编译内核时，使能CONFIG_ARM_APPENDED_DTB）。

	**反编译dtb**文件为dts文件的命令：
	```
	$ dtc -I dtb -O dts -o test.dts ./r8a7795-salvator-xs-android.dtb
	```
* Binding —— 讲解文档，讲解设备树中的节点和属性是如何来描述设备的硬件细节的，扩展名.txt。

	位于内核的Documentation/devicetree/bindings目录。

* BootLoader —— Uboot从v1.1.2开始支持设备树。使能方法：在编译Uboot时，在config文件中，加入 “#define CONFiG_OF_LIBFDT”。

![Linux设备树声明周期](https://github.com/titron/titron.github.io/raw/master/img/2020-02-19-linux_ddd_dts_lifec.png)

![Linux设备树节点属性读取](https://github.com/titron/titron.github.io/raw/master/img/2020-02-19-linux_ddd_dts_node.png)

![Linux设备树节点属性cells](https://github.com/titron/titron.github.io/raw/master/img/2020-02-19-linux_ddd_dts_cells.png)

![Linux设备树全景视图](https://github.com/titron/titron.github.io/raw/master/img/2020-02-19-linux_ddd_dts_all.png)

常用的 OF API	(实现代码位于内核的drivers/of目录下):

```c
of_machine_is_compatible();
of_device_is_compatible();

of_find_compatible_node(); /* 寻找节点 */

of_find_device_by_node(); /* 获取与节点对应的platform_device */

of_property_read_bool(); /* 读取属性，bool值 */
of_property_read_u8_array(); /* 读取属性, 数组 */
of_property_read_u8(); /* 读取属性，一个值 */
of_property_read_string(); /* 读取字符串 */

of_address_to_resource(); /* 内存映射 */

irq_of_parse_and_map(); /* 解析中断 */
```

另外，还可以参考官方文档：
1. [dts文件格式官方参考文档](https://www.devicetree.org/specifications)
2. [dts文件格式官方参考文档-DeviceTree Specification Release v0.4-rc1 - Released 1 December 2021](https://github.com/devicetree-org/devicetree-specification/releases/tag/v0.4-rc1)
3. [内核文档列表解析-booting-without-of.txt](https://www.kernel.org/doc/Documentation/devicetree/booting-without-of.txt)
4. [内核文档列表解析-booting.rst](https://www.kernel.org/doc/Documentation/arm64/booting.rst)

