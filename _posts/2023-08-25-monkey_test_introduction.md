---
layout: post
title:  "什么是monkey测试"
categories: basic
tags: monkey test
author: David
---

* content
{:toc}

---

参考：
1. [Monkey测试详解](https://blog.csdn.net/yang_yang_heng/article/details/109167201)
2. [monkey测试](https://zhuanlan.zhihu.com/p/34319546)

### 1. Monkey简介

Monkey在英文里的含义是猴子。

在测试行业的学名叫“猴子测试”，指的是没有测试经验的人甚至是根本不懂计算机的人（就像一只猴子），不需要知道程序的任何用户交互方面的知识，给他一个程序，他就会对他看到的任何界面进行操作，当然操作是无目的的、随便乱按乱点的，这种测试在产品周期的早期阶段会很有效，为用户节省了很多时间。

Monkey是Android中的一个命令行工具，可以运行在模拟器里或实际设备中。

它向系统发送伪随机的用户事件流(如按键输入、触摸屏输入、手势输入等)，实现对正在开发的应用程序进行压力测试。

Monkey测试是一种为了***测试软件的稳定性、健壮性***的快速有效的方法。

### 2. Monkey的特征

* 测试的对象仅为应用程序包，有一定局限性
* Monkey测试使用的事件随机流是随机的，也可以进行自定义
* 可对MonkeyTest的对象，事件数量，类型，频率等进行设置

### 3. Monkey的停止条件

* 应用程序崩溃或接收到任何失控异常
* 应用程序不响应
* 正常运行结束
* 强制停止进程