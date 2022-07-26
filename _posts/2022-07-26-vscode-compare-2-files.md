---
layout: post
title:  "vscode比较两个文件"
categories: software
tags: vscode, diff, compare, beyond compare, winmerge
author: David
---

* content
{:toc}

---

### 参考
[VS Code: How to Compare Two Files (Find the Difference)](https://www.kindacode.com/article/vs-code-how-to-compare-two-files-find-the-difference/)

两个方法：

* 鼠标操作

选择要比较的两个文件，右键——“Compare Selected”.

![鼠标操作比较两个文件](https://github.com/titron/titron.github.io/raw/master/img/2022-07-26-vscode-compare-2files-mouse.png)

* 命令行操作

终端输入如下命令进行比较
```bash
code --diff [path to file 1] [path to file 2]
```

比如：
```bash
PS Z:\work\hypervisor_without\rcar_cr7_prj\release220629\testRelease220629\rcar-cr7-solution> code --diff Z:\work\hypervisor_without\rcar_cr7_prj\release220629\testRelease220629\rcar-cr7-solution\setup-env.sh C:\Users\a5059726\Downloads\recn-setup-env.sh
```

P.S.:

(1) 菜单Terminal - New Terminal，打开命令行

(2) 右键当前工程的文件，选择“copy path”，可以得到当前工程中文件的路径

(3) 从下载的文件或者其他目录的文件，右键，根据详细信息可以得到当前文件的路径