---
layout: post
title:  "linux下readlink函数解释"
categories: software
tags: linux
author: David
---

* content
{:toc}

---

[原链接](https://www.geek-share.com/detail/2798696600.html)

定义函数：int  readlink(const  char *path,  char *buf, size_t  bufsiz);
函数说明：readlink()会将参数path的符号连接内容到参数buf所指的内存空间。若参数bufsiz小于符号连接的内容长度，过长的内容会被截断

返回值：执行成功则传符号连接所指的文件路径字符串，失败返回-1， 错误代码存于errno。

例二:
```c
#include <stdio.h>
#include <unistd.h>
char * get_exe_path( char * buf, int count)
{
    int i;
    int rslt = readlink("/proc/self/exe", buf, count - 1);
    if (rslt < 0 || (rslt >= count - 1))
    {
        return NULL;
    }
    buf[rslt] = '\0';
    for (i = rslt; i >= 0; i--)
    {
        printf("buf[%d] %c\n", i, buf[i]);
        if (buf[i] == '/')
        {
            buf[i + 1] = '\0';
            break;
        }
    }
    return buf;
}

int main(int argc, char ** argv)
{
    char path[1024];
    printf("%s\n", get_exe_path(path, 1024));
    return 0;
}
```