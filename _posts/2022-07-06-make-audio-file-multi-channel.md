---
layout: post
title:  "音频多声道测试"
categories: experience
tags: audio ak4613 tdm i2s android
author: David
---

* content
{:toc}

---

### 基础知识
通常的MP3格式，是立体声（stereo，L0和R0）的单通道文件，不具备多通道音频信息。

要进行多声道音频输出的测试，首先要有多声道测试的音频文件，每个省道的音频信息可以相同也可以不同，这里有两个文件（各声道音频信息不同）可以供参考使用，具体指标：
——采样率：48KHz
——分辨率：16 bit
——声道：8声道

(1)多声道音频文件1

[音频文件1-1](https://github.com/titron/titron.github.io/blob/master/_posts/files/tdm8.zip.001)

[音频文件1-2](https://github.com/titron/titron.github.io/blob/master/_posts/files/tdm8.zip.002)

(2) 多声道音频文件2

[音频文件2-1](https://github.com/titron/titron.github.io/blob/master/_posts/files/tdm8_2.zip.001)

[音频文件2-2](https://github.com/titron/titron.github.io/blob/master/_posts/files/tdm8_2.zip.002)

有关多声道测试的文件的介绍，可以看这里：

(1)[APP音频测试 基础概念 - 单声道、立体声和环绕声](https://www.jianshu.com/p/42894fe604d0)

环绕声系统与虚拟环绕声（Virtual Surround）

AC-3杜比数码环绕声系统由5个完全独立的全音域声道和一个超低频声道组成,  有时又将它们称为5.1声道。  

其中5个独立声道为:  前置左声道、前置右声道、中置声道、环绕左声道和环绕右声道；  

另外还有一个专门用来重放120Hz以下的超低频声道,  即0.1声道。

(2)[对于android高解析度音频](https://source.android.com/devices/audio/highres-effects?hl=zh-cn)

多通道：默认的 Android 播放音效已进行了测试，确认其支持多通道（多达 8 通道）。

(3)SSI - I2S可以传递多通道音频信息

比如，AK4613的I/F format: MSB justified, LSB justified (16bit, 20bit, 24bit), I2S or TDM

![ak4613 i2s 多声道信息-mode10/15 timing(TDM512 Mode)](https://github.com/titron/titron.github.io/raw/master/img/2022-07-06-audio-multi-channel-ouput-ak4613-i2s-tdm512.png)


(4)[多声道测试文件](https://zhuanlan.zhihu.com/p/297008675)

(5)[5.1声道测试文件下载](https://zhuanlan.zhihu.com/p/348308651)



### 制作多声道音频文件的工具软件
(1) [mp3 quality modifier](https://softpedia-secure-download.com/dl/d6fc05e5250b133a36b170bc752daccb/62c3b24e/100131534/software/multimedia/audio/mp3-quality-modifier.zip)

利用该工具可以改变MP3文件的bit rate。

![gui-mp3-quality-modifier](https://github.com/titron/titron.github.io/raw/master/img/2022-07-06-audio-multi-channel-ouput-mp3-quality-modifier.png)

(2) [ocenaudio](https://www.ocenaudio.com/downloads/index.php/ocenaudio_win10.exe?)

利用该工具可以制作多通道音频文件。

![gui-ocenaudio](https://github.com/titron/titron.github.io/raw/master/img/2022-07-06-audio-multi-channel-ouput-ocenaudio.png)


### dts修改以及driver更改

dts修改点：

![dts 修改点 - dai-tdm-slot-num = <8>](https://github.com/titron/titron.github.io/raw/master/img/2022-07-06-audio-multi-channel-ouput-dts.png)

driver修改点：

![driver 修改点 - AK4613 Sampling Speed](https://github.com/titron/titron.github.io/raw/master/img/2022-07-06-audio-multi-channel-ouput-driver.png)

摘自AK4613的有关Sampling Speed的设置描述：

![driver 修改点 - AK4613 datasheet - Sampling Speed](https://github.com/titron/titron.github.io/raw/master/img/2022-07-06-audio-multi-channel-ouput-AK4613-sampling-speed.png)

