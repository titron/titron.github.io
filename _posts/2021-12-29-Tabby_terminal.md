---
layout: post
title:  "可以ssh/sftp,不会破坏windows配置文件的终端工具Tabby"
categories: tools
tags: TabbyX shell MobaXterm Finalshell
author: David
---

* content
{:toc}

---

终端工具有很多。

用过Xshell，不是免费的。

用过MobaXterm，也许是我使用方法有问题，会破坏windows配置文件。

用过Finalshell，太复杂。

我只是想用<mark>SSH</mark>和<mark>SFTP</mark> 功能。

幸好看到了[链接1](https://mp.weixin.qq.com/s/vX6Tq30Jnyo4IhLucdVceA)这里推送的另一款开源的终端工具Tabby，到目前为止，使用感觉不错！

Tabby是一款现代化的终端连接工具，开源并且跨平台，支持在Windows、MacOS、Linux系统下使用。Tabby在Github上已有20k+Star，可见它是一款非常流行的终端工具！

Tabby的安装非常简单，直接下载安装包解压即可，这里我下载的是Windows下的便携版本，[下载地址](https://github.com/Eugeny/tabby/releases)。

* 新建 ssh 连接
  
  新建ssh连接不像其他软件那么直观，需要在 Settings下，新建profile

![新建profile](https://github.com/titron/titron.github.io/raw/master/img/2021-12-29-Tabby_terminal_new_profile.png)

![新建ssh连接](https://github.com/titron/titron.github.io/raw/master/img/2021-12-29-Tabby_terminal_new_profile_ssh1.png)

![新建ssh连接config](https://github.com/titron/titron.github.io/raw/master/img/2021-12-29-Tabby_terminal_new_profile_ssh_config.png)
  

* 快捷键for split/pane
  
  split to the right: ctrl+shift+e

  split to the bottom: ctrl+shift+d

  close focused pane： ctrl+shift+Q: 


唯一吐槽的是，不能SFTP传输文件夹，只能传输单个文件。
