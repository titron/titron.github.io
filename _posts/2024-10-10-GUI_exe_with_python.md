---
layout: post
title:  "python设计GUI并生成exe文件"
categories: basic
tags: python，exe，GUI, wxPython, wxFormBuilder, pyinstaller
author: David
---

* content
{:toc}

---

**环境准备**
* python----------编程语言
* wxpython--------wxFormBuilder的打包
* wxFormBuilder---GUI设计工具
* pyinstaller-----打包exe工具

**步骤**
1. 安装环境

【1】安装python

（https://www.python.org/downloads/）下载安装包，双击安装。


【2】安装wxpython
```bash
pip install wxPython
```
"import wx", 如下例。
```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import wx

app = wx.App()

frame = wx.Frame(None, title='Simple application')
frame.Show()

app.MainLoop()
```
【3】安装wxFormBuilder
(https://github.com/wxFormBuilder/wxFormBuilder/releases)下载安装包，双击安装。

【4】安装pyinstaller
```bash
pip install pyinstaller
```

【5】其他资源
- 免费矢量图标网站（https://igoutu.cn/icons）
- 把其他格式图片转成ico格式：(https://app.xunjiepdf.com/img2icon/)


2. 操作

【1】用wxFormBuilder设计界面，并生成python代码， copy并保存成.py文件，如保存名为CalculatorFrame.py文件。

【2】编辑逻辑code，在其中引用【1】中的界面code，并保存，如将逻辑代码保存为Calculator.py。

将上面的逻辑代码保存为Calculator.py，并跟刚刚生成那个CalculatorFrame.py，放在同一个目录里。直接在代码编辑器里面右键运行。

```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import wx
import CalculatorFrame
...
```


3. 打包生成exe文件
```bash
>pyinstaller -w -F -i gw_icon.ico Calculator.py
...
543 INFO: Copying bootloader EXE to C:\d_disk\RenesasMCUHWM\RCar\Gen4\R-Car_S4\Application_Notes_for_HWM\gateway_switch\GatewaySettingTool\code\dist\Calculator.exe
...

```