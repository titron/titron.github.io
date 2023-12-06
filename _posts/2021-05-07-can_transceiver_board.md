---
layout: post
title:  "3.3V CAN收发器SN65HVD230板 rev.0.01 介绍"
categories: experience
tags: CAN Transceiver SN65HVD230
author: David
---

* content
{:toc}

---

![3.3V CAN收发器SN65HVD230板 rev.0.01](https://github.com/titron/titron.github.io/raw/master/img/2021-05-07-can_txrx_vp230_rev001.png) 

### 特点：

- 采用原装TI SN65HVD230收发器，通讯质量更有保证（如对成本有要求，可以采用国产收发器替代）

- 控制器侧连接信号：3.3V / CTX / CRX / Standby(可选) / GND（有清晰的丝印标注，辅助接线）

- CAN侧连接信号：CAN-H / GND / CAN-L（有清晰的丝印标注，辅助接线）

- Rs控制：通过跳线，可选择3钟控制方式——高速通讯 / Slope控制（需要焊接相应电阻） / 可由控制器进行Standby控制（有清晰的丝印标注，辅助接线）

- CAN总线保护电路：可选择是否需要焊接静电抑制二极管(ESD)对CAN总线进行保护

- CAN总线终端电阻（120欧姆）控制：可通过跳线，选择连接或者断开终端电阻

- 单通道设计

- 无论是控制器还是CAN侧，均采用插针连接方式，使用起来更方便，更灵活
  （如需要采用凤凰端子或航空插头连接方式，可联系进行更改设计）

- 四个直径3.0mm的安装螺孔，安装更可靠，更方便

