#!/bin/bash

#
# Copyright (C) Renesas Electronics Corporation 2017-2018 All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

set -eu

TOP=`pwd`

ABSPV=v5.3.0
VERSION=9.0.0_r35
WORK=${TOP}/../mydroid/
USE_REFERENCE_OPTION="NO"
DATE=`date +"%Y%m%d_%H%M%S"`

HAVE_OMX=${HAVE_OMX:="YES"}
HAVE_ADSP=${HAVE_ADSP:="YES"}
#echo ${HAVE_OMX} ${HAVE_ADSP}

source ./target_dir.sh

if [ ${USE_REFERENCE_OPTION} = "NO" ] ; then
	REFERENCE_IPL=""
	REFERENCE_OPTEE=""
	REFERENCE_UBOOT=""
	REFERENCE_KERNEL=""
else
	REFERENCE_IPL="--reference /home/git/arm-trusted-firmware.git/"
	REFERENCE_OPTEE="--reference /home/git/optee_os.git/"
	REFERENCE_UBOOT="--reference /home/git/u-boot.git/"
	REFERENCE_KERNEL="--reference /home/git/linux.git/"
fi

ls ${WORK} || exit

#
# hardware/renesas/
#
# |-- hardware
# |   |-- hardware.renesas.*.tar.gz
#
hardware()
{
echo && echo "Hardware:"
cd ${WORK}
	mkdir -p hardware/renesas
	cd hardware/renesas
		echo && pwd
		tar zxvf ${TOP}/hardware/hardware.renesas.s492c.tar.gz
		for td in ${added_dir_hardware[@]}; do
			# echo ${td} | sed -e 's/^.*\///'
			tar zxvf ${TOP}/hardware/hardware.renesas.`echo ${td} | sed -e 's/^.*\///'`.tar.gz
		done
if [ ${HAVE_OMX} = "YES" ]; then
		for td in ${added_dir_hardware_omx[@]}; do
			# echo ${td} | sed -e 's/^.*\///'
			tar zxvf ${TOP}/hardware/hardware.renesas.`echo ${td} | sed -e 's/^.*\///'`.tar.gz
		done
fi
cd ${WORK}
}

#
# vendor/renesas/
#
# `-- vendor
#     `-- vendor.renesas.tar.gz
#
vendor()
{
echo && echo "Vendor:"
cd ${WORK}
	mkdir -p vendor/
	cd vendor/
		echo && pwd
		tar zxvf ${TOP}/vendor/vendor.renesas.tar.gz
		cd renesas/firmware/usb/
			wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/r8a779x_usb3_v2.dlmem
			wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/r8a779x_usb3_v3.dlmem
cd ${WORK}
}

#
# external/i2c-tools
#
# |-- i2c-tools
# |   `-- 0001-Move-i2cset-binary-to-vendor-partition.patch
#
i2c-tools()
{
echo && echo "i2c-tools:"
cd ${WORK}
	cd external
		echo && pwd
		if [ ! -d i2c-tools ]; then
			git clone https://github.com/suapapa/i2c-tools
			cd i2c-tools
				git checkout b1bef14300a951d0a5ba02a43a05977bb5624fda
				patch -p1 < ${TOP}/i2c-tools/0001-Move-i2cset-binary-to-vendor-partition.patch
				patch -p1 < ${TOP}/i2c-tools/0002-Android.mk-Fixed-build-rules-for-VNDK-build-support.patch
			
		fi
cd ${WORK}
}


#
# device/renesas/salvator
#
# |-- renesas
# |   `-- device.renesas.salvator.tar.gz
#
salvator()
{
echo && echo "Salvator:"
cd ${WORK}
	mkdir -p device/renesas/salvator
	cd device/renesas/salvator
		echo && pwd
		tar zxvf ${TOP}/renesas/device.renesas.salvator.tar.gz
cd ${WORK}
}

#
# device/renesas/common
#
# |-- renesas
# |   `-- device.renesas.common.tar.gz
#
common()
{
echo && echo "Common:"
cd ${WORK}
	mkdir -p device/renesas/common
	cd device/renesas/common
		echo && pwd
		tar zxvf ${TOP}/renesas/device.renesas.common.tar.gz
cd ${WORK}
}

#
# device/renesas/ulcb
#
# |-- renesas
# |   `-- device.renesas.ulcb.tar.gz
#
ulcb()
{
echo && echo "Ulcb:"
cd ${WORK}
	mkdir -p device/renesas/ulcb
	cd device/renesas/ulcb
		echo && pwd
		tar zxvf ${TOP}/renesas/device.renesas.ulcb.tar.gz
cd ${WORK}
}

