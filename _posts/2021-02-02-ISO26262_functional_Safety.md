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

### 功能安全缩写词列表

| 缩写词 | 全称 |
|-|-|
| DFA | Dependent Failure Analysis（依赖失效分析）|
| DIA | Development Interface Agreement（开发接口协议） |
| DIR | Development Interface Report（开发接口报告） |
| ECC | Error Correction Code（错误校正编码）|
| FMEA | Failure Mode and Effects Analysis（失效模式与效果分析）|
| FMEDA | Failure Modes Effects and Diagnostics Analysis（失效模式效果与诊断分析）|
| FSA | Functional Safety Assessment Report（功能安全评估报告） |
| FTTI | Fault Tolerant Time Interval（容错间隔）|
| FTA | Fault Tree Analysis（错误树分析）|
| HE | Hard Error（硬件错误）|
| LFM | Latent Fault Metric（潜在故障矩阵） |
| MPF,D | Multiple-Point Fault detected（多点故障） |
| MPF,L | Multiple-Point Fault latent（潜伏多点故障） |
| MPF,P | Multiple-Point Fault perceived（可感知的多点故障） |
| NSR | Non Safety Related（非安全相关） |
| PMHF | Probabilistic Metric For Random Hardware Faults（随机硬件故障的概率度量） |
| RF | Residual Fault（残余故障） |
| SAN | Safety Application Note（安全应用说明） |
| SC | Safety Case Summary（安全案例摘要） |
| SE | Soft Error（软件错误）|
| SEooC | Safety Element out of Context（脱离上下文的安全元素） |
| SPF | Single-Point Fault（单点故障） |
| SPFM | Single Point Fault Metric（单点故障矩阵） |
| SRS | Safety Requirement Specification（安全要求规范） |








