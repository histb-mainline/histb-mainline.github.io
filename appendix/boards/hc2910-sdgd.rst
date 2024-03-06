HC2910 (Shandong Broadnet)
==========================

Board
-----

.. image:: /_images/hc2910-sdgd-top.thumb.jpg
  :target: ../../_images/hc2910-sdgd-top.jpg
  :width: 25%
  :alt: Board top view

.. image:: /_images/hc2910-sdgd-bottom.thumb.jpg
  :target: ../../_images/hc2910-sdgd-bottom.jpg
  :width: 25%
  :alt: Board bottom view

::ref:`USB_BOOT <USB Boot>`: See below

.. image:: /_images/hc2910-sdgd-usb-boot.jpg
  :width: 25%
  :alt: USB Boot pin

bootargs
--------

.. code-block:: none

  baudrate=115200
  bootargs=console=ttyAMA0,115200 blkdevparts=mmcblk0:2M(fastboot),2M(bootargs),2M(bootargsbak),10M(recovery),10M(recoverybak),2M(properties),2M(markparam),2M(baseparam),2M(pqparam),20M(logo),40M(fastplay),20M(kernel),2M(misc),50M(private),2M(tpl),100M(factory),600M(otapackage),100M(cache),800M(system),-(userdata) quiet
  bootargs_1G=mem=1G mmz=ddr,0,0,44M
  bootargs_2G=mem=2G mmz=ddr,0,0,44M
  bootargs_3840M=mem=1G mmz=ddr,0,0,44M
  bootargs_512M=mem=512M mmz=ddr,0,0,44M
  bootargs_768M=mem=768M mmz=ddr,0,0,44M
  bootcmd=mmc read 0 0x1FFBFC0 0x2F000 0x5000; bootm 0x1FFBFC0
  bootdelay=0
  bootfile="uImage"
  gmac_debug=0
  ipaddr=192.168.1.10
  netmask=255.255.255.0
  phy_addr=2,1
  phy_intf=mii,rgmii
  serverip=192.168.1.1
  stderr=serial
  stdin=serial
  stdout=serial
  use_mdio=0,1
  verify=n

Flash layout
------------

.. table::

  ===========  ======  ====  ==============================================
  Name         Offset  Size  Description
  ===========  ======  ====  ==============================================
  fastboot     0M      2M    :doc:`/software/bootrom/bootloader`
  bootargs     2M      2M    U-Boot env file, sector size: ``0x10000``
  bootargsbak  4M      2M    bootargs backup
  recovery     5M      10M   U-Boot legacy uImage
  recoverybak  5M      10M   recovery backup
  properties   5M      2M    ``hw_version`` ``chip_type`` ``soc_type`` ``stb_manufacturer`` ``stb_id`` ``mac`` ``stb_factorytest_finish``
  markparam    5M      2M    ?
  baseparam    22M     2M    ``hi_drv_pdm.h``
  pqparam      26M     2M    Video Post Processing parameters
  logo         30M     20M   ``LOGO_TABLE``
  fastplay     34M     40M   Fastboot DRM parameters (optional)
  kernel       82M     20M   Android bootimg
  misc         50M     2M    empty
  private      82M     50M   ext3/4, Android ``/private`` partition
  tpl          82M     1M    squashfs, Android ``/tpl`` partition

                             ``libHA.AUDIO.TPL.decode.so``
  factory      58M     100M  U-Boot legacy uImage
  otapackage   94M     600M  ext3/4, Android ``/otapackage`` partition

                             A single ``upgrade/update.zip``.
  cache        442M    100M  ext3/4, Android ``/cache`` partition
  system       782M    800M  ext3/4, Android ``/system`` partition
  userdata     1302M         ext3/4, Android ``/data`` partition
  ===========  ======  ====  ==============================================

Fastboot
--------

.. code-block:: none

  fastboot# getinfo ddrfree
  DDR free region baseaddr:0x1000000 size:0x3F000000

