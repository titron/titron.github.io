---
layout: post
title:  "Altium Designer拼板的方法和坑"
categories: hardware
tags: PCB
author: David
---

* content
{:toc}

Altium Designer拼板的方法有两种：

1. 比较保险的方法

适用于：所有情况

推荐值：*****

实现步骤：

（1）新建1个PCB

（2）在新PCB界面下，点“Place”---\"Embedded Board Array/Panelize\"，进入拼板界面，设置好拼板阵列就可以了。

2. 比较坑的方法

适用于：不含内层或内层是非负片的情况。

推荐值：***

实现步骤：

（1）pcb文件中，S-B（board）， 全选 board

（2）ctrl+c, 复制，选择 基准点， 在板子空旷地方，单击鼠标左键。

（3）查看板子的长、宽信息

![pcb长x宽信息](https://github.com/titron/titron.github.io/raw/master/img/2020-10-14-AD_pinban_boardInfo.png)

（4）Edit-Past Special

![paste special](https://github.com/titron/titron.github.io/raw/master/img/2020-10-14-AD_pinban_pasteSpecial.png)

这样，就生成了1*2的array。

（5）重复上面【1】~【4】步骤，生成2*3的array。

注意：Y-Spacing = 38.014mm = 36.013+2 mm

![paste special](https://github.com/titron/titron.github.io/raw/master/img/2020-10-14-AD_pinban_pasteSpecial_arrays.png)

（6）添加工艺边

工艺边和v-cut线用“外形层”。

比如，如果板子外框用 mechanic1层，那么工艺边和v-cut也用 mechanic层。

添加mark点，及工艺孔（通孔，非电镀，直径2mm）。

![paste special](https://github.com/titron/titron.github.io/raw/master/img/2020-10-14-AD_pinban_addEdge.png)