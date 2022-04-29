---
layout: post
title:  "Linux Screen 命令详解（转）"
categories: software
tags: screen Linux
author: David
---

* content
{:toc}

---

[Linux Screen 命令详解（转）](https://www.cnblogs.com/mchina/archive/2013/01/30/2880680.html)

常用screen参数

screen -S yourname -> 新建一个叫yourname的session

screen -ls -> 列出当前所有的session

screen -r yourname -> 回到yourname这个session

screen -d yourname -> 远程detach某个session

screen -d -r yourname -> 结束当前session并回到yourname这个session

```
# C-a d
# screen -ls
# screen -d
# screen -r 12865
```