---
layout: post
title:  "linux下带进度条copy"
categories: software
tags: linux, cp, progress, rsync
author: David
---

* content
{:toc}

---

转自[实现本机拷贝带进度的方法](https://blog.51cto.com/yangzhiming/1033043)


### 法1：coreutils工具（推荐）
让cp显示进度的工具，拷贝文件夹也是可以的
```bash
$ wget  http://ftp.gnu.org/gnu/coreutils/coreutils-9.1.tar.xz
$ tar -xf coreutils-9.1.tar.xz
$ cd coreutils-9.1/
$ curl -JLO https://raw.githubusercontent.com/jarun/advcpmv/master/advcpmv-0.9-9.1.patch
$ patch -p1 -i advcpmv-0.9-9.1.patch
$ export FORCE_UNSAFE_CONFIGURE=1
$ ./configure
$ make
$ sudo cp src/cp /usr/bin/cp
$ sudo cp src/mv /usr/bin/mv
 
# 用的时候要切换到root模式才行
# cp -r -g /root /home/

#（显示总大小、速度、剩余时间、不显示已拷贝大小，一般速度200kb/s）
```

### 法2：rsync命令
```bash
$ rsync -av --progress /mnt /home
# （显示拷贝速度、剩余时间、已拷贝大小、进度%，不显示总大小，一般速度为300kb/s）
```

### 法3：cp -r -v 命令（推荐）
```bash
$ cp -rv 1113 1113_cr7_2
````

### 法4：scp命令

**只适用于远程两节点间拷贝**

```bash
$ scp -r /mnt  root@127.0.0.1:/home     (拷贝文件夹要加参数 -r，拷贝文件不需要)
#（显示拷贝速度、剩余时间、已拷贝大小、进度%，不显示总大小，一般速度为10M/s）
```

### 法5: cp.sh脚本
```bash
# （显示速度、进度、不显示总大小、剩余时间、已拷贝大小，一般速度300kb-1M/s不等）

# vi cp.sh
 
#!/bin/bash

trap 'exit_fun' 2

usage(){
        echo "Usage: `basename $0` \"src file\" \"dst file\""
        exit 1
}

exit_fun(){
        echo -e "\033[?25h"
        kill -9 $(ps -ef|awk '/ [c]p /{print $2}') &>/dev/null
        exit 1
}

[ "$#" -ne "2" ] && usage
[ -d "$2" ] && k=${2%%/}/`basename $1` || k=$2
fromsize=`ls -s $1|cut -d" " -f1`
cp $1 $k &
start=`date +%s`
sleep 0.2
echo -ne "\033[?25l"

while :;do
        tosize=`ls -s $k|cut -d" " -f1`
        x=`echo "$tosize $fromsize"|awk '{print int($1*100/$2)}'`
        [ $x -eq 99 ] && x=100
        echo -n "["
        for((i=0;i<x;i=$i+2));do echo -n "=";done
        echo -n ">"
        for((j=i;j<=99;j=$j+2));do echo -n " ";done
        now=$[`date +%s` - $start]
        [ $now -eq 0 ] && now=1
        avg=$[$tosize/$now]
        printf "] %4s%% %4sKb/s" $i $avg
        [ $x -ge 100 ] && break
        sleep 0.1
        echo -ne "\r"
done
echo -e "\033[?25h"

:wq

# chmod +x cp.sh

# 示例：
# ./cp.sh /mnt/a.tar.gz /home
```

注：
**不能拷贝文件夹，只能拷贝单个文件**