.. code-block:: none

  fastboot# help
  ?       - alias for 'help'
  base    - print or set address offset
  bootm   - boot application image from memory
  bootp   - boot image via network using BOOTP/TFTP protocol
  clear_bootf- clear Hibernate!! bootflag
  cmp     - memory compare
  cp      - memory copy
  crc32   - checksum calculation
  ddr     - ddr training function
  fatinfo - print information about filesystem
  fatload - load binary file from a dos filesystem
  fatls   - list files in a directory (default /)
  fdt     - flattened device tree utility commands
  getinfo - print hardware information
  go      - start application at address 'addr'
  help    - print command description/usage
  hibernate- Hibernate!! boot
  ir      - IR command:
  loadb   - load binary file over serial line (kermit mode)
  loady   - load binary file over serial line (ymodem mode)
  loop    - infinite loop on address range
  md      - memory display
  mii     - MII utility commands
  mm      - memory modify (auto-incrementing address)
  mmc     - MMC sub system
  mmcinfo - mmcinfo <dev num>-- display MMC info
  mtest   - simple RAM read/write test
  mw      - memory write (fill)
  nand    - NAND sub-system
  nboot   - boot from NAND device
  nm      - memory modify (constant address)
  otp_burntoecurechipset- Burn to secure chipset, please be careful !!!
  otp_getcustomerkey- otp_getcustomerkey
  otp_getstbprivdata- otp_getstbprivdata
  otp_gettrustzonestat- Get TEE status
  otp_setstbprivdata- StbPrivData
  otp_settrustzone- Set TEE enable
  otpreadall- read otp ,for example otpreadall
  otpwrite- write otp ,for example otpwrite adddress value
  ping    - send ICMP ECHO_REQUEST to network host
  printenv- print environment variables
  rarpboot- boot image via network using RARP/TFTP protocol
  reset   - Perform RESET of the CPU
  saveenv - save environment variables to persistent storage
  setenv  - set environment variables
  tftp    - tftp  - download or upload image via network using TFTP protocol
  unzip   - unzip a memory region
  uploadx - upload binary file over serial line (xmodem mode)
  usb     - USB sub-system
  usbboot - boot from USB device
  version - print monitor version


Boot log
--------

