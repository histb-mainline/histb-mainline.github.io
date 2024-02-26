Fastboot
========

.. note::
  Despite its name, it is **NOT** the Android Fastboot, though it can actually boot Android bootimgs. Clearly it's U-Boot forked around 2014, and removed all copyright notices.

Vendor Fastboot support booting from uImage or Android bootimg (uImage + initrd).

.. _Fastboot USB Boot:

Boot sequence
-------------

1. If :ref:`USB_BOOT <USB Boot>` is pulled down, it will try to read two files on u-disk:

    - ``bootargs.bin``: U-Boot env file, sector size: ``0x10000``
    - ``recovery.img``: Android bootimg or uImage

   Otherwise, go to next step.
2. Read Android bootimg or uImage from eMMC or NAND storage.

   If Secure Boot is enabled, only Android bootimg will be considered.

Prepare boot files
------------------

Prepare uImage:

.. code-block:: sh

  VER=6.0
  cat zImage dtb > zImage-dtb
  mkimage -A arm -O linux -T kernel -C none -a 0x2000000 -e 0x2000000 -n Linux-$VER -d zImage-dtb uImage

Prepare Android bootimg, using uImage:

.. code-block:: sh

  # without ramdisk
  mkbootimg --kernel uImage --base 0 --kernel_offset 0x3e08000 -o bootimg
  # with ramdisk
  mkbootimg --kernel uImage --ramdisk ramdisk.cpio.xz --base 0 --kernel_offset 0x3e08000 --ramdisk_offset 0x4e00000 -o recovery.img

TODO: work out offset meaning

.. hint::
  Use U-Boot fw-utils to prepare ``bootargs.bin``.

Console Output
--------------

.. code-block:: none

  fastboot# getinfo ddrfree
  DDR free region baseaddr:0x1000000 size:0x3F000000

.. code-block:: none

  fastboot# help
  ?       - alias for 'help'
  CXSecSystemBoot- Conax CA security system booting
  base    - print or set address offset
  bootimg - boot application boot.img(kernel+ramdisk) from memory
  bootm   - boot application image from memory
  bootp   - boot image via network using BOOTP/TFTP protocol
  ca_auth - verify android system: bootargs, recovory, kernel, system...
  ca_cbcmac_test-
  ca_common_verify_bootargs- ca_common_verify_bootargs
  ca_common_verify_bootargs_partition- ca_common_verify_bootargs_partition
  ca_common_verify_encryptimage- Encrypt image for Digital Signature
  ca_common_verify_image_signature- verify pariton-image signature with tail mode
  ca_common_verify_signature_check- verify BootArgs signature_check
  ca_common_verify_system_signature- verify pariton-image signature with tail mode
  ca_decryptflashpartition- decrypt flash_patition_name to DDR
  ca_enablesecboot- ca_enablesecboot flash_type(spi|nand|sd|emmc)
  ca_encryptboot- CA Encrypt Boot
  ca_get_extern_rsa_key- get external rsa key
  ca_getotprsakey- ca_getotprsakey
  ca_getrsakeylockflag- ca_getrsakeylockflag
  ca_getsecbootstatus- ca_getsecbootstatus
  ca_lockrsakey- ca_lockrsakey
  ca_setotprsakey- ca_setotprsakey
  ca_special_burnflashname- Encrypt DDR image with R2R Key-ladder and burn DDR image into flash
  ca_special_burnflashnamebylen- Encrypt DDR image with R2R Key-ladder and burn DDR image into flash
  ca_special_verify- ca_special_verify flash_patition_name
  ca_special_verifyaddr- ca_special_verifyaddr flash_patition_Addr
  ca_special_verifybootargs- verify bootargs
  cipher_cbc_mac_test-
  clear_bootf- clear Hibernate!! bootflag
  cmp     - memory compare
  cp      - memory copy
  crc32   - checksum calculation
  ddr     - ddr training function
  fatinfo - print information about filesystem
  fatload - load binary file from a dos filesystem
  fatls   - list files in a directory (default /)
  getinfo - print hardware information
  go      - start application at address 'addr'
  hash    - Calcluate hash
  hash_test- hash_test [x]:[0] SHA1; [1] SHA256; [2] HMAC-SHA1; [3] HMAC-SHA256;
  help    - print command description/usage
  hibernate- Hibernate!! boot
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
  otp_getchipid- otp_getchipid
  otp_getcustomerkey- otp_getcustomerkey
  otp_getmsid- otp_getmsid
  otp_getsecurebooten- otp_getsecurebooten
  otp_getstbprivdata- otp_getstbprivdata
  otp_getstbsn- otp_getstbsn
  otp_setstbprivdata- StbPrivData
  otpreadall- read otp ,for example otpreadall
  otpwrite- write otp ,for example otpwrite adddress value
  ping    - send ICMP ECHO_REQUEST to network host
  printenv- print environment variables
  rarpboot- boot image via network using RARP/TFTP protocol
  reset   - Perform RESET of the CPU
  saveenv - save environment variables to persistent storage
  setenv  - set environment variables
  setproflag-  --- setflags to product test page
  tftp    - tftp  - download or upload image via network using TFTP protocol
  unzip   - unzip a memory region
  uploadx - upload binary file over serial line (xmodem mode)
  usb     - USB sub-system
  usbboot - boot from USB device
  version - print monitor version

.. seealso::
  For most commands, refer to `U-Boot help page <https://docs.u-boot.org/en/latest/usage/index.html#shell-commands>`_.
