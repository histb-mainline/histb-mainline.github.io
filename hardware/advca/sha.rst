SHA
===

SHA hash device.

Two variants are observed. On Hi3798cv200 / Hi3798mv200 / Hi3798mv300 ``MSHA`` variant is present which supports state recovery.

:Kernel option: ``CRYPTO_DEV_HISI_ADVCA``
:Driver file: ``drivers/crypto/hisilicon/advca/hisi-advca-sha.c``
:Devive tree:

.. code-block:: dts

  /* secure hash, only usuable when TEE does not present */
  hash0: hash@f9a10000 {
    compatible = "hisilicon,hi3798mv100-advca-sha";
    reg = <0xf9a10000 0x1000>;
    resets = <&crg 0xc4 4>;
  };

  /* noo-secure hash, only usuable when TEE presents */
  hash1: hash@f9a20000 {
    compatible = "hisilicon,hi3798mv100-advca-sha";
    reg = <0xf9a20000 0x1000>;
    resets = <&crg 0xc4 6>;
  };

:Registers:

.. table:: ``STATUS`` (``+0x08``)

  ============  ====  ========================================================
  Name          Bits  Description
  ============  ====  ========================================================
  HASH_READY    0     Set if not ``START``.
  DMA_READY     1
  MSG_READY     2
  RECORD_READY  3     Set if data read.

                      For DMA: ~10ns/byte, minimal record time ~4ms

                      For single data read: < 1us
  ERR_STATE     5:4
  LEN_ERR       6     Set if ``RECORD_LEN > TOTAL_LEN``
  ============  ====  ========================================================

.. table:: ``CTRL`` (``+0x0c``)

  ============  ====  ========================================================
  Name          Bits  Description
  ============  ====  ========================================================
  SINGLE_READ   0     If set, read data from ``DATA_IN`` (``+0x1c``), otherwise from ``DMA_ADDR`` (``+0x14``) and ``DMA_LEN`` (``+0x18``)
  ALG           2:1   Algorithm select:
                        - 0: SHA-1 round function
                        - 1: SHA-2 round function
  HMAC          3     If set, calculate HMAC (pad inner key header)
  KEY_FROM_CPU  4     If set with ``HMAC``, use key from ``MCU_KEYn`` (``+0x70`` ~ ``+0x7c``), otherwise from ``KL_KEYn`` (``+0x80`` ~ ``+0x8c``). All key registers are write-only.
  ENDIAN        5     If set, treat data as little endian. You should always set this bit.
  USED_BY_ARM   6     (On non-``MSHA``) Set to inform internal 8051 microprocessor the device is used by user.
  SET_INIT      6     (On ``MSHA``) If set, use ``INITn`` (``+0x90`` ~ ``+0xac``) as initial state to fill ``OUTn`` (``+0x30`` ~ ``+0x4c``).

                      Otherwise the latters are filled according to ``ALG``:
                        - 0: SHA-1
                        - 1: SHA-256

                      On non-``MSHA``, it is treated as not set.
  USED_BY_C51   7     (On non-``MSHA``) Set if device is used by internal 8051 microprocessor.
  ============  ====  ========================================================

.. table:: ``START`` (``+0x10``)

  =====  ====  ===============================================================
  Name   Bits  Description
  =====  ====  ===============================================================
  START  1     Set to trigger internal state setup.

               Once set, it cannot be unset unless resetting device.
  =====  ====  ===============================================================

Quirks:

- ``DMA_ADDR`` and ``DMA_LEN`` must be divisible by 4, otherwise the hardware will panic (and in some cases cannot be recovered by software resetting).
