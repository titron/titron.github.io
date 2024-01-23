---
layout: post
title:  "build Yocto问题记录"
categories: basic
tags: Yocto
author: David
---

* content
{:toc}

---

### （1）安装rsync
```bash
root@5b37c152a18b:/home/tzdong/yocto_v590/build# apt-get install rsync 
```

### （2）不能用root权限build
```bash
root@5b37c152a18b:/home/tzdong/yocto_v590/build# vim ../poky/meta/conf/sanity.conf  
# INHERIT += "sanity"
```

### （3）添加异常目录为safe
```bash
root@5b37c152a18b:/home/tzdong/yocto_v590/build# git config --global --add safe.directory /home/tzdong/yocto_v590/build/downloads/git2/gitlab.freedesktop.org.pkg-config.pkg-config.git 
```

### （4）unshadow异常目录
去对应的git目录下，执行下面的命令
```bash
# git fetch --unshallow
```

### （5）git clone太慢
```bash
error: RPC failed; curl 18 transfer closed with outstanding read data remaining

# 配置git的最低速和最低速时间
dongtz@renesas-abd:~/work/linux/yocto_v590$ git config --global http.lowSpeedLimit 0
dongtz@renesas-abd:~/work/linux/yocto_v590$ git config --global http.lowSpeedTime 999999

# 可以增加git的缓存大小
dongtz@renesas-abd:~/work/linux/yocto_v590$ git config --global http.postBuffer 1048576000 

# 文件太大,解决方式为git添加 compression 配置项
dongtz@renesas-abd:~/work/linux/yocto_v590$ git config --global core.compression -1
```