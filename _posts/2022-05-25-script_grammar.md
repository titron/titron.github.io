---
layout: post
title:  "Shell脚本语言"
categories: software
tags: script
author: David
---

* content
{:toc}

---

在写shell脚本的时候发现cd切换目录的时候无法切换，还是在当前目录下，这是什么原因呢？
```bash
#!/bin/bash
TOP=`pwd`
cd ${TOP}/../XXXXX/rcar-xos/v3.3.0/
ls -l
```

可以使用下述命令去执行我们的脚本即可。
```bash
# way - 1
$ source xxx.sh

# way - 2
# note: . ./xxx.sh .和.中间有个空格！
$ . ./xxx.sh
```



参考:
1. [Shell脚本语言(语法)](https://www.jianshu.com/p/da49f71b9fc8)
2. [shell脚本基本语法详解](https://blog.csdn.net/qq_18297675/article/details/52693464)