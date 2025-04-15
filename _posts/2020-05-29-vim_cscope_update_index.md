---
layout: post
title:  "使用vim+cscope如何动态更新代码索引"
categories: experience
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

```makefile
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

```bash
$ chmod +x generate.sh
```
generate.sh文件的内容如下:

```makefile
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


### 其他
```bash
# ~/.vimrc内容如下：

if has("cscope") && filereadable("/usr/bin/cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif

nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-\>i :cs find i <C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

" map F12 key
"Highlight all search pattern matches
set hls
"Map F12 to create ctags index in current directory
map <F12> :!ctags -R <CR><CR>
"A shotcut to execute the grep command
map mg :!grep <C-R><C-W> . -r <CR>
"change the comment color
hi Comment ctermfg=6

" for 'tags not found'
set tags=tags;
set autochdir
" 'ctags -R' in terminal
```
