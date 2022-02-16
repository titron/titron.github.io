---
layout: post
title:  "开关电源三种控制模式：PWM/PFM/PSM(转)"
categories: hardware
tags: power, buck, boost, pwm, pfm, psm
author: David
---

* content
{:toc}

---

关于开关电源的三种控制模式，这篇文章介绍的简洁明白：

[原文链接](https://mp.weixin.qq.com/s/hmef8wcT_u0GEWT_NYslcw)

PWM: Pulse Width Modulation, 频率不变，不断调整脉冲宽度

PFM: Pulse Frequency Modulation, 脉冲宽度不变，调整频率

PSM: Pulse Skip Modulation, 频率和脉宽都不变，脉冲时有时无

![PWM/PFM/PWM](https://github.com/titron/titron.github.io/raw/master/img/2022-2-16-pwm_pfm_psm.png)

| 模式 | 优点 | 缺点 |
| --- | --- | --- |
| PWM | 噪声低；重负载，效率高；频率高，滤波器设计相对容易 | 轻负载，效率低 |
| PFM | 轻负载，效率高 | 重负载，效率低；频率低，滤波器设计困难与复杂 |
| PSM | 兼顾并改善PWM/PFM的缺点 | 频率低，输出纹波大 |




