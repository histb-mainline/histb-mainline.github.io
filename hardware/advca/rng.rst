RNG
===

This page describes MCU Random Number Generator.

:Kernel option: ``HW_RANDOM_HISTB``
:Driver file: ``drivers/char/hw_random/histb-rng.c``
:Devive tree:

.. code-block:: dts

  rng: rng@f8005000 {
    compatible = "hisilicon,histb-rng";
    reg = <0xf8005000 0xc>;
  };

:Registers:

.. table:: ``RNG_CTRL`` (``+0x0``)

  =======================  ====  =================================================================
  Name                     Bits  Description
  =======================  ====  =================================================================
  ``RNG_SOURCE``           1:0   Only ``2`` or ``3`` valid, select other source results exhaustion
  ``DROP_ENABLE``          5
  ``POST_PROCESS_ENABLE``  7
  ``POST_PROCESS_DEPTH``   15:8  Speed: ``1``: ~1 ms/trial, ``255``: ~16 ms/trial
  =======================  ====  =================================================================

.. table:: ``RNG_NUMBER`` (``+0x4``)

  =======================  ====  =================================================================
  Name                     Bits  Description
  =======================  ====  =================================================================
  ``RNG_NUMBER``           31:0  Random number, valid if ``DATA_COUNT != 0``
  =======================  ====  =================================================================

.. table:: ``RNG_STAT`` (``+0x8``)

  =======================  ====  ========================
  Name                     Bits  Description
  =======================  ====  ========================
  ``DATA_COUNT``           2:0   Buffer length, max ``4``
  Unknown                  31    Module ready bit?
  =======================  ====  ========================
