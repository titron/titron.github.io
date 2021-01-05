---
layout: post
title:  "为什么murata电感上有个极性标志？"
categories: hardware
tags: inductor
author: David
---

* content
{:toc}

---

参考[链接](https://article.murata.com/en-global/article/basic-facts-about-inductors-lesson-6)

murata的部分贴片电感是有极性标志的：


![有极性标志的贴片电感](https://github.com/titron/titron.github.io/raw/master/img/2021-01-05-inductor_dir_mark.png)

这里的极性标志，表示的是安装方向/位置。

存在于murata的以下系列中：

-（薄膜）LQP_T series

-（叠层）multilayer-type LQG series 

-（绕线）LQH inductors 

由于电感的结构不是完美对称，所以，相应不同的安装方式，其属性也会改变。 

极性点的目的是，保证使用其真正的值，下图示例，不同安装方向，电感值得变化。

![电感值 VS 不同安装方向](https://github.com/titron/titron.github.io/raw/master/img/2021-01-05-inductor_dir_vs_value.png)

