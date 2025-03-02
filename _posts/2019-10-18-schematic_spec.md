---
layout: post
title:  "我的原理图设计规范"
categories: experience
tags: Orcad schematic
author: David
---

* content
{:toc}

原理图设计基本原则：易于理解。

以下是我的原理图设计检查规范，按照序号顺序检查。

| 索引 | 项目 | 描述 | 备注 |
|---|---|---|---|
| 1 | 工具 | Orcad Capture |  |
| 2 | 图纸file name | 格式：编号.图纸名称 |  |
| 3 | 图纸size | | 公制，A4 |
| 4 | 公司Name | xxx | 设置：Verdana, 常规，小六 |
| 5 | Title | 项目名称，板名-子部分名称 | 设置：Arial， 粗体，小五 |
| 6 | Document Number | 编号-日期等-图纸号 | 设置：Arial, 常规，小六 |
| 7 | Rev | X.XX | 设置：Arial, 常规，小六 |
| 8 | sheet number | X of Y <br> X为当前原理图纸编号。<br> Y为总原理图纸数。 |  |
| 9 | 标注Annotate | 放置离页连接（Off-page）和交互页码 | 改版的原理图不要对器件重新编号，否则PCB Layout时会重新计算费用。|
| 10 | 原理图上加上必要的标识说明 | Design Note用于原理图说明 <br>CAD Note用于layout说明。| Arial， 常规，小六 |
| 11 | 图分块 | 将电路图按功能分块，尽量不要把多个电路放在一张图上 |  |
| 12 | 开关的使用 | 使用了开关，要注明开关设置及功能分配 |  |
| 13 | 信号命名 | 对于多功能使用，命名中包含各个功能、逻辑、电压、输入输出方向<br>对于GPIO引脚，标明GPIO port number |  |
| 14 | 被动元器件 | 如电阻、电容，要包含如精度、封装等信息 |  |
| 15 | 不安装的元器件 | 标明“NM”字样 |  |
| 16 | 0欧姆电阻 | 如是否添加jumper、switcher |  |
| 17 | 连接器 | 添加信号分布说明，避免错误的插入或信号分配 |  |
| 18 | 原理图最后检查 | 器件原理库文件是否正确； <br>工作原理连接是否正确； <br> 封装名称； <br> 板间连接的引脚分配是否需要翻转； <br>线缆与板连接引脚分配是否需要翻转； <br>标号复位后重新标注； <br>添加离页连接； |  |
| 19 | FPGA | 根据FPGA走线重新调整线序 |  |
| 20 | 原理图器件库设计 | 器件具有相同名称的电源引脚、GND引脚,要将其属性设置为’Power‘。否则生成网表时会出现错误；<br> 子板设计时，要注意两个插座的名称CN1/CN2，不要搞错。且位置要沿用以前的PCB设计。|  |
| 21 | DRC检查 | 原理图完成后，一定要进行设计规则检查（DRC） |  |
| 22 | 再版设计时 | 如果通过实验确定了有些器件（如0R/NM等器件）是否使用，那么可以适当删除这些器件。|  |


![原理图设计注意点-1](https://github.com/titron/titron.github.io/raw/master/img/2019-10-18-schematic_1.png)

![原理图设计注意点-2](https://github.com/titron/titron.github.io/raw/master/img/2019-10-18-schematic_2.png)