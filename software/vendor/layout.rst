Flash layout
============

This page describes how vendor Android image arrange eMMC storage.

..  table::

    ==========  ======  ====  ==============================================
    Name        Offset  Size  Description
    ==========  ======  ====  ==============================================
    fastboot    0M      1M    :ref:`fastboot.bin`
    bootargs    1M      4M    U-Boot env file [#]_, sector size: ``0x10000``
    recovery    5M      16M   Android bootimg
    deviceinfo  21M     1M    Model type, Serial No, MAC address, etc
    baseparam   22M     4M    ``hi_drv_pdm.h``
    pqparam     26M     4M    Video Post Processing parameters
    logo        30M     4M    ``LOGO_TABLE``
    fastplay    34M     16M   empty, or Fastboot DRM parameters
    misc        50M     8M    empty, or Android ``/misc`` partition
    factory     58M     24M   empty, or Android ``/factory`` partition
    kernel      82M     12M   Android bootimg
    iptv_data   94M     8M    ``huawei_iptv_data_2.0``, control URL, etc
    backup      102M    340M  ext3/4, Android ``/backup`` partition
    cache       442M    340M  ext3/4, Android ``/cache`` partition
    system      782M    520M  ext3/4, Android ``/system`` partition
    userdata    1302M         ext3/4, Android ``/data`` partition
    ==========  ======  ====  ==============================================

.. [#] https://github.com/u-boot/u-boot/blob/master/tools/env/fw_env.config

YMMV, especially the size of ``backup``, ``cache``, and ``system``.
