---
layout: post
title:  "shell中的注释"
categories: software
tags: linux
author: David
---

* content
{:toc}

---

[原链接](https://blog.csdn.net/lansesl2008/article/details/20558369)

* 单行注释

在行首用符号“#”。

* 多行注释

有多种方法，比较喜欢以下这种方法：

```
:<<!

......

!
```

例：

```
...
# Tarballs provided with the PoC
### comment for debug
:<<!
# CR7 loade 
tar xf ${PKG_RELEASE}/src/cr7-loader/cr7-loader*.tar.gz -C ./
mv cr7-loader* cr7-loader
# CR7 vlib
tar xf ${PKG_RELEASE}/src/cr7-vlib/cr7-vlib*.tar.gz -C ./
mv cr7-vlib* cr7-vlib
!

# Git repos plus patches
...
```

