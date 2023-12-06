---
layout: post
title:  "makefile 语法memo"
categories: basic
tags: makefile script linux gcc
author: David
---

* content
{:toc}

---

[1] -D
```Bash
CFLAGS += -DETHTSN
```

解释：
-D是gcc命令行参数，定义宏。
虽然写在Makefile中，跟Makefile没什么关系

比如：
CFLAGS= -D_MY_MACRO
下面一定有
$(CC) $(CFLAGS) 这样传给gcc

