---
layout: post
title:  "linux下git clone出错:ssh: Could not resolve hostname xxxxx.com: Name or service not known"
categories: software
tags: git
author: David
---

* content
{:toc}

---

转自[Could not resolve host: github.com的解决方案](https://blog.csdn.net/yjn18021006815/article/details/118568048)

解决方法：添加相应IP 地址到文件：/etc/hosts
```bash
$ git clone git@mmmmm.com:llll.git
Cloning into 'llll'...
ssh: Could not resolve hostname mmmmm.com: Name or service not known
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.

$ sudo vim /etc/hosts
# add 
xxx.yyy.zzz.xxx mmmmm.com

$ ping mmmmm.com
PING mmmmm.com (xxx.yyy.zzz.xxx) 56(84) bytes of data.
64 bytes from mmmmm.com (xxx.yyy.zzz.xxx): icmp_seq=1 ttl=46 time=108 ms
64 bytes from mmmmm.com (xxx.yyy.zzz.xxx): icmp_seq=1 ttl=46 time=108 ms
64 bytes from mmmmm.com (xxx.yyy.zzz.xxx): icmp_seq=1 ttl=46 time=108 ms

```
