---
layout: post
title:  "Android P升级过程记录"
categories: software
tags: Android, OTA, A/B update
author: David
---

* content
{:toc}

---

### 制作升级包					
【step 1】Prepare
```
mydroid$ export TARGET_BOARD_PLATFORM=r8a77965		
mydroid$ source build/envsetup.sh				
mydroid$ lunch salvator-userdebug				
mydroid$ make -j3				
…...			
[100% 66/66] Target vbmeta image: out/target/product/salvator/vbmeta.img			
					
#### build completed successfully (06:23 (mm:ss)) ####			
```
【step 2】make OTA package
```
mydroid$ make otapackage				#——会生成sd卡用的全部系统升级包
(or, mydroid$ make full_otapackage)				
…...			
[100% 75/75] Package OTA: out/target/product/salvator/salvator-ota-eng.dongtz.zip			
…...			
running:  java -Xmx2048m -Djava.library.path=out/host/linux-x86/lib64 -jar out/host/linux-x86/framework/signapk.jar -w build/target/product/security/testkey.x509.pem build/target/product/security/testkey.pk8 /tmp/tmpqPUopK.zip out/target/product/salvator/salvator-ota-eng.dongtz.zip			
done.			
					
#### build completed successfully (06:28 (mm:ss)) ####			
```
【step 3】Edit code				
修改代码以后。				
					
【step 4】re-make				
```
mydroid$ make				#——重新编译
mydroid$ make otapackage	#——重新生产升级包
mydroid$ ./build/tools/releasetools/ota_from_target_files -i <A package> <B package> <差分包名>				
/mydroid$ ./build/tools/releasetools/ota_from_target_files -i out/target/product/salvator/salvator-ota-eng.dongtz.zip out/target/product/salvator/salvator-ota-eng.dongtz.original.zip out/target/product/salvator/ota_diff_package.zip		#---这里有错误发生，也许还有bug，导致不能生成差分包		
Traceback (most recent call last):				
	  File "./build/tools/releasetools/ota_from_target_files", line 1996, in <module>				
	    main(sys.argv[1:])				
	  File "./build/tools/releasetools/ota_from_target_files", line 1887, in main				
	    OPTIONS.info_dict = common.LoadInfoDict(input_zip)				
	  File "/home/dongtz/work/android/android_v530_m3n/RENESAS_RCH3M3M3N_Android_P_ReleaseNote_2019_08E/mydroid/build/make/tools/releasetools/common.py", line 169, in LoadInfoDict				
	    raise ValueError("can't find META/misc_info.txt in input target-files")				
ValueError: can't find META/misc_info.txt in input target-files				

### 用升级包升级					
【方法1 】通过recovery实现				
通过recovery升级的功能进行实现的。				
Recovery提供的功能如下，使用apply update from sdcard功能即可升级OTA包。				
					
【方法2 】通过adb实现				
[参考这里](https://blog.csdn.net/YuZhuQue/article/details/90696640)				
					
可以通过adbroot/adb remount/adb push指令实现，但是需要连接到电脑PC端，且支持adb才行。				
```					
$ ./adb push -p /home/m3n_imgs/salvator-ota-eng.dongtz.zip /data/update.zip			
$ ./adb shell uncrypt  /data/update.zip   /cache/recovery/block.map			#---注意：要等待一段时间，直到命令执行退出…，然后在执行如下命令；			
$ ./adb shell "echo  \"--update_package=@/cache/recovery/block.map\"  > /cache/recovery/command"			
$ ./adb reboot recovery			#---注意：要多等待一段时间，直到升级完成。			
......
[    2.969568] read strings		
[    2.972384] android.hardware.health@2.0-impl: wakealarm_init: timerfd_create failed		
[    2.982487] audit: type=1400 audit(1576201012.192:7): avc:  denied  { wake_alarm } for  pid=1400 comm="charger" capability=35  scontext=u:r:charger:s0 tcontext=u:r:charger:s0 tclass=capability2 permissive=0		
[    2.983643] healthd: battery none chg=		#---这里要一直等待，不要断电，直到出现下面的log信息提示
[  123.044678] init: Received sys.powerctl='reboot,' from pid: 1401 (/sbin/recovery)		
[  123.052392] init: Clear action queue and start shutdown trigger		
[  123.058413] init: processing action (shutdown_done) from (<Builtin Action>:0)		
[  123.065652] init: Reboot start, reason: reboot,, rebootTarget:		
[  123.071825] init: Shutdown timeout: 6000 ms		
[  123.076064] init: terminating init services		
[  123.080274] init: Sending signal 15 to service 'recovery' (pid 1401) process group...		
[  123.089378] init: Sending signal 15 to service 'charger' (pid 1400) process group...		
[  123.097858] init: Sending signal 15 to service 'tee_supplicant' (pid 1398) process group...		
[  123.106414] init: Sending signal 15 to service 'ueventd' (pid 1064) process group...		
[  126.210034] reboot: Restarting system with command ''		
NOTICE:  R-Car M3N Initial Program Loader(CR7)		
NOTICE:  Initial Program Loader (Rev.2.0.7)		
NOTICE:  Built : 13:05:37, Apr  1 2021		
NOTICE:  PRR is R-Car M3N Ver.1.1		
```