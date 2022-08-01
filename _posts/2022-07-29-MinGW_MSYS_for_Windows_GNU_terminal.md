---
layout: post
title:  "MSYS和MinGW配合打造Windows下的GNU命令行终端和编译系统"
categories: software
tags: MinGW, MSYS, GNU, Linux
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


## 设置环境变量

去msys2的安装目录，找到etc文件夹下的profile文件，然后添加环境变量。
```c
# Here, add "../Renesas/rcar-xos/v3.3.0/tools/toolchains/mingw64/bin"
MSYS2_PATH="/usr/local/bin:/usr/bin:/bin:../Renesas/rcar-xos/v3.3.0/tools/toolchains/mingw64/bin"
```

\etc\fstab文件，可以配置文件目录映射：比如配置C:\Users\lenovo\Desktop /desktop后，可以在终端直接cd /desktop后可以直接切换到C:\Users\lenovo\Desktop目录下，下面是配置mingw的映射示例：
```c
# Win32_Path                                                Mount_Point
C:/Renesas/rcar-xos/v3.3.0/tools/toolchains/mingw64         /mingw
```

查看PATH以及gcc版本
```bash
$ echo $PATH
/mingw64/bin:/usr/local/bin:/usr/bin:/bin:../Renesas/rcar-xos/v3.3.0/tools/toolchains/mingw64/bin:/c/Windows/System32:/c/Windows:/c/Windows/System32/Wbem:/c/Windows/System32/WindowsPowerShell/v1.0/:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl

$ gcc -v
Using built-in specs.
COLLECT_GCC=C:\Renesas\rcar-xos\v3.3.0\tools\toolchains\mingw64\bin\gcc.exe
COLLECT_LTO_WRAPPER=C:/Renesas/rcar-xos/v3.3.0/tools/toolchains/mingw64/bin/../libexec/gcc/x86_64-w64-mingw32/7.3.0/lto-wrapper.exe
Target: x86_64-w64-mingw32
Configured with: ../../../src/gcc-7.3.0/configure --host=x86_64-w64-mingw32 --build=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --prefix=/mingw64 --with-sysroot=/c/mingw730/x86_64-730-posix-seh-rt_v5-rev0/mingw64 --enable-shared --enable-static --disable-multilib --enable-languages=c,c++,fortran,lto --enable-libstdcxx-time=yes --enable-threads=posix --enable-libgomp --enable-libatomic --enable-lto --enable-graphite --enable-checking=release --enable-fully-dynamic-string --enable-version-specific-runtime-libs --enable-libstdcxx-filesystem-ts=yes --disable-libstdcxx-pch --disable-libstdcxx-debug --enable-bootstrap --disable-rpath --disable-win32-registry --disable-nls --disable-werror --disable-symvers --with-gnu-as --with-gnu-ld --with-arch=nocona --with-tune=core2 --with-libiconv --with-system-zlib --with-gmp=/c/mingw730/prerequisites/x86_64-w64-mingw32-static --with-mpfr=/c/mingw730/prerequisites/x86_64-w64-mingw32-static --with-mpc=/c/mingw730/prerequisites/x86_64-w64-mingw32-static --with-isl=/c/mingw730/prerequisites/x86_64-w64-mingw32-static --with-pkgversion='x86_64-posix-seh-rev0, Built by MinGW-W64 project' --with-bugurl=https://sourceforge.net/projects/mingw-w64 CFLAGS='-O2 -pipe -fno-ident -I/c/mingw730/x86_64-730-posix-seh-rt_v5-rev0/mingw64/opt/include -I/c/mingw730/prerequisites/x86_64-zlib-static/include -I/c/mingw730/prerequisites/x86_64-w64-mingw32-static/include' CXXFLAGS='-O2 -pipe -fno-ident -I/c/mingw730/x86_64-730-posix-seh-rt_v5-rev0/mingw64/opt/include -I/c/mingw730/prerequisites/x86_64-zlib-static/include -I/c/mingw730/prerequisites/x86_64-w64-mingw32-static/include' CPPFLAGS=' -I/c/mingw730/x86_64-730-posix-seh-rt_v5-rev0/mingw64/opt/include -I/c/mingw730/prerequisites/x86_64-zlib-static/include -I/c/mingw730/prerequisites/x86_64-w64-mingw32-static/include' LDFLAGS='-pipe -fno-ident -L/c/mingw730/x86_64-730-posix-seh-rt_v5-rev0/mingw64/opt/lib -L/c/mingw730/prerequisites/x86_64-zlib-static/lib -L/c/mingw730/prerequisites/x86_64-w64-mingw32-static/lib '
Thread model: posix
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
resolving dependencies...
looking for conflicting packages...

Packages (1) vim-8.2.5117-2

Total Download Size:    8.41 MiB
Total Installed Size:  53.39 MiB

:: Proceed with installation? [Y/n] y
:: Retrieving packages...
 vim-8.2.5117-2-x86_64                                                                                               8.4 MiB  1993 KiB/s 00:04 [######################################################################################] 100%
(1/1) checking keys in
...
$ vim --version
VIM - Vi IMproved 8.2 (2019 Dec 12, compiled Jun 23 2022 04:01:15)
Included patches: 1-5117
Compiled by <https://www.msys2.org/>
...
```

## 参考：
1. [MinGW、MSYS、Cygwin、Git Bash Shell](https://blog.csdn.net/nydia_lvhq/article/details/121183596)
2. [MSYS2](https://www.msys2.org/)
3. [windows上msys2配置及填坑](https://hustlei.github.io/2018/11/msys2-for-win.html)
4. [msys2+WinGW64以及msys2中环境变量的配置](https://blog.csdn.net/qq_16981075/article/details/123835207)


