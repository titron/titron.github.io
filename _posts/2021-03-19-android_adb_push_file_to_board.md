---
layout: post
title:  "android利用adb传输文件"
categories: experience
tags: android adb
author: David
---

* content
{:toc}

---

### 准备条件：

1 板子通过usb2uart连接到ubuntu虚拟机（可移动设备名称为：Google Salxxxxxx）。

并启动android。

2 虚拟机上首先要安装VMware Tools（否则，会看不到共享文件夹）。

[可以参考这里](https://titron.github.io/2021/03/15/vmware_intall_tools_and_softlink/)

3 启用windows下共享文件夹、

   (1)要传输的文件，例如，test.txt

   (2)android img文件夹——含adb命令

以上两者均位于该共享文件夹。

### 操作：

1 虚拟机上，进入终端，并进入上述共享文件夹下，或软连接目录。

2 shell下，

```bash
$ ./adb root
restarting adbd as root

$ ./adb shell  （可以进入板上目录）

salvator:/ # ls
acct         dev                       init.zygote64_32.rc sdcard
bin          etc                       lost+found          storage
bugreports   init                      mnt                 sys
cache        init.environ.rc           odm                 system
charger      init.rc                   oem                 ueventd.rc
config       init.recovery.salvator.rc postinstall         vendor
d            init.usb.configfs.rc      proc
data         init.usb.rc               product
default.prop init.zygote32.rc          sbin

salvator:/sdcard/Movies # exit

$ ./adb push /home/titron/test.txt /sdcard/Download
$ ./adb push /home/m3n_imgs/aaa.mp3 /data/media/0/Download
$ ./adb push /home/m3n_imgs/bbb.apk /data/media/0/Download
# 说明：
# 推送到/data/media/0/Download，
# 相当于推送到/sdcard/Download
#
# "/data/media/0"是安卓手机内置存储的真实目录，
# 而"/sdcard"是内置存储被安卓系统挂载的快捷方式（指向"/data/media/0"）；
# 通常需要存储空间权限的手机app会访问后者，前者需要ROOT权限才能访问，因此这两个文件夹是一个目录
# 有关android内部存储和外部存储，请参看下面的附录连接。

```

附录：

1. [Android中的内部存储和外部存储](http://huzhengyu.com/2019/08/10/storage/)

2. [ADB & fastboot 常用命令](https://blog.csdn.net/pen_cil/article/details/79762640?utm_medium=distribute.pc_relevant.none-task-blog-searchFromBaidu-8.control&dist_request_id=&depth_1-utm_source=distribute.pc_relevant.none-task-blog-searchFromBaidu-8.control)



