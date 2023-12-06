---
layout: post
title:  "Linux设备驱动开发 学习笔记（3）——内核模块"
categories: basic
tags: Linux, Driver
author: David
---

* content
{:toc}

---
基于宋宝华《Linux设备驱动开发详解-基于最新的Linux4.0内核》。

---

Linux设备驱动会以内核模块的形式出现，因此，学会编写Linux内核模块编程是学习Linux设备驱动的先决条件。

为了避免编译后的内核尺寸过大，有些功能不会被编译进内核。

当需要使用这些功能的时候，相应的代码被动态的加载到内核。这种机制被称为模块（Module）：

* 模块本身不被编译入内核image
* 模块一旦被加载，它就和内核中的其他部分完全一样

一个Linux模块主要由以下几个部分组成：

* 模块加载函数
* 模块卸载函数
* 模块许可证声明
* 模块参数（可选）
* 模块导出符号（可选）
* 模块作者等信息声明（可选）

```c
/*
 * 模块说明
 *
 */

static int __init xxx_init(void)
{

}

module_init(xxx_init);

static int __exit xxx_exit(void)
{

}

module_exit(xxx_exit);

MODULE_AUTHOR("XXX");
MODULE_LICENSE("XXX");
...
```

编译后，生成xxx.ko目标文件。

| 命令 | 描述 |
|---|---|
| insmod ./xxx.ko | 加载模块 |
| modprob ./xxx.ko | 加载模块及该模块依赖的其他模块 |
| modprob -r ./xxx.ko | 卸载模块及该模块依赖的其他模块 |
| lsmod | 获得系统中已经加载的所有模块及模块间的依赖关系（读取/proc/modules文件）；已经加载的模块信息位于/sys/module目录 |
| modinfo <模块名> | 获得模块的信息 |

