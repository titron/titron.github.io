---
layout: post
title:  "在vmware的ubuntu虚拟机与服务器之间传递数据"
categories: software
tags: vmware, ubuntu, ssh
author: David
---

* content
{:toc}

---

![系统框图](https://github.com/titron/titron.github.io/raw/master/img/2022-08-11-share_file_block.png)

### step 1: vmware上的ubuntu虚拟机
操作如下：
```bash
# 安装SSH server
titron@ubuntu:~/s4poc_dev/build-spider-gateway$ sudo apt-get install ssh openssh-server
# 检查虚拟机的IP地址
titron@ubuntu:~/s4poc_dev/build-spider-gateway$ sudo apt install net-tools
titron@ubuntu:~/s4poc_dev/build-spider-gateway$ ifconfig
ens33: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.231.129  ...
```
得到虚拟机的IP地址：192.168.231.129

### step 2: windowns
操作如下：添加一个网络位置：
![添加网络位置](https://github.com/titron/titron.github.io/raw/master/img/2022-08-11-share_file_add_net_link.png)

### step 3: 用FileZilla传递文件或者文件夹
操作如下：
FileZilla中，输入VM的ip地址，连接成功。
另一侧窗口指向服务器端。
就可以传送文件或者文件夹了。
![用FileZilla传递文件或者文件夹](https://github.com/titron/titron.github.io/raw/master/img/2022-08-11-share_file_FileZilla_to_transfer.png)

