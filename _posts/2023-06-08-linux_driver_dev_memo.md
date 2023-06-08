---
layout: post
title:  "linux驱动开发中相关的问题"
categories: software
tags: linux，driver
author: David
---

* content
{:toc}

---

参考：
1. [入职Linux驱动工程师后，我才知道的真相…](https://mp.weixin.qq.com/s/bOkJbBO57SXT0xJHFwmQNw)


1. 输出hello

在.c中实现module_init和module_exit这两个函数，然后在module_init的函数里加个printk，输出个hello world。

把.c编译成.ko，然后insmod加载驱动，看到有打印，就算成功了。

2. 设备树相关

加载dtb和.ko驱动，看到有打印，又成功了。心想，设备树应该就是这样吧。

3. 系统启动前加载

要把一个.ko驱动在系统启动完成前就加载，这时才知道原来可以把命令放到/etc/init.d/rcS里。

作为驱动工程师，可以不用把文件系统了解的太深，但起码要知道inittab、rcS、passwd和shadow这几个文件的作用，还有就是前面说的C库。

rcS是文件系统启动时要执行的一些命令，inittab、passwd和shadow主要是修改系统登录时的用户名和密码，包括设置免密登录等等。

通常把文件系统提供给客户前，都会把用户名改为root，密码改为自己公司的名字，这时就会用到这几个文件。

4. 驱动编进内核

Linux内核源码中每个目录下都有一个Makefile，我以为改个Makefile就行了。

但一运行，驱动没生效。后来才知道，原来还要修改Kconfig。

把驱动编进内核，其实正确的做法应该是通过menconfig菜单能够配置这个驱动是否编译，即修改Kconfig。

Makefile和Kconfig都修改了，驱动还是没生效？

这时就要看.o文件是否编译出来了，如果编译出来了。进一步看这个驱动的初始化级别，看是module_init、arch_initcall还是其他的级别。

然后加打印，把内核initcall的等级打印出来，看内核是否已经跑了该等级的初始化。如果已经跑到了，再把该等级的initcall执行函数的地址打印出来，然后反汇编vmlinux，看是否已经执行了新加驱动的probe函数。

5. 手动修改defconfig配置引发的问题

编译内核时，通常都会用厂商提供的一个默认配置文件，例如make xxx_defconfig。

但是，如果我们想这个配置文件中加一个自己的宏，例如CONFIG_XXX=y，然后在代码中判断#ifdef CONFIG_XXX，你会发现并没有生效，并且原来写的CONFIG_XXX=y也没了。

这是很多新手改defconfig都会遇到的问题，其实是没有搞懂如何正确修改defconfig文件。

在defconfig中定义了CONFIG_XXX=y后，还要在Kconfig文件中添加一个config XXX的配置才会生效。

另外，如何某个配置选项存在依赖关系，但依赖的配置选项没打开，也会出现这种不生效的情况。

所以，还是建议通过menconfig菜单进行配置，除非真的弄清楚了这些关系，才能去手动修改defconfig。

6. 源码阅读/跟踪问题

虽然有一些比较有用的内核调试技巧，但真正常用的，还是加打印跟踪，其它调试技巧归根到底还是辅助性的，很多情况下还是靠加打印分析问题。

跟踪一些函数传参过程，关注是否正确使用、是否正确传参问题，因为最终解决问题可能只是一个很简单的操作。

7. 需要学会多少个驱动才行？

会多少驱动，这其实是一个进阶的过程。没有说一定要会多少个，但随着工作经验的增长，自身所掌握的驱动也会越来越多，承担的责任也越大。