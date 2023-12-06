---
layout: post
title:  "USB控制器类型-OHCI/UHCI/EHCI/XHCI"
categories: basic
tags: USB
author: David
---

* content
{:toc}

---

参考：

[Host controller interface (USB, Firewire)](https://en.wikipedia.org/wiki/Host_controller_interface_(USB,_Firewire)#USB)

[几种USB控制器类型：OHCI，UHCI，EHCI，XHCI](http://smilejay.com/2012/10/usb_controller_xhci/)

OHCI、UHCI---都是USB1.1的接口标准，
EHCI---是对应USB2.0的接口标准，
xHCI---是USB3.0的接口标准。

* OHCI(Open Host Controller Interface)

是支持USB1.1的标准，但它不仅仅是针对USB，还支持其他的一些接口，比如它还支持Apple的火线（Firewire，IEEE 1394）接口。

与UHCI相比，OHCI的硬件复杂，硬件做的事情更多，所以实现对应的软件驱动的任务，就相对较简单。

主要用于非x86的USB，如扩展卡、嵌入式开发板的USB主控。

* UHCI(Universal Host Controller Interface)

是Intel主导的对USB1.0、1.1的接口标准，与OHCI不兼容。

UHCI的软件驱动的任务重，需要做得比较复杂，但可以使用较便宜、较简单的硬件的USB控制器。

Intel和VIA使用UHCI，而其余的硬件提供商使用OHCI。

* EHCI(Enhanced Host Controller Interface)

是Intel主导的USB2.0的接口标准。

EHCI仅提供USB2.0的高速功能，而依靠UHCI或OHCI来提供对全速（full-speed）或低速（low-speed）设备的支持。

* xHCI(eXtensible Host Controller Interface)

是最新最火的USB3.0的接口标准，它在速度、节能、虚拟化等方面都比前面3种有了较大的提高。

xHCI支持所有种类速度的USB设备（USB 3.0 SuperSpeed, USB 2.0 Low-, Full-, and High-speed, USB 1.1 Low- and Full-speed）。

xHCI的目的是为了替换前面3种（UHCI/OHCI/EHCI）。
