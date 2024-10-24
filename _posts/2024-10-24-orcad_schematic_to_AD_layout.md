---
layout: post
title:  "用OrCAD设计原理图用AD设计layout"
categories: basic
tags: OrCAD，AltiumDesigner，schematic，layout
author: David
---

* content
{:toc}

---

### 一、Orcad Capture 生成网表
1、点击.DSN文件，然后点击TOOS，再点击Create Netlist;如下图：

![DSN生成netlist文件](https://github.com/titron/titron.github.io/raw/master/img/2024-10-24-create_netlist.png)

![选择netlist格式](https://github.com/titron/titron.github.io/raw/master/img/2024-10-24-netlist_formatters.png)

![查看netlist文件](https://github.com/titron/titron.github.io/raw/master/img/2024-10-24-netlist_formatters.png)

2、查看网表是否生成。
打开项目文件存放路径，看到了有MCU.NET的文件已经生成，将这个文件导入到PCB文件中即可。

### 二、Altium Designer中导入网表文件
1、新建PCB工程文件，新建.PCB加粗样式文件，添加AD的封装库文件及网表文件到PCB工程文件中。如图：
![导入netlist到AD PCB文件](https://github.com/titron/titron.github.io/raw/master/img/2024-10-24-import_netlist_to_new_pcb_file.png)


2、对比文件选择选择完之后点击“确定”。
![导选择导入文件](https://github.com/titron/titron.github.io/raw/master/img/2024-10-24-import_netlist_file.png)


3、更新到PCB文件中
上一步对比结果出来后，按如下图选择操作。
![更新](https://github.com/titron/titron.github.io/raw/master/img/2024-10-24-update_pcb_file.png)

![执行](https://github.com/titron/titron.github.io/raw/master/img/2024-10-24-Execute_update.png)


至此网表导入完毕！！！！




