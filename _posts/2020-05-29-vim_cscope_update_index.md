---
layout: post
title:  "使用vim+cscope如何动态更新代码索引"
categories: software
tags: vim, cscope
author: David
---

* content
{:toc}

---
参考了以下的[贴子 ](https://kinlin.github.io/2019/04/01/How-to-dynamic-update-the-tags-with-cscope/)


### 步骤1 找到.vimrc文件

一般只改用户家目录下面的 .vimrc 此配置文件只针对用户有效。
更改后需使用su - 用户名 来使配置生效(例如 su - zhang3)。

.vimrc为隐藏文件 使用ls -al可查看。

### 步骤2 在.vimrc文件中，添加快捷键F12的映射

```

" update cscope index
map <F12> : call ReConnectCscope()<cr>
func! ReConnectCscope()
    exec "cs kill 0"
    exec "!./generate.sh"
    exec "cs add cscope.out"
endfunc

```

![F12按键映射](https://github.com/titron/titron.github.io/raw/master/img/2020-05-29-vim_cscope_1.png)

其中，generate.sh文件要放到你自己当前的工作目录下，并更改文件属性为可执行文件。

```

$ chmod +x generate.sh

```	
generate.sh文件的内容如下:

```

#!/bin/bash
date;
echo "ctags done......"
find -L . -name  "*.h" -o -name "*.c" -o -name "*.cc" -o -name 
find -L . -name "*.pl" >>cscope.files

date;
cscope -RCbq -i cscope.files;
ctags -R -L cscope.files;
echo "cscope done......"
date;

```
![generate.sh放置到工作目录下](https://github.com/titron/titron.github.io/raw/master/img/2020-05-29-vim_cscope_generate.png)

### 步骤3 编辑文件时，用F12按键实时更新cscope索引

在你正在编辑文件过程中，按F12按键，开始更新cscope索引

![更新cscope索引](https://github.com/titron/titron.github.io/raw/master/img/2020-05-29-vim_cscope_update_index.png)

回车

![更新cscope索引2](https://github.com/titron/titron.github.io/raw/master/img/2020-05-29-vim_cscope_update_index2.png)

回车


cscope索引更新完成!

