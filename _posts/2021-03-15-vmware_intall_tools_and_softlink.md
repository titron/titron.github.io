---
layout: post
title:  "vmware安装VMware Tools, 及建立windows文件夹的软连接"
categories: software
tags: linux, patch
author: David
---

* content
{:toc}

---

[原帖](https://www.jianshu.com/p/2ee4924553d4)

### 1. 安装VMware Tools

启动VMware 的Linux系统，并开启虚拟机。

![dvd加载vmware tools光盘镜像](https://github.com/titron/titron.github.io/raw/master/img/2021-03-15-vmware_tools_iso.png)

等待Linux操作系统正常启动完毕，然后点击菜单

```
    Player - 管理 - 安装VMware Tools
```

然后，会在Linux的系统桌面上生成一个名字为“VMware Tools”的光驱文件。

双击“VMware Tools”光驱文件并进入，会看到一个后缀为.tar.gz的压缩文件。

将压缩文件复制到home目录下，home目录即左侧的主目录文件夹。复制过程用鼠标操作完成即可。复制完毕如下图所示。
```
    $ cp -rf *.tar.gz /home/xxx/
    $ cd /home/xxx/
    $ tar -xzvf *.tar.gz
```

解压完毕用“ls”命令查看，会看到产生一个“vmware-tools-distrib”文件夹。

用“cd vmware-tools-distrib”命令进入vmware-tools-distrib文件夹，然后在命令行执行：

```
    $ sudo ./vmware-install.pl   (输入用户密码即可进行vmware tools的安装)
```

等待VMware Tools安装完毕。安装成功会显示“Found VMware Tools CDROM mounted at ......"的字样，如下图所示。

上述VMware Tools安装完毕后，就可以从windows 拖拽文件夹到虚拟机中了。

不过，由于经常从windows copy文件到ubuntu虚拟机中，会造成VMware空间变得很大。

即使在虚拟机中删除了copy的文件，清空回收站，虚拟机尺寸并不能减小，尝试了网上减小尺寸的方法后，并不能减小虚拟机的尺寸。

这时，可以尝试下面的软连接方法，就不用拖拽文件夹到虚拟机中了，从而不用担心虚拟机尺寸变大的问题了。

### 2. 设置共享文件夹

首先，设置共享文件夹：

菜单： 管理 - 虚拟机设置 - 选项 - 共享文件夹，选择右侧的 “总是启用”，并添加windows文件夹。

![设置共享文件夹](https://github.com/titron/titron.github.io/raw/master/img/2021-03-15-vmware_share_softlink.png)

### 3. 建立windows文件夹的软连接

```
   $ cd /mnt/hgfs   (hgfs是可以看到共享成功的文件夹)
   $ sudo ln -s /mnt/hgfs/release/ /home/titron/img/M3N_imgs  (输入虚拟机系统密码 --ENTER即可)
   $ cd /home/titron/img/M3N_imgs
   $ ls  (可以看到软连接的文件夹目录了)
```
