---
layout: post
title:  "linux patch补丁文件格式说明"
categories: software
tags: linux, patch
author: David
---

* content
{:toc}

---


[linux patch 格式与说明（收录）](https://www.cnblogs.com/wuyuxin/p/7001320.html)


*.patch文件

```
diff -rBNu src.orig/java/org/apache/nutch/analysis/NutchAnalysisConstants.java src/java/org/apache/nutch/analysis/NutchAnalysisConstants.java
--- src.orig/java/org/apache/nutch/analysis/NutchAnalysisConstants.java 2009-03-10 11:34:01.000000000 -0700
+++ src/java/org/apache/nutch/analysis/NutchAnalysisConstants.java  2009-03-10 14:11:55.000000000 -0700
@@ -4,9 +4,12 @@

+  int CJK = 21;
+  int DIGIT = 22;

   int DEFAULT = 0;

   String[] tokenImage = {
     "<EOF>",
+    "\"OR\"",
     "<WORD>",
     "<ACRONYM>",
     "<SIGRAM>",
@@ -39,6 +42,8 @@
     "\"\\\"\"",
     "\":\"",
     "\"/\"",
+    "\"(\"",
+    "\")\"",
     "\".\"",
     "\"@\"",
     "\"\\\'\"",\
```


patch文件的结构
* --- vs +++

---开头表示旧文件，

+++开头表示新文件。

一个补丁文件中的多个补丁
一个补丁文件中可能包含以---/+++开头的很多节，每一节用来打一个补丁。所以在一个补丁文件中可以包含好多个补丁。

* @@

块是补丁中要修改的地方。它通常由一部分不用修改的东西开始和结束。他们只是用来表示要修改的位置。他们通常以@@开始，结束于另一个块的开始或者一个新的补丁头。

* /- vs +

块会缩进一列，而这一列是用来表示这一行是要增加还是要删除的。
块的第一列

+号表示这一行是要加上的。

-号表示这一行是要删除的。

没有加号也没有减号表示这里只是引用的而不需要修改。

* @@ -4,9 +4,12

@@ -4,9 +4,12 旧文件从4行开始，共9行；新文件从4行开始，共12行 无+—符号，是引用的内容