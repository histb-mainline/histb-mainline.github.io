OTP
===

This page describes One-time Programmable Memory.

:Registers:

.. table:: ``CHANNEL_SEL`` (``+0x0``)

  ===========  ====  ===========================================
  Name         Bits  Description
  ===========  ====  ===========================================
  ``CHANNEL``  1:0   Only ``2`` valid, other channel has no data
  ===========  ====  ===========================================

.. table:: ``RW_CTRL`` (``+0x4``)

  =============  ====  =====================================
  Name           Bits  Description
  =============  ====  =====================================
  ``WRITE_SEL``  0     Enable write operation
  ``READ_EN``    1     Enable read operation
  ``WRITE_EN``   2     Enable write operation
  ``RW_WIDTH``   5:3   Operation width (only ``4`` observed)
  =============  ====  =====================================

.. table:: ``WRITE_START`` (``+0x8``)

  ===============  ====  =============
  Name             Bits  Description
  ===============  ====  =============
  ``WRITE_START``  0     Foolproof reg
  ===============  ====  =============

.. table:: ``CTRL_STATUS`` (``+0xc``)

  ==============  ====  ====================================
  Name            Bits  Description
  ==============  ====  ====================================
  ``CTRL_READY``  0     Operation finished
  ``FAIL``        1
  ``SOAK``        2
  ``READ_LOCK``   4     If set, read operation not allowed
  ``WRITE_LOCK``  5     If set, write operation not allowed
  ==============  ====  ====================================

Steps
-----

#. Set ``CHANNEL_SEL``, ``RW_CTRL``
#. Write ``READ_ADDR``, or ``WRITE_ADDR`` with ``WRITE_DATA``
#. If write, set ``WRITE_START``
#. Wait until ``CTRL_READY != 0`` (about 1.1ms)
#. If read, read ``READ_DATA``

Memory content
--------------

:Length: ``0x800``
