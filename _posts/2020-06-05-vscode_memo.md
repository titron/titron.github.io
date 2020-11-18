---
layout: post
title:  "vscode中调试使用记录"
categories: Software
tags: vscode
author: David
---

* content
{:toc}

---

## vs-code设置ssh-remote免密登录遇到的问题

### 问题1：Vs code 无法ssh到服务器

解决方案：

windows命令行下：
```
SET REMOTEHOST=username@hostname

scp %USERPROFILE%.ssh\id_rsa.pub %REMOTEHOST%:~/tmp.pub ssh %REMOTEHOST% “mkdir
-p ~/.ssh && chmod 700 ~/.ssh && cat ~/tmp.pub >> ~/.ssh/authorized_keys
&& chmod 600 ~/.ssh/authorized_keys
&& rm -f ~/tmp.pub”
```
如果此方法不行，可直接登录服务器去创建修改
***/.ssh/authorized_keys***

### 问题2：VS code ssh remote连接时，需要输入密码？但是却没有可以输入密码的地方？

解决方案：

在VS code工具栏***File->preference->settings***搜索 ***remote.SSH.showLoginTerminal***，并***勾选**上

### 问题3：VS Code ssh remote报administrativePermitted

解决方案：在 ***/etc/ssh/sshd-config***更改***AllowTCPForwarding - yes***

### 问题4：设置SSH之后，仍然需要密码才能连接

解决方案：确认如下***三个权限***是否正确（显示隐藏文件命令：ls -la）

【1】
```
chmod 700 /home/username
```
【2】
```
chmod 700 ~/.ssh/
```
【3】
```
chmod 600 ~/.ssh/authorized_keys
```

确认public_key在服务器上是否正确：***cat ~/.ssh/authorized_keys***

---------------------
[vscode远程开发及公钥配置（告别密码登录）](https://blog.csdn.net/u010417914/article/details/96918562)

### 调试服务器上的c/c++代码

1. 安装插件：Remote Development

该插件包包含：Remote-SSH, Remote-WSL, Remote-Containers

2. 设置

为避免以后每次SSH连接输入密码，这里选择用SSH key连接

首先，生成SSH Key pair。

![生成SSH Key pair](https://github.com/titron/titron.github.io/raw/master/img/2020-06-05-vscode_memo_1.png)

其次，授权用SSH public key连接服务器（用Git Bash Here终端）

![连接服务器1](https://github.com/titron/titron.github.io/raw/master/img/2020-06-05-vscode_memo_2.png)

![连接服务器2](https://github.com/titron/titron.github.io/raw/master/img/2020-06-05-vscode_memo_3.png)

授权你的windows连接（VSCode的PowerShell下）

![授权1](https://github.com/titron/titron.github.io/raw/master/img/2020-06-05-vscode_memo_authorize1.png)

![授权2](https://github.com/titron/titron.github.io/raw/master/img/2020-06-05-vscode_memo_authorize2.png)

在服务器上，确认文件都有了

![confirm file](https://github.com/titron/titron.github.io/raw/master/img/2020-06-05-vscode_memo_confirmFile.png)

在vscode中，运行(ctrl+shift+p) Remote-SSH: Open Configuration File...
会出现一个不显眼的提示，选择Host端是Linux，还是Windows，回车即可。

![ssh连接1](https://github.com/titron/titron.github.io/raw/master/img/2020-06-05-vscode_memo_ssh1.png)

![ssh连接2](https://github.com/titron/titron.github.io/raw/master/img/2020-06-05-vscode_memo_ssh2.png)

![ssh连接3](https://github.com/titron/titron.github.io/raw/master/img/2020-06-05-vscode_memo_ssh3.png)

![ssh连接4](https://github.com/titron/titron.github.io/raw/master/img/2020-06-05-vscode_memo_ssh4.png)

![ssh连接5](https://github.com/titron/titron.github.io/raw/master/img/2020-06-05-vscode_memo_ssh5.png)

3. 安装插件 C/C++ GNU Global

![C/C++ GNU Global](https://github.com/titron/titron.github.io/raw/master/img/2020-06-05-vscode_memo_gnu_global1.png)

安裝好以後先按 F1，叫出命令列後執行 Global: Show GNU Global Version 確認 GNU Global 有正確安裝及版本號碼。

![确认C/C++ GNU Global版本号](https://github.com/titron/titron.github.io/raw/master/img/2020-06-05-vscode_memo_gnu_global2.png)

接著同樣叫出命令列後執行 Global: Rebuild Gtags Database，這個命令會在專案資料夾內建立三個檔案: GTAGS、GRTAGS、GPATH，這三檔案就是 GNU Global 的 tag  檔 (你會想把他們加入全域的 gitignore 的)，建立完成後就可以對著函數按 F12 跳轉到函數定義了。

![建立索引](https://github.com/titron/titron.github.io/raw/master/img/2020-06-05-vscode_memo_end.png)

### c/c++无法跳转

把扩展插件

* C/C++

* C++ Intellinsense

卸载，关掉vscode。

重启vscode，重新安装以上插件，关掉vscode。

重启vscode，OK。



