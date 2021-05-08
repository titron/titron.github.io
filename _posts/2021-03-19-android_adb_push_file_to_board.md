---
layout: post
title:  "android利用adb传输文件"
categories: software
tags: android，adb
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
   
```
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

$ ./adb push /home/titron/test.txt /sdcard/Movies
$ ./adb push /home/m3n_imgs/aaa.mp3 /data/media/0/Download
$ ./adb push /home/m3n_imgs/bbb.apk /data/media/0/Download

```

附录：[ADB & fastboot 常用命令](https://blog.csdn.net/pen_cil/article/details/79762640?utm_medium=distribute.pc_relevant.none-task-blog-searchFromBaidu-8.control&dist_request_id=&depth_1-utm_source=distribute.pc_relevant.none-task-blog-searchFromBaidu-8.control)

