---
layout: post
title:  "ARM FIQ vs IRQ"
categories: basic
tags: ARM
author: David
---

* content
{:toc}

---

[原帖](https://stackoverflow.com/questions/973933/what-is-the-difference-between-fiq-and-irq-interrupt-system)

ARM calls FIQ the **fast interrupt**, with the implication that IRQ is normal priority. In any real system, there will be many more sources of interrupts than just two devices and there will therefore be some external hardware interrupt controller which allows masking, prioritization etc. of these multiple sources and which drives the interrupt request lines to the processor.

To some extent, this makes the distinction between the two interrupt modes redundant and many systems do not use nFIQ at all, or use it in a way analogous to the non-maskable (NMI) interrupt found on other processors (although FIQ is software maskable on most ARM processors).

### So why does ARM call FIQ "fast"?

1. FIQ mode has its own dedicated banked registers, r8-r14. R14 is the link register which holds the return address(+4) from the FIQ. But if your FIQ handler is able to be written such that it only uses r8-r13, it can take advantage of these banked registers in two ways:
* One is that it does not incur the overhead of pushing and popping any registers that are used by the interrupt service routine (ISR). This can save a significant number of cycles on both entry and exit to the ISR.
* Also, the handler can rely on values persisting in registers from one call to the next, so that for example r8 may be used as a pointer to a hardware device and the handler can rely on the same value being in r8 the next time it is called.
2. FIQ location at the end of the exception vector table (0x1C) means that if the FIQ handler code is placed directly at the end of the vector table, no branch is required - the code can execute directly from 0x1C. This saves a few cycles on entry to the ISR.
3. FIQ has higher priority than IRQ. This means that when the core takes an FIQ exception, it automatically masks out IRQs. An IRQ cannot interrupt the FIQ handler. The opposite is not true - the IRQ does not mask FIQs and so the FIQ handler (if used) can interrupt the IRQ. Additionally, if both IRQ and FIQ requests occur at the same time, the core will deal with the FIQ first.

### So why do many systems not use FIQ?

1. FIQ handler code typically cannot be written in C - it needs to be written directly in assembly language. If you care sufficiently about ISR performance to want to use FIQ, you probably wouldn't want to leave a few cycles on the table by coding in C in any case, but more importantly the C compiler will not produce code that follows the restriction on using only registers r8-r13. Code produced by a C compiler compliant with ARM's ATPCS procedure call standard will instead use registers r0-r3 for scratch values and will not produce the correct cpsr restoring return code at the end of the function.
2. All of the interrupt controller hardware is typically on the IRQ pin. Using FIQ only makes sense if you have a single highest priority interrupt source connected to the nFIQ input and many systems do not have a single permanently highest priority source. There is no value connecting multiple sources to the FIQ and then having software prioritize between them as this removes nearly all the advantages the FIQ has over IRQ.



FIQ or fast interrupt is often referred to as Soft DMA in some ARM references.
Features of the FIQ are,

1. Separate mode with banked register including stack, link register and R8-R12.
2. Separate FIQ enable/disable bit.
3. Tail of vector table (which is always in cache and mapped by MMU).
The last feature also gives a slight advantage over an IRQ which must branch.