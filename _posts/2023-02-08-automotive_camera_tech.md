---
layout: post
title:  "车载摄像头技术解析"
categories: hardware
tags: automotive, camera, ADAS
author: David
---

* content
{:toc}

---

参考：

“车载摄像头技术方案分析报告”

### camera系统组成
![车载camera系统组成](https://github.com/titron/titron.github.io/raw/master/img/2023-02-08-automotive_camera_arch.png)

视频流：

Sensor -》 ISP -》 Serializer -》 CSI/MIPI -》 DeSerializer -》 SoC（内含ISP）

### Sensor & ISP
Sensor：CCD 或者 CMOS
![CCD vs CMOS](https://github.com/titron/titron.github.io/raw/master/img/2023-02-08-automotive_camera_ccd_cmos.png)
![ISO12233分辨率测试卡(标准型)](https://github.com/titron/titron.github.io/raw/master/img/2023-02-08-automotive_camera_res_card.jpg)

ISP: 黑电平补偿 、镜头矫正 、坏像素矫正 、颜色插值 、Bayer 噪声去除、 白平衡矫正、 色彩矫正 、 gamma 矫正、
色彩空间转换（ RGB 转换为 YUV） 、 在 YUV 色彩空间上彩噪去除与边缘加强、 色彩与对比度加强，中间还要进行自动曝光控制

### 色彩空间
色彩空间的概念，主要是RGB、YUV这两种（实际上，这两种体系包含了许多种不同的颜色表达方式和
模型，如sRGB, Adobe RGB, YUV422, YUV420 …）。

RGB与YUV的转换公式
![RGB->YUV](https://github.com/titron/titron.github.io/raw/master/img/2023-02-08-automotive_camera_rgb2yuv.png)

### 车载应用场景
如果摄像头图像传给到SoC主机后，用作自动驾驶，就涉及到自动驾驶的视觉技术，视觉技术需要解决的是“摄像头拍到的是什么物体”。

机器识别能读懂是什么物体，需要进行后续图像分割、物体分类、目标跟踪、世界模型、多传感器融合、在线标定、视觉SLAM、ISP等一系列步骤进行匹配与深度学习，其核心环节在于物体识别与匹配，或者运用AI 自监督学习来达到感知分析物体的目的。

### 特斯拉应用
特斯拉的深度学习网络称为HydraNet。其中，基础算法代码是共享的，整个HydraNet包含48个不同的神经网络，通过这48个神经网络，就能输出1000个不同的预测张量。理论上来说，特斯拉的这个超级网络，能同时检测1000种物体。

可以由视觉完成3D的深度信息。
### 车载摄像头实现ADAS
![camera to ADAS](https://github.com/titron/titron.github.io/raw/master/img/2023-02-08-automotive_camera_adas.png)

### 车载摄像头选型
前视摄像头：FOV角度不大（40~50度左右），频率30~60Hz，高动态（100dB），像素100W~200W。

倒车摄像头：FOV角度大于130度，频率30Hz以上就可以，大于70dB即可，像素大于100W。

环视摄像头：FOV角度非常大（170度），频率大于30Hz，宽动态。



