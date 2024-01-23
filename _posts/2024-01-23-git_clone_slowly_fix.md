---
layout: post
title:  "解决git clone慢"
categories: basic
tags: git
author: David
---

* content
{:toc}

---

[(转载)关于git拉取项目时，报RPC failed; curl 18 transfer closed with outstanding read data remaining错的解决方法](https://cloud.tencent.com/developer/article/1660797)

1. “error: RPC failed; curl 18 transfer closed with outstanding read data remaining”
	
* 配置git的最低速和最低速时间
	dongtz@renesas-abd:~/work/linux/yocto_v590$ git config --global http.lowSpeedLimit 0                          
	dongtz@renesas-abd:~/work/linux/yocto_v590$ git config --global http.lowSpeedTime 999999                      
* 可以增加git的缓存大小
	dongtz@renesas-abd:~/work/linux/yocto_v590$ git config --global http.postBuffer 1048576000                    
* 文件太大,解决方式为git添加 compression 配置项
	dongtz@renesas-abd:~/work/linux/yocto_v590$ git config --global core.compression -1 


global配置对当前用户生效，如果需要对所有用户生效，则用–system

2. 借助GitClone网站

在项目地址中间加上 gitclone.com

![添加gitclone.com](https://github.com/titron/titron.github.io/raw/master/img/2024-01-23-git_clone_slowly_fix)