.. code-block:: none

  Bootrom start
  Boot Media: eMMC (Default Speed)
  Decrypt auxiliary code ...OK

  lsadc voltage min: 00000100, max: 00000101, aver: 00000100, index: 00000004

  Enter boot auxiliary code
  Build: Oct 10 2018 - 11:10:02

  Reg Time:     2019/03/06 18:59:48
  Reg Name:     hi3798m2hdmd_hi3798mv200h_DDR3-1866_1GB_16bitx2_4layers_A0825.reg

  Set cpu freq

  Boot auxiliary code success
  Bootrom success


  System startup


  Relocate Boot

  Jump to C code


  Fastboot 3.3.0 (proj-sdL-jngdzx_cwsz_121374@join-r730-00) (Dec 09 2021 - 14:25:31)

  Fastboot:      Version 3.3.0
  Build Date:    Dec  9 2021, 14:26:50
  CPU:           Hi3798Mv200H
  Boot Media:    eMMC
  DDR Size:      1GB

  LOGO Flag:3d34a8d2
  Found flash memory controller hifmc100.
  no found nand device.

  MMC/SD controller initialization.
  scan edges:2 p2f:6 f2p:8
  mix set temp-phase 3
  scan elemnts: startp:128 endp:122
  Tuning SampleClock. mix set phase:[03/07] ele:[13/16]
  MMC/SD Card:
      MID:         0x15
      Read Block:  512 Bytes
      Write Block: 512 Bytes
      Chip Size:   7456M Bytes (High Capacity)
      Name:        "8GTF4R"
      Chip Type:   MMC
      Version:     5.1
      Speed:       100000000Hz
      Mode:        HS400
      Voltage:     1.8V
      Bus Width:   8bit
      Boot Addr:   0 Bytes
  Net:   up

  Boot Env on eMMC
      Env Offset:          0x00200000
      Env Size:            0x00010000
      Env Range:           0x00010000


  SDK Version: gitServer_v2018121410

  Normal logo
  bootargs RECOVERY_CHECK_MODE=<NULL>
  start check ir booting:
      0xeb14ef10||0x0, BOOTING_FACTORY_ALONE_KEYCODE(4)
      0xbc43ef10||0xe916ef10, BOOTING_FACTORY_FN_KEYCODE(3)
      0xbc43fe01||0x0, BOOTING_FACTORY_ALONE_KEYCODE(4)
      0x7d82dd22||0x7e81dd22, BOOTING_RECOVERY_SHOW_UI(1)
      0x35cadd22||0x0, BOOTING_RECOVERY_NOT_SHOW_UI(2)
      0xf20def10||0x0, BOOTING_RECOVERY_NOT_SHOW_UI(2)
      0xf20d1920||0x0, BOOTING_RECOVERY_NOT_SHOW_UI(2)
      0x35cafd01||0x0, BOOTING_RECOVERY_NOT_SHOW_UI(2)
      0x35caef11||0x0, BOOTING_RECOVERY_NOT_SHOW_UI(2)
      0xfc032c40||0x0, BOOTING_RECOVERY_NOT_SHOW_UI(2)
      0xff007748||0x0, BOOTING_RECOVERY_NOT_SHOW_UI(2)
  [Recovery] Wate Times: 302ms(906ms)
  [Recovery] Wate Times: 604ms(906ms)
  [Recovery] Wate Times: 906ms(906ms)
  serialno:XXXXXXXXXXXXXXXX
  properties mac match step1.
  properties mac=XX:XX:XX:XX:XX:XX.
  mac:XX:XX:XX:XX:XX:XX
  Reserve Memory
      Start Addr:          0x3FFFE000
      Bound Addr:          0x8D8F000
      Free  Addr:          0x3EF24000
      Alloc Block:  Addr         Size
                    0x3FBFD000   0x400000
                    0x3F8FC000   0x300000
                    0x3F8F9000   0x2000
                    0x3F8F7000   0x1000
                    0x3F8F4000   0x2000
                    0x3F8F2000   0x1000
                    0x3F8EF000   0x2000
                    0x3F79C000   0x152000
                    0x3EFB1000   0x7EA000
                    0x3EFAF000   0x1000
                    0x3EFA5000   0x9000
                    0x3EF24000   0x80000

  Press Ctrl+C to stop autoboot

  MMC read: dev # 0, block # 192512, count 20480 ... 20480 blocks read: OK

  175762560 Bytes/s

  Found Initrd at 0x04000000 (Size 352002 Bytes), align at 16384 Bytes

  ## Booting kernel from Legacy Image at 01ffffc0 ...
     Image Name:   Linux-3.18.24_hi3798mv310
     Image Type:   ARM Linux Kernel Image (uncompressed)
     Data Size:    8694300 Bytes = 8.3 MiB
     Load Address: 02000000
     Entry Point:  02000000
     XIP Kernel Image ... OK
  OK
  ATAGS [0x00000100 - 0x00000500], 1024Bytes

  Starting kernel ...

  Uncompressing Linux... done, booting the kernel.
  mdio_bus f9840000.hieth1: /soc/hieth1@f9840000/hieth_phy@1 PHY address 255 is too large
  hi_eth: no dev probed!
  init: /init.bigfish.rc: 59: invalid command 'getprop'
  init: /init.bigfish.rc: 118: invalid option 'sdcard_r'
  init: /init.bigfish.rc: 223: invalid option '//add'
  init: /init.bigfish.rc: 374: invalid command '//insmod'
  init: /dev/hw_random not found
  init: cannot open '/initlogo.rle'
  init: /dev/hw_random not found
  healthd: wakealarm_init: timerfd_create failed
  init: cannot find '/system/bin/rild', disabling 'ril-daemon'
  init: cannot find '/system/bin/dbus-daemon', disabling 'dbus'
  init: cannot find '/system/etc/install-recovery.sh', disabling 'flash_recovery'
  init: cannot find '/system/bin/teecd', disabling 'teecd'
  init: cannot find '/system/bin/basicService', disabling 'basicService'
  init: cannot find '/system/bin/startsoftdetector.sh', disabling 'softdetector'
  init: cannot find '/system/bin/xiriservice_All', disabling 'xiriservice'
  init: cannot find '/system/bin/frontPanel', disabling 'frontPanel'
  init: cannot find '/system/bin/mtkbt', disabling 'blueangel'
  init: cannot find '/system/bin/dtvserver', disabling 'dtvserver'
  init: cannot find '/system/bin/usb-driver', disabling 'usb-driver'
  init: property 'sys.powerctl' doesn't exist while expanding '${sys.powerctl}'
  init: powerctl: cannot expand '${sys.powerctl}'
  init: property 'sys.sysctl.extra_free_kbytes' doesn't exist while expanding '${sys.sysctl.extra_free_kbytes}'
  init: cannot expand '${sys.sysctl.extra_free_kbytes}' while writing to '/proc/sys/vm/extra_free_kbytes'
  healthd: No charger supplies found
  root@Hi3798MV200H:/ # init: sys_prop: permission denied uid:1000  name:ro.config.gfx2d_compose
  init: untracked pid 1116 exited
