---
layout: post
title:  "更改Linux/Unix 环境变量"
categories: experience
tags: knowledge base
author: David
---

* content
{:toc}

情况一：在终端中直接设置（生效）
```bash
export PATH=$PATH:/new/path
```

这是在当前 shell（父进程）中直接修改 PATH
后续所有命令都继承这个新 PATH

情况二：在脚本中设置（不生效）
```bash
# setpath.sh
export PATH=$PATH:/new/path
echo $PATH  # 脚本内能看到新 PATH
```

```bash
./setpath.sh    # 或 bash setpath.sh
echo $PATH      # 终端中 PATH 未改变！
```

**为什么？**

当你运行 ./setpath.sh 时，系统会启动一个子 shell 来执行脚本
脚本中的 export 只修改了子 shell 的环境变量
脚本执行完毕后，子 shell 退出，修改不会回传给父 shell（你的终端）
📌 Unix/Linux 的设计原则：子进程不能修改父进程的环境变量（安全机制）

✅ 正确解决方案
### 方案 1：使用 source 命令（推荐！）
```bash
source setpath.sh# 
或简写
. setpath.sh
```

原理：
* source 不会启动子 shell，而是在当前 shell 中逐行执行脚本
* 所有变量修改都作用于当前终端

### 方案 2：在 shell 配置文件中永久设置
如果希望每次打开终端都生效，将 PATH 添加到配置文件：

对当前用户：
```bash
echo 'export PATH="$PATH:/opt/myapp/bin"' >> ~/.bashrc
# 或 ~/.zshrc（如果你用 zsh）
```

然后重载配置：
```bash
source ~/.bashrc
```

对所有用户（需 root 权限）：
```bash
sudo echo 'export PATH="$PATH:/opt/myapp/bin"' >> /etc/environment
```
