Bootstrap
=========

This page describes how to send :doc:`bootloader` to bootrom.

.. _USB Boot:

USB bootstrap
-------------

Short-circuit Pin ``USB_BOOT`` with GND (pin name may vary). It is `Schmitt triggered <https://en.wikipedia.org/wiki/Schmitt_trigger>`_. Once pulled down, it may affect subsequent boot sequence even if released after bootrom stage. See :ref:`Fastboot <Fastboot USB Boot>`.

This method will also be triggered automatically if no internal storages (eMMC or NAND) are found.

Create an FAT32 partition on u-disk, name your bootloader ``fastboot.bin`` and put it into filesystem root, then plug it into any USB port.

.. note::
  You will need other files if you use vendor ``fastboot.bin`` for USB bootstrap, see :ref:`Fastboot USB Boot <Fastboot USB Boot>`.

.. seealso::
  See :doc:`/appendix/boards/index` for ``USB_BOOT`` locations on different boards.

.. code-block:: none

  Bootrom start
  Boot from eMMC

  Entry usb bootstrap

  Udisk(1):
  Initializing DDR ... OK
  Starting DDR training ... OK
  Starting fastboot ...

  <usb fastboot log follows>

You can wire the test pin to GND permanently for easy debug. If no USB storage device is found, bootrom will try to find bootloader from internal storage (eMMC or NAND) instead.

.. code-block:: none

  Bootrom start
  Boot from eMMC

  Entry usb bootstrap
  No found fastboot.bin in host:1
  No found fastboot.bin in host:2
  Initializing DDR ... OK
  Starting DDR training ... OK
  Starting fastboot ...

  <emmc fastboot log follows>

Serial bootstrap
----------------

.. note::
  In HiSilicon official buring tool ``HiTool``, this is manipulated by ``Resources/Common/libbootrom.{dll,so}``

Bootrom serial may give printable ASCII message or binary packet. Char point >= 0x80 indicates start of binary packet.

.. code-block:: c

  /* big endian */

  struct packet {
    u8 cmd;
  #define CHIP_ID        0xbd
  #define DECRYPT        0xce
  #define BEGIN_TRANSFER 0xfe
  #define TRANSFER       0xda
  #define END_TRANSFER   0xed
    u8 offset;  /* real_offset % 256, step 1 */
    u8 offset_bnot;  /* ~offset */
    u8 payload[];  /* could be struct cmd_? */
    /* struct packet_request OR struct packet_reply */
  } __packed;

  struct packet_request {
    u16 crc16;
  } __packed;

  struct packet_reply {
    u16 crc16;
    u8 state;
  #define PACKET_REPLY_OK             0xaa
  #define PACKET_REPLY_CRC_MISMATCHED 0x55
  } __packed;

  struct cmd_chip_id {
    u8 cmd;
  #define CHIP_IP_REQUEST 0x01
  #define CHIP_IP_REPLY   0x08
    union {
      u64 chip_id;  /* see hardware/socs */
      u64 request_unknown;  /* 00 00 00 00 00 00 00 01 */
    }
  } __packed;

  struct cmd_decrypt_request {
    u8 cmd;  /* 01 */
    u32 flag;
    u32 flag2;  /* same as flag */
  } __packed;

  struct cmd_decrypt_reply {
    u8 cmd;  /* 04 */
    u32 unknown;  /* all 0 */
  } __packed;

  struct cmd_begin_transfer {
    u8 cmd; /* 01 */
    u32 size;
    u32 offset;
  } __packed;

  struct cmd_transfer {
    u8 payload[1024];
  } __packed;

  struct cmd_end_transfer {
    /* nothing */
  } __packed;
