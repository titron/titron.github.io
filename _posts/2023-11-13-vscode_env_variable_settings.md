---
layout: post
title:  "vscode检测不到环境变量解决办法"
categories: experience
tags: vscode, GNUMAKE
author: David
---

* content
{:toc}

---


### 现象：
* 查不到设置的环境变量
* 运行SampleApp.bat，出现编译错误：
```bash
C:\Renesas\mcal\v3.16.0\sw_src\g4mh_mcal\rel\S4\common_family\make\ghs>SampleApp.bat mcu R19-11 S4 No
...
common.mak:125: \cygdrive\c\Renesas\mcal\v3.16.0\sw_src\g4mh_mcal\rel\common\generic\compiler\19_11\ghs\make\ghs_rh850_r19_11_defs.mak: No such file or directory
...
```


### 原因：
1. 没有指定“GNUMAKE”环境变量
解决方法：
![vscode 指定GNUMAKE环境变量](https://github.com/titron/titron.github.io/raw/master/img/2023-11-13-vscode_env_variables_settins_GNUMAKE.png)

note:
```bash
# 查看环境变量"GNUMAKE"
PS C:\Renesas\mcal\v3.16.0\sw_src\g4mh_mcal\rel\S4\common_family\make\ghs> $env:GNUMAKE
```

2. 没有指定vscode以管理员身份启动
解决方法：
![vscode 指定GNUMAKE环境变量](https://github.com/titron/titron.github.io/raw/master/img/2023-11-13-vscode_env_variables_administrator.png)
