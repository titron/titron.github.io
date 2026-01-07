---
layout: post
title:  "Interleaved, planar, or semi-planar,都是什么意思"
categories: experience
tags: vsp, isp
author: David
---

* content
{:toc}

在图像处理、视频编码和内存存储中，**Interleaved**（交错）、**Planar**（平面）和 **Semi-planar**（半平面）是描述**多通道数据**（如 RGB、YUV）在内存中**布局方式**的三种常见格式。它们直接影响**内存访问效率、硬件解码兼容性、图像处理性能**。

下面以最常见的 **YUV 色彩空间**（视频常用）为例进行说明（RGB 原理类似）：

---

## 🎯 核心概念：YUV 三通道
- **Y**：亮度（Luma），人眼对亮度最敏感
- **U、V**：色度（Chroma），可压缩而不明显影响观感
- 常见采样格式：**YUV420**（U/V 分辨率是 Y 的 1/2）

---

## 1. ✅ **Planar **(平面格式)

### 定义：
所有 **Y 像素连续存储**，然后 **所有 U 像素连续存储**，最后 **所有 V 像素连续存储**。

### 内存布局（YUV420 示例，4×4 图像）：
```
内存地址 → [YYYY YYYY YYYY YYYY UU UU VV VV]
           ↑     ↑     ↑     ↑   ↑   ↑
          Y平面  |     |     |  U平面 V平面
                全部Y数据    全部U数据 全部V数据
```

### 特点：
- **优点**：通道分离，便于单独处理 Y/U/V（如只增强亮度）。
- **缺点**：访问一个像素需跨多个内存区域，**缓存不友好**。
- **常见格式**：
  - `I420`（YUV420 Planar）
  - `YV12`（Y, V, U 顺序，Planar）

> 📌 **典型应用**：FFmpeg、OpenCV（`cv::COLOR_YUV2BGR_I420`）、部分摄像头原始输出。

---

## 2. ✅ **Interleaved **(交错格式)

### 定义：
**Y、U、V 像素按像素或宏块交错存储**。常见于 **RGB**，YUV 中较少（但有）。

### RGB 交错示例（每个像素 R-G-B 连续）：
```
[R0 G0 B0] [R1 G1 B1] [R2 G2 B2] ...
```

### YUV 交错（如 YUYV）：
- 每 2 个 Y 共享 1 组 U、V（YUV422）：
```
[Y0 U0 Y1 V0] [Y2 U1 Y3 V1] ...
```

### 特点：
- **优点**：单像素数据连续，**缓存友好**，适合逐像素处理。
- **缺点**：Y/U/V 无法独立访问。
- **常见格式**：
  - `RGB24`（R-G-B 交错）
  - `YUYV` / `UYVY`（YUV422 Interleaved）

> 📌 **典型应用**：显示器帧缓冲、USB 摄像头（UVC）、DirectShow。

---

## 3. ✅ **Semi-planar **(半平面格式)

### 定义：
- **Y 平面连续存储**（同 Planar）
- **U 和 V 交错存储**（如 UVUVUV...）

### 内存布局（YUV420 Semi-planar）：
```
[YYYY YYYY YYYY YYYY UV UV UV UV]
 ↑     ↑     ↑     ↑   ↑
Y平面（全部Y）        UV平面（U和V交替）
```

### 特点：
- **优点**：Y 单独存储（便于亮度处理），UV 合并（减少内存碎片），**硬件友好**。
- **缺点**：U/V 仍需解交错。
- **常见格式**：
  - `NV12`：Y + UV 交错（U 在前）
  - `NV21`：Y + VU 交错（V 在前，Android camera 默认）

> 📌 **典型应用**：
> - **Android Camera** 输出格式：`NV21`
> - **Intel/AMD/NVIDIA GPU** 视频解码器：默认输出 `NV12`
> - **H.264/H.265 解码**：硬件解码器常输出 Semi-planar

---

## 📊 三种格式对比（以 YUV420 为例）

| 特性 | Planar (I420) | Semi-planar (NV12) | Interleaved (YUYV) |
|------|---------------|---------------------|---------------------|
| **Y 存储** | 连续 | 连续 | 与 U/V 交错 |
| **U/V 存储** | U 连续，V 连续 | UV 交替（UVUV...） | 与 Y 交错 |
| **内存块数** | 3 块（Y, U, V） | 2 块（Y, UV） | 1 块 |
| **硬件支持** | 一般 | ⭐⭐⭐（GPU/编解码器首选） | 中等 |
| **Android Camera** | ❌ | ✅ `NV21` | ❌ |
| **OpenCV 支持** | ✅ `I420` | ✅ `NV12` | ✅ `YUYV` |

---

## 🔧 实际应用场景

### 1. **Android App 开发**
- 相机预览回调格式是 **`NV21`**（Semi-planar）
- 若需用 OpenCV 处理，需转换：
  ```java
  // Java (Android)
  Mat yuvMat = new Mat(height + height/2, width, CvType.CV_8UC1);
  yuvMat.put(0, 0, nv21ByteArray);
  Mat bgrMat = new Mat();
  Imgproc.cvtColor(yuvMat, bgrMat, Imgproc.COLOR_YUV2BGR_NV21);
  ```

### 2. **视频解码（FFmpeg + GPU）**
- 硬件解码器（如 VAAPI、CUDA）输出 **`NV12`**
- 渲染到屏幕前可能需转为 RGB Interleaved

### 3. **嵌入式 DSP 图像处理**
- 为节省带宽，ISP 输出 **Planar YUV**（Y 单独处理降噪，UV 降分辨率）

---

## ✅ 总结

| 格式 | 中文 | 存储方式 | 典型用途 |
|------|------|---------|--------|
| **Planar** | 平面格式 | Y / U / V 分三个连续区域 | 软件处理、FFmpeg |
| **Semi-planar** | 半平面格式 | Y 连续 + UV 交错 | **Android、GPU、硬件编解码** |
| **Interleaved** | 交错格式 | 每像素/宏块内 YUV 交错 | 显示器、RGB 图像、摄像头 |

> 💡 **记住**：  
> - **Planar = 三通道分离**  
> - **Semi-planar = Y 分离，UV 合并交错**  
> - **Interleaved = 所有通道混合交错**

理解这三种布局，对**优化图像处理性能、调试视频 pipeline、跨平台数据转换**至关重要。



