---
layout: post
title:  "常用音频Audio接口与标准-PCM/I2S/TDM/PDM"
categories: basic
tags: audio
author: David
---

* content
{:toc}

---

* PCM(Pulse Code Modulation,脉冲编码调制)

应用场景：
AP处理器和通信MODEM/蓝牙之间也是通过PCM来传输语音数据（就是双向打电话的数据）

![audio-PCM](https://github.com/titron/titron.github.io/raw/master/img/2020-12-16-audio_if_PCM.png)

* I2S(Inter-IC Sound/Integrated Interchip Sound/IIS,IC间音频)

应用场景：
CD播放器。I2S速度快，专门用于传音乐。

![audio-I2S](https://github.com/titron/titron.github.io/raw/master/img/2020-12-16-audio_if_I2S.png)

* TDM(Time Division Multiplexing,时分复用)

应用场景：
麦克风矩阵。PCM可以传多达16路数据，采用时分复用的方式。

![audio-TDM](https://github.com/titron/titron.github.io/raw/master/img/2020-12-16-audio_if_TDM.png)

* PDM(Pulse Density Modulation,脉冲分时复用)

应用场景：
手机和平板电脑等便携设备。对于空间限制严格的场合，即尺寸受限应用中优势明显，有着广泛的应用前景。

![audio-PDM](https://github.com/titron/titron.github.io/raw/master/img/2020-12-16-audio_if_PDM.png)

参考：

[常用音频接口：TDM，PDM，I2S，PCM](https://www.crifan.com/common_audio_interface_tdm_pdm_i2s_pcm/)