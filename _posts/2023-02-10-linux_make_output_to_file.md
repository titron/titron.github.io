---
layout: post
title:  "MAKE输出LOG"
categories: experience
tags: linux make
author: David
---

* content
{:toc}

---

Linux系统下执行make命令，编译比较大一点的工程或者文件的时候，在命令行下错误和警告信息直接就把我们的实现覆盖了。

那么如何保存配置编译过程的信息？

最好是把编译过程的信息保存成日志文件，方便后面的分析。举例说明保存编译信息的行命令，它把make过程打印的所有信息都保存在xxx.log中。

```bash
# 这条命令是编译并保存打印信息。在Linux Shell的设备定义中，“0”表示标准输入，“1”表示标准输出，“2”表示标准出错信息输出。2>&1表示把2设备的信息重定向到1设备；

# “|”是管道符号，把标准输出的信息直接传递给后面的命令；tee是创建文件并保存信息的工具；xxx.log是文件名。
$ make 2>&1|tee xxx.log

# 相比于上面的命令，输出到log文件的信息更多
# 但是，终端不显示任何编译信息
$ make > build.log 2>&1
```

参考：
[1. 保存打印信息到文件](https://www.cnblogs.com/cane/p/3914502.html)
[2. Linux下Make编译结果输出到文件](https://blog.csdn.net/faithzzf/article/details/72466420)