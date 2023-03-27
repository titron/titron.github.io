---
layout: post
title:  "git 修改.gitignore后生效"
categories: software
tags: git, gitignore
author: David
---

* content
{:toc}

---

转自[git 修改.gitignore后生效](https://blog.csdn.net/mingjie1212/article/details/51689606)

```bash
git rm -r --cached .  #清除缓存
git add . #重新trace file
git commit -m "update .gitignore" #提交和注释
git push origin master #可选，如果需要同步到remote上的话
```
