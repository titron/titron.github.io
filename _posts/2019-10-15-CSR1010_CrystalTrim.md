---
layout: post
title:  "CSR1010时钟晶体校正方法"
categories: experience
tags: bluetooth crystal trim
author: David
---

* content
{:toc}

## 测试条件

* 频谱分析仪

如Tektronix的RSA3068，或 Agilent N9320B。

![Tektronix的RSA3068](https://github.com/titron/titron.github.io/raw/master/img/2019-10-15-bt_trim_RSA3068.png)

![Agilent N9320B](https://github.com/titron/titron.github.io/raw/master/img/2019-10-15-bt_trim_N9320B.png)

* CSR uEnergy Tools中的CsConfig和uEnergyTest

![CsConfig和uEnergyTest](https://github.com/titron/titron.github.io/raw/master/img/2019-10-15-bt_trim_csrtools.png)

* USB-SPI下载调试器

![usb-spi下载器](https://github.com/titron/titron.github.io/raw/master/img/2019-10-15-bt_trim_spitools.png)

* 待测蓝牙线路板
 
## 校正步骤

* 步骤1：连接好SPI-USB调试编程下载线缆，上电。

* 步骤2：运行uEnergyTest  

![uEnergyTest选择Ptest Firmware Default](https://github.com/titron/titron.github.io/raw/master/img/2019-10-15-bt_trim_1.png)

![uEnergyTest设定输出通道](https://github.com/titron/titron.github.io/raw/master/img/2019-10-15-bt_trim_2.png)

![uEnergyTest设定校正值](https://github.com/titron/titron.github.io/raw/master/img/2019-10-15-bt_trim_3.png)

* 步骤3：CW TRANSMIT

设定右侧的channel值，蓝牙就会输出相应的频率。

![蓝牙频率输出](https://github.com/titron/titron.github.io/raw/master/img/2019-10-15-bt_trim_4.png)

用频谱仪观察该频率，就会发现实际频率与理想频率的频差是多少，以决定Trim补偿数值。

这里，channel 0的频率是2402MHz。

蓝牙基本知识：

2.4G带宽80M，2M一个频带，40个频道

即，channel0 ---2402MHz， channel39 --- 2480MHz

* 步骤4：CRYSTAL TRIM SET

输入校正值，点击Execute，校正值输入的CSR1010中。

再次CW TRANSMIT，用频谱仪观察校正后的频率数值，观察偏差，调整Trim的值。

重复上述过程，使实际频率接近理想频率。

记下该Trim的值。


如果想观察实际写入CSR1010的Trim值是多少，可以用CsConfig的“Crystal frequency trim”选项观察。

如下图中，实际的值是0x003F。该值的设定范围为：0~63.

![查看校正值](https://github.com/titron/titron.github.io/raw/master/img/2019-10-15-bt_trim_5.png)

* 步骤5：RADIO STOP

停止蓝牙输出。

如果有多个信号时，可以通过该选项关闭蓝牙输出。

再用CW TRANSMIT输出蓝牙信号，可以再频谱仪上观察哪个信号是待测蓝牙信号。

* 步骤6：TX Power Level Set   

如果输出信号看不到或幅度不大，可以增加该设定值。

* 步骤7：写入校正值
* 
运行CSR uEnergy SDK 2.6.1.7(xIDE)，将上述Trim 值写入.keyr文件中，编译，下载。

![在xIDE中写入校正值](https://github.com/titron/titron.github.io/raw/master/img/2019-10-15-bt_trim_6.png)

CSR1010就以该校准值运行了。可以通过CsConfig查询实际的校准值。


### 引用：

1. [CSR102x crystal trim 校准方法](https://mp.weixin.qq.com/s?__biz=MzI2MzAxMDk3MA==&mid=2650672766&idx=1&sn=aa977b9783d956be407e2d84addf322d&chksm=f248c18bc53f489ddab8fa460488cc7f36f153252d4ed45a57df33198adab34856aa37aade50#rd)