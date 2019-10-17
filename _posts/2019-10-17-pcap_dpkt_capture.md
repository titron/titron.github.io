---
layout: post
title:  "用pcap+dpkt进行抓包"
categories: VLAN 802.1q
tags: AVB, 802.1Q, VLAN, pcap, dpkt
author: David
---

* content
{:toc}

* 安装dpkt

从dpkt网站下载.whl文件，然后进入Python27\Scripts目录，运行以下命令：

```
pip install dpkt-1.8.7-py2-none-any.whl
```

* 安装pcap

[1] Python

python-2.5.4.msi. python-2.6.3.msi. 

安装完成后，将相关目录信息添加到PATH。

缺省路径：

C:\Python25 and C:\Python25\Scripts 

或

C:\Python26 and C:\Python26

[2] Scapy

从Mercurial库下载最新版本，然后解压，运行：

```
python setup.py install
```

[3] pywin32

pywin32-214.win32-py2.5.exe 

或

pywin32-214.win32-py2.6.exe

[4] WinPcap

WinPcap_4_1_3.exe. 

选择

“[x] Automatically start the WinPcap driver at boot time”

这样，任何一个用户都可以sniff。

[5] pypcap

pcap-1.1-scapy-20090720.win32-py25.exe 

或

pcap-1.1-scapy-20090720.win32-py2.6.exe. 

[6] libdnet

dnet-1.12.win32-py2.5.exe 

或

dnet-1.12.win32-py2.6.exe. 

[7] pyreadline

pyreadline-1.5-win32-setup.exe

* 代码

```
import pcap
import dpkt
import binascii

pc = pcap.pcap()
pc.setfilter(éther proto 0x8100')

try
  for ptime, pdata in pc:
    t = binascii.hexlify(pdata)
    print(t)
except:
  print(Érror')

```