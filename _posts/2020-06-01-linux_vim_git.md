---
layout: post
title:  "一个超级强大的vim 配置介绍：vimplus（转）"
categories: Software
tags: vim vimplus linux git
author: David
---

* content
{:toc}

---
参考：[原贴 ](https://mp.weixin.qq.com/s/kZvCBLyNi0aTkZtws1UoSA)


### 解决“E117: Unknown function: textobj#user#plugin”的问题：

```
$cd ~/.vim/plugged/
$git clone http://www.github.com/kana/vim-textobj-user

```
安装上这个插件就OK了.

### 解决“YouCompleteMe unavailable: requires Vim compiled with Python (3.5.1+) support”问题

[指定python3](https://www.jianshu.com/p/4d4f3773f832)

```
vim .vimrc

```

配置let g:ycm_server_python_interpreter = ''pthon3绝对路径'
比如：
let g:ycm_server_python_interpreter = '/usr/bin/python3.5'



[vimplus快捷键定义](https://learnku.com/articles/26431)


### 解决“YouCompleteMe unavailable: requires Vim compiled with Python (3.5.1+) support.”问题

* 需要root权限。

* 重新编译YouCompleteMe：

```
$ cd ~/.vim/bundle/YouCompleteMe
$ python3 install.py --all
```

如果提示
```
Searching Python 3.7 libraries...
ERROR: Python headers are missing in /usr/include/python3.7m.”
```

* 需要重新安装“python3.x-dev”：

```
xxxxx@renesas-abd:~/.vim/plugged/YouCompleteMe$ sudo apt install python3.7-dev
```

如果提示
```
ERROR: Unable to find executable 'go'. go is required to build gopls.
```

* 需要安装go：

```
sudo apt-get install golang
```