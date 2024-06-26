---
layout: post
title:  "vscode中调试使用记录"
categories: experience
tags: vscode
author: David
---

* content
{:toc}

---

## VS Code超详细配置指南
[原始链接1](https://mp.weixin.qq.com/s/JAiYgvctNgM-_ygN0CUpag)

插件列表：
1. Remote Development
2. Markdown Preview Github Styling
3. GitLens
4. Bracket Pair Colorizer 2
5. sftp
6. TODO HighLight

快捷键：
1. Ctrl + `: 打开 VS Code 自带的终端。
2. Ctrl + Shift +F：在全局的文件夹中进行搜索
3. Shift + F12: 查找某个函数在哪些地方被调用了

## "Bad owner or permissions on .ssh/config"
[refer link](https://stackoverflow.com/questions/49926386/openssh-windows-bad-owner-or-permissions)
Use ssh client from Git instead of Windows inbuilt SSH client. E.g. set VS Code to use C:\Program Files\Git\usr\bin\ssh.exe instead of C:\Windows\System32\OpenSSH\ssh.exe.

Steps:

In VS Code navigated to [File] -> [Preferences] -> [Settings] -> Search remote.ssh.path
Input C:\Program Files\Git\usr\bin\ssh.exe
Alternatively:

Update PATH environment variable to point to Git bin before Windows System32.
Type "env" in Start bar to edit System (or account) environment variables.
Select Path and hit edit.
Add C:\Program Files\Git\usr\bin\ssh.exe to the list and move it to the top of the list.

## vs-code设置ssh-remote免密登录遇到的问题

[SSH的本质](https://blog.csdn.net/dongwuming/article/details/9705595)

单向登陆的操作过程（能满足上边的目的）：

1、登录A机器

2、ssh-keygen -t [rsa|dsa]，将会生成密钥文件和私钥文件 id_rsa,id_rsa.pub或id_dsa,id_dsa.pub

3、将 .pub 文件复制到B机器的 .ssh 目录， 并 cat id_dsa.pub >> ~/.ssh/authorized_keys

4、大功告成，从A机器登录B机器的目标账户，不再需要密码了；（直接运行 #ssh 192.168.20.60 ）

### 问题1：Vs code 无法ssh到服务器

*解决方案*：

windows命令行下：
```bash
SET REMOTEHOST=username@hostname

scp %USERPROFILE%.ssh\id_rsa.pub %REMOTEHOST%:~/tmp.pub ssh %REMOTEHOST% “mkdir
-p ~/.ssh && chmod 700 ~/.ssh && cat ~/tmp.pub >> ~/.ssh/authorized_keys
&& chmod 600 ~/.ssh/authorized_keys
&& rm -f ~/tmp.pub”
```
如果此方法不行，可直接登录服务器去创建修改
***/.ssh/authorized_keys***

### 问题2：VS code ssh remote连接时，需要输入密码？但是却没有可以输入密码的地方？

*解决方案*：

在VS code工具栏***File->preference->settings***搜索 ***remote.SSH.showLoginTerminal***，并***勾选**上

### 问题3：VS Code ssh remote报administrativePermitted

*解决方案*：

在 ***/etc/ssh/sshd-config***更改***AllowTCPForwarding - yes***

### 问题4：设置SSH之后，仍然需要密码才能连接

*解决方案*：

确认如下***三个权限***是否正确（显示隐藏文件命令：ls -la）

【1】
```bash
chmod 700 /home/username
```
【2】
```bash
chmod 700 ~/.ssh/
```
【3】
```bash
chmod 600 ~/.ssh/authorized_keys
```

确认public_key在服务器上是否正确：***cat ~/.ssh/authorized_keys***

### 问题5：连接SSH时，提示：Permission denied, please try again

连接ssh server时，即使输入正确的密码，仍然有以上提示。

*解决方法*：

在TERMINAL中，首先，手动登录：

```bash
ssh 用户名@服务器地址
```

输入密码，登录成功后。

然后，再次连接ssh server，就可以成功了。

### 问题6： search时exclude多个目录

![连接服务器1](https://github.com/titron/titron.github.io/raw/master/img/2020-06-05-vscode_memo_exclude_folders.png)



---------------------
## vs-code中的插件
[vscode远程开发及公钥配置（告别密码登录）](https://blog.csdn.net/u010417914/article/details/96918562)

### (插件1 - Remote Development)调试服务器上的c/c++代码

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

### (插件2 - C/C++ GNU Global)调试服务器上的c/c++代码

![C/C++ GNU Global](https://github.com/titron/titron.github.io/raw/master/img/2020-06-05-vscode_memo_gnu_global1.png)

安裝好以後先按 F1，叫出命令列後執行 Global: Show GNU Global Version 確認 GNU Global 有正確安裝及版本號碼。

![确认C/C++ GNU Global版本号](https://github.com/titron/titron.github.io/raw/master/img/2020-06-05-vscode_memo_gnu_global2.png)

接著同樣叫出命令列後執行 Global: Rebuild Gtags Database，這個命令會在專案資料夾內建立三個檔案: GTAGS、GRTAGS、GPATH，這三檔案就是 GNU Global 的 tag  檔 (你會想把他們加入全域的 gitignore 的)，建立完成後就可以對著函數按 F12 跳轉到函數定義了。

![建立索引](https://github.com/titron/titron.github.io/raw/master/img/2020-06-05-vscode_memo_end.png)

### (插件3 - Git Lens)Git operation

使用此插件，操作git会非常方便。

可以参考[这里](https://titron.github.io/2020/10/13/vscode_gitlens_guide/)。

### (插件4 - c/c++) from Microsoft

慎用该插件，否则，当打开服务器上的工程较大时，会实时占用服务器的大量带宽。

![慎用该插件](https://github.com/titron/titron.github.io/raw/master/img/2020-06-05-vscode_memo_c_cplus.png)



