---
layout: post
title:  "vim 命令详解（转）"
categories: tools
tags: vim Linux
author: David
---

* content
{:toc}

---

![vim cheat sheet 2](https://github.com/titron/titron.github.io/raw/master/img/2022-05-06-vim-cheatsheet2.png)


### vim中delete（backspace）键不能向左删除
[参考](https://blog.csdn.net/zf766045962/article/details/90052374)
在~/.vimrc中添加了一下内容
```bash
" 解决插入模式下delete/backspce键失效问题：set backspace=2
```