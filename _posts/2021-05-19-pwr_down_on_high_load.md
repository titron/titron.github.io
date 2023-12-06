---
layout: post
title:  "重负载导致了电源突降解决方法（MOS开关管的使用）"
categories: experience
tags: LDO power load
author: David
---

* content
{:toc}

---

昨天碰到了一个MOS开关管使用的问题：
![MOSFET switch 原电路](https://github.com/titron/titron.github.io/raw/master/img/2021-05-19-pwr_down_using_mosfet.png)
![Vin vs Vout 添加R2/C1之前](https://github.com/titron/titron.github.io/raw/master/img/2021-05-19-pwr_down_using_mosfet_before.png)
![Vin vs Vout 添加R2/C1之后](https://github.com/titron/titron.github.io/raw/master/img/2021-05-19-pwr_down_using_mosfet_after.png)
   
 
解决方案【1】
由于Vout外接大容性负载，很容易造成Vin上的冲击/急剧跳变，以至于会降至Vmax/2以下，所以需要添加电阻R2、C1使MOS管“慢慢”打开，同时，也缩短Vout由“0”到“1”的上升时间，使由Vout供电的器件能够被可靠的上电复位。

解决方案【2】
以上电路还可以进一步改进，在开关管的输出端串联一个电感，改善这种由于重负载造成的电源突降，如下图。
![进一步改造的电路](https://github.com/titron/titron.github.io/raw/master/img/2021-05-19-pwr_down_using_mosfet_inductor.png)
 
解决方案【3】
不过，以上方法并不完美，比较好的处理方法是，将MOS开关管前的电压用一路LDO，供应不大的电流给MCU，MOS开关管后面的电压用一路带有使能端的开关DC/DC，供应较大的电流给外围器件，这样能彻底避免由于重负载造成的电源突降。
![进一步改造的电路](https://github.com/titron/titron.github.io/raw/master/img/2021-05-19-pwr_down_using_mosfet_ldo.png)
 
 





[原文](http://www.zhouyousong.cn/2021/05/09/yuv%e7%bc%96%e7%a0%81%e7%9f%a5%e8%af%86%e6%80%bb%e7%bb%93/)

文章中，嵌入的两个视频不错。
[视频1——YCbCr and RGB Colour](https://www.youtube.com/watch?v=3dET-EoIMM8&t=30s)
[视频2——Do you need 4:2:2 sampling](https://www.youtube.com/watch?v=32PPzwPjDZ8&list=LL&index=2)
