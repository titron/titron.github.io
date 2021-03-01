#!/bin/bash

#
# Copyright (C) Renesas Electronics Corporation 2017-2019 All rights reserved.
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

HAVE_OMX=${HAVE_OMX:="YES"}
HAVE_ADSP=${HAVE_ADSP:="YES"}

#echo ${HAVE_OMX} ${HAVE_ADSP}

TOP=`pwd`
if [ $# -ne 1 ]; then
	echo "Usage: $ `basename $0` [H3|M3|M3N]" 1>&2
	exit 1
fi
##TARGET=${1:-H3}
TARGET=$1
if [ ${TARGET} = "H3" ] ; then
	echo "TARGET="$TARGET
	HAVE_VP9=${HAVE_VP9:="NO"}
	echo "HAVE_VP9="$HAVE_VP9
elif [ ${TARGET} = "M3" ] ; then
	echo "TARGET="$TARGET
	HAVE_VP9=${HAVE_VP9:="YES"}
	echo "HAVE_VP9="$HAVE_VP9
elif [ ${TARGET} = "M3N" ] ; then
	echo "TARGET="$TARGET
	HAVE_VP9=${HAVE_VP9:="YES"}
	echo "HAVE_VP9="$HAVE_VP9
else
	echo "Invalid TARGET="$TARGET
	exit 1
fi

#
# extract pkgs_dir/gfx/*
#
extract_gfx()
{
	ls ${TOP}/pkgs_dir/gfx

	cd ${TOP}/pkgs_dir/gfx
		rm -fr RCH3G001A9001ZDO_1_1_0        || true
	#	rm -fr RCH3G002A9001ZNI_0_0_8        || true
		rm -fr RTM0RC7795GQGG0001SA90C_1_1_0 || true
		rm -fr RCM3G001A9001ZDO_1_1_0        || true
	#	rm -fr RCM3G002A9001ZNI_0_0_8        || true
		rm -fr RTM0RC7796GQGG0001SA90C_1_1_0 || true
		rm -fr RCN3G001A9001ZDO_1_1_0        || true
	#	rm -fr RCN3G002A9001ZNI_0_0_8        || true
		rm -fr RTM0RC7796GQGGB001SA90C_1_1_0 || true


		if [ ${TARGET} = "H3" ] ; then
			# H3
			unzip RCH3G001A9001ZDO_1_1_0.zip
			mv ${TOP}/pkgs_dir/gfx/RCH3G001A9001ZDO_1_1_0/RCH3G001A9001ZDO/renesas.imgtec.rogue_km.tar.gz                ${TOP}/RELFILES/renesas-imgtec
			unzip RTM0RC7795GQGG0001SA90C_1_1_0.zip
			mv ${TOP}/pkgs_dir/gfx/RTM0RC7795GQGG0001SA90C_1_1_0/RTM0RC7795GQGG0001SA90C/Software/renesas.imgtec.prebuilts.tar.gz ${TOP}/RELFILES/renesas-imgtec
		elif [ ${TARGET} = "M3" ] ; then
			# M3
			unzip RCM3G001A9001ZDO_1_1_0.zip
			mv ${TOP}/pkgs_dir/gfx/RCM3G001A9001ZDO_1_1_0/RCM3G001A9001ZDO/renesas.imgtec.rogue_km.tar.gz                ${TOP}/RELFILES/renesas-imgtec
			unzip RTM0RC7796GQGG0001SA90C_1_1_0.zip
			mv ${TOP}/pkgs_dir/gfx/RTM0RC7796GQGG0001SA90C_1_1_0/RTM0RC7796GQGG0001SA90C/Software/renesas.imgtec.prebuilts.tar.gz ${TOP}/RELFILES/renesas-imgtec
		elif [ ${TARGET} = "M3N" ] ; then
			# M3N
			unzip RCN3G001A9001ZDO_1_1_0.zip
			mv ${TOP}/pkgs_dir/gfx/RCN3G001A9001ZDO_1_1_0/RCN3G001A9001ZDO/renesas.imgtec.rogue_km.tar.gz                ${TOP}/RELFILES/renesas-imgtec
			unzip RTM0RC7796GQGGB001SA90C_1_1_0.zip
			mv ${TOP}/pkgs_dir/gfx/RTM0RC7796GQGGB001SA90C_1_1_0/RTM0RC7796GQGGB001SA90C/Software/renesas.imgtec.prebuilts.tar.gz ${TOP}/RELFILES/renesas-imgtec
		fi

	cd ${TOP}
}

#
# extract pkgs_dir/omx/*
#
extract_omx()
{
	ls ${TOP}/pkgs_dir/omx

	cd RELFILES/renesas-omx/
		HAVE_VP9=${HAVE_VP9} ./make_renesas-omx.sh              ${TOP}/pkgs_dir/omx for_make_source_code
		HAVE_VP9=${HAVE_VP9} ./make_hardware.renesas.omx.sh     ${TOP}/pkgs_dir/omx for_make_source_code
		                     ./make_hardware.renesas.uvcs_km.sh ${TOP}/pkgs_dir/omx
	cd ${TOP}
}
#
# extract pkgs_dir/adsp/*
#
extract_adsp()
{
	ls ${TOP}/pkgs_dir/adsp

	cd RELFILES/renesas-adsp/
		./make_renesas-adsp.sh ${TOP}/pkgs_dir/adsp
		./make_hardware.renesas.s492c.sh ${TOP}/pkgs_dir/adsp
	cd ${TOP}
}

#
# procedure
#

rm ${TOP}/RELFILES/renesas-imgtec/renesas.imgtec.prebuilts.tar.gz || true
rm ${TOP}/RELFILES/renesas-imgtec/renesas.imgtec.rogue_km.tar.gz  || true
extract_gfx

if [ ${HAVE_OMX} = "YES" ]; then
	rm ${TOP}/RELFILES/renesas-omx/renesas.omx.tar.gz  || true
	extract_omx
fi
if [ ${HAVE_ADSP} = "YES" ]; then
	rm ${TOP}/RELFILES/renesas-adsp/renesas.adsp.tar.gz  || true
	extract_adsp
fi

#./buildenv.sh # titron comment
### titron start
MYDROID_DIR=mydroid
cd ${TOP}
if [ ! -d ${MYDROID_DIR} ]; then
	./buildenv.sh
fi
### titron end

##sed -i -e "s/USE_REFERENCE_OPTION=\"NO\"/USE_REFERENCE_OPTION=\"YES\"/" RELFILES/apply_patch.sh
cd RELFILES
	HAVE_OMX=${HAVE_OMX} HAVE_ADSP=${HAVE_ADSP} ./apply_patch.sh
cd ${TOP}
echo "Done : TARGET="$TARGET "HAVE_VP9="$HAVE_VP9
