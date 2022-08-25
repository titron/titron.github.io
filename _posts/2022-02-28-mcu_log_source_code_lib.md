---
layout: post
title:  "几个单片机/嵌入式开发应用的开源工具"
categories: software
tags: mcu, embedded, lib, log, open-source
author: David
---

* content
{:toc}

---



[从菜鸟到大牛，少不了这100多个软硬件开源项目！](https://mp.weixin.qq.com/s/cbLJSMmUOW60FIJ6K6z67g)

## 开源按键处理程序
[开源的按键库 MultiButton](https://github.com/liu2guang/MultiButton)
[FlexibleButton](https://github.com/zhaojuntao/FlexibleButton)

## .ini配置文件解析器--minIni
[minIni](https://github.com/compuphase/minIni)

## 显示相关
[小型GUI菜单框架-基于状态机?还是表驱动?...(附代码)](https://mp.weixin.qq.com/s?__biz=MzAwNjYwMjYyOA==&mid=2247491211&idx=1&sn=80c651e9b36ae104472542d01fb7244c&chksm=9b0bb460ac7c3d764c8be4c9cab2af4157c978172dc261dc036ece929e1caaaecf41096a5925&mpshare=1&scene=24&srcid=0201XrM5DXI8xFNMRwmxGX5V&sharer_sharetime=1612132577790&sharer_shareid=af43b8c65c55c076649d31f86aa3c934#rd)

开源嵌入式GUI：Ucgui、emWin、TouchGFX、MiniGUI、Lvglgui等。

[盘点嵌入式那些常见的GUI：emWin、TouchGFX、MiniGUI、Qt等](https://mp.weixin.qq.com/s/CGFQ4TM-sjZ958N8SkQOIg)


## 几个单片机/嵌入式开发应用的开源日志库

[原文](https://mp.weixin.qq.com/s/alkM9OmciddhCpxX_xi9PQ)

通常我们对日志有这些要求：

* 不同的日志级别（Debug,Warning, Info, Error, Fatal）；
* 日志打印要和printf一样简单易用；
* 能够设置日志级别；
* 占用空间小；
* 可配置，甚至可以禁用日志；
* 基于不同日志级别，支持颜色高亮；
* 可以自定义配置，时间戳；
* 支持RTOS；

以上是比较基本的功能，但是在嵌入式设备中，有的时候我们希望可以保存设备的运行日志，我们需要以下的一些功能；
* 支持多种访问方式，比如串口终端，保存到嵌入式文件系统中；
* 支持shell命令行通过串口终端进行访问；

以上这些需求不一定会全部实现。


### 1. log4c, [https://github.com/bmanojlovic/log4c](https://github.com/bmanojlovic/log4c)

   [介绍](https://www.cnblogs.com/jyli/archive/2010/02/11/1660606.html)

Log4c中有三个重要的概念: Category, Appender, Layout。

Category用于区分不同的Logger, 其实它就是个logger。在一个程序中我们可以通过Category来指定很多的Logger，用于不同的目的。

Appender用于描述输出流，通过为Category来指定一个Appender，可以决定将log信息来输出到什么地方去，比如*stdout, stderr, 文件, 或者是socket*等等

Layout用于指定日志信息的格式，通过为Appender来指定一个Layout,可以决定log信息以何种格式来输出，比如*是否有带有时间戳， 是否包含文件位置信息等，以及他们在一条log信息中的输出格式*等。

```c
//初始化
log4c_init();

//获取一个已有的category
log4c_category_t* mycat = log4c_category_get("mycat");

//用该category进行日志输出，优先级为DEBUG，输出信息为 "Hello World!"
log4c_category_log(mycat, LOG4C_PRIORITY_DEBUG, "Hello World!");
```

### 2. rxi_log, [https://github.com/rxi/log.c](https://github.com/rxi/log.c)

基于 C99 实现的简单日志库.

将源码中的log.c和log.h集成到你的项目中即可，需要打印日志的话，调用API即可.

```c
log_trace(const char *fmt, ...);
log_debug(const char *fmt, ...);
log_info(const char *fmt, ...);
log_warn(const char *fmt, ...);
log_error(const char *fmt, ...);
log_fatal(const char *fmt, ...);
```

### 3. ulog, [https://github.com/rdpoor/ulog](https://github.com/rdpoor/ulog)

uLog 为嵌入式微控制器或任何资源有限的系统提供结构化的日志记录机制。它继承了流行的 Log4c 和 Log4j 平台背后的一些概念，但开销更低。

uLog 的一些特点：

* uLog 易于集成到几乎任何环境中，由一个头文件和一个源文件组成，并且是用纯 C 编写的。
* uLog 提供熟悉的严重级别（CRITICAL、ERROR、WARNING、INFO、DEBUG、TRACE）。
* uLog 支持多个用户定义的输出（控制台、日志文件、内存缓冲区等），每个输出都有自己的报告阈值级别。
* uLog 是具有最小依赖性的“积极独立”，仅需要 stdio.h、string.h 和 stdarg.h。
* 当您不使用 uLog 时，它不会妨碍您：如果 ULOG_ENABLED 在编译时未定义，则不会生成日志记录代码。
* uLog 已经过很好的测试。有关详细信息，请参阅随附的 ulog_test.c 文件。

### 4. EasyLogger, [https://github.com/armink/EasyLogger](https://github.com/armink/EasyLogger)

特点如下：

* 轻量，ROM<1.6K, RAM<0.3K；
* 支持多种访问模式（例如：终端、文件、数据库、串口、485、Flash...）；
* 日志内容可包含级别、时间戳、线程信息、进程信息等；
* 线程安全，并支持 异步输出 及 缓冲输出 模式；
* 支持多种操作系统（RT-Thread、UCOS、Linux、Windows...），也支持裸机平台；
* 日志支持 RAW格式 ，支持 hexdump ；
* 支持按 标签 、 级别 、 关键词 进行动态过滤；
* 各级别日志支持不同颜色显示；
* 扩展性强，支持以插件形式扩展新功能。

