---
layout: post
title:  "当前主流的小型嵌入式GUI有哪些？（转）"
categories: software, hardware
tags: BlueTooth, software, hardware
author: David
---

* content
{:toc}

---

参考：[原文](https://mp.weixin.qq.com/s/mnY93O0nEtCNX0gGhpVwgw)


### TouchGFX
* 以界面华丽，流畅以及强劲的TouchGFX Designer著称
* 2018年被ST收购，当前主要用于STM32平台
* [官方网址](https://www.touchgfx.com/)

### Embedded Wizard GUI
* 以华丽，流畅的界面和强劲的GUIBuilder著称
* 独创Chora界面编程语言，让大家的界面编程极其简单
* GUIBuilder上面含有非常多的控件，皮肤和主题供用户选择
* 支持调试
* [官方网址](http://www.embedded-wizard.de/)


### emWin(uCGUI)
* 老牌的嵌入式GUI，软件架构和功能比较成熟
* [emWin教程第1版](http://www.armbbs.cn/forum.php?mod=viewthread&tid=2932)
* [emWin教程第2版](http://www.armbbs.cn/forum.php?mod=viewthread&tid=19834)
* [emWin教程第3版](http://www.armbbs.cn/forum.php?mod=viewthread&tid=98429)
* [官方网址](https://www.segger.com/products/user-interface/emwin/)


### Qt for MCU
* 有ST的F7，瑞萨的RH850和NXP的i.MX RT1050[视频展示](http://www.armbbs.cn/forum.php?mod=viewthread&tid=95912)
* 2019 Qt峰会的时候，正式发布Qt for MCU V1.0
* 收费

### Crack Storyboard
* 一款非常优秀的GUI设计器，能够大大的加速GUI的设计
* 足够绚丽，各种仪表，工控，医疗，物联网等都能很好的支持
* 当前支持厂家：NXP, ST, Microchip, Torodex, EmbeddedArtisis, TI, Renesas
* [收费方式](https://www.cranksoftware.com/storyboard-pricing-licensing)
* [官方网址](https://www.cranksoftware.com/)
  
### Altia GUI
* 有将近30年的发展史
* 通过了AutomotiveSPICE汽车级HMI的一级认证(这个认证共分为6个级别，0到5级，其中第5级是最高等级)
* 图形开发软件更是极其强劲。有如下三款软件组成
** (1)人机交互界面集成开发环境 — Altia Design
** (2)自动代码生成工具 — Altia DeepScreen
** (3)在Adobe Photoshop中构建交互式用户界面资源 — Altia PhotoProto
* 当前支持厂家：Cypress,NXP, Renesas, ST, TI, Fujitsu, Panasonic, Toshiba, etc.
* 收费软件, 具体收费方式要联系要联系他们获取
* [官方网址](https://www.altia.com/)
  
### μGFX
* 功能也是简单实用
* 支持的硬件平台，RTOS和显示屏驱动在这里有[详细说明](http://www.ugfx.org/platforms.html)
* 也是要收费的，具体收费标准看[这里](http://www.ugfx.org/pricing.html)
* [官方网址](http://www.ugfx.org/)
  
  
### ThreadX GUIX
* 微软的高级工业级GUI解决方案
* 专门针对深度嵌入式，实时和IoT应用程序而设计。
* 微软还提供了名为GUIX Studio的桌面开发工具，该工具允许开发人员在桌面上设计其GUI并生成GUIX代码，然后可以将其导出到目标。
* GUIX通过了医疗认证IEC-62304 Class C，汽车认证IEC-61508 ASIL D，工业认证IEC-61508 SIL 4和运输/铁路认证EN50128。表明GUIX可用于安全关键型系统。
  
### LVGL
* 强大的构建模组 按钮、图表、列表、滑块、图像等
* 先进的图形 动画、反锯齿、半透明、平滑滚动
* 多样的输入设备 触摸板、鼠标、键盘、编码器等
* 多显示器支持 支持同时使用多个TFT或单色显示器
* 多语言支持 UTF-8格式文字编码
* 完全自定义 图形元素
* 硬件无关 可用于任意微控制器或显示器
* 可裁剪 用于小内存（80 KB FLASH，12 KB RAM）操作
* 操作系统、外部存储以及GPU 支持但非必须
* 单帧缓存 即可实现先进的图形效果
* C语言编写 以最大化兼容（C++ 兼容）
* 模拟器 无需嵌入式硬件就可以在电脑上开始GUI设计
* 教程、示例、主题 从而快速GUI设计
* 文档 在线及离线
* 免费开源 基于MIT协议

### LLGUI
* 代替串口屏、组态，降低产品成本，产品软硬件自主可控。
* 配套界面开发软件，图形化编辑界面，生成C代码，直接和用户产品代码结合。
* 配套下载升级软件和bootloader，解决产品升级功能和图片下载问题。
* [教程](https://www.yuque.com/books/share/3317aaa7-f47f-4bfd-a4c2-7e64e7f1c4be?#)



