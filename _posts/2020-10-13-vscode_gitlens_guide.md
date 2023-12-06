---
layout: post
title:  "vsCode 源代码管理插件GitLens使用指南(转) 以及git使用"
categories: tools
tags: VS Code git GitLens
author: David
---

* content
{:toc}


[vsCode 源代码管理插件GitLens使用指南](https://www.codenong.com/js95a1a06ac0fb/)

## 1. 插件名称： GitLens

### 图标：

![安装后的GitLens图标](https://github.com/titron/titron.github.io/raw/master/img/2020-10-13-vscode_gitlens_icon.png)

### 功能：

![GitLens功能项目](https://github.com/titron/titron.github.io/raw/master/img/2020-10-13-vscode_gitlens_items.png)

### commit 和 push：

![commit和push](https://github.com/titron/titron.github.io/raw/master/img/2020-10-13-vscode_gitlens_commit_push.png)

### 切换分支：

![切换分支](https://github.com/titron/titron.github.io/raw/master/img/2020-10-13-vscode_gitlens_switch_branch.png)


## 2. windows下已安装git，vscode中找不到git的解决办法
搜索已经安装的git.exe所在的路径，比如，安装在这里：C:\Users\a5059726\AppData\Local\Programs\Git\bin\git.exe。

打开vs code 文件--首选项--设置--输入框中搜索git.path
```json
{
    (...)
    "git.path": "C:/Users/a5059726/AppData/Local/Programs/Git/bin/git.exe",
    (...)
}
```

另外，更改环境变量，将“C:/Users/a5059726/AppData/Local/Programs/Git/bin/”添加到“Path”变量中。