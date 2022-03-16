---
layout: post
title:  "PWM如此简单（转）"
categories: hardware, software
tags: mcu
author: David
---

* content
{:toc}

---

[原文](https://mp.weixin.qq.com/s/cgHvFdOUUhvezB-033Nn9A)

这篇文章短小精悍！

PWM波的频率太低会导致电机运转不畅，振动大，噪音大；

频率太高会导致驱动器开关损耗较大，甚至有电机会啸叫而不转的情况。

一般1k~30k的PWM频率较为普遍，几百Hz的也有，实际上还是根据电机功率在测试时确定合适的PWM频率范围为宜。