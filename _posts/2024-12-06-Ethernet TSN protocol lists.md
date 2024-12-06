---
layout: post
title:  "Ethernet TSN protocol lists"
categories: basic
tags: automotive, Ethernet, TSN
author: David
---

* content
{:toc}

---

### TSN 主要的目标
是致力于构建真正统一的高性能网络基础设施，为各类流量提供协调共存的平台，通过提供统一网络基础设施，支持在多应用融合的网络上传输不同优先级的数据包。这样的网络同时可支持 *高带宽*、*实时通讯*、*高可靠性*和*高性能*的应用

![TSN vs Layers](https://github.com/titron/titron.github.io/raw/master/img/2024-12-06-tsn_layer.png)
![TSN profiles](https://github.com/titron/titron.github.io/raw/master/img/2024-12-06-tsn_profiles.png)
![TSN Applications](https://github.com/titron/titron.github.io/raw/master/img/2024-12-06-tsn_application.png)


### Ethernet TSN protocol lists

|802.1xxx|缩写|TSN IEEE802.1xxxxx|Name|中文名称|
|-|-|-|-|-|
|802.1AS|gPTP|IEEE 802.1AS-2011|gPTP (generic Precise Timing Protocol)|定时和同步|
|802.1Qci||IEEE 802.1Qci-2017|Per Stream Filtering & Policing (Qci)|每（逐）流过滤和监管（控）|
|802.1Qbv|TAS|IEEE 802.1Qbv-2015|Time Aware Shaper (Qbv)|分时调度——预定流量的增强功能|
|802.1Qat|SRP|IEEE 802.1Qat-2010|SRP (Stream Reservation Protocol – in Q section 35)||
|802.1Qav|CBS|IEEE 802.1Qav-2009|Credit based shaper (in Q-2014 section 34)|信用整形——保留流量，时间敏感流的转发和排队增强|
|802.1Qbu&3br||IEEE 802.1Qbu-2016 & IEEE 802.3br-2016|Preemption (Qbu & 3br)|帧抢占|
|802.1CB||IEEE 802.1CB-2017|Frame Replication & Elimination|帧复制和消除可靠性|
|||IEEE 1722-2011|AVTP (Audio Video Transport Protocol)||
|||IEEE 1722.1-2013|AVDECC (Audio Video Discovery, Enumeration, Connection management, and Control)||
|802.1BA||IEEE 802.1BA-2009|Audio Video Bridging(AVB) System||
|||IEEE 802.1AS-Rev|Enhanced Generic Precise Timing Protocol||
|||IEEE 802.1Qch-2017|Cyclic Queuing & Forwarding (Qch)|循环队列与转发|
|||IEEE 802.1Qcc|Stream Reservation Protocol Enhancements|流预留协议的增强|
|||IEEE 802.1Qcr|Asynchronous Traffic Shaping (Qcr)||

### AVB/TSN Link Layer Abbreviations
|abbr.|description|
|-|-|
|ARP|Address Resolution Protocol (ARP)|
|RARP|reverse Address Resolution Protocol (RARP)|
|EAPOL|EAP over LAN (EAPoL)|
|NDP|Neighbor Discovery Protocol|
|SRP|Stream Reservation Protocol|
|MAC Control|Media Access Control|
|MACsec|Media Access Control Security|
|MKA|MACsec Key Agreement |

### others in Application Layer and Internet Layer
|abbr.|description|
|-|-|
|DHCP|Dynamic Host Configuration Protocol |
|ICMP|Internet Control Message Protocol|
|IGMP|Internet Group Management Protocol|

