---
layout: post
title:  "配置tftp服务和NFS服务"
categories: software
tags: tftp, nfs
author: David
---

* content
{:toc}

---

### 1. 安装TFTP/NFS server

步骤，[参考](https://www.cnblogs.com/shenhaocn/archive/2011/03/13/1983042.html)

配置目录：

——TFTP server配置工作目录：
```makefile
/home/titron/tftpboot
```
——NFS server 配置工作目录：
```makefile
/home/titron/export/rfs *(rw,sync,no_root_squash)
```

u-boot下，设置环境变量：
```bash
=> setenv ethaddr 2E:09:0A:03:8A:28
=> setenv ipaddr '192.168.0.3' (板子ip)
=> setenv load_run_qnx_tftp 'tftp 0x40100000 192.168.0.20:ifs-rcar_h3.bin; go 0x40100000' （服务器ip）
```

### 2.	配置TFTP server
```bash
$ sudo gedit /etc/default/tftpd-hpa
```

将原来的内容为:
```makefile
# /etc/default/tftpd-hpa
TFTP_USERNAME="tftp"
#TFTP_DIRECTORY="/var/lib/tftpboot" #修改为自己需要的路径，与上面创建的目录一致
TFTP_ADDRESS="0.0.0.0:69"
#TFTP_OPTIONS="--secure" #可以通过查看mantftpd,看各种参数的意义
```
#修改为
```makefile
TFTP_DIRECTORY="/home/shenhao/tftpboot"
TFTP_OPTIONS="-l -c -s"
```

### 3. 配置NFS server
在文件/etc/exports中进行定义, 将目录 /home/renesas/export/rfs 共享出来。
```makefile
/home/renesas/export/rfs *(rw,sync,no_root_squash)
```
参看下面的修改：
```makefile
# /etc/exports: the access control list for filesystems which may be exported
#               to NFS clients.  See exports(5).
#
# Example for NFSv2 and NFSv3:
# /srv/homes       hostname1(rw,sync,no_subtree_check) hostname2(ro,sync,no_subtree_check)
#
# Example for NFSv4:
# /srv/nfs4        gss/krb5i(rw,sync,fsid=0,crossmnt,no_subtree_check)
# /srv/nfs4/homes  gss/krb5i(rw,sync,no_subtree_check)
#
/home/titron/export/rfs *(rw,sync,no_root_squash)
```

### 4. 启动 server

启动tftpserver
```bash
$ sudo service tftpd-hpa start
```
启动nfs server
```bash
$ sudo /etc/init.d/rpcbind restart
$ sudo /etc/init.d/nfs-kernel-server restart
```

### 5. 使用
```bash
# ifconfig ravb0 192.168.0.3
# fs-nfs3 192.168.0.20:/home/renesas/export/demo  /demo
```

