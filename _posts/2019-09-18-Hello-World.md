---
layout: post
title:  "简单描述用github构建自己的博客（blog）过程"
categories: test
tags: blog github markdown
author: David
---

* content
{:toc}


第一步 找一个自己喜欢的github blog库，然后fork到自己的git仓库

详细情况，请参考[博客搭建详细教程](https://github.com/qiubaiying/qiubaiying.github.io/wiki/%E5%8D%9A%E5%AE%A2%E6%90%AD%E5%BB%BA%E8%AF%A6%E7%BB%86%E6%95%99%E7%A8%8B)

第二步 更改仓库名字为自己喜欢的

如：xxx.github.io

第三步 更改以下文件内容符合自己

[这里有Jekyll相关文件夹和文件的内容描述](http://jekyllcn.com/docs/structure/)

挑几个主要的更改

| 文件名 | 描述 | 文件夹 |
|----|----|----|
| _config.yml | 配置数据 | 根目录 |
| index.html | 首页 | 根目录 |
| about.md | 关于 | \page |
| *.md | blog文章 | \_posts |

第四步 删除不属于自己的blog

位于目录 \_posts 下。
      
第五步 编写自己的blog（markdown ".md"）文件，位于目录 \_posts 下。

文件命名有一定规则，如：2019-09-18-blog标题.md
         
第六步 查看（https://(自己的github.io)），修正不符合自己期望的地方