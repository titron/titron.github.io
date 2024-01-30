---
layout: post
title:  "Cortex-R52 enable ATCM BTCM CTCM"
categories: basic
tags: ARM, Cortex-R52, ATCM, BTCM, CTCM
author: David
---

* content
{:toc}

---

### （1）define address of ATCM, BTCM, CTCM
```c
#define ___asm(c)                __asm_(c)
#define __asm_(c)                __asm(#c);
#define __as1(c, d)              __as1_(c, d)
#define __as1_(c, d)             __asm( #c " , " #d);
#define __as2(c, d, e)           __as2_(c, d, e)
#define __as2_(c, d, e)          __asm( #c " , " #d " , " #e);
#define __as3(c, d, e, f)        __as3_(c, d, e, f)
#define __as3_(c, d, e, f)       __asm( #c " , " #d " , " #e " , " #f);
#define __as4(c, d, e, f, g)     __as4_(c, d, e, f, g)
#define __as4_(c, d, e, f, g)    __asm( #c " , " #d " , " #e " , " #f  " , " #g);
#define __as5(c, d, e, f, g, h)  __as5_(c, d, e, f, g, h)
#define __as5_(c, d, e, f, g, h) __asm( #c " , " #d " , " #e " , " #f  " , " #g " , " #h);
```
### （2）define address of ATCM, BTCM, CTCM
```c
### file:Include\ARMStartup_Platform.h
const uint32 brsTcmBase[BRS_CPU_CORE_AMOUNT][NUM_TCM_PER_CORE] = {					
  {					
    0xE4000018,  /* CLUSTER0_CORE0_TCMA */					
    0xE4100018,  /* CLUSTER0_CORE0_TCMB */					
    0xE4200018}, /* CLUSTER0_CORE0_TCMC */	
    ...				
  }
}
```

### （3）EL2, EL1 Vector
```c
/* file:ARMStartup_CortexR52.c
 */

/* EL2 Vector */
BRS_GLOBAL(EL2_VectorTable)
BRS_LABEL(EL2_VectorTable)  /* Temporary Interrupt Vector Table */
___asm(B _start)
___asm(B EL2_Unhandled_Handler)
...

/* EL1 Vector */
BRS_GLOBAL(EL1_VectorTable)
BRS_LABEL(EL1_VectorTable)  /* Temporary Interrupt Vector Table */
___asm(B brsStartupEntry)
___asm(B EL1_Unhandled_Handler)
...


/* EL2 Entry */
BRS_GLOBAL(_start)
...
__as1(MOV r0,  #0)
__as1(MOV r1,  #0)
...
__as1(LDR r0, =EL1_VectorTable)     /* Set EL1 vector table */
__as5(MCR p15, #0, r0, c12, c0, #0) /* Write to VBAR */
__as1(LDR r0, =EL1_VectorTable)     /* Load entry label */
__as2(ORR r0, r0, #1)
__as1(MSR ELR_hyp, r0)              /* Set the link register */
___asm(DSB)
___asm(ISB)
___asm(ERET)                        /* Trigger EL1 level */
...

/* EL1 Entry */
BRS_SECTION_CODE(brsStartup)
...
 BRS_GLOBAL(brsFirstCoreInit)
...
 BRS_BRANCH(brsInitialMPUconfig)
...
#if (MPU_TCM_REGION == STD_ON)
/* Configure MPU region 12 for TCM */
__as1(LDR r0, =MPU_TCM_REGION_START)
__as1(LDR r1, =0x02)                /* Non-Shareable, RW, Execute */
__as2(ORR r0, r0, r1)
__as5(MCR p15, #0, r0, c6, c14, #0) /* Write MPU base address register */
___asm(ISB)
__as1(LDR r0, =MPU_TCM_REGION_END)  /* Set the limit address */
__as2(BFC r0, #0, #6)               /* Align the limit address to 64 bytes */
__as1(LDR r1, =0x09)                /* Attr4 of MAIR1, EN */
__as2(ORR r0, r0, r1)
__as5(MCR p15, #0, r0, c6, c14, #1) /* Write MPU limit address register */
___asm(ISB)
#endif
...
 BRS_BRANCH(coreRegisterInit)
...
 BRS_BRANCH(coreRegisterInit2)

```


### （4）Config ATCM, BTCM, CTCM
```c
/* file:ARMStartup_CortexR52.c */
							
/* Enable Tightly Coupled Memory */							
#if (BRS_ENABLE_TCM == STD_ON)							
BRS_READ_COREID(r0)							
__as1(MOV  r1, #NUM_TCM_PER_CORE)							
__as2(MUL r1, r0, r1)							
__as2(LSL r1, r1, #2)							
__as1(LDR r2, =brsTcmBase)							
__as1(ADD r2, r1)							
__as1(LDR r1, [r2])                 /* Load corresponding base address */
__as2(ORR r1, r1, #1)               /* Enable TCMA */
__as5(MCR p15, #0, r1, c9, c1, #0)  /* Write TCMA Region Register */

__as2(LDR r1, [r2, #4])							
__as2(ORR r1, r1, #1)               /* Enable TCMB */
__as5(MCR p15, #0, r1, c9, c1, #1)  /* Write TCMB Region Register */

__as2(LDR r1, [r2, #8])							
__as2(ORR r1, r1, #1)               /* Enable TCMC */
__as5(MCR p15, #0, r1, c9, c1, #2)  /* Write TCMC Region Register */
#endif /*BRS_ENABLE_TCM*/							
```