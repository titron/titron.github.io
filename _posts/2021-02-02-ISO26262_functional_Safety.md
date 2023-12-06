---
layout: post
title:  "功能安全Functional Safety/ISO 26262"
categories: basic
tags: FuSa ISO 26262
author: David
---

* content
{:toc}

---

### 功能安全生命周期（lifecycle）三阶段

功能安全，贯穿从设计前/设计中/设计后三个阶段。

![功能安全lifecycle](https://github.com/titron/titron.github.io/raw/master/img/2021-02-02-FS_lifecycle.png)


### 功能安全分级（ISO26262 vs IEC61508）

可以看到，在SIL2/ASIL B-C，最多会有一人死亡。
![功能安全分级](https://github.com/titron/titron.github.io/raw/master/img/2021-02-02-FS_Integrity_Level.png)


### MCU vs Functional Safety

可以看到，设计MCU/CPU，要想加入功能安全属性，像memory，bus，clock，voltage,peripherals这些地方，需要很多工作要做的，如memory中的ECC/Parity校验，均是功能安全要求的。
![MCU设计中Fault vs 功能安全](https://github.com/titron/titron.github.io/raw/master/img/2021-02-02-FS_MCU_Fault_functional_safety.png)


### 功能安全V形结构

可以看到，从设计目标，设计实现，到结果验证，呈现出一个V形架构。
![功能安全设计V形结构](https://github.com/titron/titron.github.io/raw/master/img/2021-02-02-FS_V_shape.png)







