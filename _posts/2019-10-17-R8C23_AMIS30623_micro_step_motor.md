---
layout: post
title:  "一种基于LIN总线的步进电机驱动方案"
categories: hardware software system
tags: LIN, step-motor, AMIS-30623, AFS, HVAC
author: David
---

* content
{:toc}

本文介绍一种新型的基于LIN总线网络的步进电机驱动方案是以瑞萨电子公司（Renesas）的16位单片机R8C/23实现LIN主节点，以On Semiconductor的微步电机驱动芯片AMIS-30623为LIN从节点，构建的一种极其简单而又可靠的LIN总线网络，用以驱动步进电机，实现对汽车车身网络控制，如汽车前照灯转向控制(AFS)， 汽车采暖通风调节(HVAC)等。

## 引言

从目前来看，在汽车内网络应用中，CAN（Controller Area Network）总线是最被普遍应用的网络标准，其高性能和可靠性已被认同，并已经被广泛地应用于除汽车电子外的其他领域，如工业自动化、船舶、医疗设备、工业设备等领域。但是，相比较来说，对于一些传输速率不是很高，成本要求比较敏感的应用场合，LIN（Local Interconnect Network）总线更加能够满足要求。本文将以汽车前照灯转向控制为例，介绍LIN网络在其中的具体应用。包括硬件R8C/23与AMIS-30623的硬件接口电路和具体的软件描述。

## R8C/23

R8C/23单片机是瑞萨电子R8C Tiny产品家族的成员，它采用CISC结构，内部总线宽度16位，最高运行频率达20MHz，具有内置可在线编程FLASH、EMI 性能出色、硬件看门狗、引脚功能丰富等多种优点。R8C/23单片机内置了CAN 控制器和LIN模块，可在车载温度范围内使用。

