---
layout: post
title:  "SCP Sample - R-Car S4"
categories: software
tags: R-Car, S4, SDK, Spider
author: David
---

* content
{:toc}

---

## Overview
This sample is based on R-Car S4 SDK v3.16.0.

SCP sample application consists of Linux on CA55, SCP sample application on CR52 and SCP sample application on G4MH and they can communicate with SCMI.

You need to rebuild Linux Image, dtb, ICUMX firmware and Security BSP for SCP.

SCP sample application on CR52 and G4MH is built on MCAL build tree. You need to install SCP code on MCAL build tree and to edit MCAL build systems to build SCP module. 

SCP module needs MCAL MCU library. You must build MCAL MCU module before building SCP sample application.

## Prepare the environments
1. Necessary SDK software lists for this example:

| Index | Software Name | Software Type |
|-|-|-|
| 1 | R-Car S4 G4MH MCAL ASIL | mcal_sdk-gateway_v3.16.0_release.exe |
| 2 | R-Car S4 CA55 SCP for Linux | rcar-xos_sdk1-gateway_v3.16.0_release.exe |
| 3 | Poky Linux toolchain |  rcar_tool_ubuntu_v3.16.0.zip |

2. Terminals

| Index | Terminal Name | Link |
|-|-|-|
| 1 | git bash | https://gitforwindows.org/ |
| 2 | VS Code terminal | https://code.visualstudio.com/ |
| 3 | Cygwin terminal | http://www.cygwin.com/ |

3. compilers

| Index | Compiler | Target | License |
|-|-|-|-|
| 1 | GHS | for (G4MH) MCU library, G4MH SCP sample application; for (ICUMX) IPL, Dummy FW and Dummy MCU  | license is necessary |
| 2 | ARM Compiler | for (CR52) MCU library,  | license is necessary |
| 3 | Cygwin terminal | http://www.cygwin.com/ |
| 4 | GNUWin32 | C:\d_disk\RenesasMCUHWM\RCar\Gen4\R-Car_S4\s4_dev\tools\GnuWin32\GetGnuWin32\gnuwin32\bin |


## Build and Execute SCP sample application
### 1. How to build SCP on G4MH

(*here, git bash is used.*)

```bash
# Step 1. Install SCP code 
# Unzip SCP source tree on MCAL source tree.
a5059726@CHN-5CG1064GKY MINGW64 /c/Renesas/mcal/v3.16.0/sw_src/g4mh_mcal/rel/modules/scp
$ unzip g4mh_scp.zip

# Step 2. Apply the patches to build MCU libraries with reset function
# Apply the patches to enable reset function on MCAL MCU module.
a5059726@CHN-5CG1064GKY MINGW64 /c/Renesas/mcal/v3.16.0/sw_src/g4mh_mcal
$ patch -p 1 <rel/modules/scp/patches/0001-edit-mcu-config-for-scp.patch
patching file rel/modules/mcu/sample_application/S4/19_11/config/App_MCU_S4_RTM8RC79FG_Sample.arxml

a5059726@CHN-5CG1064GKY MINGW64 /c/Renesas/mcal/v3.16.0/sw_src/g4mh_mcal
$ patch -p 1 <rel/modules/scp/patches/0002-add-rte-for-scp.patch
patching file rel/common/generic/stubs/19_11/Rte/include/SchM_Scp.h
patching file rel/common/generic/stubs/19_11/Rte/make/rte_rules.mak
patching file rel/common/generic/stubs/19_11/Rte/src/SchM_Scp.c

a5059726@CHN-5CG1064GKY MINGW64 /c/Renesas/mcal/v3.16.0/sw_src/g4mh_mcal
$ patch -p 1 <rel/modules/scp/patches/0003-edit-common.mak.patch
patching file rel/S4/common_family/make/ghs/Common.mak

a5059726@CHN-5CG1064GKY MINGW64 /c/Renesas/mcal/v3.16.0/sw_src/g4mh_mcal
$ patch -p 1 <rel/modules/scp/patches/0004-enable-mfis-interrupt.patch
patching file rel/S4/common_family/src/ghs/Interrupt_VectorTable_PE0.c

a5059726@CHN-5CG1064GKY MINGW64 /c/Renesas/mcal/v3.16.0/sw_src/g4mh_mcal
$ patch -p 1 <rel/modules/scp/patches/0005-SampleApp.bat-enable-build.patch
patching file rel/S4/common_family/make/ghs/SampleApp.bat


```



