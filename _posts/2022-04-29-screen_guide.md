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

1. [Linux Screen 命令详解（转）](https://www.cnblogs.com/mchina/archive/2013/01/30/2880680.html)
2. [linux下screen如何显示当前处在哪个screen（如何显示当前screenid）](https://blog.csdn.net/weixin_34220834/article/details/92107468)

### 常用screen参数

| command | description |
| - | - |
| screen -S yourname  | # 新建一个叫yourname的session |
| screen -ls | # 列出当前所有的session |
| screen -r yourname | # 回到yourname这个session |
| screen -d yourname | # 远程detach某个session |
| screen -d -r yourname | # 结束当前session并回到yourname这个session |
| echo $STY | 查看自己是不是在screen里边. 如果回显是空的，那么就是在真·终端里，否则会显示当前的screen ID |

```bash
# C-a d                     # detach
# screen -ls                # list session
# screen -d                 # detach session
# screen -r 12865           # recall session
# screen -S 7311 -X quit    # kill session
```

当然，如果你在另一台机器上没有分离一个Screen会话，就无从恢复会话了。

这时可以使用下面命令强制将这个会话从它所在的终端分离，转移到新的终端上来：
```bash
# screen -r 12865           # recall session
# screen -d 12865           # detach session
# screen -r 12865           # recall session
```

### screen显示窗口查看历史输出
利用ctrl-a [ 进入copy mode，即可查看。

