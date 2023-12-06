---
layout: post
title:  "舵机(servo)简介"
categories: basic
tags: servo motor
author: David
---

* content
{:toc}

---

![舵机控制原理](https://github.com/titron/titron.github.io/raw/master/img/2022-04-01-servo_motor_control.gif)

### 释义：
舵机，由直流电机、减速齿轮组、传感器和控制电路组成的一套自动控制系统。

舵机一般而言都有最大旋转角度（比如180度）。使用舵机（servo）控制转向。

与普通直流电机的区别主要在，直流电机是一圈圈转动的，舵机只能在一定角度内转动，不能一圈圈转（数字舵机可以在舵机模式和电机模式中切换，没有这个问题）。

### 舵机连线（例：TowerPro SG-5010）

![TowerPro SG-5010 Specification](https://github.com/titron/titron.github.io/raw/master/img/2022-04-01_servo_motor_SG5010_figure.png)

| 接线颜色 | 连接 |
|---|---|
| 红 | 正 |
| 棕 | 负 |
| 黄 | 信号 |

### 控制

通过发送信号，指定输出轴旋转角度。

舵机的控制原理就是pmw脉宽调制，通过给舵机调节占空比来控制他的转向。

![control servo](https://github.com/titron/titron.github.io/raw/master/img/2022-04-01_servo_motor_control.png)

以SG-5010为例：
- 20ms (50Hz)脉冲	
- 1% ~ 12%占空比

  占空比增加（从1% ~ 12%），向左旋转
  
  占空比减少（从12% ~ 1%），向右旋转

### 舵机指标（例：TowerPro SG-5010）

![TowerPro SG-5010 Specification](https://github.com/titron/titron.github.io/raw/master/img/2022-04-01_servo_motor_SG5010_spec.png)

### 常用舵机型号

| 舵机 | 说明 |
|---|---|
| TowerPro SG-5010 | 价格便宜，5.5kg扭力（4.8V供电） |
| TowerPro MG995 | 价格便宜，金属齿轮，耐用度也不错，扭力小 |
| DYNAMIXEL SR-403P | 价格低，全金属齿轮，扭力大 |
| AX-12+ | 价格高，485接口 |
| HG0680 | 塑料齿轮模拟舵机，跟随性好 |
| S3010 | 扭力<=6.5kgf.cm> |
| S-U400 | 扭力>=6.5kgf.cm> |
| HG14-M | 数字舵机 |

参考：
1. [PWM波控制舵机总结](https://mp.weixin.qq.com/s/iYGDthkrpXLxMWGAHPDdJw)
2. [舵机的原理和控制](https://mp.weixin.qq.com/s/FR3Tp-f2LQeBK0ISjLdupQ)
3. [舵机控制原理](https://mp.weixin.qq.com/s/s3orZo9NwZcCMTMhRxa_Wg)
