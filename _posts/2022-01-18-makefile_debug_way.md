---
layout: post
title:  "Makefile常用调试方法（转）"
categories: software
tags: makefile
author: David
---

* content
{:toc}

---

[原文链接](https://www.cnblogs.com/lotgu/p/5936465.html) 

### warning函数

$(warning string）函数可以放在makefile 中的任何地方，执行到该函数时，会将string输出，方便定位make执行到哪个位置。warning函数可以放在makefile 中的任何地方：开始的位置、工作目标或必要条件列表中以及命令脚本中。这让你能够在最方便查看变量的地方输出变量的值。例如：
```
$(warning A top-level warning)

 

FOO := $(warning Right-hand side of a simple variable)bar

BAZ = $(warning Right-hand side of a recursive variable)boo

 

$(warning A target)target: $(warning In a prerequisite list)makefile

$(BAZ)

$(warning In a command script)

ls

$(BAZ):
```

这会产生如下的输出：
```
$ make

makefile:1: A top-level warning

makefile:2: Right-hand side of a simple variable

makefile:5: A target

makefile:5: In a prerequisite list

makefile:5: Right-hand side of a recursive variable

makefile:8: Right-hand side of a recursive variable

makefile:6: In a command script

ls

makefile
```

注意，warning函数的求值方式是按照make标准的立即和延后求值算法。虽然对BAZ的赋值动作中包含了一个warning函数，但是直到BAZ在必要条件列表中被求值后，这个信息才会被输出来。