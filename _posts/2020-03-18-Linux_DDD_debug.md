---
layout: post
title:  "Linux设备驱动开发 学习笔记（10）—— 调试"
categories: Software
tags: Linux Driver
author: David
---

* content
{:toc}

---
基于宋宝华《Linux设备驱动开发详解-基于最新的Linux4.0内核》。

---

## GDB
GDB是GNU开源组织发布的一个强大的UNIX下的程序调试工具，主要帮着工程师完成下面4个方面的功能（其图形化工具是DDD[http://www.gnu.org/software/ddd/](http://www.gnu.org/software/ddd/)）：

* 启动程序（驱动或用户空间的应用程序）
* 让程序在指定断点处停住
* 当程序停止住时，检查变量等信息
* 动态的改变程序的执行环境，如更改变量或memory的内容

准备：

* 编译输出.o文件（包含调试信息的二进制文件）
* 执行gdb xxx（.o），进入调试状态
* （然后，就可以使用以下GDB命令了，详细命令参考[http://sourceware.org/gdb/current/onlinedocs/gdb/](http://sourceware.org/gdb/current/onlinedocs/gdb/)  ）

| GDB命令 | 缩写 | 描述 | 备注 |
|---|---|---|---|
| list \<linenum> | l | 显示源程序 | \<linenum> - 显示第linenum行周围的源程序<br>\<function> - 显示function函数周围的源程序 |
| run | r | 运行程序 |  |
| break | b | 设置断点 | \<linenum> - 断在指定行号<br>\<function> - 断在指定函数 |
| next | n | 单步运行 | 相当于step over |
| step | s | 单步运行 | 相当于step in |
| continue | c | 运行到结束或下一个断点 |  |
| print | p | 查看运行数据 | print \<expr> |
| watch | w | 观察运行数据 | watch \<expr> |
| examine | x | 查看内存地址中的值 | x/\<n/f/u> |
| set |  | 修改内存 | set *(unsigned char *)p='h' |
| jump | j | 跳转 | jump \<address> |
| help | h | GDB帮助 |  |
| quit | q | 退出GDB |  |

## 内核调试
内核调试方法：

* 目标机“插桩”，如打上KGDB补丁，这样主机上的GDB就可以与目标机上的KGDB通过串口或网口通讯
* 使用仿真器
* 目标板上通过printk()、Oops、strace等软件方法进行”观察“调试。

### printk
目前，应用最广泛的方法是printk()。

printk()定义了8个消息级别（级别越低（数值越大），消息越不重要）。

可以通过/proc/sys/kernel/printk调节printk()的输出等级。

可以通过dmesg命令查看内核打印缓冲区，也可以使用cat /proc/kmsg命令来显示内核信息。

### Oops
Oops：Linux内核发生不正确的行为，并产生一份错误日志。（oops其实是表示惊讶或后悔，翻译过来可以译成哎哟，带有自我吃惊的意思，有时候也有抱歉的含义，但是这个词语不能代替真正的抱歉）

[这里有一篇来自TI的介绍Oops的文档](https://training.ti.com/debugging-embedded-linux-kernel-oops-logs?context=1128405-1139125-1128404)

![Oops实例](https://github.com/titron/titron.github.io/raw/master/img/2020-03-18-linux_ddd_debug_OopsExample.png)


## 性能分析与调优工具
在性能优化中的常用手段：

* 常用工具：top、vmstat、iostat、sysctl
* 高级分析手段：OProfile、gprof
* 内核跟踪：[LTTng](http://lttng.org/)
* 压力测试：[LTP](http://ltp.sourcefore.net/)
* 使用Benchmark[评估系统](http://lbs.sourceforge.net/)