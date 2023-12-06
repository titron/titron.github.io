---
layout: post
title:  "AMBA APB AXI AXI-lite AHB ACE总线介绍"
categories: basic
tags: bus
author: David
---

* content
{:toc}

---

参考：

[AMBA总线架构](http://verificationexcellence.in/amba-bus-architecture/)


![AMBA bus version](https://github.com/titron/titron.github.io/raw/master/img/2020-12-07-AMBA_Bus_AMBAx.png)


![AXI vs APB](https://github.com/titron/titron.github.io/raw/master/img/2020-12-07-AMBA_Bus_AXI_vs_APB.png)




### AMBA ### 
Advanced Micro controller Bus Architecture 

ARM has open sourced all of the protocols and all the specifications can be downloaded from the ARM website free by signing up.

## APB ###
Advanced Peripheral Bus is used for connecting *low bandwidth peripherals* .

### AHB ###
Advanced High-performance Bus is used for connecting components that need *higher bandwidth* on a shared bus.

### AHB-lite ###
a simplified version of AHB

### AXI ###
Advanced Extensible interface is useful for *high bandwidth and low latency* interconnects.

### AXI-lite ###
a simplified version of AXI and the simplification comes in terms of *no support for burst data transfers*.

### AXI-stream ###
another flavor of the AXI protocol  that supports only *streaming* of data from a master to a slave. 

### ACE ###
AXI Coherence *extension* protocol is an extension to AXI 4 protocol and evolved in the era of multiple CPU cores with coherent caches getting integrated on a single chip.

### ACE-Lite ###
a simplified version of ACE protocol for those agents that does *not have a cache of its own* but still are part of the shareable coherency domain. 

### AXI ###
read and write data channels by introducing *separate snoop address, snoop data and snoop response channels*. 

### CHI ###
Coherent Hub Interface. The AMBA 5 revision introduced CHI protocol as *a complete re-design of the ACE protocol*. 

The best way to learn further is to read the specifications to understand details of each protocol. 

The APB and AHB are relatively easy and can be learned easily. 

AXI and ACE/CHI are relatively complex and will need detailed reading along with understanding of basics of cache coherency and general communication protocols.