(here, VS Code - terminal is used.)
```bash
# Step 3: Build MCU libraries
PS C:\Renesas\mcal\v3.16.0\sw_src\g4mh_mcal\rel\S4\common_family\make\ghs> .\SampleApp.bat mcu R19-11 S4 No

(...)
        -map="C:\Renesas\mcal\v3.16.0\sw_src\g4mh_mcal\rel\modules\mcu\sample_application\S4\obj\ghs\App_MCU_S4_Sample.map" \
        -o "C:\Renesas\mcal\v3.16.0\sw_src\g4mh_mcal\rel\modules\mcu\sample_application\S4\obj\ghs\App_MCU_S4_Sample.out"
Generating Motorola S-Record file ...
"C:\ghs\comp_202214\gsrec.exe" -S3 "C:\Renesas\mcal\v3.16.0\sw_src\g4mh_mcal\rel\modules\mcu\sample_application\S4\obj\ghs\App_MCU_S4_Sample.out" \
        -o "C:\Renesas\mcal\v3.16.0\sw_src\g4mh_mcal\rel\modules\mcu\sample_application\S4\obj\ghs\App_MCU_S4_Sample.s37"
Done ...

===========================================================================
                       BUILDING COMPLETED
===========================================================================

# check bin file of "mcu" sample application
PS C:\Renesas\mcal\v3.16.0\sw_src\g4mh_mcal\rel\S4\common_family\make\ghs> ls C:\Renesas\mcal\v3.16.0\sw_src\g4mh_mcal\rel\modules\mcu\sample_application\S4\obj\ghs\
-a----        11/13/2023   3:39 PM          70560 App_MCU_S4_Sample.map
-a----        11/13/2023   3:39 PM          40216 App_MCU_S4_Sample.o
-a----        11/13/2023   3:39 PM         392984 App_MCU_S4_Sample.out
-a----        11/13/2023   3:39 PM          53240 App_MCU_S4_Sample.s37

# Note:
# Please set environments variables "GNUMAKE" if below error happened and run VS Code as administrator:
# "common.mak:125: \cygdrive\c\Renesas\mcal\v3.16.0\sw_src\g4mh_mcal\rel\common\generic\compiler\19_11\ghs\make\ghs_rh850_r19_11_defs.mak: No such file or directory"


# Step 4. Build SCP sample application
PS D:\Renesas\mcal\v3.16.0\sw_src\g4mh_mcal\rel\S4\common_family\make\ghs> .\SampleApp.bat scp R19-11 S4 No
(...)
        -map="C:\Renesas\mcal\v3.16.0\sw_src\g4mh_mcal\rel\modules\scp\sample_application\S4\obj\ghs\App_SCP_S4_Sample.map" \
        -o "C:\Renesas\mcal\v3.16.0\sw_src\g4mh_mcal\rel\modules\scp\sample_application\S4\obj\ghs\App_SCP_S4_Sample.out"
Generating Motorola S-Record file ...
"C:\ghs\comp_202214\gsrec.exe" -S3 "C:\Renesas\mcal\v3.16.0\sw_src\g4mh_mcal\rel\modules\scp\sample_application\S4\obj\ghs\App_SCP_S4_Sample.out" \
        -o "C:\Renesas\mcal\v3.16.0\sw_src\g4mh_mcal\rel\modules\scp\sample_application\S4\obj\ghs\App_SCP_S4_Sample.s37"
Done ...

===========================================================================
                       BUILDING COMPLETED
===========================================================================

# check bin file of "scp" sample application
PS C:\Renesas\mcal\v3.16.0\sw_src\g4mh_mcal\rel\S4\common_family\make\ghs> ls C:\Renesas\mcal\v3.16.0\sw_src\g4mh_mcal\rel\modules\scp\sample_application\S4\obj\ghs
(...)
-a----        11/13/2023   4:08 PM         110449 App_SCP_S4_Sample.map
-a----        11/13/2023   4:08 PM         124856 App_SCP_S4_Sample.o
-a----        11/13/2023   4:08 PM         604252 App_SCP_S4_Sample.out
-a----        11/13/2023   4:08 PM          98028 App_SCP_S4_Sample.s37
(...)
```

## 2. How to build SCP sample application on CR52

