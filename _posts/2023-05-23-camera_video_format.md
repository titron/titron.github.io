---
layout: post
title:  "摄像头视频图像格式rawRGB、RGB、YUV"
categories: basic
tags: camera video YUV RGB raw
author: David
---

* content
{:toc}

---

参考：
1. [一文读懂rawRGB、RGB和YUV数据格式与转换](https://blog.csdn.net/qq_29575685/article/details/103954096?spm=1001.2101.3001.6661.1&utm_medium=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-103954096-blog-120610907.235%5Ev36%5Epc_relevant_default_base3&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-103954096-blog-120610907.235%5Ev36%5Epc_relevant_default_base3&utm_relevant_index=1)
2. [RAW数据格式解析](https://blog.csdn.net/HuddHeaven/article/details/37807379)


### rawRGB

图像采集的过程为：光照在成像物体被反射 -> 镜头汇聚 -> Sensor光电转换-> ADC转换为rawRGB。

因为sensor上每个像素只采集特定颜色的光的强度，因此sensor每个像素只能为R或G或B，形成的数据就成为了rawRGB数据。

rawRGB数据是sensor的经过光电转换后通过ADC采样后直接输出数据，是未经处理过的数据，表示sensor接受到的各种光的强度。

Raw数据在输出的时候是有一定的顺序的，一般为以下四种:
00：GR/BG
01: RG/GB
10: BG/GR
11: GB/RG

为什么每种情况里有两个G分量呢？这时因为人的眼睛对绿色比较敏感，所以增加了对绿色的采样。其中每个分量代表一个piexl。所以GR/BG就代表四个piexl，在物理sensor上就表示4个晶体管，用一个晶体管只采样一个颜色分量，然后通过插值计算得到每个piexl，这样做的主要目的是降低功耗。

假设一个sensor的像素是8*8（分辨率为8*8），那么这个sensor就有8*8个感光点，每个感光点就是一个晶体管。那么对于上表中四种排列格式的rawRGB数据如下图所示：

![rawRGB数据格式](https://github.com/titron/titron.github.io/raw/master/img/2023-05-23-camera_video_format_rawrgb.jpg)

由上图可以看出，每一种格式的rawRGB数据的G分量都是B、R分量的两倍，是因为人眼对于绿色的更加敏感，所以加重了其在感光点的权重，增加了对绿色信息的采样。

那么，这里还有一个问题：在rawRGB数据中，每个像素只有R、G、B颜色三分量中一个分量，那么这一个分量用多少bit来表示呢？答案如下表：

之所以有个rawRGB这种格式的数据，这样做的目的一般是为了降低感光器件的物理工艺难度，然后通过ISP处理还原出更真实的图像信息。

sensor输出的数据一般要送到ISP中处理才会得到一个好的效果，这就需要ISP知道sensor输出的raw数据的<span style="background-color:yellow"><font color=red>顺序与大小</font></span>，其中顺序一般通过配置ISP的pattern寄存器来实现，大小一般配置在ISP的输入格式控制寄存器中。

raw数据几种常用的格式:

*RAW8*: Raw8即是用8bits表示G/R/B/G中的一个分量,而不是使用8bits表示RG/GB四个分量。在sensor中，为了降低功耗，使用一个晶体来表示一种颜色，然后利用差值计算出相邻像素的值。

*Raw10*: Raw10就是使用10bit表示上述的一个G/R/B/G，但是数据中是16bit的，高6位没用。

*Raw12*: Raw12: 就是使用12bit表示上述的一个G/R/B/G，但是数据中是16bit的，高4位没用

看raw数据的工具：picasa、irfanview、photoshop


### RGB

在数字化的时代，需要一种标准来量化自然界的各种颜色。RGB就是一种在数字化领域表示颜色的标准，也称作一种色彩空间，通过用三原色R、G、B的不同的亮度值组合来表示某一种具体的颜色。注意，*RGB里面存的是颜色的亮度值，而不是色度值。*

在实际应用中，RGB存在着许多的格式，之所以存在着这些格式，是因为随着技术的进步，系统的更迭，不同的应用场景和设备环境，对颜色表达的需求是不同的。

常用的RGB格式如下表所示：

| 格式 | 描述 |
|-|-|
| RGB565 | 每个像素用16位表示，RGB分量分别使用5位、6位、5位。<BR> 内存中排列（高字节->低字节）：R R R R R G G G G G G B B B B B |
| RGB555 | 每个像素用16位表示，RGB分量都使用5位（剩下1位不用）<BR> 内存中排列（高字节->低字节）：X R R R R G G G G G B B B B B（X表示不用，可以忽略） |
| RGB24(RGB888)| 每个像素用24位表示，RGB分量各使用8位。<BR> 内存中排列（高字节->低字节）：B B B B B B B B G G G G G G G G R R R R R R R R |
| RGB32 | 每个像素用32位表示，RGB分量各使用8位（剩下8位不用）<BR>内存中排列（高字节->低字节）：B B B B B B B B G G G G G G G G R R R R R R R R X X X X X X X X （X表示不用，可以忽略） |
| ARGB32 | 每个像素用32位表示，RGB分量各使用8位（剩下的8位用于表示Alpha通道值）<BR>内存中排列（高字节->低字节）：B B B B B B B B G G G G G G G G R R R R R R R R A A A A A A A A|

### YUV
YUV是一种色彩编码方法，Y表示亮度，U和V表示色度。只有Y就是黑白图像，再加上UV就是彩色图像了。YUV的一个好处就是让彩色系统和传统黑白系统很好的兼容，同时利用了人类视觉系统对亮度的敏感度比对色度高。

在一般应用中，人们所说的YUV就是YCbCr，这我认为是从狭义的角度理解（毕竟现在是数字信号的天下，YCbCr恰好是描述数字信号的）。广义上说，YUV是一种色彩空间分类，一种颜色模型，具体的类型有Y'UV， YUV， YCbCr，YPbPr等，目前市场上常用数字的视频信号和视频/图片文件中的编码格式，用YCbCr来描述，于是人们口中的YUV就代指的是YCbCr，常见应用如H.264/H.265码流、MPEG、JPEG等。

YCbCr中的Cb指蓝色色度分量，而Cr指红色色度分量。

YUV和RGB的相同点：都是用来表达颜色的数学方法；

YUV和RGB的相同点：对颜色的描述思路和方法不同。RGB将一个颜色拆解为3个纯色的亮度组合，YUV将一个颜色分解为一个亮度和2个色度的组合。

那引入YUV这种色彩空间的好处具体有啥呢？

（1）YUV提取Y亮度信号，可以直接给黑白电视使用，兼容黑白电视

（2）人眼对UV的敏感性小于亮度，这样我们适当减少uv的量，而不影响人的感官。所以才会有多种格式的 YUV描述，如420、422、444。

（3）伴随显示设备分辨率的提升，bt组织也针对yuv2rgb设定了不同的系数，来最好的从YUV转换到RGB。

（4）YUV格式可以比RGB格式储存空间小。

那RGB存在的作用是什么呢？

目前人类发明的所有彩色的输入输出设备，本质上都只支持RGB数据。哪怕设备允许YUV的输入输出，那也是经过内部的数据转换而间接支持。

* YUV——采样
主流采样方式有如下三种：

（1）YUV 4:4:4 采样

全采样，对每个像素点的的YUV分量都进行采样，这样的三个分量信息量完整。

（2）YUV 4:2:2 采样

部分采样，可节省1/3存储空间和1/3的数据传输量。UV分量是Y分量采样的一半，Y分量和UV 分量按照2 : 1的比例采样。如果水平方向有10个像素点，那么采样了10个Y分量，而只采样了5个UV分量。其中，每采样过一个像素点，都会采样其Y分量，而U、V分量就会间隔一个采集一个。

（3）YUV 4:2:0 采样

部分采样，可节省1/2存储空间和1/2的数据传输量。YUV 420采样，并不是指只采样U分量而不采样V分量。而是指，在每一行扫描时，只扫描一种色度分量（U或者V），和Y分量按照2 : 1的方式采样。比如，第一行扫描时，YU 按照 2 : 1的方式采样，那么第二行扫描时，YV分量按照 2:1的方式采样。对于每个色度分量来说，它的水平方向和竖直方向的采样和Y分量相比都是2:1 。

* YUV——存储格式

YUV存储格式通常有两大类：打包（packed）格式和平面（planar）格式。前者将YUV分量存放在同一个数组中，通常是几个相邻的像素组成一个宏像素(macro-pixel)；而后者使用三个数组分开放 YUV 三个分量，就像是一个三维平面一样。

（1） YUV422 Planar （YUV422P，也称为I422格式）

这里，Y\U\V数据是分开存放的，每两个水平Y采样点，有一个U和一个V采样点，如下图：

![YUV422P](https://github.com/titron/titron.github.io/raw/master/img/2023-05-23-camera_video_format_yuv422p.jpg)

也就是说，U0V0由Y0、Y1共用，这样整幅图像较RGB就减少了1/3的存储空间。

YUV 422P 格式，又叫做 I422格式，采用的是平面格式进行存储，先存储所有的 Y 分量，再存储所有的 U 分量，再存储所有的 V 分量。

假如一个8*2像素的图像的该格式的存储分布如下图：

![YUV422P memory](https://github.com/titron/titron.github.io/raw/master/img/2023-05-23-camera_video_format_yuv422p_memory.jpg)


（2） YUV422 packed

此格式有两种情况：分为YUYV格式和UYVY格式。

*YUYV格式*:

YUYV 格式是采用打包格式进行存储的，指每个像素点都采用 Y 分量，但是每隔一个像素采样它的UV分量。

假如一个8*2像素的图像的该格式的存储分布如下图：

![YUV422P-YUYV](https://github.com/titron/titron.github.io/raw/master/img/2023-05-23-camera_video_format_yuv422p_yuyv_memory.jpg)

*UYVY格式*:

UYVY 格式也是采用打包格式进行存储，它的顺序和YUYV相反，先采用U分量再采样Y分量。

假如一个8*2像素的图像的该格式的存储分布如下图：

![YUV422P-UYVY](https://github.com/titron/titron.github.io/raw/master/img/2023-05-23-camera_video_format_yuv422p_uyvy_memory.jpg)

（3） YUV420 Planar （YUV420P）

这个格式跟YUV422 Planar 类似，但对于U和V的采样在水平和垂直方向都减少为2:1，根据采样规则如下图：

![YUV420P](https://github.com/titron/titron.github.io/raw/master/img/2023-05-23-camera_video_format_yuv420p_memory.jpg)

也就是说，U0V0由Y0、Y1、YW、YW+1共用，这样整幅图像较RGB就减少了1/2的存储空间。

YU12和YV12格式都属于YUV 420P类型，即先存储Y分量，再存储U、V 分量，区别在于：YU12是先Y再U后V，而YV12是先Y再V后U 。

*YU12格式（也称为I420格式）*

YU12是先Y再U后V。

假如一个8*2像素的图像的该格式的存储分布如下图：

![YUV420P-YU12](https://github.com/titron/titron.github.io/raw/master/img/2023-05-23-camera_video_format_yuv420p_yu12.jpg)


*YV12格式*

YV12是先Y再V后U

假如一个8*2像素的图像的该格式的存储分布如下图：

![YUV420P-YV12](https://github.com/titron/titron.github.io/raw/master/img/2023-05-23-camera_video_format_yuv420p_yv12.jpg)

（4） YUV422 Semi-Planar （YUV422SP）

Semi 是“半”的意思，个人理解这个是半平面模式，这个格式的数据量跟YUV422 Planar的一样，但是U、V是交叉存放的。                                              

假如一个8*2像素的图像的该格式的存储分布如下图：

![YUV422SP](https://github.com/titron/titron.github.io/raw/master/img/2023-05-23-camera_video_format_yuv422sp_memory.jpg)


（5） YUV420 Semi-Planar （YUV420SP）

这个格式的数据量跟YUV420 Planar的一样，但是U、V是交叉存放的。

NV12和NV21格式都属于 YUV420SP 类型。它也是先存储了Y分量，但接下来并不是再存储所有的U或者V分量，而是把UV分量交替连续存储。

*NV12*

NV12是IOS中有的模式，它的存储顺序是先存Y分量，再UV进行交替存储。

假如一个8*2像素的图像的该格式的存储分布如下图：

![YUV420SP-NV12](https://github.com/titron/titron.github.io/raw/master/img/2023-05-23-camera_video_format_yuv420sp_nv12.jpg)


*NV21*

NV21是安卓中有的模式，它的存储顺序是先存Y分量，在VU交替存储。

假如一个8*2像素的图像的该格式的存储分布如下图：

![YUV420SP-NV21](https://github.com/titron/titron.github.io/raw/master/img/2023-05-23-camera_video_format_yuv420sp_nv21.jpg)

### RGB与YUV转换

由于YUV有这数字信号和模拟信号的YUV类型，于是RGB与YUV转换方式多种多样，大致分为模拟和数字两种。每种方式下，不同的清晰度视频信号的转换公式也是有所不同。

这里仅仅列出数字YUV（YCbCr）与数字RGB相互转换的BT601(标清国际定义)的转换公式：

![YUV420SP-NV21](https://github.com/titron/titron.github.io/raw/master/img/2023-05-23-camera_video_format_yuv2rgb.png)

