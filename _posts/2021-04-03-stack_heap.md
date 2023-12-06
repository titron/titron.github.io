---
layout: post
title:  "堆是堆，栈是栈"
categories: basic
tags: stack heap
author: David
---

* content
{:toc}

---

[关于堆栈的讲解(我见过的最经典的)](https://www.eet-china.com/mp/a44614.html?utm_source=EETC%20Forum%20Alert&utm_medium=Email&utm_campaign=2021-04-02)

```c
// 一位工程师写的示例代码
// 向这位工程师致敬！
//
int a = 0; //全局初始化区
int a = 0; //全局初始化区
char *p1; //全局未初始化区
main() {
    int b; //栈
    char s[] = "abc"; //栈
    char *p2; //栈
    char *p3 = "123456"; //123456\0在常量区，p3在栈上。
    static int c = 0; //全局（静态）初始化区
    p1 = (char *)malloc(10);
    p2 = (char *)malloc(20);
    //分配得来得10和20字节的区域就在堆区。
    strcpy(p1, "123456"); //123456\0放在常量区，编译器可能会将它与p3所指向的"123456"优化成一个地方。
}
```