(*here, git bash is used.*)
```bash
# Step 1. Install SCP code
a5059726@CHN-5CG1064GKY MINGW64 /c/Renesas/mcal/v3.16.0/sw_src/cr52_mcal/rel/modules/scp
$ unzip cr52_scp.zip

# Step 2: Apply the patches to build MCU libraries with reset function
a5059726@CHN-5CG1064GKY MINGW64 /c/Renesas/mcal/v3.16.0/sw_src/cr52_mcal
$ patch -p 1 < rel/modules/scp/patches/0001-edit-mcu-config-for-scp.patch
patching file rel/modules/mcu/sample_application/S4/19_11/config/App_MCU_S4_RTM8RC79FR_Sample.arxml

a5059726@CHN-5CG1064GKY MINGW64 /c/Renesas/mcal/v3.16.0/sw_src/cr52_mcal
$ patch -p 1 < rel/modules/scp/patches/0002-add-rte-for-scp.patch
patching file rel/common/generic/stubs/19_11/Rte/include/SchM_Scp.h
patching file rel/common/generic/stubs/19_11/Rte/make/rte_rules.mak
patching file rel/common/generic/stubs/19_11/Rte/src/SchM_Scp.c

a5059726@CHN-5CG1064GKY MINGW64 /c/Renesas/mcal/v3.16.0/sw_src/cr52_mcal
$ patch -p 1 < rel/modules/scp/patches/0003-edit-common.mak.patch
patching file rel/S4/common_family/make/arm/Common.mak

a5059726@CHN-5CG1064GKY MINGW64 /c/Renesas/mcal/v3.16.0/sw_src/cr52_mcal
$ patch -p 1 < rel/modules/scp/patches/0004-enable-mfis-interrupt.patch
patching file rel/S4/common_family/include/arm/Interrupt_Cfg.h

a5059726@CHN-5CG1064GKY MINGW64 /c/Renesas/mcal/v3.16.0/sw_src/cr52_mcal
$ patch -p 1 < rel/modules/scp/patches/0005-SampleApp.bat-enable-build.patch
patching file rel/S4/common_family/make/arm/SampleApp.bat


```

(here, VS Code - terminal is used.)
```bash
# Step 3: Build MCU libraries
PS C:\Renesas\mcal\v3.16.0\sw_src\cr52_mcal\rel\S4\common_family\make\arm> .\SampleApp.bat mcu R19-11 S4 No
()...)
 C:\Renesas\mcal\v3.16.0\sw_src\cr52_mcal\rel\modules\mcu\sample_application\S4\obj\arm\start.o
[LINK]... Done
--------------------------------------------------------------------
[S-REC GENERATOR]   "C:\Program Files\ARMCompiler6.6.3\bin\fromelf.exe"
[FLAGS]      --m32combined --base=0xE2100000 --output="C:\Renesas\mcal\v3.16.0\sw_src\cr52_mcal\rel\modules\mcu\sample_application\S4\obj\arm\App_MCU_S4_Sample.srec"
             "C:\Renesas\mcal\v3.16.0\sw_src\cr52_mcal\rel\modules\mcu\sample_application\S4\obj\arm\App_MCU_S4_Sample.elf"
[GENERATING S-RECORD]...
[GENERATION]... Done
(...)

# Step 4: Build SCP sample application
PS C:\Renesas\mcal\v3.16.0\sw_src\cr52_mcal\rel\S4\common_family\make\arm> .\SampleApp.bat scp R19-11 S4 No
(...)
[FLAGS]      --m32combined --base=0xE2100000 --output="C:\Renesas\mcal\v3.16.0\sw_src\cr52_mcal\rel\modules\scp\sample_application\S4\obj\arm\App_SCP_S4_Sample.srec"
             "C:\Renesas\mcal\v3.16.0\sw_src\cr52_mcal\rel\modules\scp\sample_application\S4\obj\arm\App_SCP_S4_Sample.elf"
[GENERATING S-RECORD]...
[GENERATION]... Done
(...)

```


## 3. How to build Linux Image and dtb for SCP

