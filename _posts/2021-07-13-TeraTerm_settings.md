---
layout: post
title:  "Tera Term保存设置字体"
categories: software
tags: Tera Term, Terminal
author: David
---

* content
{:toc}

---


Tera Term是一款很好的SSH工具，笔者遇到一个头疼的问题，每次打开的时候，都要自己重新设置一遍Font，今天尝试了下把自己喜欢的字体，设置好后，保存到默认配置中的方法。

第1步：Setup->Font

![字体设置]](https://github.com/titron/titron.github.io/raw/master/img/2021-07-13-teraterm_settings_font.png)


第2步：设置为自己喜欢的字体，字形，大小

![选择字体]](https://github.com/titron/titron.github.io/raw/master/img/2021-07-13-teraterm_settings_select_font.png)


第3步：保存到TERATERM.INI中

![选择字体]](https://github.com/titron/titron.github.io/raw/master/img/2021-07-13-teraterm_save_setup.png)


第4步：对比一下前后文件中修改了什么

![选择字体]](https://github.com/titron/titron.github.io/raw/master/img/2021-07-13-teraterm_settings_vs.png)


到这一步就搞定了，下一次再打开软件的时候，显示的就是自己喜欢的默认字体大小了。
