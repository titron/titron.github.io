---
layout: post
title:  "Linux性能测试工具之sysbench"
categories: tools
tags: linux bench
author: David
---

* content
{:toc}

[Linux性能测试工具之sysbench](https://www.linuxrumen.com/cyml/721.html)：

```bash
$source poky/oe-init-build-env
$bitbake sysbench
$cp build/tmp/work/aarch64-poky-linux/sysbench/0.4.12-r0/image/usr/bin/sysbench 到虚拟机上的nfs server根目录，这里是指/home/renesas/export/rfs。
```

启动kernel后，$cd /
然后，执行以下命令，进行CPU测试

```bash
[root@zcwyou ~]# sysbench --test=cpu --cpu-max-prime=20000 run
```


```bash
sysbench 0.4.12:  multi-threaded system evaluation benchmark

Running the test with following options:
Number of threads: 1

Doing CPU performance benchmark

Threads started!
Done.

Maximum prime number checked in CPU test: 20000


Test execution summary:
    total time:                          16.1375s
    total number of events:              10000
    total time taken by event execution: 16.1360
    per-request statistics:
         min:                                  1.58ms
         avg:                                  1.61ms
         max:                                  3.12ms
         approx.  95 percentile:               1.62ms

Threads fairness:
    events (avg/stddev):           10000.0000/0.00
    execution time (avg/stddev):   16.1360/0.00
```


说明：
cpu测试主要是进行素数的加法运算，在下图例子中，指定了最大的质数发生器数量为 20000，可以看出服务器此次测试 执行时间 大约为10.0005s秒


