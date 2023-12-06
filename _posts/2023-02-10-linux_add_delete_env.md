---
layout: post
title:  "LINUX中查看、添加、删除PATH以及永久添加PATH(转)"
categories: experience
tags: linux environment
author: David
---

* content
{:toc}

---

转：

[LINUX中查看、添加、删除PATH以及永久添加PATH](https://www.cnblogs.com/xiaopiyuanzi/p/11910107.html)

```bash
# list PATH
$ echo $PATH

# add new to PATH
$ export PATH=$PATH:新添加的路径

# delete something in PATH
$ echo $PATH  #if PATH=路径1:路径2:路径3:路径4
$ export PATH=路径1:路径2:路径4
```