![图1是R8C/23的引脚分配图](https://github.com/titron/titron.github.io/raw/master/img/2019-10-17-LIN_Motor_r8c23.png) 

R8C/23单片机的主要性能特点如下：

* 地址空间：1M字节

* 存储空间：可编程ROM为最大为48K字节，数据闪存为1K字节×2，RAM为2.5K字节

* 端口：输入/输出为41个，输入3个

* 定时器：4个

* 串行接口：2个。1个通道(UART0）——时钟同步串行I/O、时钟异步串行I/O，1个通道(UART1）——时钟异步串行I/O

* 时钟同步串行接口：1通道（I2C，带片选时钟同步串行I/O）

* LIN模块：1通道，硬件LIN

* CAN模块：1通道（CAN2.0B，16 slot）

* A/D转换器：10位×12通道

* 看门狗定时器

* 中断：14个内部中断，6个外部中断，4个软件中断，7个中断优先级

* 时钟产生电路：外部和内部时钟源可以选择

在本方案中使用的是R8C/23 CAN/LIN 演示板，如图2所示。

![图2R8C/23 CAN/LIN 演示板](https://github.com/titron/titron.github.io/raw/master/img/2019-10-17-LIN_Motor_r8c23_canlin_demo.png) 

R8C/23 CAN/LIN演示板是瑞萨电子开发的面向CAN/LIN应用的开发工具。演示板除了提供必要的硬件资源之外，还提供了4个样例程序- CAN应用、LIN主机应用、LIN从机应用以及LCD显示驱动程序，可以助您快速熟悉、掌握瑞萨单片机以及瑞萨单片机在CAN、LIN总线方面的应用方法。

## AMIS-30623
AMIS-30623是On Semiconductor半导体公司推出具有LIN通讯接口、无传感器失步和堵转检测、诊断保护功能的步进电机驱动单芯片集成电路，可以用于汽车以及工业控制中，增强可靠性、减少元器件数量、减少线路板空间并降低成本以及缩短开发时间。该产品的目标用途包括前灯调平和旋转、汽车采暖、通风和空调(HVAC)设计、监视摄像机控制、专业照明设备、工业XYZ台和制造机器人等。

AMIS-30623的工作温度在-40ºC至125ºC之间，可提供最高至800mA的可编程峰值电流，简捷的编程指令以实现对步进电机的所有运动控制。芯片上位置控制器可根据不同的电机类型、定位范围和参数（例如速度、加速和减速）进行设置。该产品具备保持电流的特性，低于100μA的断电电流确保了在备用模式下消耗最小功率。

![图3是AMIS-30623的引脚分配图](https://github.com/titron/titron.github.io/raw/master/img/2019-10-17-LIN_Motor_30623_pins.png) 

AMIS-30623的主要性能如下：

* 无需传感器的失步检测

* 可编程驱动电流峰值可到800mA

* 固定频率的PWM电流控制

* 快速和慢速衰减模式自动选择

* 1/2, 1/4, 1/8和1/16四种微步模式

* 位置控制

* 兼容14V/24V

* 速度、加速度可配置

* LIN接口（LIN rev.1.3，通讯速率19.2Kbps）

* 可现场编程的节点地址

* 动态分配ID

* 详尽的诊断和状态信息

* 过流保护、降压保护、开路检测、高温报警

* LIN总线短路到地或电源保护

* 支持LIN总线唤醒

其典型应用电路：

![图4是AMIS-30623的典型应用电路](https://github.com/titron/titron.github.io/raw/master/img/2019-10-17-LIN_Motor_30623_circuit.png) 

## 硬件连接

R8C/23 CAN/LIN演示板与AMIS-30623驱动板的连接如图5所示。

![图5是R8C/23 CAN/LIN演示板与AMIS-30623驱动板连接示意图](https://github.com/titron/titron.github.io/raw/master/img/2019-10-17-LIN_Motor_r8c23_30623_con.png) 

从上图中可以看出，整个系统只需接入+12V和GND，系统即可工作，连线非常简单。图中的步进电机使用的是2相步进电机KH39FM2-851，来自日本伺服有限公司(JAPAN SERVO CO., LTD.)。

用R8C/23实现LIN主节点的硬件原理如图6所示。本例中LIN收发器采用的是NXP-TJA1020。

![图6是用R8C/23实现LIN主节点](https://github.com/titron/titron.github.io/raw/master/img/2019-10-17-LIN_Motor_r8c23_lin_nodedemo.png) 



## 软件实现
软件的实现由两部分构成。

一部分实现了R8C/23的有关LIN功能以及LCD显示控制界面。

另一部分实现了AMIS-30623的工作参数设置以及通讯。

* R8C/23的有关LIN功能的实现
有关R8C/23 LIN功能的具体实现请参见参考资料1。图7是R8C/23发送LIN帧头的实现流程图。

![R8C/23发送LIN帧头流程图](https://github.com/titron/titron.github.io/raw/master/img/2019-10-17-LIN_Motor_r8c23_tx_lin_header.png) 

首先设定LIN的工作模式、相关中断设置、错误状态清零等，然后其具体的数据收发功能实现与UART0的数据收发基本相同，实现起来比较简单。

* AMIS-30623的工作参数设置以及通讯命令实现

有关AMIS-30623的详细操作实现请参阅参考文献3。

有关LIN帧可以分为两类：设置帧、回读帧。

设置帧的作用：对OTP(OneTimeProgramable, 一次性可编程)的内容进行编程、配置步进电机的工作参数（电流、速度、步进模式，等等）、设置步进电机的步进位置。对应的设置命令有：GotoSecurePosition、HardStop、GotoSecurePosition、HardStop、ResetPosition、ResetToDefault、RunVelocity、SetDualPosition、SetMotorParam、SetOTPparam、SetStallparam、SetPosition、SetPositionShort、SetPosParam。

回读帧的作用：得到当前步进电机的实际位置、取得错误标志的状态、检查参数或编程的设置是否正确。对应的回读命令有：GetActualPos、GetFullStatus、GetOTPparam、GetStatus。

在本实现方案中主要使用了两个命令：SetDualPosition、SetMotorParam。

SetDualPosition命令的作用是以两个不同的速度是步进电机运行至某一位置，其命令格式参见表1。有关各参数的具体意义请参见参考资料3的详细说明。

SetMotorParam命令的作用是设置步进电机的工作参数。其命令格式参见表2。有关各参数的具体意义请参见参考资料3的详细说明。

![表1 SetDualPosition命令格式](https://github.com/titron/titron.github.io/raw/master/img/2019-10-17-LIN_Motor_30623_set_dualP.png) 

![表2 SetMotorParam命令格式](https://github.com/titron/titron.github.io/raw/master/img/2019-10-17-LIN_Motor_30623_set_motorP.png) 

由R8C/23实现的LIN主节点首先通过命令SetMotorParam实现步进电机的运行参数设置，然后使用命令SetDualPosition即可实现驱动步进电机到某一位置。

## AFS 解决方案

随着中国汽车工业的发展，国内汽车产家已把目光瞄准国际先进的高性能汽车，在众多的汽车前照灯转向控制方案中，我们推荐一种简单而又可靠的一种方案，利用瑞萨电子公司高性价比的单片机和AMIS公司的独特的步进电机驱动器，采用汽车通行的LIN总线控制方式，用极及简洁的布局结构，构建AFS系统。

该系统只需采用一款瑞萨单片机，一款AMIS30600的LIN收发器和4片AMIS30623 步进电机驱动器，整个通讯系统包括电源，地和LIN线仅需3跟线，具有将抗干扰的AMIS驱动器可放置在步进电机机壳上，连线图和安装图如图9图10所示。

![图9 步进电机驱动系统连线图](https://github.com/titron/titron.github.io/raw/master/img/2019-10-17-LIN_Motor_afs.png) 

![图10 驱动器板与电机安装图](https://github.com/titron/titron.github.io/raw/master/img/2019-10-17-LIN_Motor_drive.png) 

## 结论
从上文的描述中可以看出，用R8C/23实现LIN主节点功能、用AMIS-30623实现LIN从节点驱动步进电机，无论从硬件还是从软件上实现都非常简单，可靠性很高。可以看出，对于实际应用，本文中的设计方案有很高的参考价值。

## 参考文献：
* “R8C/22 Group, R8C/23 Group Hardware Manual”, Renesas Electronics
* “R8C/23 CAN/LIN演示板用户手册”, Renesas Electronics
* “AMIS-30623 LIN Microstepping Motordriver Data Sheet”, On semiconductor

