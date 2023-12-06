---
layout: post
title:  "android rc文件（转）"
categories: basic
tags: android rc
author: David
---

* content
{:toc}

---
## 简介

**init**进程是Android系统中用户空间的第一个进程，进程ID为1，源代码位于system/core/init 目录。作为Android系统的第一个进程，Init进程承担这很多重要的初始化任务，一般Init进程的初始化可以分为两部分，前半部分挂载文件系统，初始化属性系统和Klog， selinux的初始化等，后半部分重要通过解析init.rc来初始化系统daemon服务进程，然后以epoll的监控属性文件，系统信号等。

**init.rc**则是init进程启动的配置脚本，这个脚本是用一种叫**Android Init Language**(Android初始化语言)的语言写的。在7.0以前，init进程只解析根目录下的init.rc文件，但是随着版本的迭代，init.rc越来越臃肿，在7.0以后，init.rc一些业务被拆分到
```
 /system/etc/init
 /vendor/etc/init
 /odm/etc/init
 ```
 三个目录下。

## Android Init Language(简称 AIL)组成
AIL包括四种类型的语句：

* 动作 (Action)
* 命令 (Commands)
* 服务 (Service)
* 选项 (Option)

**语法特性**

* AIL是面向行的代码，也就是每一行是一条语句，回车就是分隔符，一个语句包含若干个tokens, token之间需要有空格分割符，如果token中有空格需要通过c语言风格的反斜杠('\')来转义，或者使用双引号将整个token包裹起来。反斜杠出现在末尾表示下一行任属于当前语句。
* 以#开始的行为注释，
* AIL编写分成多个(Section), 每个部分的开头需要指定Actions或Services,也就是每个Actions和Services都是一个Section,所有的Commands和Options只能属于定义的这个Section,
* Actions和Services的名称必须唯一，如果多个一样的名字,后面声明的将被忽略为一个错误。

### 动作 (Action)
Actions是被命名的命令(Commands)序列，由trigger(触发器)来决定这个actions什么时候发生，当一个时间触发了一个符合的action触发器，这个action就会被添加到处理队列尾部(它已经存在在对列除外)。

在处理队列中每一个action都按照排序出列，action中的command也按照顺序执行：

```
on <trigger> ##触发条件
​   <command> ##执行命令
   <command> ##可以同时执行多个命令
   <command>
```
**trigger**
init.rc中常见的trigger如下：
| trigger(触发器) |	功能 |
|-|-|
| boot |	这是init启动时（加载/init.conf之后）发生的第一个触发器。|
| \<name>=\<value>	| 当属性\<name>设置为特定值\<value>时，会触发此触发器 |
| device-added-\<path> <br> device-removed-\<path> |	当添加或删除设备节点时，会触发这些触发器。|
| service-exited-\<name> |	当指定服务退出时，将触发这些触发器。|

两种常见的Action定义代码：
```
#当init被触发时执行
on init
  <command>
  ...

#当属性sys.boot_completed被设置为1时执行
on property:sys.boot_completed=1
  <command1>
```



### 命令 (Commands)
init.rc中常见的Commands有以下一些：
| Command | Description |
|---|---|
| exec \<path> [ \<argument> ]* | 创建和执行程序(\<path>)。这将会阻塞init，直到程序执行完成。由于它不是内置命令，应尽量避免使用exec，它可能会引起init卡死|
| export \<name> \<value> | 在全局环境变量中设定环境变量 \<name>为\<value>。（这将会被所有在这命令之后运行的进程所继承）|
| ifup \<interface> | 启动网络接口\<interface> |
| import \<filename> | 解析一个init配置文件，扩展当前配置|
| hostname \<name> | 设置主机名|
| chdir \<directory> | 改变工作目录|
| chmod \<octal-mode> \<path> | 更改文件访问权限|
| chown \<owner> \<group> \<path> | 更改文件的所有者和组|
| chroot \<directory> | 改变进程的根目录|
| class_start *<serviceclass> | 启动该类service所有尚未运行的服务|
| class_stop \<serviceclass> | 停止所有该类正在运行的service|
| domainname \<name> | 设置域名|
| enable \<servicename> | 改变一个disable的service为enabled。一般用于service在init.rc中被标记为disabled，这样的service是不会被启动的，当满足一定的触发条件时，可以同enable命令来将他变为enabled|
| insmod \<path> | 安装位于\<path>的模块（PS：驱动）|
| mkdir \<path> [mode] [owner] [group] | 在\<path>创建一个目录，（可选）使用给定的模式，所有者个组。如果没有提供，该目录将用755权限，所有者为root用户，组为root|
| mount \<type> \<device> \<dir>[ \<mountoption> ]* | 尝试挂载\<device>到\<dir>，\<device>可能有mtd@name形式，以指定名为name的mtd块设备。 \<mountoption>包括 "ro", "rw", "remount", "noatime", ...|
| restorecon \<path> [ \<path> ]* | 恢复名为\<path>的文件在file_contexts中配置的的安全级别。自动被init标记正确，不需要用init.rc创建的目录|
| restorecon_recursive \<path> [ \<path> ]* | 递归的恢复\<path>指出的目录树中file_contexts配置指定的安全级别。 path不要用shell可写或app可写的目录，如/data/locla/temp，/data/data，或者有类似前缀的（目录）|
| setcon \<securitycontext> | 设置当前进程的security context为特定的字符串。这是典型的仅用于所有进程启动之前的early-init设置init context |
| setenforce 0\|1 | 设置SELinux系统范围的enfoucing状态。0 is permissive (i.e. log but do not deny), 1 is enforcing. |
| setprop \<name> \<value> | 设置系统属性\<name>为\<value>.|
| setrlimit \<resource> \<cur> \<max> | 为特定资源设置rlimit|
| setsebool \<name> \<value> | 设置SELinux的bool类型\<name>为\<value>。 \<value> may be 1\|true\|on or 0\|false\|off  |
| start \<service> | 启动一个服务（如果服务尚未启动） |
| stop \<service> | 停止服务（如果正在运行）|
| symlink \<target> \<path> | 创建一个符号连接，at \<path> with the value \<target>|
| sysclktz \<mins_west_of_gmt> | Set the system clock base (0 if system clock ticks in GMT) |
| trigger \<event> | 触发一个事件。一个动作将另一动作排队|
| wait \<path> [ \<timeout> ] | poll特定的\<path>，出现后返回，或timeout到达。如果timeout没有指定，默认为5秒|
| write \<path> \<string> | 打开一个位于\<path>的文件，写入（不是追加）字符串\<string>|

### 服务 (Service)
服务是初始化程序init需要启动的一些程序，初始化程序可能在这些程序退出后重启他们。Services的形式:
```
service <name> <pathname> [ <argument> ] *

    <option>

    <option>
```

### 选项 (Option)
选项属于服务，它将影响初始化程序运行服务的时机和方法。可能的选项如下:
| 选项 | 说明 |
|---|---|
| disabled |	此服务不会自动从其类启动。它必须按名称显式启动。|
| socket \<name>\<type> \<perm> [ \<user> [ \<group> ] ] |	创建一个名为/dev/socket/\<name>的unix域套接字，并将其fd传递给启动的进程。有效的\<type>值包括dgram和stream。用户和组默认为0。|
| user \<username> |	在执行此服务之前更改为用户名。当前默认为root |
| group \<groupname> [ \<groupname> ]* |	在执行此服务之前更改为groupname。第一个组之外的其他组名（这是必需的）用于设置进程的其他组（使用set groups（））。当前默认为root |
| capability [ \<capability> ]+	| 在执行此服务之前设置linux功能 |
| class \<name> |	指定服务的类名。命名类中的所有服务必须一起启动和停止。如果服务不是通过类选项指定的，则将其视为类“默认”。|
| oneshot |	退出时不要重新启动服务。|


## 应用中添加使用rc例
1.在Android.mk 同目录下，新建文件haha.sh (文件名任意)，执行shell 操作, 以下简单举例

```bash
#!/bin/sh

rm -rf /system/etc/xxx
```

2.在Android.mk 同目录下，新建文件test.rc (文件名任意)

含义：当设置系统属性persist.vendor.test.haha=2时，启动服务，执行shell 脚本

```bash
on property:persist.vendor.test.haha=2
	start haha-sh

service haha-sh /vendor/bin/haha.sh
        class main
        user root
        group root
        disabled
```

3.在Android.mk 中添加配置

```bash
LOCAL_INIT_RC := test.rc
```

4.在型号添加配置模块的mk 文件中添加以下内容，将代码中的sh 文件copy 到vendor/bin 目录下

```makefile
PRODUCT_COPY_FILES += \
        vendor/apps/TestApp/haha.sh:$(TARGET_COPY_OUT_VENDOR)/bin/haha.sh \
```


参考:
1. [Android Init Language](https://wladimir-tm4pda.github.io/porting/bring_up.html#:~:text=The%20Android%20Init%20Language%20consists%20of%20four%20broad,1%20Actionn%202%20Commands%203%20Services%204%20Options)
2. [Android Init Language(安卓初始化语言)](https://www.jianshu.com/p/8a919ce5e892)
3. [Android rc 文件的使用](https://blog.csdn.net/yinhunzw/article/details/111661135)