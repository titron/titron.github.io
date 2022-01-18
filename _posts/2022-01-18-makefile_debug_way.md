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

[原文链接](https://blog.csdn.net/guozhongwei1/article/details/88693221) 

## 使用info/warning/error增加调试信息

### info
```
$(info “here add the debug info”)
```
注,info信息,不打印信息所在行号

### warning
```
$(warning “here add the debug info”)
```
### error
```
$(error “error: this will stop the compile”)
```

这个可以停止当前makefile的编译

### 打印变量的值
```
$(info $(TARGET_DEVICE) )
```

### 使用echo增加调试信息

注:echo只能在target：后面的语句中使用，且前面是个TAB,

形式如下:
```
@echo “start the compilexxxxxxxxxxxxxxxxxxxxxxx”
@echo $(files)
```
参考并修正:[Makefile中的几个调试方法](https://blog.csdn.net/wlqingwei/article/details/44459139)
