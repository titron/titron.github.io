---
layout: post
title:  "ubuntu下使用终端分屏工具terminator"
categories: experience tools
tags: terminator
author: David
---

* content
{:toc}

---

参考：
[Ubuntu中终端分屏工具terminator的安装和使用](https://blog.csdn.net/learning_tortosie/article/details/102581261)

### 安装：

```bash
$ sudo apt-get install terminator
```

### 打开

快捷键：ctrl+alt+t

或者，终端下：
```bash
$ terminator
```

### 拆分终端

水平：ctrl+shit+o

垂直：ctrl+shift+e

删除终端：ctrl+d

Ubuntu中终端分屏工具terminator的安装和使用

### 定义配置

```bash
$ cd ~/.config/terminator/
$ vim config


[global_config]
  dbus = False
  geometry_hinting = True
[keybindings]
[profiles]
  [[default]]
    background_darkness = 0.92
    background_type = transparent
    cursor_color = "#3036ec"
    font = Ubuntu Mono 15
    foreground_color = "#00ff00"
    show_titlebar = False:
    login_shell = True
    custom_command = tmux
    use_system_font = False
[layouts]
  [[default]]
    [[[window0]]]
      type = Window
      parent = ""
    [[[child1]]]
      type = Terminal
      parent = window0
[plugins]
```

### 切换会自带的终端

```bash
$ sudo update-alternatives --config x-terminal-emulator

选择：
gnome-terminal.wrapper
```