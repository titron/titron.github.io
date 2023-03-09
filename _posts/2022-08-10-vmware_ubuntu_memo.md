---
layout: post
title:  "vmware下ubuntu虚拟机memo"
categories: software
tags: vmware, ubuntu
author: David
---

* content
{:toc}

---

### 扩展系统磁盘空间
[VMware虚拟机Ubuntu20.04扩展系统磁盘空间](https://www.dounaite.com/article/62756d3fac359fc91320b5c4.html)

先在vmware中调整空间。

然后，启动虚拟机。

在终端，安装并用gparted工具调整系统磁盘空间大小。

### 共享文件夹失效
[重新安装工具，选"覆盖"](https://titron.github.io/2021/03/15/vmware_intall_tools_and_softlink/)

vmware管理中，连接CD/DVD到：C:\Program Files (x86)\VMware\VMware Player\linux.iso.

然后，启动虚拟机。

copy光驱中的压缩包到desktop，解压。

然后，运行压缩包中的文件：sudo ./vmware-install.pl （安装过程中，选择“覆盖”）。

### 调整终字体大小
放大：ctrl+shift+=

恢复初始大小：ctrl+0

（吐槽：为什么不添加一个缩小呢？：ctrl+shift+-）
### 虚拟机释放键盘控制快捷键
CTRL+ALT: release the mouse pointer so that it is no longer inside the remote desktop

