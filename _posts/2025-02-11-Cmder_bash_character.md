---
layout: post
title:  "Cmder命令提示符λ改成$"
categories: basic
tags: Cmder, cmd, powershell, terminal
author: David
---

* content
{:toc}

---

参考：[Cmder命令提示符λ改成$](https://blog.csdn.net/weixin_45701789/article/details/124129247)

### 简介

windows下终端工具，集成了linux常用命令，最关键是包含了git工具集。

下载：[cmder.app](https://cmder.app/)

![Cmder](https://github.com/titron/titron.github.io/raw/master/img/2025-02-11-Cmder_main.png)


### 安装

1. Unzip
2. (optional) Place your own executable files into the bin folder to be injected into your PATH.
3. Run Cmder (Cmder.exe)

### Cmder命令提示符λ改成$
![old bash character](https://github.com/titron/titron.github.io/raw/master/img/2025-02-11-Cmder_old.png)
![new bash character](https://github.com/titron/titron.github.io/raw/master/img/2025-02-11-Cmder_new.png)


#### 修改方法

找到cmder_prompt_config.lua文件，通常在config这个目录下：

修改这两项数值：
![change config](https://github.com/titron/titron.github.io/raw/master/img/2025-02-11-Cmder_config.png)