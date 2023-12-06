---
layout: post
title:  "git diff或者打patch时，清除掉这些多余的whitesapce"
categories: experience
tags: git patch whitespace Trailing-Spaces
author: David
---

* content
{:toc}

---

git diff或者打patch时，经常会碰到如下提示：
```bash
Applying: set EMMC_BOOT_P2=1 to boot from eMMC partition 2
.git/rebase-apply/patch:33: trailing whitespace.
NOTICE("eMMC boot from partition1...\n");
.git/rebase-apply/patch:39: trailing whitespace.
NOTICE("eMMC boot from partition2...\n");
.git/rebase-apply/patch:79: trailing whitespace.
NOTICE("eMMC boot from partition2 now...\n");
.git/rebase-apply/patch:85: trailing whitespace.
NOTICE("boot from hyperflash...\n");
```
出现上述现象的原因：存在大量的行尾空格 或者 换行后编译器智能添加的空行（没有写任何代码）

这时，可以在vscode中，安装如下扩展插件——**Trailing Spaces**：

![Extension - Trailing Spaces](https://github.com/titron/titron.github.io/raw/master/img/2022-06-22-vscode-trim-trailing-spaces-extensions.png)

然后，通过菜单进入**Settings**设置：
![Settings](https://github.com/titron/titron.github.io/raw/master/img/2022-06-22-vscode-trim-trailing-spaces-menu-settings.png)

可以设置如下：
![Settings-Remove and Trim](https://github.com/titron/titron.github.io/raw/master/img/2022-06-22-vscode-trim-trailing-spaces-settings.png)


参考：
[Remove trailing spaces automatically or with a shortcut](https://stackoverflow.com/questions/30884131/remove-trailing-spaces-automatically-or-with-a-shortcut)