---
layout: post
title:  "Android 中Ninja 简介"
categories: basic
tags: android, ninja
author: David
---

* content
{:toc}

---

参考：
1. [（转）Android中Ninja简介](https://blog.csdn.net/shift_wwx/article/details/84770716?utm_medium=distribute.pc_relevant.none-task-blog-2~default~baidujs_baidulandingword~default-0-84770716-blog-125856258.235^v43^pc_blog_bottom_relevance_base4&spm=1001.2101.3001.4242.1&utm_relevant_index=3)
2. [Ninja, a small build system with a focus on speed](https://ninja-build.org/)
3. [GitHub - ninja-build/ninja: a small build system with a focus on speed](https://github.com/ninja-build/ninja)
4. [理解 Android Build 系统](https://blog.csdn.net/jingerppp/article/details/84749685)
5. [Android中Kati简介](https://blog.csdn.net/jingerppp/article/details/84784567)
6. [Android中的Android.bp、Blueprint 和Soong简介](https://blog.csdn.net/jingerppp/article/details/84790429)

最开始，Ninja 是用于Chromium 浏览器中，Android 在SDK 7.0 中也引入了Ninja。
Ninja 其实就是一个编译系统，如同make ，使用Ninja 主要目的就是因为其编译速度快。
Ninja 除了用于Chromium browser 和Android，也用于LLVM 和依赖CMake的Ninja 后端项目。

## 1. Ninja 简介
Ninja 主要是一个注重**速度**的小型编译系统，主要有两个有别与其他编译系统的特点：

* input files是由高级别的编译系统生成而来；
* 让编译尽可能的fast；

如果把其他的编译系统看作是“高级语言”(例如C 语言)，那么Ninja 目标就是使自己成为“汇编语言”。

Ninja 包含描述任意依赖关系的最基本的功能。由于语法简单而无法表达复杂的决策。为此，Ninja 用一个单独的程序来生成input files。该程序(如autotools 项目中的./configure) 能分析系统的依赖关系，而且尽可能提前多做出策略，以便增加编译速度。

### 1.1 设计目标
下面是Ninja 设计的目标：
* 编译特别快，甚至是一个非常大型的项目；
* 关于如何编译代码的策略特别少。高级别的编译系统会有不同的策略。例如，编译后的目标文件是与源文件一个目录，还是用单独的目录来存放这些目标文件？是否有个“package” 规则来构建项目的分配分包？而对于Ninja，即使会出现更多的冗长，也会避免这些决策。
* 一些用Makefiles  难以获取到的依赖关系，Ninja 可以正确获取；
* 当便利和速度产生冲突的时候，Ninja 选择速度；

其中总结出来两句话：
* Ninja 优先选择速度，即使编译策略有更便利的方式；
* Ninja 用冗长的代码避免复杂的策略机制，这也是为了方便快速编译；

### 1.2 明确的非目标
* 手动编写构建文件的便捷语法。 应该使用另一个程序生成 ninja 文件。 
* 内置规则。 Ninja 没有开箱即用的规则，例如： 编译C代码。
* 构建的构建时定制。 选项属于生成 ninja 文件的程序。
* 构建时决策能力，例如条件或搜索路径。 做决定的速度很慢。

## 2. Makefile 与 Ninja
Makefile默认文件名为Makefile或makefile，也常用.make或.mk作为文件后缀。执行Makefile的程序，默认是 GNU make，也有一些其它的实现。在Android项目中，make需要编译主机上安装，作为环境的一部分。 

Ninja 的默认文件名是build.ninja，其它文件也以.ninja为后缀。Ninja 的执行程序，就是ninja命令。而ninja 命令则是Android平台代码自带。
```bash
$ find prebuilts/ -name ninja
prebuilts/build-tools/linux-x86/asan/bin/ninja
prebuilts/build-tools/linux-x86/bin/ninja
prebuilts/build-tools/darwin-x86/bin/ninja
```
## 3. Ninja 命令
```bash
$ ninja -h
usage: ninja [options] [targets...]
 
if targets are unspecified, builds the 'default' target (see manual).
 
options:
  --version  print ninja version ("1.7.2")
 
  -C DIR   change to DIR before doing anything else
  -f FILE  specify input build file [default=build.ninja]
 
  -j N     run N jobs in parallel [default=6, derived from CPUs available]
  -k N     keep going until N jobs fail [default=1]
  -l N     do not start new jobs if the load average is greater than N
  -n       dry run (don't run commands but act like they succeeded)
  -v       show all command lines while building
  -d MODE  enable debugging (use -d list to list modes)
  -t TOOL  run a subtool (use -t list to list subtools)
    terminates toplevel options; further flags are passed to the tool
  -w FLAG  adjust warnings (use -w list to list warnings)
```
很多参数，和make是比较类似的，比如-f、-j等，不再赘述。 有趣的是-t、-d、-w这三个参数，最有用的是-t。

```bash
$ ninja -t list
ninja subtools:
    browse  browse dependency graph in a web browser
     clean  clean built files
  commands  list all commands required to rebuild given targets
      deps  show dependencies stored in the deps log
     graph  output graphviz dot file for targets
     query  show inputs/outputs for a path
   targets  list targets by their rule or depth in the DAG
    compdb  dump JSON compilation database to stdout
 recompact  recompacts ninja-internal data structures
```
ninja -t clean是清理产物，是自带的，而make clean往往需要自己实现。 其它都是查看编译过程信息的工具，各有作用，可以进行复杂的编译依赖分析。

## 4. Android 中ninja 文件
从Android 7开始，编译时默认使用 Ninja。 但是，Android项目里是没有 .ninja 文件的。 遵循Ninja的设计哲学，编译时，会先把Makefile通过 kati 转换成 .ninja文件，然后使用 ninja 命令进行编译。 这些 .ninja 文件，都产生在 out/ 目录下，共有三类。

### 4.1 build-*.ninja 文件
通常非常大，几十到几百MB。 对 make 全编译，命名是 build-<product_name>.ninja。 如果Makefile发生修改，需要重新产生Ninja文件。

这里 Android 有一个 bug，或者说设计失误。 mm、mma 的Ninja文件，命名是build-<product_name>-<path_to_Android.mk>.ninja。 而 mmm、mmma 的Ninja文件，命名是build-<product_name>-_<path_to_Android.mk>.ninja。 显然，不同的单模块编译，产生的也是不同的Ninja文件。

这个设计本身就有一些问题了，为什么不同模块不能共用一个总的Ninja文件？ 这大概还是为了兼容旧的 Makefile 设计。 在某些 Android.mk 中，单模块编译与全编译时，编译内容截然不同。 如果说这还只能算是设计失误的话，那么 mm 与 mmm 使用不同的编译文件，就是显然的 bug了。 二者相差一个下划线_，通过mv或cp，可以通用。

### 4.2 combined-*.ninja 文件
在使用了Soong 后，除了 build-*.ninja之外，还会产生对应的 combined-*.ninja，二者的*内容相同。 以下以 AOSP 的 aosp_arm64-eng 为例，展示 out/combined-aosp_arm64.ninja文件的内容。

```bash
builddir = out
include out/build-aosp_arm64.ninja
include out/soong/build.ninja
build out/combined-aosp_arm64.ninja: phony out/soong/build.ninja
```
这类是组合文件，是把 build-*.ninja 和 out/soong/build.ninja 组合起来。 所以，使用Soong后，combined-*.ninja 是编译执行的真正入口。

4.3 out/soong/build.ninja 文件
它是从所有的Android.bp 转换过来的。

build-*.ninja 是从所有的 Makefile，用 Kati 转换过来的，包括 build/core/*.mk 和所有的Android.mk。 所以，在不使用Soong时，它是唯一入口。 在使用了 Soong 以后，会新增源于Android.bp的 out/soong/build.ninja，所以需要 combined-*.ninja 来组合一下。

可以通过以下命令，单独产生全编译的Ninja文件。
```bash
make nothing
```
文件组织如下图所示：（其中的aosp_arm为<product_name>）
![ninja file](https://github.com/titron/titron.github.io/raw/master/img/2024-03-26-ninja_fig_1.png)

## 5. 用Ninja 编译
在产生全编译的Ninja文件后，可以绕过Makefile，单独使用 ninja 进行编译。

全编译（7.0版本），相当于make：
```bash
ninja -f out/build-aosp_arm64.ninja
```

单独编译模块，比如Settings，相当于make Settings：
```bash
ninja -f out/build-aosp_arm64.ninja Settings
```
在8.0以上，上面的文件应该替换为out/combined-aosp_arm64.ninja，否则可能找不到某些Target。

另外，还有办法不用输入-f参数。 如前所述，如同Makefile之于make，ninja默认的编译文件是build.ninja。 所以，使用软链接，可以避免每次输入繁琐的-f。
```bash
ln -s out/combined-aosp_arm64.ninja build.ninja
ninja Settings
```
用ninja进行单模块编译的好处，除了更快以外，还不用生成单模块的Ninja文件，省了四五分钟。

## 9. 总结
在以Ninja在实际编译中替换 Makefile 以后，Android在编译时更快了一些。 不过，在首次生成、或重新生成Ninja文件时，往往额外耗时数分钟，反而比原先使用Makefile更慢了。

在增量编译方面，原先由于其 Makefile 编译系统的实现问题，是不完善的。 也就是说，在make编译完一个项目后，如果再执行make，会花费较长时间重新编译部分内容。 而使用Ninja以后，增量编译做得比较完善，第二次make将在一分钟内结束。

除此之外，由于Ninja的把编译流程集中到了一个文件，并且提供了一些工具命令。 所以编译信息的提取、编译依赖的分析，变得更加方便了。