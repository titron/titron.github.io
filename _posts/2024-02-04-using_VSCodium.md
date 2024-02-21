---
layout: post
title:  "Using VSCodium"
categories: basic
tags: VSCode, VSCodium, Scoop
author: David
---

* content
{:toc}

---

### （1）install Scoop

```bash
# vscode terminal is being used here
PS C:\d_disk> irm get.scoop.sh -outfile 'install.ps1'
PS C:\d_disk> .\install.ps1 -RunAsAdmin
Initializing...
Downloading ...
Creating shim...
Adding ~\scoop\shims to your path.
Scoop was installed successfully!
Type 'scoop help' for instructions.
```
### （2）install VSCodium
```bash
PS C:\d_disk>scoop bucket add extras
Checking repo... OK
The extras bucket was added successfully.
PS C:\d_disk> scoop install vscodium
Installing 'vscodium' (1.85.2.24019) [64bit] from extras bucket
VSCodium-win32-x64-1.85.2.24019.zip (118.6 MB) [===============================================================================================================================================] 100%    
Checking hash of VSCodium-win32-x64-1.85.2.24019.zip ... ok.
Extracting VSCodium-win32-x64-1.85.2.24019.zip ... done.
Running pre_install script...
Linking ~\scoop\apps\vscodium\current => ~\scoop\apps\vscodium\1.85.2.24019
Creating shim for 'vscodium'.
Creating shortcut for VSCodium (VSCodium.exe)
Persisting data
Running post_install script...
'vscodium' (1.85.2.24019) was installed successfully!
Notes
-----
Add VSCodium as a context menu option by running 'reg import "C:\Users\MyPC\scoop\apps\vscodium\current\install-context.reg"'
For file associations, run 'reg import "C:\Users\MyPC\scoop\apps\vscodium\current\install-associations.reg"'
PS C:\d_disk>
```
