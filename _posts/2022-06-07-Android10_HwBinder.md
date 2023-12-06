---
layout: post
title:  "Android10.0 HwBinder（转）"
categories: basic
tags: android HwBinder
author: David
---

* content
{:toc}

---

### Binder通信原理
1. [Android10.0 Binder通信原理(一)Binder、HwBinder、VndBinder概要](https://blog.csdn.net/yiranfeng/article/details/105175578#:~:text=%E6%80%BB%E7%BB%93)
2. [Android10.0 Binder通信原理(二)-Binder入门篇](https://blog.csdn.net/yiranfeng/article/details/105181297)
3. [Android10.0 Binder通信原理(三)-ServiceManager篇](https://blog.csdn.net/yiranfeng/article/details/105210069)
4. [Android10.0 Binder通信原理(四)-Native-C\C++实例分析](https://blog.csdn.net/yiranfeng/article/details/105210611)
5. [Android10.0 Binder通信原理(五)-Binder驱动分析](https://blog.csdn.net/yiranfeng/article/details/105232709)
6. [Android10.0 Binder通信原理(六)-Binder数据如何完成定向打击](https://blog.csdn.net/yiranfeng/article/details/105233936)
7. [Android10.0 Binder通信原理(七)-Framework binder示例](https://blog.csdn.net/yiranfeng/article/details/105313042)
9. [Android10.0 Binder通信原理(八)-Framework层分析](https://blog.csdn.net/yiranfeng/article/details/105313236)
10. [Android10.0 Binder通信原理(九)-AIDL Binder示例](https://blog.csdn.net/yiranfeng/article/details/105313562)
11. [Android10.0 Binder通信原理(十)-AIDL原理分析-Proxy-Stub设计模式](https://blog.csdn.net/yiranfeng/article/details/105314318)
12. [Android10.0 Binder通信原理(十一)-Binder总结](https://blog.csdn.net/yiranfeng/article/details/105314445)

### HwBinder 参考:
1. [HwBinder入门篇-Android10.0 HwBinder通信原理(一)](https://blog.csdn.net/yiranfeng/article/details/107751217)
2. [HIDL详解-Android10.0 HwBinder通信原理(二)](https://blog.csdn.net/yiranfeng/article/details/107824605)
3. [HIDL示例-C++服务创建Client验证-Android10.0 HwBinder通信原理(三)](https://blog.csdn.net/yiranfeng/article/details/107899185)
4. [HIDL示例-JAVA服务创建-Client验证-Android10.0 HwBinder通信原理(四)](https://blog.csdn.net/yiranfeng/article/details/107899517)
5. [HwServiceManager篇-Android10.0 HwBinder通信原理(五)](https://blog.csdn.net/yiranfeng/article/details/107922919#:~:text=HwServic,nit%E8%BF%9B%E7%A8%8B%E5%90%AF%E5%8A%A8%E3%80%82)
6. [Native层HIDL服务的注册原理-Android10.0 HwBinder通信原理(六)](https://blog.csdn.net/yiranfeng/article/details/107966454)
7. [Native层HIDL服务的获取原理-Android10.0 HwBinder通信原理(七)](https://blog.csdn.net/yiranfeng/article/details/108037473)
8. [JAVA层HIDL服务的注册原理-Android10.0 HwBinder通信原理(八)](https://blog.csdn.net/yiranfeng/article/details/108037698)
9. [JAVA层HIDL服务的获取原理-Android10.0 HwBinder通信原理（九）](https://blog.csdn.net/yiranfeng/article/details/108038035)
10. [HwBinder驱动篇-Android10.0 HwBinder通信原理(十)](https://blog.csdn.net/yiranfeng/article/details/108038530)
11. [HwBinder原理总结-Android10.0 HwBinder通信原理(十一)](https://blog.csdn.net/yiranfeng/article/details/108038530)