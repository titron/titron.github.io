---
layout: post
title:  "ssh与github"
categories: software
tags: github ssh
author: David
---

* content
{:toc}

---

访问github又崩溃了，提示ssh授权失败。

参考这里重新设置ssh公钥,[windows下GitHub的SSH key配置](https://www.jianshu.com/p/9317a927e844)

生成SSH密钥 并 添加公共密钥到GitHub上的帐户

### 先设置GitHub的user name和email
进入终端，运行如下命令，直接用用户名和邮箱替换包括括号的部分：
```bash
git config --global user.name "Git账号"
git config --global user.email "Git邮箱"
```

### 生成新秘钥
```bash
ssh-keygen -t rsa -C "your_email@example.com"
```
注：
* 一定注意生成的文件保存路径，有可能目录/c/Users/xxxxxxx/.ssh/下，copy过去。
* 生成的SSH私钥路径 /c/Users/xxxxxxx/.ssh/id_rsa, 后面要用到。


### 将SSH私钥添加到 ssh-agent
/c/Users/xxxxxxx/.ssh/目录下，右键Git Bash here
```bash
eval $(ssh-agent -s)
ssh-add /c/Users/xxxxxxx/.ssh/id_rsa
```

### 将SSH公钥添加到GitHub账户
先复制SSH公钥的完整内容（/c/Users/xxxxxxx/.ssh/id_rsa.pub）
进入GitHub的设置页面（登录GitHub，在右上角）, settins - SSH and GPG keys - delete old key then new SSH key - 粘贴公钥

### 测试连接
Git Bash下
```bash
ssh -T git@github.com
```
出现“Hi，xxxxxxx， You've successfully authenticated...”，说明SSH Key配置成功
如果提示的是“ access denied”， 请参考这里：[these instructions for diagnosing the issue](https://link.jianshu.com/?t=https://help.github.com/articles/error-permission-denied-publickey).


### 提示
* 如果git clone时失败，可以尝试https方式clone。
* 如果能https pull，但是不能push，需要按照上面的方法更新新的秘钥（步骤中有错误，比如，目录不对）
* 有时用tortoise git push不成功，不一定是git的原因，而是tortoise git本身的原因，需要重新安装。可以在git bash下git push看结果进行判断。
