---
layout: post
title:  "git进阶-stash, reset --soft, cherry-pick, revert, reflog"
categories: software
tags: software, git
author: David
---

* content
{:toc}

---

参考：
1. [Git 不能只会 pull 和 push，学学这 5 条提高效率的命令，太炸裂了！](https://mp.weixin.qq.com/s/ws2ZqmY6wNgZbWVe8h9FAA)

### 1. stash
#### 描述：
官方解释：当您想记录工作目录和索引的当前状态，但又想返回一个干净的工作目录时，请使用git stash。该命令将保存本地修改，并恢复工作目录以匹配头部提交。

stash 命令能够将还未 commit 的代码存起来，让你的工作目录变得干净。

#### 应用场景
某一天你正在 feature 分支开发新需求，突然产品经理跑过来说线上有bug，必须马上修复。而此时你的功能开发到一半，于是你急忙想切到 master 分支。。。

#### 命令使用
```bash
# 保存当前未commit的代码
$ git stash 

# 当你修复完线上问题，切回 feature 分支，想恢复代码时
$ git stash apply 
```

相关命令
```bash

# 保存当前未commit的代码  
$ git stash  
  
# 保存当前未commit的代码并添加备注  
$ git stash save "备注的内容"  
  
# 列出stash的所有记录  
$ git stash list  
  
# 删除stash的所有记录  
$ git stash clear  
  
# 应用最近一次的stash  
$ git stash apply  
  
# 应用最近一次的stash，随后删除该记录  
$ git stash pop  
  
# 删除最近的一次stash  
$ git stash drop  

```

### 2. reset --soft
#### 描述：
回退你已提交的 commit，并将 commit 的修改内容放回到暂存区。

一般我们在使用 reset 命令时，git reset --hard会被提及的比较多，它能让 commit 记录强制回溯到某一个节点。

而git reset --soft的作用正如其名，--soft(柔软的) 除了回溯节点外，还会保留节点的修改内容。

#### 应用场景
应用场景1：有时候手滑不小心把不该提交的内容 commit 了，这时想改回来，只能再 commit 一次，又多一条“黑历史”。

应用场景2：规范些的团队，一般对于 commit 的内容要求职责明确，颗粒度要细，便于后续出现问题排查。本来属于两块不同功能的修改，一起 commit 上去，这种就属于不规范。这次恰好又手滑了，一次性 commit 上去。

#### 命令使用
```bash
# 恢复最近一次 commit  
$ git reset --soft HEAD^
```

reset --soft相当于后悔药，给你重新改过的机会。对于上面的场景，就可以再次修改重新提交，保持干净的 commit 记录。

以上说的是还未 push 的commit。对于已经 push 的 commit，也可以使用该命令，不过再次 push 时，由于远程分支和本地分支有差异，需要强制推送git push -f来覆盖被 reset 的 commit。

还有一点需要注意，在reset --soft指定 commit 号时，会将该 commit 到最近一次 commit 的所有修改内容全部恢复，而不是只针对该 commit。


### 3. cherry-pick
#### 描述：
将已经提交的 commit，复制出新的 commit 应用到分支里。

#### 应用场景
应用场景1：有时候版本的一些优化需求开发到一半，可能其中某一个开发完的需求要临时上，或者某些原因导致待开发的需求卡住了已开发完成的需求上线。这时候就需要把 commit 抽出来，单独处理。

应用场景2：有时候开发分支中的代码记录被污染了，导致开发分支合到线上分支有问题，这时就需要拉一条干净的开发分支，再从旧的开发分支中，把 commit 复制到新分支。

#### 命令使用
#### 【1】 复制单个
现在有一条feature分支，commit 记录如下：
```bash
commit a51cfd09f6f346a2b55226ba8a3aca53f35b9919 (HEAD -> support_ar0231_camera_moudle)
Author: tiezhuangdong <tiezhuang.dong.yh@renesas.com>
Date:   Mon Aug 7 13:20:38 2023 +0800

    add ar0231 init ----------- c

commit 3c613c4c9cf84a2c25f698c49a5750599bf7e7be
Author: tiezhuangdong <tiezhuang.dong.yh@renesas.com>
Date:   Thu Jul 27 11:14:36 2023 +0800

    only display camera link0 ----------- b

commit 1849850ea14dd31605f726418601492206822587 (tag: RECN_220629, origin/main, origin/HEAD, main)
Author: Tiezhuang Dong <tiezhuang.dong.yh@renesas.com>
Date:   Thu May 12 02:56:06 2022 +0000

    Add fatfs app for cr7 solution ----------- a

    Signed-off-by: tiezhuangdong <tiezhuang.dong.yh@renesas.com>
```
需要把 b 复制到另一个分支，首先把 commitHash 复制下来，然后切到 main 分支。使用cherry-pick把 b 应用到当前分支。
```bash
$ git switch main
Switched to branch 'main'
Your branch is up to date with 'origin/main'.

$ git log
commit 1849850ea14dd31605f726418601492206822587 (HEAD -> main, tag: RECN_220629, origin/main, origin/HEAD)
Author: Tiezhuang Dong <tiezhuang.dong.yh@renesas.com>
Date:   Thu May 12 02:56:06 2022 +0000

    Add fatfs app for cr7 solution

    Signed-off-by: tiezhuangdong <tiezhuang.dong.yh@renesas.com>


$ git cherry-pick 3c613c4c9cf84a2c25f698c49a5750599bf7e7be

```

#### 【2】 复制多个
以上是单个 commit 的复制，下面再来看看 cherry-pick 多个 commit 要如何操作。

* 一次转移多个提交：
```bash
$ git cherry-pick commit1 commit2  
```

* 多个连续的commit，也可区间复制：
```bash
$ git cherry-pick commit1^..commit2  
```

#### 【3】 解决冲突
```bash
# 如果cherry-pick 提示 发生冲突
$ git cherry-pick commit1 

# 解决冲突，重新提交到暂存区。

# 让cherry-pick继续进行下去
cherry-pick --continue
```
#### 【4】 其他cherry-pick命令
```bash
# 放弃 cherry-pick --- 回到操作前的样子，就像什么都没发生过。
$ git cherry-pick --abort

# 退出 cherry-pick --- 不回到操作前的样子。即保留已经cherry-pick成功的 commit，并退出cherry-pick流程。
$ git cherry-pick --quit 
```

### 4. revert
#### 描述：
将现有的提交还原，恢复提交的内容，并生成一条还原记录。

#### 应用场景
有一天测试突然跟你说，你开发上线的功能有问题，需要马上撤回，否则会影响到系统使用。这时可能会想到用 reset 回退，可是你看了看分支上最新的提交还有其他同事的代码，用 reset 会把这部分代码也撤回了。由于情况紧急，又想不到好方法，还是任性的使用 reset，然后再让同事把他的代码合一遍（同事听到想打人），于是你的技术形象在同事眼里一落千丈。

#### 命令使用
#### 【1】 revert 普通提交
```bash
commit a51cfd09f6f346a2b55226ba8a3aca53f35b9919 (HEAD -> support_ar0231_camera_moudle)
Author: tiezhuangdong <tiezhuang.dong.yh@renesas.com>
Date:   Mon Aug 7 13:20:38 2023 +0800

    add ar0231 init ----------- 同事的提交

commit 3c613c4c9cf84a2c25f698c49a5750599bf7e7be
Author: tiezhuangdong <tiezhuang.dong.yh@renesas.com>
Date:   Thu Jul 27 11:14:36 2023 +0800

    only display camera link0 ----------- 自己的提交

commit 1849850ea14dd31605f726418601492206822587 (tag: RECN_220629, origin/main, origin/HEAD, main)
Author: Tiezhuang Dong <tiezhuang.dong.yh@renesas.com>
Date:   Thu May 12 02:56:06 2022 +0000

    Add fatfs app for cr7 solution ----------- a

    Signed-off-by: tiezhuangdong <tiezhuang.dong.yh@renesas.com>


# revert掉自己提交的commit
# 因为 revert 会生成一条新的提交记录，这时会让你编辑提交信息，编辑完后 :wq 保存退出就好了。
git revert 3c613c4c9cf84a2c25f698c49a5750599bf7e7be

# 看下最新的 log，生成了一条 revert 记录，虽然自己之前的提交记录还是会保留着，但你修改的代码内容已经被撤回了。
```

#### 【2】 revert 合并提交
还是上面的log信息
```bash

# revert掉自己提交的commit
$ git revert 3c613c4c9cf84a2c25f698c49a5750599bf7e7be
# revert掉同事的提交
# 使用刚刚同样的 revert 方法，会发现命令行报错了。
# 通常无法 revert 合并，因为您不知道合并的哪一侧应被视为主线。此选项指定主线的父编号（从1开始），并允许 revert 反转相对于指定父编号的更改
$ git revert a51cfd09f6f346a2b55226ba8a3aca53f35b9919

# -m 后面要跟一个 parent number 标识出"主线"，一般使用 1 保留主分支代码。
$ git revert -m 1 <commitHash> 
```

revert 合并提交后，再次合并分支会失效

还是上面的场景，在 master 分支 revert 合并提交后，然后切到 feature 分支修复好 bug，再合并到 master 分支时，会发现之前被 revert 的修改内容没有重新合并进来。

因为使用 revert 后， feature 分支的 commit 还是会保留在 master 分支的记录中，当你再次合并进去时，git 判断有相同的 commitHash，就忽略了相关 commit 修改的内容。

这时就需要 revert 掉之前 revert 的合并提交，有点拗口，接下来看操作吧。

再次使用 revert，之前被 revert 的修改内容就又回来了。

### 5. reflog
#### 描述：

此命令管理重录中记录的信息。

如果说reset --soft是后悔药，那 reflog 就是强力后悔药。它记录了所有的 commit 操作记录，便于错误操作后找回记录。
#### 应用场景

某天你眼花，发现自己在其他人分支提交了代码还推到远程分支，这时因为分支只有你的最新提交，就想着使用reset --hard，结果紧张不小心记错了 commitHash，reset 过头，把同事的 commit 搞没了。

没办法，reset --hard是强制回退的，找不到 commitHash 了，只能让同事从本地分支再推一次（同事瞬间拳头就硬了，怎么又是你）。于是，你的技术形象又一落千丈。

#### 命令使用
```bash
commit 8631553fbd0c8c3dfd321a9e1e927377d6c218d6 (HEAD -> master) 
Author: ChanWahFung <552095989@qq.com>
Date: Sat Mar 5 21:10:56 2022 +0800 

    update（c）：自己的错误提交

commit 1fc4ea10756198d4bc464a32b23b9cd1d091dd5b 
Author: ChanWahFung <552095989@qq.com>
Date: Sat Mar 5 10:26:46 2022 +0800 

    update(b): b

commit 1a900ac29eba73ce817bf959f82ffcbøbfa38f75 
Author: ChanWahFung <552095989@qq.com>
Date: Fri Mar 4 00:17:53 2022 +0800

    update(a): a
```

分支记录如上，想要 reset 到 b。

误操作 reset 过头，b 没了，最新的只剩下 a。
```bash
# 这时用git reflog查看历史记录，把错误提交的那次 commitHash 记下。
$ git reflog
la900ac (HEAD -> Master) HEAD@{0}: reset:moving to 1a900ac29eba73ce81
8631553 HEAD@{1}: commit：update（c）：自己的错误提交
```

```bash
# 再次 reset 回去，就会发现 b 回来了。
$ git reset --hard 8631553
HEAD is now at 8631553 update（c）：自己的错误提交 

$ git 1og
commit 8631553fbdøc8c3dfd321a9e1e927377d6c218d6 (HEAD ->master) 
Author: ChanWahFung<552095989@qq.com> 
Date: Sat Mar 5 21:10:56 2022 +0800 

    update（c）：自己的错误提交

commit 1fc4ea10756198d4bc464a32b23b9cd1d091dd5b 
Author:ChanWahFung<552095989@qq.com>
Date: Sat Mar 5 10:26:46 2022 +0800 

    update(b):b

commit 1a900ac29eba73ce817bf959f82ffcbobfa38f75 
Author:ChanWahFung <552095989@qq.com>
Date: Fri Mar 4 00:17:53 2022 +0800 
    
    update(a):a
```
### 总结
5个在开发中实用的 Git 命令：

* <font color=red>stash：</font>存储临时代码。
* <font color=red>reset --soft：</font>软回溯，回退 commit 的同时保留修改内容。
* <font color=red>cherry-pick：</font>复制 commit。
* <font color=red>revert：</font>撤销 commit 的修改内容。
* <font color=red>reflog：</font>记录了 commit 的历史操作。