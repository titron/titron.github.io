---
layout: post
title:  "在 Ubuntu 22.04上搭建TFTP服务器和NFS服务器"
categories: experience
tags: knowledge, base, tftp server, nfs server
author: David
---

* content
  {:toc}

在 Ubuntu 22.04 上搭建 **TFTP 服务器**和 **NFS 服务器**是嵌入式开发（如 Linux 内核调试、根文件系统挂载）的经典组合。以下是详细的搭建步骤：

---

## 一、 搭建 TFTP 服务器

TFTP（简单文件传输协议）常用于在开发板启动时下载 Linux 内核镜像（`uImage`/`zImage`）和设备树文件（`.dtb`）。

### 1. 安装 TFTP 相关软件

打开终端，执行以下命令安装 TFTP 服务端和客户端：

Bash

```
sudo apt update
sudo apt install tftpd-hpa tftp-hpa
```

### 2. 创建 TFTP 工作目录

创建一个用于存放传输文件的目录，并赋予最高权限，确保开发板可以正常读写：

Bash

```
sudo mkdir -p /home/tftpboot
sudo chmod 777 /home/tftpboot
```

### 3. 修改配置文件

编辑 TFTP 的配置文件 `/etc/default/tftpd-hpa`：

Bash

```
sudo nano /etc/default/tftpd-hpa
```

将内容修改为以下配置（主要修改 `TFTP_DIRECTORY` 和 `TFTP_OPTIONS`）：

Plaintext

```
TFTP_USERNAME="tftp"
TFTP_DIRECTORY="/home/tftpboot"
TFTP_ADDRESS=":69"
TFTP_OPTIONS="--secure --create"
```

> **提示**：`--create` 参数允许客户端在服务器上创建新文件（即支持上传）。

### 4. 重启并检查服务

保存退出后，重启 TFTP 服务并将其设置为开机自启：

Bash

```
sudo systemctl restart tftpd-hpa
sudo systemctl enable tftpd-hpa
```

检查服务状态，确保显示 `active (running)`：

Bash

```
sudo systemctl status tftpd-hpa
```

### 5. 本地测试 TFTP

你可以通过本地回环测试来验证是否搭建成功：

Bash

```
echo "TFTP Test File" > /home/tftpboot/test.txt
cd /tmp
tftp 127.0.0.1
# 进入 tftp 命令行后输入：
get test.txt
quit

# 查看 /tmp 目录下是否成功获取文件
cat test.txt
```

---

## 二、 搭建 NFS 服务器

NFS（网络文件系统）常用于将 Ubuntu 上的某个目录（如根文件系统 rootfs）挂载到开发板上，方便直接修改和调试代码而无需反复烧录。

### 1. 安装 NFS 服务端

Bash

```
sudo apt install nfs-kernel-server
```

### 2. 创建 NFS 共享目录

创建一个用于挂载的文件目录：

Bash

```
sudo mkdir -p /home/nfsroot
sudo chmod 777 /home/nfsroot
```

### 3. 配置共享目录权限

编辑 `/etc/exports` 文件来指定允许访问的客户端和权限：

Bash

```
sudo nano /etc/exports
```

在文件末尾添加以下内容（根据你的网络环境调整）：

Plaintext

```
/home/nfsroot *(rw,sync,no_root_squash,no_subtree_check)
```

**参数说明**：

- `*`：代表允许所有的 IP 访问（在局域网开发环境中很方便。如果为了安全，可以写具体网段如 `119.168.1.0/24`）。

- `rw`：读写权限。

- `sync`：资料同步写入内存与硬盘。

- `no_root_squash`：如果客户端使用的是 root 用户，则对该共享目录也拥有 root 权限（嵌入式开发必备）。

- `no_subtree_check`：不检查子目录权限，提高性能。

### 4. 解决 Ubuntu 22.04 的 NFS 版本兼容问题（重要 ⚠️）

> **避坑指南**：Ubuntu 22.04 默认**关闭了 NFS v2 和 v3**，只开启了 NFS v4。但是很多老旧的开发板 U-Boot 或内核只支持 NFS v2 或 v3。如果你在挂载时遇到 `Protocol not supported` 或一直连不上，请按以下步骤开启 v3 支持。

1. 编辑 `/etc/default/nfs-kernel-server`：
   
   Bash
   
   ```
   sudo nano /etc/default/nfs-kernel-server
   ```
   
   修改或添加以下内容，确保不禁用 v3：
   
   Plaintext
   
   ```
   RPCNFSDOPTS=""
   ```

2. 编辑 `/etc/nfs.conf`：
   
   Bash
   
   ```
   sudo nano /etc/nfs.conf
   ```
   
   找到 `[nfsd]` 标签，取消注释并修改 `vers3` 如下：
   
   Plaintext
   
   ```
   [nfsd]
   vers3=y
   ```

### 5. 重启 NFS 服务

配置完成后，重启相关服务并导出共享目录：

Bash

```
sudo systemctl restart rpcbind
sudo systemctl restart nfs-kernel-server
sudo systemctl enable nfs-kernel-server
```

使用以下命令查看当前生效的 NFS 共享目录：

Bash

```
showmount -e
```

如果输出显示 `/home/nfsroot *`，说明配置成功。

### 6. 本地测试 NFS

你可以尝试在本地挂载自己，验证服务是否正常：

Bash

```
sudo mount -t nfs -o nfsvers=3 127.0.0.1:/home/nfsroot /mnt
# 检查是否成功挂载，随后卸载
ls /mnt
sudo umount /mnt
```

---

## 三、 常见注意事项

1. **防火墙问题**：如果开发板依然无法连接，建议直接关闭 Ubuntu 的防火墙（仅限本地安全开发环境）：
   
   Bash
   
   ```
   sudo ufw disable
   ```

2. **IP 地址在同一网段**：请确保你的 Ubuntu 主机、Windows 宿主机（如果是虚拟机的话）以及开发板的 IP 地址处于**同一个网段**，且能够互相 `ping` 通。