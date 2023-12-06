---
layout: post
title:  "清理windows空间"
categories: experience
tags: windows
author: David
---

* content
{:toc}

---

参考：
1. [移除pagefile.sys和hiberfil.sys获取C盘空间](https://www.zhihu.com/tardis/zm/art/87565681?source_id=1003)
2. [SCCM客户端ccmcache文件夹清除和修改及Installer文件夹大小问题](https://blog.51cto.com/lorysun/1952604)



### 1. 清除 ccmcache文件夹

控制面板 - Configuration Manager -选择“缓存”-->点击“配置设置”,

可以更改文件夹路径，可以删除文件

### 2. 清除 休眠文件 Hiberfil.sys

终端cmd，
```bash
# 不使用休眠功能
powercfg -h off

# 使用休眠功能
powercfg -h on
```

### 3. 清除 pagefile.sys

***设置***：
我的电脑 右键属性，然后高级系统设置 -> 系统属性 -> 高级 -> 设置(性能)

点击C盘，选择“无分页文件”，

点击D盘，选择“无分页文件”，

***禁用页面文件***: 方法是：依次进入注册表编辑器“HKEY_LOCAL_MACHINE/System/CurrentControlSet/Control/SessionManager/MemoryManagement”下，在“DisablePa-ging Executive”（禁用页面文件）选项中将其值设为“1”即可

***清空页面文件***: 在同一位置上有一个“ClearPageFileAtShutdown（关机时清除页面文件）”，将该值设为“1”（如图1）。这里所说的“清除”页面文件并非是指从硬盘上完全删除pagefile.sys文件，而是对其进行“清洗”和整理，从而为下次启动Windows XP时更好地利用虚拟内存做好准备。