(dongtz@renesas-abd:~/work/s4/s4_scp_sample_app$)
```bash
# Step 1: Prepare clone Linux Kernel Code from GitHub.
dongtz@renesas-abd:~/work/s4/s4_scp_sample_app$ git clone  https://github.com/renesas-rcar/linux-bsp.git
dongtz@renesas-abd:~/work/s4/s4_scp_sample_app$ cd linux-bsp
dongtz@renesas-abd:~/work/s4/s4_scp_sample_app/linux-bsp$ git checkout -b scp_sample remotes/origin/v5.10.41/rcar-5.1.7.rc10

# Step 2: Set SCP to enable as below
dongtz@renesas-abd:~/work/s4/s4_scp_sample_app/linux-bsp$ git revert 88bb2c34c114

dongtz@renesas-abd:~/work/s4/s4_scp_sample_app/linux-bsp$ git log --oneline -10
5196ec69154c (HEAD -> scp_sample) Revert "arm64: dts: renesas: r8a779f0: Disable S2RAM support for R-Car S4"
88bb2c34c114 (origin/v5.10.41/rcar-5.1.7.rc10) arm64: dts: renesas: r8a779f0: Disable S2RAM support for R-Car S4
9a3b37ed269c pci: dwc: renesas: Fix PCIe flow to work with NVME device
17c213d4bdc2 PCI/MSI: Add pci_has_msi() helper
1b037e1d137c i2c: rcar: Add I2C setting for RC21008A clock generator in resuming
bb65bd17b26d gpio: pca953x: Change to resume early
b34faf8a0865 pci: dwc: renesas: Support PCIe 4.0 working with x4 lanes
27a0bc97b5d6 pci: dwc: pcie-renesas-ep: Support PCIe 4.0 working with x4 lanes
b72b77c8dd17 pci: dwc: renesas: Fix PCIe suspend/resume asynchronous issue
d2520042f889 pci: dwc: renesas: Add PCIe support for S2RAM

# Step 3: Build the Image and dtbs
# 3.1 install docker: ubuntu 20.04
dongtz@renesas-abd:~/work/s4/s4_scp_sample_app/linux-bsp$ docker images
REPOSITORY                   TAG                 IMAGE ID            CREATED             SIZE
grafana/grafana-enterprise   latest              8861608c3eec        8 months ago        342MB
ubuntu                       20.04               e40cf56b4be3        9 months ago        72.8MB
ubuntu                       18.04               5d2df19066ac        9 months ago        63.1MB
ubuntu                       <none>              d5447fc01ae6        11 months ago       72.8MB
opengrok/docker              latest              531d5b0b61cc        12 months ago       901MB
ubuntu                       latest              a8780b506fa4        12 months ago       77.8MB
ubuntu                       20.04_focal         680e5dfb52c7        12 months ago       72.8MB
opendms                      latest              55f5f8db927f        14 months ago       4.71GB
<none>                       <none>              10f7f705174b        14 months ago       961MB
ubuntu                       <none>              3bc6e9f30f51        15 months ago       72.8MB
ubuntu                       <none>              8d5df41c547b        15 months ago       63.1MB
hello-world                  latest              feb5d9fea6a5        2 years ago         13.3kB
danielguerra/ubuntu-xrdp     20.04               5534dc94a278        2 years ago         1.59GB
gitlab/gitlab-ce             13.0.6-ce.0         2b9ac1a40dd1        3 years ago         1.81GB
dongtz@renesas-abd:~/work/s4/s4_scp_sample_app/linux-bsp$ docker pull ubuntu:20.04
20.04: Pulling from library/ubuntu 
96d54c3075c9: Pull complete
Digest: sha256:ed4a42283d9943135ed87d4ee34e542f7f5ad9ecf2f244870e23122f703f91c2
Status: Downloaded newer image for ubuntu:20.04
docker.io/library/ubuntu:20.04
dongtz@renesas-abd:~/work/s4/s4_scp_sample_app/linux-bsp$ docker images
REPOSITORY                   TAG                 IMAGE ID            CREATED             SIZE
ubuntu                       20.04               bf40b7bc7a11        5 weeks ago         72.8MB
grafana/grafana-enterprise   latest              8861608c3eec        8 months ago        342MB
ubuntu                       <none>              e40cf56b4be3        9 months ago        72.8MB
ubuntu                       18.04               5d2df19066ac        9 months ago        63.1MB
ubuntu                       <none>              d5447fc01ae6        11 months ago       72.8MB
opengrok/docker              latest              531d5b0b61cc        12 months ago       901MB
ubuntu                       latest              a8780b506fa4        12 months ago       77.8MB
ubuntu                       20.04_focal         680e5dfb52c7        12 months ago       72.8MB
opendms                      latest              55f5f8db927f        14 months ago       4.71GB
<none>                       <none>              10f7f705174b        14 months ago       961MB
ubuntu                       <none>              3bc6e9f30f51        15 months ago       72.8MB
ubuntu                       <none>              8d5df41c547b        15 months ago       63.1MB
hello-world                  latest              feb5d9fea6a5        2 years ago         13.3kB
danielguerra/ubuntu-xrdp     20.04               5534dc94a278        2 years ago         1.59GB
gitlab/gitlab-ce             13.0.6-ce.0         2b9ac1a40dd1        3 years ago         1.81GB
dongtz@renesas-abd:~/work/s4/s4_scp_sample_app/linux-bsp$ docker run -it -d --name tzdong_xos_dev ubuntu:20.04
5b37c152a18b5ffd0da409d26ccae098814de6c783aa4a76f05835eaab86f61d
dongtz@renesas-abd:~/work/s4/s4_scp_sample_app/linux-bsp$ docker ps
CONTAINER ID        IMAGE                            COMMAND                  CREATED             STATUS                 PORTS                                                            NAMES
5b37c152a18b        ubuntu:20.04                     "/bin/bash"              52 seconds ago      Up 48 seconds                                                                           tzdong_xos_dev
ee59e351136b        danielguerra/ubuntu-xrdp:20.04   "/usr/bin/docker-ent…"   2 weeks ago         Up 2 weeks             9001/tcp, 0.0.0.0:30022->22/tcp, 0.0.0.0:33389->3389/tcp         goofy_hellman
d8442f43d791        danielguerra/ubuntu-xrdp:20.04   "/usr/bin/docker-ent…"   3 months ago        Up 2 weeks             9001/tcp, 0.0.0.0:60022->22/tcp, 0.0.0.0:63389->3389/tcp         liuhm_gen4sdk
c4f4a704a7a6        danielguerra/ubuntu-xrdp:20.04   "/usr/bin/docker-ent…"   6 months ago        Up 2 weeks             9001/tcp, 0.0.0.0:50022->22/tcp, 0.0.0.0:53389->3389/tcp         damon
49d9aab0e1b2        danielguerra/ubuntu-xrdp:20.04   "/usr/bin/docker-ent…"   10 months ago       Up 2 weeks             9001/tcp, 0.0.0.0:20022->22/tcp, 0.0.0.0:23389->3389/tcp         gitlab-runner
85006f20aa19        danielguerra/ubuntu-xrdp:20.04   "/usr/bin/docker-ent…"   18 months ago       Up 2 weeks             9001/tcp, 0.0.0.0:10022->22/tcp, 0.0.0.0:13389->3389/tcp         xos-dev
4a554ad51917        gitlab/gitlab-ce:13.0.6-ce.0     "/assets/wrapper"        19 months ago       Up 2 weeks (healthy)   0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp, 0.0.0.0:2222->22/tcp   gitlab

dongtz@renesas-abd:~/work/s4/s4_scp_sample_app/linux-bsp$ docker exec -it tzdong_xos_dev /bin/bash
root@5b37c152a18b:/# cd home/
root@5b37c152a18b:/home# mkdir tzdong
root@5b37c152a18b:/home# su -
root@5b37c152a18b:~# apt-get update
root@5b37c152a18b:~# apt-get install sudo -y
sudo apt install gawk wget git-core diffstat unzip texinfo gcc-multilib \
build-essential chrpath socat cpio python3 python3-pip python3-pexpect \
xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa \
libsdl1.2-dev pylint3 xterm libarchive-zip-perl

#NOTE: error in Startup Guide
# C:\Renesas\rcar-xos\v3.16.0\docs\sw\yocto_linux\user_manual\gateway\build_yocto.sh


# 3.2 install & set poky toolchain 
dongtz@renesas-abd:~/work/s4/tools$ docker cp rcar_tool_ubuntu_v3.16.0.zip tzdong_xos_dev:/home/tzdong/s4_tools/rcar_tool_ubuntu_v3.16.0

root@5b37c152a18b:/home/tzdong/s4_tools/rcar_tool_ubuntu_v3.16.0# tar -zxvf rcar-xos_tool_poky_toolchain_ubuntu_5.24.0.tar.gz

root@5b37c152a18b:/home/tzdong/s4_tools/rcar_tool_ubuntu_v3.16.0/tools/toolchains/poky# ./poky-glibc-x86_64-rcar-image-gateway-aarch64-spider-toolchain-3.1.11.sh
(...)
Each time you wish to use the SDK in a new shell session, you need to source the environment setup script e.g.
 $ . /opt/poky/3.1.11/environment-setup-aarch64-poky-linux

# 3.3 build
root@5b37c152a18b:/home/tzdong/s4_scp_sample/linux_bsp/linux-bsp# source /opt/poky/3.1.11/environment-setup-aarch64-poky-linux 
root@5b37c152a18b:/home/tzdong/s4_scp_sample/linux_bsp/linux-bsp# unset LDFLAGS
root@5b37c152a18b:/home/tzdong/s4_scp_sample/linux_bsp/linux-bsp# make mrproper
root@5b37c152a18b:/home/tzdong/s4_scp_sample/linux_bsp/linux-bsp# make defconfig
root@5b37c152a18b:/home/tzdong/s4_scp_sample/linux_bsp/linux-bsp# apt-get install libghc-libyaml-dev
root@5b37c152a18b:/home/tzdong/s4_scp_sample/linux_bsp/linux-bsp# apt-get install libssl-dev
root@5b37c152a18b:/home/tzdong/s4_scp_sample/linux_bsp/linux-bsp# apt-get install bc
root@5b37c152a18b:/home/tzdong/s4_scp_sample/linux_bsp/linux-bsp# make Image dtbs -j4 LOCALVERSION=-yocto-standard 
# after compiling successfully,
# - arch/arm64/boot/Image
# - arch/arm64/boot/dts/renesas/r8a779f0-spider.dtb 
root@5b37c152a18b:/home/tzdong/s4_scp_sample/linux_bsp/linux-bsp# ls arch/arm64/boot/
Image  Makefile  dts  install.sh
root@5b37c152a18b:/home/tzdong/s4_scp_sample/linux_bsp/linux-bsp# ls arch/arm64/boot/dts/renesas/r8a779f0-spider.dtb 
arch/arm64/boot/dts/renesas/r8a779f0-spider.dtb

# copy Image & dtb from docker
dongtz@renesas-abd:~/work/s4/s4_scp_sample_app$ docker cp tzdong_xos_dev:/home/tzdong/s4_scp_sample/linux_bsp/linux-bsp/arch/arm64/boot/Image .
dongtz@renesas-abd:~/work/s4/s4_scp_sample_app$ docker cp tzdong_xos_dev:/home/tzdong/s4_scp_sample/linux_bsp/linux-bsp/arch/arm64/boot/dts/renesas/r8a779f0-spider.dtb .
```

