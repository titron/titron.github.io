---
layout: post
title:  "这个小架构又美又秀（转）"
categories: experience tools
tags: MCU cpost
author: David
---

* content
{:toc}

---

[这个小架构又美又秀](https://mp.weixin.qq.com/s/pl_yYSFsYNwcKcrzV_2H5w)
我们通常认为，在中断中，不能执行耗时的操作，否则会影响系统的稳定性，尤其对于嵌入式编程。对于带操作系统的程序而言，可以通过操作系统的调度，将中断处理分成两个部分，耗时的操作可以放到线程中去执行，但是对于没有操作系统的情况，又应该如何处理呢

比较常见的，我们可能会定义一些全局变量，作为flag，然后在mainloop中不停的判断这些flag，再在中断中修改这些flag，最后在mainloop中执行具体的逻辑，但是这样，无疑会增加耦合，增加程序维护成本。

cpost正是应用在这种情况下的一个简单但又十分方便的工具，它可以特别方便的进行上下文的切换，减少模块耦合。
cpost链接：
[https://github.com/NevermindZZT/cpost](https://github.com/NevermindZZT/cpost)

cpost借鉴的Android的handler机制，通过在mainloop中跑一个任务，然后在其他地方，可以是中断，也可以是模块逻辑中，直接抛出需要执行的函数，使其脱离调用处的上下文，运行在mainloop中。cpost还支持延迟处理，可以指定函数在抛出后多久执行。