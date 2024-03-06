Fastboot
========

.. note::
  Despite its name, it is **NOT** the Android Fastboot, though it can actually boot Android bootimgs. Clearly it's U-Boot forked around 2014, and removed all copyright notices.

Vendor Fastboot support booting from uImage or Android bootimg (uImage + initrd).

Please be aware that, Vendor Fastboot depends on Hisi Reg file, which contains initial values for critical registers, such as DDR training. The reg file must also match your board for proper boot in addition to SoC type.

.. _Fastboot USB Boot:

Boot sequence
-------------

1. If :ref:`USB_BOOT <USB Boot>` is pulled down, it will try to read two files on u-disk:

    - ``bootargs.bin``: U-Boot env file, sector size: ``0x10000``
    - ``recovery.img``: Android bootimg or uImage

   Otherwise, go to next step.
2. Read Android bootimg or uImage from eMMC or NAND storage.

   If Secure Boot is enabled, only Android bootimg will be considered.

Prepare uImage / Android bootimg
--------------------------------

Prepare uImage:

.. code-block:: sh

  sudo apt install u-boot-tools

.. code-block:: sh

  cat zImage dtb > zImage-dtb
  mkimage -A arm -O linux -T kernel -C none -a 0x2000000 -e 0x2000000 -n Linux-$VER -d zImage-dtb uImage

Prepare Android bootimg, using uImage:

.. code-block:: sh

  sudo apt install mkbootimg

.. code-block:: sh

  # without ramdisk
  mkbootimg --kernel uImage --base 0 --kernel_offset 0x3e08000 -o bootimg
  # with ramdisk
  mkbootimg --kernel uImage --ramdisk ramdisk.cpio.xz --base 0 --kernel_offset 0x3e08000 --ramdisk_offset 0x4e00000 -o recovery.img

TODO: work out offset meaning

Prepare ``bootargs.bin``
------------------------

Use U-Boot fw-utils to prepare ``bootargs.bin``.

.. code-block:: sh

  sudo apt install libubootenv-tool

Example ``fw_env.config``:

.. code-block:: none

  bootargs.bin 0 0x10000 0x10000

.. code-block:: sh

  # read bootargs
  fw_printenv -c fw_env.config
  # write bootargs
  fw_setenv -c fw_env.config $key $value

Console Output
--------------

See :doc:`/appendix/boards/index`.

.. seealso::
  For most commands, refer to `U-Boot help page <https://docs.u-boot.org/en/latest/usage/index.html#shell-commands>`_.
