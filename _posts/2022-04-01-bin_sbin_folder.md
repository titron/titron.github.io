---
layout: post
title:  "bin sbin目录的区别"
categories: software
tags: rootfs, kernel
author: David
---

* content
{:toc}

---

/bin,/sbin目录是在系统启动后挂载到根文件系统中的，所以,/sbin,/bin目录必须和根文件系统在同一分区：
- bin/ 下存放系统的一些指令。bin为binary的简写主要放置一些系统的必备执行档例如:cat、cp、chmod df、dmesg、gzip、kill、ls、mkdir、more、mount、rm、su、tar等。
- sbin/ 下一般是指超级用户指令。主要放置一些系统管理的必备程式例如:cfdisk、dhcpcd、dump、e2fsck、fdisk、halt、ifconfig、ifup、 ifdown、init、insmod、lilo、lsmod、mke2fs、modprobe、quotacheck、reboot、rmmod、 runlevel、shutdown等。

/usr/bin,usr/sbin可以和根文件系统不在一个分区。
- /usr/bin/下是你在后期安装的一些软件的运行脚本。主要放置一些应用软体工具的必备执行档例如c++、g++、gcc、chdrv、diff、dig、du、eject、elm、free、gnome*、 gzip、htpasswd、kfm、ktop、last、less、locale、m4、make、man、mcopy、ncftp、 newaliases、nslookup passwd、quota、smb*、wget等。
- /usr/sbin/放置一些用户安装的系统管理的必备程式例如:dhcpd、httpd、imap、in.*d、inetd、lpd、named、netconfig、nmbd、samba、sendmail、squid、swap、tcpd、tcpdump等。

如果新装的系统，运行一些很正常的诸如：shutdown，fdisk的命令时，悍然提示：bash:command not found。那么首先就要考虑root 的$PATH里是否已经包含了这些环境变量。

可以查看PATH，如果是：
```bash
PATH=$PATH:$HOME/bin
```
则需要添加成如下：
```bash
PATH=$PATH:$HOME/bin:/sbin:/usr/bin:/usr/sbin
```


参考：
[/bin,/sbin,/usr/sbin,/usr/bin 目录之简单区别](https://blog.csdn.net/kkdelta/article/details/7708250)