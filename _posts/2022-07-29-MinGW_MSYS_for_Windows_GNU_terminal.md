---
layout: post
title:  "MSYS和MinGW配合打造Windows下的GNU命令行终端和编译系统"
categories: experience
tags: MinGW MSYS GNU Linux
author: David
---

* content
{:toc}

---

## 释义
**MinGW** 是Minimalist GNU for Windows的缩写，提供了windows平台上极简的GUN开发环境，包含编译器gcc、g++、链接器、调试器等，用以开发windows应用程序。

MinGW开发的程序是windows本地程序，不依赖额外的运行时库。

**MSYS**的全称叫Minimal SYStem，是MinGW的一个子系统，是一套运行在Windows上的bash，也就是运行在Win上的Linux Terminal，可以代替cmd来使用。

对一些GNU的开源软件，MSYS可能是必需的，因为它们通常需要./configure然后make才能运行。

我们将MSYS和MinGW配合使用就可以打造出一个Win下的GNU命令行终端和编译系统。

## 安装MSYS2
从[MSYS2](https://www.msys2.org/)下载安装版本，然后，双击安装。

![MSYS Menu-Options](https://github.com/titron/titron.github.io/raw/master/img/2022-07-29-mingw-msys-options.png)
![MSYS Options](https://github.com/titron/titron.github.io/raw/master/img/2022-07-29-mingw-msys-options-config.png)

* 更新包到最新版本
```bash
$ pacman -Syu
```

## 安装MinGW
（预先已经安装好了MinGW环境。）

重命名:mingw32-make.exe ---> make.exe


## 设置环境变量

去msys2的安装目录，找到etc文件夹下的profile文件，然后添加环境变量。
```c
# Here, add "../xxxxx/rcar-xos/v3.3.0/tools/toolchains/mingw64/bin"
MSYS2_PATH="/usr/local/bin:/usr/bin:/bin:../xxxxx/rcar-xos/v3.3.0/tools/toolchains/mingw64/bin"
...
export GNUMAKE=/D/Renesas/rcar-xos/v3.3.0/tools/toolchains/mingw64/bin
```

\etc\fstab文件，可以配置文件目录映射：比如配置C:\Users\lenovo\Desktop /desktop后，可以在终端直接cd /desktop后可以直接切换到C:\Users\lenovo\Desktop目录下，下面是配置mingw的映射示例：
```c
# Win32_Path                                                Mount_Point
C:/xxxxx/rcar-xos/v3.3.0/tools/toolchains/mingw64         /mingw
```

查看PATH以及gcc版本
```bash
$ echo $PATH
/mingw64/bin:/usr/local/bin:/usr/bin:/bin:../xxxxx/rcar-xos/v3.3.0/tools/toolchains/mingw64/bin:/c/Windows/System32:/c/Windows:/c/Windows/System32/Wbem:/c/Windows/System32/WindowsPowerShell/v1.0/:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl

$ gcc -v
...
gcc version 7.3.0 (x86_64-posix-seh-rev0, Built by MinGW-W64 project)
```

## 检验环境是否设置正确
在当前HOME目录下，编辑hello.c文件
```C
#include <stdio.h>
int main() {
    printf("Hello,World!\n");
    printf("sizeof(size_t)=%ld\n", sizeof(size_t));
    return 0;
}
```
编译，执行
```
$ gcc hello.c
$ ./a
Hello,World!
sizeof(size_t)=8

```
## 其他——
### 【1】建立快捷方式
开始——MSYS2 64bit——MSYS2 MinGW x64——打开文件位置，右键——发送到——桌面快捷方式。
### 【2】安装vim
```bash
$ pacman -S vim
...
$ vim --version
...
```
### 【3】Conemu支持tab页面，以及分屏
下载<https://conemu.github.io/>安装。
用下面的命令建立new task，for MinGW64 shell:
```bash
set MSYSTEM=MINGW64 & set MSYSCON=conemu64.exe & "c:\msys2_64\usr\bin\bash.exe" --login -i
```
![Conemu-New task](https://github.com/titron/titron.github.io/raw/master/img/2022-07-29-mingw-msys-options-Conemu.png)


## 参考：
1. [MinGW、MSYS、Cygwin、Git Bash Shell](https://blog.csdn.net/nydia_lvhq/article/details/121183596)
2. [MSYS2](https://www.msys2.org/)
3. [windows上msys2配置及填坑](https://hustlei.github.io/2018/11/msys2-for-win.html)
4. [msys2+WinGW64以及msys2中环境变量的配置](https://blog.csdn.net/qq_16981075/article/details/123835207)
5. [Conemu, Msys2 工具整合，提升windows下控制台工作效率](https://www.cnblogs.com/piepie/p/8474263.html)
6. [ConEmu: How to call msys2 as tab?](https://superuser.com/questions/1024301/conemu-how-to-call-msys2-as-tab)
