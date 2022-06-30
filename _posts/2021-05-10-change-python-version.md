---
layout: post
title:  "建立android环境时，提示SyntaxError: invalid syntax"
categories: software
tags: ubuntu, android
author: David
---

* content
{:toc}

---

建立android环境时，运行以下命令：
```bash
$ ./walkthrough.sh ALL
```
提示以下错误
```bash
  File "/home/dongtz/work/android/Gen3_Android_v10_2.0/RENESAS_RCH3M3M3N_Android_10_ReleaseNote_2020_09E/mydroid/.repo/repo/main.py", line 79
    file=sys.stderr)
        ^
SyntaxError: invalid syntax
```

原因：
```bash
...mydroid/.repo/repo$ vim main.py
```
发现，需要**python 3环境**
```bash
# python-3.6 is in Ubuntu Bionic.
MIN_PYTHON_VERSION_SOFT = (3, 6)
MIN_PYTHON_VERSION_HARD = (3, 5)

if sys.version_info.major < 3:
  print('repo: error: Python 2 is no longer supported; '
        'Please upgrade to Python {}.{}+.'.format(*MIN_PYTHON_VERSION_SOFT),
        file=sys.stderr)
  sys.exit(1)
else:
```

### 检查当前python环境：
```bash
$ python2 --version
$ python3 --version
Python 3.7.8
$ python --version
Python 2.7.12
$ echo alias python=python3 >> ~/.bashrc   #更改当前python环境
$ source ~/.bashrc
$ python --version         # 确认一下
Python 3.7.8
```

### 重新设置repo
```bash
$ curl https://storage.googleapis.com/git-repo-downloads/repo-1 > repo
$ chmod +x repo
$ export PATH=$(pwd):${PATH}
```

删除mydroid/后，重新按照手册进行操作。