#
# device/renesas/kingfisher
#
# |-- renesas
# |   `-- device.renesas.kingfisher.tar.gz
#
kingfisher()
{
echo && echo "Kingfisher:"
cd ${WORK}
	mkdir -p device/renesas/kingfisher
	cd device/renesas/kingfisher
		echo && pwd
		tar zxvf ${TOP}/renesas/device.renesas.kingfisher.tar.gz
cd ${WORK}

# Bluetooth/WIFI firmware and NOTICE
cd ${WORK}
cd ..
	git clone ${WORK}/device/linaro/hikey
	cd hikey
		git checkout a5ec180c8cee90099b6e35080e156a810b9e6f3c
	cd ..
	cp -rf hikey/bt-wifi-firmware-util/TIInit_11.8.32-pcm-960.bts  ${WORK}/device/renesas/kingfisher/wlan/wl18xx_fw/TIInit_11.8.32.bts
	cp -rf hikey/bt-wifi-firmware-util/wl18xx-conf-wl1837mod.bin   ${WORK}/device/renesas/kingfisher/wlan/wl18xx_fw/wl18xx-conf.bin
	cp -rf hikey/bt-wifi-firmware-util/NOTICE                      ${WORK}/device/renesas/kingfisher/wlan/wl18xx_fw/
	rm -fr hikey

	git clone git://git.ti.com/wilink8-wlan/wl18xx_fw.git
	cd wl18xx_fw
		git checkout c0a99bffe1364fb5b31fca6fbf5bbb4460b971d4
	cd ../
	cp -fr wl18xx_fw/wl18xx-fw-4.bin ${WORK}/device/renesas/kingfisher/wlan/wl18xx_fw/
	rm -fr wl18xx_fw
cd ${WORK}
}

#
# device/renesas/kingfisher/hal/radio/fw/
#
si-tools()
{
cd ${WORK}
	mkdir ${TOP}/../si-tools.${DATE}
	cd ${TOP}/../si-tools.${DATE}
		git clone https://github.com/CogentEmbedded/meta-rcar.git
		cd meta-rcar
		git checkout origin/v2.23.0
		cd meta-rcar-gen3-adas/recipes-bsp/si-tools/files
		tar -xzvf si-tools.tar.gz
		cd si-tools/firmware/

		cp -rf patch.bin ${WORK}/device/renesas/kingfisher/hal/radio/fw/
		cp -rf am.bif ${WORK}/device/renesas/kingfisher/hal/radio/fw/
		cp -rf fm.bif ${WORK}/device/renesas/kingfisher/hal/radio/fw/
	rm -fr ${TOP}/../si-tools.${DATE}
cd ${WORK}
}

#
# device/renesas/proprietary/adsp
#
renesas-adsp()
{
echo && echo "Adsp:"
cd ${WORK}
	mkdir -p device/renesas/proprietary
	cd device/renesas/proprietary
		echo && pwd
		tar xvf ${TOP}/renesas-adsp/renesas.adsp.tar.gz
cd ${WORK}
}

#
# device/renesas/proprietary/imgtec/
#
# |-- renesas-imgtec
# |   |-- renesas.imgtec.prebuilts.tar.gz
# |   `-- renesas.imgtec.rogue_km.tar.gz
#
renesas-imgtec()
{
echo && echo "GFX:"
cd ${WORK}
	mkdir -p device/renesas/proprietary
	cd device/renesas/proprietary
		echo && pwd
		tar xvf ${TOP}/renesas-imgtec/renesas.imgtec.prebuilts.common.tar.gz
		tar xvf ${TOP}/renesas-imgtec/renesas.imgtec.prebuilts.tar.gz
		tar xvf ${TOP}/renesas-imgtec/renesas.imgtec.rogue_km.tar.gz
cd ${WORK}
}

#
# device/renesas/proprietary/omx/
#
# |-- renesas-omx
# |   |-- make_renesas-omx.sh
# |   |-- omx_skeleton.tar.gz
# |   `-- renesas.omx.tar.gz
#
renesas-omx()
{
echo && echo "OMX:"
cd ${WORK}
	mkdir -p device/renesas/proprietary
	cd device/renesas/proprietary
		echo && pwd
		tar xvf ${TOP}/renesas-omx/renesas.omx.tar.gz
cd ${WORK}
}

