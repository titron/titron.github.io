---
layout: post
title:  "mkfs.ext4: no command解决方法"
categories: software
tags: yocto, bitbake, mkfs, e2fsprogs
author: David
---

* content
{:toc}

---

编译Yocto工程，使用默认的rootfs设置进行编译，烧写Image和rootfs后，启动。

打算用mkfs.ext4命令格式化emmc，这时，才发现bin/和sbin/目录下都没有*mkfs.ext4*命令。

### 解决方法【1】：

一般默认的local.conf里很多package是没有的。

如果有需求的话，一般是先通过
```
bitbake -s | grep 关键字 
```
检索当前的配方列表里是否有那个package。

然后,再按这个配置添加到local.conf里，编辑local.conf，在后面加以下内容：

```
IMAGE_INSTALL_APPEND = " e2fsprogs"
```
这样，bitbake core-image-weston后，会编译这个package，并将生成的image **自动存放** 到rootfs（根文件系统）里。

### 解决方法【2】：

```
$ source poky/oe-init-build-env 
$ bitbake e2fsprogs
```
*mkfs.ext4* 命令存在于这个目录下：
```
~/build/tmp/work/aarch64-poky-linux/e2fsprogs/1.45.4-r0/image$			
```
将所有的目录**copy**到虚拟机下的NFS服务器目录（home/titron/export/rfs/）下，再次启动kernel，就能使用这些命令了。 				

BTW，命令*mkfs.fat*不在e2fsprogs包中，需要从这里下载，然后编译该包生成：
https://github.com/dosfstools/dosfstools/releases/download/v4.2/dosfstools-4.2.tar.gz

