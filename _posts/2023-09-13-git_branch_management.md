---
layout: post
title:  "大厂git分支管理规范（转）"
categories: software
tags: software, git
author: David
---

* content
{:toc}

---

参考：
1. [大厂git分支管理规范：规范指南](https://mp.weixin.qq.com/s/NWIKSF29emmRwJCseq1pyQ)


Git 的常用分支介绍

### 1 Production 分支

也就是我们经常使用的 Master 分支，这个分支最近发布到生产环境的代码，最近发布的
Release， 这个分支只能从其他分支合并，不能在这个分支直接修改。

### 2 Develop 分支

这个分支是我们是我们的主开发分支，包含所有要发布到下一个 Release 的代码，这个主要合
并与其他分支，比如 Feature 分支。

### 3 Feature 分支

这个分支主要是用来开发一个新的功能，一旦开发完成，我们合并回 Develop 分支进入下一个
Release。

### 4 Release分支

当你需要一个发布一个新 Release 的时候，我们基于 Develop 分支创建一个 Release 分支，完
成 Release 后，我们合并到 Master 和 Develop 分支。

### 5 Hotfix分支

当我们在 Production 发现新的 Bug 时候，我们需要创建一个 Hotfix, 完成 Hotfix 后，我们合
并回 Master 和 Develop 分支，所以 Hotfix 的改动会进入下一个 Release。


![all branches block](https://github.com/titron/titron.github.io/raw/master/img/2023-09-13-git_branches.png)