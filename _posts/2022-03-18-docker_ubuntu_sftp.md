---
layout: post
title:  "在ubuntu 16.04服务器上用docker再安装一个ubuntu 20.04"
categories: experience
tags: docker Ubuntu sftp
author: David
---

* content
{:toc}

---
参考：
[1. docker的介绍](https://www.runoob.com/docker/docker-tutorial.html)
[2. docker命令介绍](https://www.runoob.com/docker/docker-command-manual.html)
[3. 24 个常见的 Docker 疑难杂症处理技巧](https://mp.weixin.qq.com/s/JuUULOE-axo7wFzijt1l_Q)


目前，编译bsp所用的Linux服务器是ubuntu 16.04，新项目编译bsp要求Linux服务器是ubuntu 20.04.

根据高手推荐以及网上查询，决定使用docker，实现在现有服务器上安装ubuntu 20.04。

先总结docker操作命令，如下表：

| 命令 | 说明 |
|---|---|
| $ docker ps | 查看container |
| $ docker ps -a | 查看container，-a显示停止的container |
| $ docker search ubuntu | 搜索image |
| $ docker pull ubuntu:20.04  | pull image |
| $ docker images  | show images |
| $ docker run -it -d --name tzdong-ubuntu2004 ubuntu:20.04  | 用ubuntu:20.04 image 运行container |
| $ docker run --privileged -it -d --name tzdong-ubuntu2004 ubuntu:20.04  | root privileges，用ubuntu:20.04 image 运行container |
| $ docker rename tzdong-ubuntu2004 tzd-ubuntu2004  | 重命名container |
| $ docker exec -it tzdong-ubuntu2004 /bin/bash | 执行ubuntu20.04 container中的命令。要想退出container时，让container仍然在后台运行着，运行该命令。如果运行$ docker attach ubuntu2004，每次从container中退出到前台时，container也跟着退出了 |
| $ docker start ubuntu2004 | 重新启动ubuntu20.04 container |
| root@463a1151fd69:/home/dongtz/work/s4_alpha2# exit | 或者，ctrl-D。 退出ubuntu container。 |
| $ docker system prune --all --force --volumes | 删除当前不使用的volumes/images，以节省docker空间 |
| $ docker stop ubuntu2004 | 停止container |
| $ docker restart 'container ID' | 重启指定处于status“Exit”的container ID |
| $ docker rm ubuntu2004 | 删除container |
| $ docker cp | 在宿主机和docker之间传递文件 |

参考：
1. [Docker 入门指南：如何在 Ubuntu 上安装和使用 Docker](https://kalacloud.com/blog/how-to-install-and-use-docker-on-ubuntu/)
2. [DockerでUbuntu 16.04 LTSのイメージを利用してみよう](https://weblabo.oscasierra.net/docker-ubuntu1604/)

在实际操作中碰到了一些问题，将解决方法一并记录如下：
```bash
dongtz@renesas-abd:~$ docker pull ubuntu:20.04
20.04: Pulling from library/ubuntu
Digest: sha256:8ae9bafbb64f63a50caab98fd3a5e37b3eb837a3e0780b78e5218e63193961f9
Status: Image is up to date for ubuntu:20.04
docker.io/library/ubuntu:20.04

dongtz@renesas-abd:~$ docker images
REPOSITORY TAG IMAGE ID CREATED SIZE
ubuntu 20.04 2b4cba85892a 13 days ago 72.8MB
ubuntu 16.04 330ae480cb85 21 months ago 125MB
gitlab/gitlab-ce latest 2b9ac1a40dd1 21 months ago 1.81GB

dongtz@renesas-abd:~$ docker run -it -d --name ubuntu2004 ubuntu:20.04
463a1151fd6959ee0fa571f71aff1e9eb8905e7d95c380bb02725ce553e59909

dongtz@renesas-abd:~$ docker ps
CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAMES
463a1151fd69 ubuntu:20.04 "bash" About a minute ago Up 58 seconds ubuntu2004
ecb7f8778e6c gitlab/gitlab-ce:latest "/assets/wrapper" 21 months ago Up 5 months (healthy) 0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp, 0.0.0.0:2222->22/tcp gitlab

dongtz@renesas-abd:~$
dongtz@renesas-abd:~$ docker exec -it ubuntu2004 /bin/bash
root@463a1151fd69:/#

root@463a1151fd69:/# exit
exit
dongtz@renesas-abd:~$

dongtz@renesas-abd:~$ docker ps
CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAMES
463a1151fd69 ubuntu:20.04 "bash" 10 minutes ago Up 10 minutes ubuntu2004
ecb7f8778e6c gitlab/gitlab-ce:latest "/assets/wrapper" 21 months ago Up 5 months (healthy) 0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp, 0.0.0.0:2222->22/tcp gitlab

dongtz@renesas-abd:~$ docker stop ubuntu2004
ubuntu2004

dongtz@renesas-abd:~$ docker ps
CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAMES
ecb7f8778e6c gitlab/gitlab-ce:latest "/assets/wrapper" 21 months ago Up 5 months (healthy) 0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp, 0.0.0.0:2222->22/tcp gitlab

dongtz@renesas-abd:~$ docker ps -a
CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAMES
463a1151fd69 ubuntu:20.04 "bash" 13 minutes ago Exited (0) 2 minutes ago ubuntu2004
ecb7f8778e6c gitlab/gitlab-ce:latest "/assets/wrapper" 21 months ago Up 5 months (healthy) 0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp, 0.0.0.0:2222->22/tcp gitlab fc1b3c2ca338 ubuntu:16.04 "/bin/bash" 21 months ago Exited (0) 19 months ago vmdba

dongtz@renesas-abd:~$ docker start ubuntu2004
ubuntu2004

dongtz@renesas-abd:~$ docker exec -it ubuntu2004 /bin/bash
root@463a1151fd69:/#

# Building BSP by using Yocto Project
root@463a1151fd69:/usr# cd ..
root@463a1151fd69:/# cd home/
root@463a1151fd69:/home# ls
root@463a1151fd69:/home# mkdir dongtz
root@463a1151fd69:/home# ls

# 以下步骤必要, 否则，apt-get install时，会提示E: Unable to locate package gawk
root@463a1151fd69:/home/dongtz/work/s4_alpha2# apt update
root@463a1151fd69:/home/dongtz/work/s4_alpha2# apt-get install tree

root@463a1151fd69:/home# tree

# installation of required commands
root@463a1151fd69:/home/dongtz/work/s4_alpha2# apt-get install gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa	libsdl1.2-dev pylint3 xterm libarchive-zip-perl

# 安装网络工具，包含ifconfig
root@463a1151fd69:/home/dongtz/work/s4_alpha2# apt-get install net-tools
root@463a1151fd69:/home/dongtz/work/s4_alpha2# ifconfig

# 开通ftp服务
root@463a1151fd69:/home/dongtz/work/s4_alpha2# apt-get install vsftpd

# 安装vim
root@463a1151fd69:/home/dongtz/work/s4_alpha2# apt-get install vim

# 更改sftp的以下配置：
#	nonymous_enable=NO
#	local_enable=YES
#	write_enable=YES
root@463a1151fd69:/home/dongtz/work/s4_alpha2# vi /etc/vsftpd.conf

# 启动ftp服务
root@463a1151fd69:/home/dongtz/work/s4_alpha2# /etc/init.d/vsftpd restart

# 查看ftp服务是否打开
root@463a1151fd69:/home/dongtz/work/s4_alpha2# ps -ef | grep ftp
root 7828 1 0 14:09 ? 00:00:00 /usr/sbin/vsftpd
root 7836 47 0 14:10 pts/1 00:00:00 grep --color=auto ftp

# 连接到服务器172.xx.xx.xx
root@463a1151fd69:/home/dongtz# sftp dongtz@172.xx.xx.xx
# 从服务器（172.xx.xx.xx）copy文件
sftp> get bl2.elf

# 从当前ftp服务器 cop文件到服务器（172.xx.xx.xx）
sftp> put 1.txt

# 退出sftp服务
sftp> quit

root@463a1151fd69:/home/dongtz/work/s4_alpha2# ./build_yocto.sh

# 需要将脚本中的
# git clone git://github.com/renesas-rcar/meta-renesas.git
# 更改为
# git clone https://github.com/renesas-rcar/meta-renesas.git

root@463a1151fd69:/home/dongtz/work/s4_alpha2/build-spider-gateway# bitbake rcar-image-gateway

# ERROR: Do not use Bitbake as root
#	ERROR: OE-core's config sanity checker detected a potential misconfiguration.
#	Either fix the cause of this error or at your own risk disable the checker (see sanity.conf).
#	Following is the list of potential problems / advisories:
#	Do not use Bitbake as root.
# 更改以下文件中设置，以去掉检查是不是root在执行
# If you want to still build it as root, then disable sanity check in the file: meta/conf/sanity.conf 
#		(#INHERIT \+= "sanity")
root@463a1151fd69:/home/dongtz/work/s4_alpha2# vim poky/meta/conf/sanity.conf

# 发生以下警告，编译停止
# WARNING: The free space of /home/dongtz/work/s4_alpha2/build-spider-gateway/tmp (overlay) is running low (0.939GB left)

# 退出ubuntu container。或者，ctrl-D
root@463a1151fd69:/home/dongtz/work/s4_alpha2# exit
exit

# 要想退出container时，让container仍然在后台运行着
dongtz@renesas-abd:~$ docker exec -it ubuntu2004 /bin/bash

# To delete volumes currently not being used by a running or stopped container:
dongtz@renesas-abd:~$ docker system prune --all --force --volumes

# 生成的image存在以下目录
root@463a1151fd69:/home/dongtz/work/s4_alpha2/build-spider-gateway/tmp/deploy/images/spider

# 压缩成单个文件以便于sftp传输
root@463a1151fd69:/home/dongtz/work/s4_alpha2/build-spider-gateway/tmp/deploy/images# tar -zcvf spider_img.tar.gz spider/

root@463a1151fd69:/home/dongtz/work/s4_alpha2/build-spider-gateway/tmp/deploy/images# ls
spider spider_img.tar.gz

root@463a1151fd69:/home/dongtz/work/s4_alpha2/build-spider-gateway/tmp/deploy/images# sftp dongtz@172.xx.xx.xx
dongtz@172.xx.xx.xx's password:
Connected to 172.xx.xx..

# sftp上传
sftp> put spider_img.tar.gz
Uploading spider_img.tar.gz to /home/dongtz/spider_img.tar.gz
spider_img.tar.gz 100% 424MB 129.2MB/s 00:03

sftp> quit

root@463a1151fd69:/home/dongtz/work/s4_alpha2/build-spider-gateway/tmp/deploy/images# ls

# 停止ubuntu20.04 container
dongtz@renesas-abd:~$ docker stop ubuntu2004
ubuntu2004

# 显示当前的container
dongtz@renesas-abd:~$ docker ps
CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAMES
ecb7f8778e6c gitlab/gitlab-ce:latest "/assets/wrapper" 21 months ago Up 5 months (healthy) 0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp, 0.0.0.0:2222->22/tcp gitlab
dongtz@renesas-abd:~$

```

在ubuntu 16.04服务器上解压缩image，然后FileZilla传到windows系统下，就可以烧写了
```bash
# 解压缩image
dongtz@renesas-abd:~/images/yocto_s4_spider$ tar zxvf spider_img.tar.gz

```

### 在宿主机和docker之间传递文件
```bash
titron@ubuntu:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED          STATUS          PORTS     NAMES
09be75bcbd6c   opendms   "bash"    58 minutes ago   Up 58 minutes             opendms

# 从宿主机copy文件到容器opendms下的文件夹/home/titron/opendms/下
titron@ubuntu:~$ docker cp win_share/rcar_s4_poc_dev/refer/opendms/699pic_03ek07_spxy.mp4 opendms:/home/titron/opendms/
# 从docker copy文件到宿主机
titron@ubuntu:~$ docker cp opendms:/home/titron/opendms/opendms/data/test_1.mp4 win_share/rcar_s4_poc_dev/refer/opendms/

```


### docker中的操作例

```bash
# [1] 查看操作系统是32bit还是64bit的
# i686 - 32bits
# x86_64 - 64bits
:/# uname --m
x86_64

# [2] 查看docker中的操作系统版本号
# 比如，下面的例子中显示是Ubuntu 20.04
:/# cat /etc/issue
Ubuntu 20.04.6 LTS \n \l

```

### 基本概念参考

这里，有一些基本的docker知识概念解释，便于理解：
[Docker夺命连环15问，你能坚持第几问？](https://mp.weixin.qq.com/s/57yllUfTRYl48TEux2VLog)

通过这个例子，可以看到基于docker的使用具体步骤：
[yolox dockerfile分享](https://mp.weixin.qq.com/s/-auCis4N-pTP7t7oOdXBow)