### 4. How to prepare ICUMX Software

Environments
- OS: windows
- Compiler: GreenHills

  (C:\ghs\comp_202214)

- Terminal: Cygwin
- Source code: Gen4_ICUMX_Loader

  (C:\Renesas\rcar-xos\v3.16.0\sw_src\renesas\applications\platform\others\ipl\src\s4\src\Gen4_ICUMX_Loader)

refer(1) “6.2 How to” on “r11uz0236ej0016-icumx-ipl.pdf “ (ICUMX IPL for R-Car Gen4 User's Manual)

refer(2) “5. How to run Flash writer” in “R-Car Gen4 Flash writer sample software User’s Manual: Software”

(here, VS Code - terminal is used.)
```bash
PS C:\Renesas\rcar-xos\v3.16.0\sw_src\renesas\applications\platform\others\ipl\src\s4\src\Gen4_ICUMX_Loader> make LSI=S4 S2R_ENABLE=1 BOOT_MCU=1

PS C:\Renesas\rcar-xos\v3.16.0\sw_src\renesas\applications\platform\others\ipl\src\s4\src\Gen4_ICUMX_Loader\build\release> ls
(...)
bootparam_sa0.srec
cert_header_sa9.srec
icumx_loader.srec
ntfmv_ver_tbl.bin
tfmv_ver_tbl.bin
(...)
```

### 5. How to build Security BSP

(docker is used)

```bash
# Step 1: Prepare clone arm-trusted-firmware Code from GitHub
root@5b37c152a18b:/home/tzdong/s4_scp_sample/security_bsp# git clone  https://github.com/renesas-rcar/arm-trusted-firmware
root@5b37c152a18b:/home/tzdong/s4_scp_sample/security_bsp# cd arm-trusted-firmware/
root@5b37c152a18b:/home/tzdong/s4_scp_sample/security_bsp/arm-trusted-firmware# git checkout rcar-s4_v2.5
root@5b37c152a18b:/home/tzdong/s4_scp_sample/security_bsp/arm-trusted-firmware# git log --oneline -20
b5ad4738d (HEAD -> rcar-s4_v2.5, origin/rcar-s4_v2.5, origin/HEAD) rcar-gen4: BL31: change scmi-sys-suspend and self-refresh sequence
c005892fd rcar-gen4: plat: BL31: SCMI_SYS_PWR_PROTO version mismatch W/A
(...)

# Step 2: Please build Security BSP
root@5b37c152a18b:/home/tzdong/s4_scp_sample/security_bsp/arm-trusted-firmware# source /opt/poky/3.1.11/environment-setup-aarch64-poky-linux 
root@5b37c152a18b:/home/tzdong/s4_scp_sample/security_bsp/arm-trusted-firmware# unset LDFLAGS
root@5b37c152a18b:/home/tzdong/s4_scp_sample/security_bsp/arm-trusted-firmware# make bl31 rcar_srecord PLAT=rcar_gen4 LSI=S4 SPD=opteed MBEDTLS_COMMON_MK=1 CTX_INCLUDE_AARCH32_REGS=0 LOG_LEVEL=10 DEBUG=0 SET_SCMI_PARAM=1
(...)
generating srec: /home/tzdong/s4_scp_sample/security_bsp/arm-trusted-firmware/build/rcar_gen4/release/bl31.srec

# copy bl31.srec from docker
dongtz@renesas-abd:~/work/s4/s4_scp_sample_app$ docker cp tzdong_xos_dev:/home/tzdong/s4_scp_sample/security_bsp/arm-trusted-firmware/build/rcar_gen4/release/bl31.srec .
```

## How to launch SCP sample environment on Spider board
| File Name | Program Top Address | Flash Save Address | Description |
|-|-|-|-|
| bootparam_sa0.srec | 0xEB200000 | 0x00000000 | ICUMX IPL, boot parameter |
| icumx_loader.srec | 0xEB210000 | 0x00040000 | ICUMX IPL |
| cert_header_sa9.srec | 0xEB230000 | 0x00240000 | ICUMX IPL, certification |
| App_SCP_S4_Sample.s37 | 0x00000000 | 0x00900000 | G4MH SCP sample application |
| App_SCP_S4_Sample.srec | 0xE2100000 | 0x00500000 | CR52 SCP sample application |
| bl31.srec | 0x04640000 | 0x00007000 | Security BSP |

## How to test SCP sample environment on Spider board
```bash
# 1. Test Base Protocol from Linux
root@spider:~# dmesg | grep arm-scmi
root@spider:~#

# 2.  Test the SCMI reset from Linux
root@spider:~# reboot
[  OK  ] Stopped target Multi-User System.
[  OK  ] Stopped target Login Prompts.
[  OK  ] Stopped target Timers.
(...)

# 3. Test the SCMI shutdown from Linux
root@spider:~# echo 0 > /sys/devices/system/cpu/cpu1/online
[  103.433633] IRQ225: set affinity failed(-22).
[  103.433810] CPU1: shutdown
[  103.434336] psci: CPU1 killed (polled 0 ms)
root@spider:~# echo 0 > /sys/devices/system/cpu/cpu2/online
[  132.821710] IRQ225: set affinity failed(-22).
[  132.821876] CPU2: shutdown
[  132.822396] psci: CPU2 killed (polled 0 ms)
root@spider:~# echo 0 > /sys/devices/system/cpu/cpu3/online
[  153.573659] IRQ225: set affinity failed(-22).
[  153.573805] CPU3: shutdown
[  153.574324] psci: CPU3 killed (polled 0 ms)
root@spider:~# echo 0 > /sys/devices/system/cpu/cpu4/online
[  182.849413] IRQ225: set affinity failed(-22).
[  182.849541] CPU4: shutdown
[  182.850027] psci: CPU4 killed (polled 0 ms)
root@spider:~# echo 0 > /sys/devices/system/cpu/cpu5/online
[  198.101477] IRQ225: set affinity failed(-22).
[  198.101589] CPU5: shutdown
[  198.102108] psci: CPU5 killed (polled 0 ms)
root@spider:~# echo 0 > /sys/devices/system/cpu/cpu6/online
[  214.009252] IRQ225: set affinity failed(-22).
[  214.009384] CPU6: shutdown
[  214.009877] psci: CPU6 killed (polled 0 ms)
root@spider:~# echo 0 > /sys/devices/system/cpu/cpu7/online
[  224.321316] IRQ225: set affinity failed(-22).
[  224.321430] CPU7: shutdown
[  224.321962] psci: CPU7 killed (polled 0 ms)
root@spider:~# shutdown -h now
------------------------------------------------------------[850mA -> 700mA]

# 4. Test the SCMI suspend to RAM from Linux
# //To preparatory operation for Graceful reset, shutdown, and suspend of CA, G4MH, and CR52.
root@spider:~# devmem2 0xe6348000 l 0x00002001
/dev/mem opened.
[SCMemory mapped at address 0xffff97fa7000.
Read at address  0xE6348000 (0xffff97fa7000): 0x0000000000000000
Write at address 0xEP 6348000 (0xffff97fa7000): 0x0000000000002001, readback 0x0000000000002001
G4MH] [main:1310] triggered test
                                [SCP G4MH] [handle_test:1204] handle test: test_step_bit=0x0
                                                                                            [SCP G4MH] [handle_register_notifier_callback:1189] handle register notifier callback test: command_id_bit=0x0
             [SCP G4MH] [test_R_SCP_System_SetPwrNotifyCallback:1002] test_R_SCP_System_SetPwrNotifyCallback
                                                                                                            [SCP G4MH] [test_R_SCP_System_SetPwrNotifyCallback:1056] SCP_Protocol_System_SetPwrNotifyCallback No:2 cbfunc=0xA854, ret_exp=0x0, ret_act=0x0
                                                             [SCP G4MH] [test_R_SCP_System_SetPwrNotifyCallback:1059] result: OK
                                                                                                                                root@spider:~# devmem2 0xe6348000 l 0x00001003
/dev/mem opened.
Memory mapped at address 0xffffa8c68000.
[Read at address  0xE6348000 (0xffffa8c68000): 0x0000000000000000
Write at address 0xE6348000 (0xffffa8c68000): 0x0000000000001003, readback 0x0000000000001003
SCP G4MH] [main:1310] triggered test
                                    [SCP G4MH] [handle_test:1204] handle test: test_step_bit=0x01
                                                                                                 [SCP G4MH] [handle_register_notify_send:1197] handle register notify send test: command_id_bit=0x0
      [SCP G4MH] [test_R_SCPSystem_Power_State_Notify:671] test_R_SCPSystem_Power_State_Notify
                                                                                              [SCP G4MH] [test_R_SCPSystem_Power_State_Notify:710] SCP_Protocol_System_Power_State_Notify No:1 notify_enable=1, ret_exp=0x0, ret_act=0x0
                                           [SCP G4MH] [test_R_SCPSystem_Power_State_Notify:713] result: OK
                                                                                                          root@spider:~# devmem2 0xe6349000 l 0x00002001
/dev/mem opened.
Memory mapped at address 0xffffa302f000.
Read at address  0xE6349000 (0xffffa302f000): 0x0000000000000000
Write at address 0xE6349000 (0xffffa302f000): 0x0000000000002001, readback 0x0000000000002001
root@spider:~# devmem2 0xe6349000 l 0x00001003
/dev/mem opened.
Memory mapped at address 0xffff9bc32000.
Read at address  0xE6349000 (0xffff9bc32000): 0x0000000000002001
Write at address 0xE6349000 (0xffff9bc32000): 0x0000000000001003, readback 0x0000000000001003

//Execute suspend to RAM
root@spider:~# echo 0 > /sys/module/printk/parameters/console_suspend
root@spider:~# echo mem > /sys/power/state
[  865.290508] PM: suspend entry (deep)
[  865.290966] Filesystems sync: 0.000 seconds
[  865.294045] Freezing user space processes ... (elapsed 0.001 seconds) done.
[  865.296366] OOM killer disabled.
[  865.296579] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[  865.328100] renesas_eth_sw e68c0000.ethernet tsn0: Link is Down
[  865.338724] Disabling non-boot CPUs ...
[  865.339755] IRQ225: set affinity failed(-22).
[  865.339850] CPU1: shutdown
[  865.340338] psci: CPU1 killed (polled 0 ms)
[  865.343285] IRQ225: set affinity failed(-22).
[  865.343361] CPU2: shutdown
[  865.343850] psci: CPU2 killed (polled 0 ms)
[  865.346346] IRQ225: set affinity failed(-22).
[  865.346410] CPU3: shutdown
[  865.346901] psci: CPU3 killed (polled 0 ms)
[  865.349714] IRQ225: set affinity failed(-22).
[  865.349784] CPU4: shutdown
[  865.350410] psci: CPU4 killed (polled 0 ms)
[  865.353202] IRQ225: set affinity failed(-22).
[  865.353253] CPU5: shutdown
[  865.353736] psci: CPU5 killed (polled 0 ms)
[  865.356607] IRQ225: set affinity failed(-22).
[  865.356669] CPU6: shutdown
[  865.357158] psci: CPU6 killed (polled 0 ms)
[  865.359959] IRQ225: set affinity failed(-22).
[  865.360011] CPU7: shutdown
[  865.360515] psci: CPU7 killed (polled 0 ms)
N:ICUMX Loader Rev.0.22.0
N:Built : 14:30:50, Nov 16 2023
N:PRR is R-Car S4 Ver1.2
N:Boot device is QSPI Flash(40MHz)
N:LCM state is CM
N:Normal boot(ICUMX)
(...)
------------------------------------------------------------[850mA -> 430mA]

# 5 Test the SCMI reset from CR52 and G4MH
# from G4MH Graceful Reset
root@spider:~# devmem2 0xE6348000 l 0x00007067
/dev/mem opened.
Memory mapped at address 0xffff87d5a000.
[Read at address  0xE6348000 (0xffff87d5a000): 0x0000000000000000
Write at address 0xE6348000 (0xffff87d5a000): 0x0000000000007067, readback 0x0000000000007067
SCP G4MH] [main:1310] troot@spider:~# riggered test
                                                   [SCP G4MH] [handle_test:1204] handle test: test_step_bit=0x03
                                                                                                                [SCP G4MH] [handle_system_power_test:1155] handle system power test: command_id_bit=0x03
           [SCP G4MH] [test_R_SCP_System_Power_State_Set:522] test_R_SCP_System_Power_State_Set No. 07
                                                                                                      N:ICUMX Loader Rev.0.22.0
N:Built : 14:30:50, Nov 16 2023
(...)


# from CR52 Graceful Reset
root@spider:~# devmem2 0xE6349000 l 0x00007067
/dev/mem opened.
Memory mapped at address 0xffff8202c000.
Read at address  0xE6349000 (0xffff8202c000): 0x0000000000007067
Write at address 0xE6349000 (0xffff8202c000): 0x0000000000007067, readback 0x0000000000007067

# from G4MH Forceful Reset
root@spider:~# devmem2 0xE6348000 l 0x00001067
/dev/mem opened.
Memory mapped at address 0xffffae058000.
[SCP Read at address  0xE6348000 (0xffffae058000): 0x0000000000000000
Write at address 0xE6348000 (0xffffae058000): 0x00000000000010G4MH67, readback 0x0000000000001067
] [main:1310] triggered test
                            [SCP G4MH] [handle_test:1204] handle test: test_step_bit=0x03
                                                                                         [SCP G4MH] [handle_system_power_test:1155] handle system power test: command_id_bit=0x03
                                                                                                                                                                                 [SCP G4MH] [test_R_SCP_System_Power_State_Set:522] test_R_SCP_System_Power_State_Set No. 01
                                                                               N:ICUMX Loader Rev.0.22.0
N:Built : 14:30:50, Nov 16 2023
(...)

# from CR52 Forceful Reset
root@spider:~# devmem2 0xE6349000 l 0x00001067
/dev/mem opened.
Memory mapped at address 0xffffaad7a000.
Read at address  0xE6349000 (0xffffaad7a000): 0x0000000000000000
Write at address 0xE6349000 (0xffffaad7a000): 0x0000000000001067, readback 0x0000000000001067
```

