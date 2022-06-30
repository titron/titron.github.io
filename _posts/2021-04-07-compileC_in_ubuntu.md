---
layout: post
title:  "在Ubuntu下编辑、编译并运行C语言程序"
categories: software
tags: linux, ubuntu, c
author: David
---

* content
{:toc}

---

1. ctrl+alt+t打开Terminal（终端），然后
   ```bash
   $ vim test.c
   ```
2. 编辑c语言文件test.c
   ```c
   #include <stdio.h>

   int main(void)
   {
       int i;

       for(i=0;i<10;i++)
           printf("%d \n\r",i);

       printf("----------");

       for(i=0;i<10;++i)
           printf("%d \n\r",i);

       return;
   }
   ```
   编辑完毕后，shift+: wq 保存退出。
3. 终端下，编译c语言文件test.c
   ```bash
   $ gcc test.c -o test
   ```
4. 终端下，运行test
   ```bash
   $ ./test
    0
    1
    2
    3
    4
    5
    6
    7
    8
    9
    ----------
    0
    1
    2
    3
    4
    5
    6
    7
    8
    9
   ```
