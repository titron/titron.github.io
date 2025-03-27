---
layout: post
title:  "Ubuntu 下minicom的安装及使用"
categories: experience tools
tags: minicom
author: David
---

* content
{:toc}

---

### 安装与设置

```bash
$sudo apt-get install minicom   # install
$sudo minicom                   # config
```
按ctrl+A，Z，出现配置菜单

![字体设置]](https://github.com/titron/titron.github.io/raw/master/img/2021-07-13-minicom_in_ubuntu_config.png)

如果是直接的串口，串行设备配置为：/dev/ttyS0

如果是USB转串口，串行设备配置为：/dev/ttyUSB0

确认配置正确后，需要保存为默认配置：save setup as dfl

然后，重启minicom，配置才会生效。

连接串口线，这时就可以打印串口信息了。

提示:

下次在输入minicon 即可直接进入。

命令minicom是进入串口超级终端画面，而minicom -s为配置minicom。

说明/dev/ttyS0 对应为串口0 为你连接开发板的端口。

注意：非正常关闭minicom，会在/var/lock下创建几个文件LCK*，这几个文件阻止了minicom的运行，将它们删除后即可恢复


### linux下使用USB转串口设备

默认情况下ubuntu已经安装了USB转串口驱动(pl2303)。

```bash
$lsmod | grep usbserial
```

如果有usbserial，说明系统支持USB转串口。


插上USB转串口，在终端输入命令

```bash
$dmesg | grep ttyUSB0
```

如果出现连接成功信息，则说明ubuntu系统已经识别该设备了。

注意：

虚拟机环境下的ubuntu默认情况下是不能自动识别的，需要在虚拟机窗口右下角点击"Prolific USB-Serial Controller"，然后选择"Connect (Disconnect from Host)"，这样才能被ubuntu系统识别。

在上面minicom的配置中设置*Serial Device: /dev/ttyUSB0*，重启开发板，这样基本上就可以正常使用minicom来打印串口信息了。

如果经过上面的步骤minicom还是不能正常工作，出现如下错误提示：

```bash
$sudo minicom
minicom: cannot open /dev/ttyUSB0: 没有该文件或目录
```

这时可以尝试换一个USB口，然后再次操作以上流程。

如果还是提示这个错误，那么可以使用下面的方法来解决。

这种方法是在硬件里添加串口设备，将window下的设备添加到虚拟机里。也就是说，要在window获得焦点的时
候加入usb转串口，然后再到虚拟机下将这个设备添加进去，这时就可以在ubuntu下查看添加的这个设备的设备文件，一般是/dev/tty0或者
/dev/ttyS0。

这种方法其实是将window的usb转串口作为虚拟机的串口，所以就是tty0或者ttyS0了，而不是真正在ubuntu下加载的。

具体步骤如下：

（1）打开虚拟机环境，然后选择"VM-->Settings(Ctrl+D)"。

（2）点"Add"，进入添加硬件向导，选择"Serial Port"，点"Next"。

（3）选择第一项"Use physical port on the host"，点"Next"。

（4）选择"Physical serial port"方式为"Auto detect"，勾选"Connect at power on"，点"Finish"完成。

(5)然后在上面minicom的配置中设置Serial Device: /dev/tty0或者Serial Device: /dev/ttyS0，重启开发板，这样就可以正常运行minicom了。

### 参考以下链接：用minicom选择ascii协议传输文件

[ubuntu下如何使用minicom传送文件](https://blog.csdn.net/xiaotaiyangzuishuai/article/details/79036716)
