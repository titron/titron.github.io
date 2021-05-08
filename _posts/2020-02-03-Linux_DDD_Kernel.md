---
layout: post
title:  "Linux设备驱动开发 学习笔记（2）——内核编程"
categories: software
tags: Linux, Driver
author: David
---

* content
{:toc}

---
基于宋宝华《Linux设备驱动开发详解-基于最新的Linux4.0内核》。

---

#### Linux内核编译与加载

在编译内核时，需要配置内核，可以使用下面命令中的一个：

* $ make config（基于文本的最为传统的配置界面，不推荐使用）
* $ make menuconfig（基于文本菜单的配置界面）
* $ make xconfig（要求QT被安装）
* $ make gconfig（要求GTK+被安装）

例：

  $ make ARCH=arm menuconfig

  $ make ARCH=arm xxx_defconfig /* arch/arm/configs/xxx_defconfig文件包含了许多电路板的默认配置 */

编译内核和模块的方法是：

  $ make ARCH=arm zImage
  
  $ make ARCH=arm modules
  
执行上述命令的结果：

- 在源代码的根目录下，会得到未压缩的内核映像vmlinux，内核符合表文件System.map;
  
- 在arch/arm/boot/目录下，会得到压缩的内核映像zImage；
  
- 在内核各对应目录，会得到选中的内核模块；

Linux内核的配置系统由以下3部分组成：  

* Makefile：分布在Linux内核源代码中，定义Linux内核的编译规则
* 配置文件（Kconfig）：给用户提供配置选择的功能
* 配置工具：包括配置命令解释器（对配置脚本中使用的配置命令进行解释）和配置用户界面（提供字符界面和图形界面）。

使用make config、make menuconfig等命令后，会生成一个.config配置文件，记录哪些部分被编译入内核，哪些部分被编译为内核模块。

运行make menuconfig等时，配置工具首先分析与体系结构对应的/arch/xxx/Kconfig文件（xxx即为传入的ARCH参数），/arch/xxx/Kconfig文件中除本身包含以下与体系结构相关的配置项与配置菜单以外，还通过source语句引入了一系列Kconfig文件，而这些Kconfig又可能再次通过source引入下一层的Kconfig，配置工具依据Kconfig包含的菜单和条目就可以描绘出一个菜单分层结构。

在Linux内核中增加程序需要完成一项3项工作：

* 将编写的源代码复制到Linux内核源代码的相应目录中
* 在目录的Kconfig文件中增加关于新源代码对应项目的编译配置选项
* 在目录的Makefile文件中增加对新源代码的编译条目

Kconfig文件中的配置项：
```
config XXXX

	tristate “xxxxxxxxx”
	
	dependson YYYY
	
	default n
	
	---help---
	
		nnnnnnnn
```

