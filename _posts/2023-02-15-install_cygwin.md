---
layout: post
title:  "安装Cygwin"
categories: experience
tags: linux windows Cygwin
author: David
---

* content
{:toc}

---

Step 1. 下载

下载地址 [官网](http://www.cygwin.com/)

Step 2. 安装

双击安装包下载。

![Select Proxy](https://github.com/titron/titron.github.io/raw/master/img/2023-02-15-install_Cygwin_Select_Proxy.png)

从[Cygwin Mirror Sites](https://cygwin.com/mirrors.html)选择国内镜像并添加，然后选择一个mirror进行安装：
![Add Mirror](https://github.com/titron/titron.github.io/raw/master/img/2023-02-15-install_Cygwin_Add_Mirror.png)

安装 Devel -binutils、 gcc 、mingw 、gdb
![Select Package-Devel](https://github.com/titron/titron.github.io/raw/master/img/2023-02-15-install_Cygwin_Select_Devel.png)

![Select Package-Devel-binutils](https://github.com/titron/titron.github.io/raw/master/img/2023-02-15-install_Cygwin_Select_Devel_binutils.png)

![Select Package-Devel-gcc](https://github.com/titron/titron.github.io/raw/master/img/2023-02-15-install_Cygwin_Select_Devel_gcc.png)

![Select Package-Devel-gdb](https://github.com/titron/titron.github.io/raw/master/img/2023-02-15-install_Cygwin_Select_Devel_gdb.png)

![Select Package-Devel-make](https://github.com/titron/titron.github.io/raw/master/img/2023-02-15-install_Cygwin_Select_Devel_make.png)

![Select Package-Devel-mingw](https://github.com/titron/titron.github.io/raw/master/img/2023-02-15-install_Cygwin_Select_Devel_mingw.png)

Step 3. 使用

```bash
a5059726@RECH-0054891 /cygdrive/c
$ cygcheck -c cygwin
Cygwin Package Information
Package              Version        Status
cygwin               3.4.6-1        OK


```

Step 4. 配置
将以下目录添加到环境变量：
```bash
C:\cygwin64\bin
C:\cygwin64\sbin
```
```bash
a5059726@RECH-0054891 /cygdrive/c
$ gcc --version
gcc (GCC) 11.3.0
Copyright (C) 2021 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

a5059726@RECH-0054891 /cygdrive/c
$ make --version
GNU Make 4.4
Built for x86_64-pc-cygwin
Copyright (C) 1988-2022 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

```

参考：
1. [Cygwin安装教程](https://blog.csdn.net/u010356768/article/details/90756742)
2. [Cygwin Mirror Sites](https://cygwin.com/mirrors.html)