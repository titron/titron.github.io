---
layout: post
title:  "u-boot command lists"
categories: basic
tags: uboot command
author: David
---

* content
{:toc}

---

?       - alias for 'help'

avb     - Provides commands for testing Android Verified Boot 2.0 functionality

base    - print or set address offset

bdinfo  - print Board Info structure

blkcache- block cache diagnostics and control

boot    - boot default, i.e., run 'bootcmd'

boota   - boot Android Image from mmc

bootd   - boot default, i.e., run 'bootcmd'

bootefi - Boots an EFI payload from memory

bootelf - Boot from an ELF image in memory

booti   - boot arm64 Linux Image image from memory

bootm   - boot application image from memory

bootp   - boot image via network using BOOTP/TFTP protocol

bootvx  - Boot vxWorks from an ELF image

bootz   - boot Linux zImage image from memory

cmp     - memory compare

coninfo - print console devices and information

cp      - memory copy

crc32   - checksum calculation

dcache  - enable or disable data cache

dhcp    - boot image via network using DHCP/TFTP protocol

dm      - Driver model low level access

dtboinfo- dtboinfo [a|b]

echo    - echo args to console

editenv - edit environment variable

env     - environment handling commands

erase   - erase FLASH memory

exit    - exit script

ext2load- load binary file from a Ext2 filesystem

ext2ls  - list files in a directory (default /)

ext4load- load binary file from a Ext4 filesystem

ext4ls  - list files in a directory (default /)

ext4size- determine a file's size

ext4write- create a file in the root directory

false   - do nothing, unsuccessfully

fastboot- run as a fastboot usb or udp device

fatinfo - print information about filesystem

fatload - load binary file from a dos filesystem

fatls   - list files in a directory (default /)

fatsize - determine a file's size

fatwrite- write file into a dos filesystem

fdt     - flattened device tree utility commands

flinfo  - print FLASH memory information

fstype  - Look up a filesystem type

fsuuid  - Look up a filesystem UUID

go      - start application at address 'addr'

gpio    - query and control gpio pins

gpt     - GUID Partition Table

guid    - GUID - generate Globally Unique Identifier based on random UUID

gzwrite - unzip and write memory to block device

help    - print command description/usage

i2c     - I2C sub-system

icache  - enable or disable instruction cache

iminfo  - print header information for application image

imxtract- extract a part of a multi-image

itest   - return true/false on integer compare

load    - load binary file from a filesystem

loadb   - load binary file over serial line (kermit mode)

loads   - load S-Record file over serial line

loadx   - load binary file over serial line (xmodem mode)

loady   - load binary file over serial line (ymodem mode)

loop    - infinite loop on address range

ls      - list files in a directory (default /)

lzmadec - lzma uncompress a memory region

md      - memory display

mdio    - MDIO utility commands

mii     - MII utility commands

mm      - memory modify (auto-incrementing address)

mmc     - MMC sub system, [mmc command](https://u-boot.readthedocs.io/en/latest/usage/mmc.html)

mmcinfo - display MMC info

mw      - memory write (fill)

nfs     - boot image via network using NFS protocol

nm      - memory modify (constant address)

ping    - send ICMP ECHO_REQUEST to network host

printenv- print environment variables

protect - enable or disable FLASH write protection

reset   - Perform RESET of the CPU

run     - run commands in an environment variable

save    - save file to a filesystem

saveenv - save environment variables to persistent storage

setenv  - set environment variables

setexpr - set environment variable as the result of eval expression

showvar - print local hushshell variables

size    - determine a file's size

sleep   - delay execution for some time

source  - run script from memory

test    - minimal test like /bin/sh

tftpboot- boot image via network using TFTP protocol

true    - do nothing, successfully

unzip   - unzip a memory region

usb     - USB sub-system

usbboot - boot from USB device

uuid    - UUID - generate random Universally Unique Identifier

version - print monitor, compiler and linker version
