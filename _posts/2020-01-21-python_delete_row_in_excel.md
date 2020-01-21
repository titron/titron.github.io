---
layout: post
title:  "python删除Excel中不符合条件的行"
categories: software
tags: Python Excel xlrd xlwt
author: David
---

* content
{:toc}


Excel文件格式：xls或xlsx

检查的文件：a.xlsx

删除行后生成的新文件名：anew.xls

删除条件：第二列中值不是“OK”

删除行：不符合条件的所有行



code：

```python
#!/usr/bin/env python
#-*- coding: utf-8 -*-
import xlrd
import xlwt

file = 'a.xlsx'
data = xlrd.open_workbook(file)
table = data.sheets()[0]
nrows = table.nrows
ncols = table.ncols
print(nrows, ncols)
workbook = xlwt.Workbook(encoding='utf-8')
news_sheet = workbook.add_sheet('news')
rank_list = []
for i in range(0, nrows):
    if not table.cell(i, 1).value == 'OK':
        print(i)
    else:
        rank_list.append(i)
print(rank_list)

for i in range(len(rank_list)):
    news_sheet.write(i, 0, table.row_values(int(rank_list[i]))[0])
    news_sheet.write(i, 1, table.row_values(int(rank_list[i]))[1])
workbook.save('anew.xls')
```
