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

.. _Serial Boot:

Serial bootstrap
----------------

In HiSilicon official buring tool "HiTool", this is manipulated by ``Resources/Common/libbootrom.{dll,so}``.

Bootrom serial may give printable ASCII message or binary frame. Char point ``>= 0x80`` indicates start of binary frame.

.. code-block:: c

  struct frame {
    u8 cmd;
    u8 seq;  /* warp around 256 */
    u8 seq_bnot;  /* ~seq */
    u8 payload[];  /* see struct cmd_* */
    /* struct frame_end end; */
  } __packed;

  struct frame_end {
    __be16 crc16;
  } __packed;

  #define CMD_HEAD  0xfe  /* set up load address and data length, TSerialComm::SendHeadFrame() */
  #define CMD_DATA  0xda  /* send data, TSerialComm::SendDataFrame() */
  #define CMD_TAIL  0xed  /* finish sending data, TSerialComm::SendTailFrame() */

  struct cmd_head {
    u8 padding;  /* 01 */
    __be32 size;
    __be32 addr;
  } __packed;

  struct cmd_data {
    u8 payload[];  /* max 1024 */
  } __packed;

  struct cmd_tail {
    /* nothing */
  } __packed;

If the chip supports ``BurnByLibBootrom`` (``BurnByLibBootrom=1`` in HiTool ``Resources/Common/ChipProperties/*.chip``), the following commands are also supported.

.. seealso::
  :ref:`ChipProperties`

.. code-block:: c

  #define CMD_TYPE  0xbd  /* get board info, TSerialComm::SendTypeFrame() */
  #define CMD_BOARD 0xce  /* instruction, TSerialComm::SendBoardFrame() */

  struct cmd_type_request {
    u8 padding;  /* 01 */
    __be64 not_bare_burn;  /* 1: not bare burn */
    __be64 ddr_or_flash;  /* 1: flash type is ddr */
  } __packed;

  struct cmd_type_reply {
    union {
      struct {
        bool ca : 1;
        bool tee : 1;
        bool multiform : 1;
      };
      u8 flags;
    };
    __be64 chip_id;  /* see hardware/socs */
  } __packed;

  struct cmd_board_request {
    u8 padding;  /* 01 */
    __be32 padding1;  /* all 0 */
    __be32 padding2;  /* all 0 */
  } __packed;

  struct cmd_board_reply {
    u8 reg;
    __be32 padding;  /* all 0 */
  } __packed;

Device may reply with a frame, with a status code at the end of data, or just a single status code.

.. code-block:: c

  #define FRAME_REPLY_OK             0xaa
  #define FRAME_REPLY_CRC_MISMATCHED 0x55

Steps for sending data:

1. Send frame ``Head(seq=0, size, addr)``, device should reply with a single ``0xaa``;
2. Send frame ``Data(seq=1...n)`` to device (the last frame needs no padding), device should reply with a single ``0xaa``;

   If a head frame is sent instead, the previous data will be ignored.
3. Send frame ``Tail(seq=n+1)`` to device, device should reply with a single ``0xaa``.
