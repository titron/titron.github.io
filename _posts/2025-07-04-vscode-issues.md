---
layout: post
title:  "vscode c语言不能跳转到definition"
categories: basic
tags: vscode, c/c++
author: David
---

* content
{:toc}

---

vscode使用c/c++插件，发现

### [1] 右键没有Go To Definition

解决办法：
File->Preferences->Settings

搜索“intelli Sense Engine”。

如果C_CPP: Intelli Sense Engine的值是Disabled，则下拉选择default。

退出设置界面或vscode，重新打开。

![vs code中右键没有跳转到定义（go to definition）解决方法](https://github.com/titron/titron.github.io/raw/master/img/2025-07-04-vscode_jump.png)

### [2] 有跳转到definition，实际上不能跳转
visual studio code中，c/c++插件重启，提示
“Unable to resolve configuration with compilerPath "/usr/local/bin/gcc".  Using "cl.exe" instead.”，

解决办法：

在VSCode中按下 Ctrl+Shift+P，

输入并选择 C/C++: Edit Configurations (UI)

然后，检查并配置正确的compiler，windows下为cl.exe，linux下为gcc。