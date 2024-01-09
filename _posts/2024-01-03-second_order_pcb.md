---
layout: post
title:  "二阶PCB"
categories: basic
tags: layout, PCB
author: David
---

* content
{:toc}

---

[（转）原文](https://zhuanlan.zhihu.com/p/408463538)

这个一阶，二阶就是指打激光孔的次数，***PCB芯板压合几次，打几次激光孔！就是几阶***。

1. 压合一次后钻孔==》外面再压一次铜箔==》再镭射钻孔

这是一阶 ，如下图所示：
![1阶PCB](https://github.com/titron/titron.github.io/raw/master/img/2024-01-03-second_order_pcb_1_order.png)

2. 压合一次后钻孔==》外面再压一次铜箔==》再镭射，钻孔==》外层再压一次铜箔==》再镭射钻孔

这是二阶。主要就是看你镭射的次数是几次，就是几阶了。

二阶就分叠孔与分叉孔两种。

如下图是八层二阶叠孔，是3-6层先压合好，外面2，7两层压上去，打一次镭射孔。再把1，8层压上去再打一次镭射孔。就是打两次镭射孔。这种孔因为是叠加起来的，工艺难度会高一点，成本就高一点。
![2阶PCB,叠孔](https://github.com/titron/titron.github.io/raw/master/img/2024-01-03-second_order_pcb_2_order_1.png)

如下图是八层二阶交叉盲孔，这种加工方法与上面八层二阶叠孔一样，也需要打两次镭射孔。但镭射孔不是叠在一起的，加工难度就少很多。
![2阶PCB,交叉孔](https://github.com/titron/titron.github.io/raw/master/img/2024-01-03-second_order_pcb_2_order_2.png)

三阶，四阶就依次类推了。