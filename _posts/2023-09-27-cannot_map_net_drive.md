---
layout: post
title:  "不能映射网络驱动器"
categories: software
tags: windows, net drive, map
author: David
---

* content
{:toc}

---

windows10， 不能建立网络驱动器映射。

解决办法：
1. win+R，打开运行，输入gpedit msc，打开本地组策略编辑器。
2. 找到：计算机配置-》管理模板-》网络-》Lanman工作站，点击“Lanman工作站“，在本地组策略编辑器的右侧，可以看到”启用不安全的来宾登录“。
3. 双击“启用不安全的来宾登录”，选择“已启用”，确定。

本地现在就可以建立映射网络驱动器了。
