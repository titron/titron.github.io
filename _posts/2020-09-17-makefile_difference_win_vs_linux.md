---
layout: post
title:  "Makefile在windows下和Linux下的不同对比"
categories: software
tags: linux
author: David
---

* content
{:toc}


| 项目 | windows | linux |
|---|---|---|
| 删除 | del | rm |
| 拷贝| copy | cp |
| 路径 | \ | / |
| 检查文件夹是否存在并建立 | @IF NOT EXIST $@ (mkdir $@) | if[ ! -d"$(TMPDIRS)"]; then mkdir $(TMPDIRS); fi |