#
# device/renesas/bootloaders/
#
# |-- bootloaders
# |   |-- ipl.*.bundle
# |   |-- ipl.qos2120.H3v11.patch
# |   |-- optee.*.bundle
# |   `-- u-boot.*.bundle
#
bootloaders()
{
echo && echo "IPL"
cd ${WORK}
	mkdir -p device/renesas/bootloaders
	cd device/renesas/bootloaders
		if [ ! -d ipl ]; then
			echo && pwd
			git clone https://github.com/renesas-rcar/arm-trusted-firmware.git ipl ${REFERENCE_IPL}
			cd ipl
				git remote update
				git status
				git bundle unbundle ${TOP}/bootloaders/ipl.${ABSPV}.bundle
				git checkout ce9f8798df18abf979fa3dff1272fd3776f7ad43
		fi

			#patch -p1 < ${TOP}/bootloaders/ipl.qos2120.H3v11.patch

cd ${WORK}

echo && echo "optee"
cd ${WORK}
	mkdir -p device/renesas/bootloaders
	cd device/renesas/bootloaders
		if [ ! -d optee ]; then
			echo && pwd
			git clone https://github.com/renesas-rcar/optee_os.git optee ${REFERENCE_OPTEE}
			cd optee
				git remote update
				git status
				git bundle unbundle ${TOP}/bootloaders/optee.${ABSPV}.bundle
				git checkout 89b9d9b1961634d145faaa3e929a0fe7ce011389
		fi

cd ${WORK}

echo && echo "U-Boot"
cd ${WORK}
	mkdir -p device/renesas/bootloaders
	cd device/renesas/bootloaders
	if [ ! -d u-boot ]; then
		echo && pwd
		git clone https://github.com/renesas-rcar/u-boot.git u-boot ${REFERENCE_UBOOT}
		cd u-boot
			git remote update
			git status
			git bundle unbundle ${TOP}/bootloaders/u-boot.${ABSPV}.bundle
			git checkout 74e87ec17659fe32e5b706d4f45c1bf33533db14
	fi

cd ${WORK}
}

#
# device/renesas/kernel
#
# |-- kernel
# |   `-- kernel.*.bundle
#
kernel()
{
echo && echo "Kernel:"
cd ${WORK}
	mkdir -p device/renesas
	cd device/renesas
	if [ ! -d kernel ]; then
		echo && pwd
		git clone https://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas-bsp.git kernel ${REFERENCE_KERNEL}
		cd kernel
			git remote add android https://android.googlesource.com/kernel/common
			git remote update
			git status

			git bundle unbundle ${TOP}/kernel/kernel.${ABSPV}.bundle
			git checkout 0e1e8d82f6c3e39345462d86e83bb478223fbad0
	fi

cd ${WORK}
}

#
# device/renesas/linux-firmware
#
linux-firmware()
{
echo && echo "Linux-firmware:"
cd ${WORK}
	mkdir -p device/renesas
	cd device/renesas
	if [ ! -f linux-firmware_1.127.20.tar.gz ]; then
		echo && pwd
		wget https://launchpad.net/ubuntu/+archive/primary/+files/linux-firmware_1.127.20.tar.gz
		tar zxvf linux-firmware_1.127.20.tar.gz
#		mkdir -p salvator-kernel/firmware/rtlwifi/
#		cp linux-firmware/rtlwifi/rtl8188eufw.bin salvator-kernel/firmware/rtlwifi/
#		cp linux-firmware/rtlwifi/rtl8192cufw.bin salvator-kernel/firmware/rtlwifi/
	fi
cd ${WORK}
}

#
# prebuilts/gcc/linux-x86/aarch64/aarch64-linux-gnu
#  aarch64-linux-gnu-gcc (Linaro GCC 7.3-2018.05) 7.3.1 20180425
#
# |-- aarch64-linux-gnu
# |   `-- Android.mk
#
aarch64-linux-gnu()
{
echo && echo "aarch64-linux-gnu:"
cd ${WORK}
	cd prebuilts/gcc/linux-x86/aarch64/
	if [ ! -f gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar ]; then
		wget https://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/aarch64-linux-gnu/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz
		xz -vd   gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz
		tar -xvf gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar
		mv gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu aarch64-linux-gnu
		cp ${TOP}/aarch64-linux-gnu/Android.mk aarch64-linux-gnu/Android.mk
	fi
cd ${WORK}
}

#
# patch for AOSP
#
# |-- aosp_patches
# |   |-- bionic
# ..
#
apply_aosp_patch()
{
PATCH=${TOP}/aosp_patches
echo && echo "Patch:"
cd ${WORK}
	for td in ${changed_dir[@]}; do
		cd ${td}
			echo && echo && pwd
			git checkout android-${VERSION}
			ls -asl ${PATCH}/${td}/*
			git am ${PATCH}/${td}/*
		cd ${WORK}
	done
cd ${WORK}
}

#
# patch for AOSP
#
delete_unnecessary()
{
echo && echo "Unnecessary:"
cd ${WORK}
	for td in ${removed_dir[@]}; do
		rm -fr ${td}
	done
cd ${WORK}
}

hardware
vendor
i2c-tools
salvator
common
ulcb
kingfisher
si-tools
renesas-imgtec

if [ ${HAVE_OMX} = "YES" ]; then
	renesas-omx
fi

if [ ${HAVE_ADSP} = "YES" ]; then
	renesas-adsp
fi

bootloaders
kernel

##linux-tfirmware
aarch64-linux-gnu
apply_aosp_patch
##delete_unnecessary

echo
echo "Done"
echo
