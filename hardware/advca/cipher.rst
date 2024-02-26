Cipher
======

MultiCipher - cipher for multiple blocks (i.e. DMA).

:Kernel option: ``CRYPTO_DEV_HISI_ADVCA``
:Driver file: ``drivers/crypto/hisilicon/advca/hisi-advca-muc.c``
:Devive tree:

.. code-block:: dts

  cipher@f9a00000 {
    compatible = "hisilicon,hi3798mv100-advca-muc";
    reg = <0xf9a00000 0x10000>;
    interrupts = <GIC_SPI 75 IRQ_TYPE_LEVEL_HIGH>, <GIC_SPI 126 IRQ_TYPE_LEVEL_HIGH>;
    interrupt-names = "base", "secure";
    resets = <&crg 0xc0 9>;
  };

:Registers:

..  table:: ``CTRL``

  ================  =====  ===================================================
  Name              Bits   Description
  ================  =====  ===================================================
  ``DECRYPT``       0      If set, do decryption
  ``MODE``          3:1    `Mode select <https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation>`_:
                             - 0: ECB
                             - 1: CBC
                             - 2: CFB
                             - 3: OFB
                             - 4: CTR (unavailable for DES)
  ``ALG``           5:4    Algorithm select:
                             - 0: `DES <https://en.wikipedia.org/wiki/Data_Encryption_Standard>`_
                             - 1: `3DES <https://en.wikipedia.org/wiki/Triple_DES>`_
                             - 2: `AES <https://en.wikipedia.org/wiki/Advanced_Encryption_Standard>`_

                           Invalid value treated as 0.

                           ``drivers/crypto/hisilicon/sec{,2}`` suggest more cipher modes (of AEAD), however we didn't test them.
  ``WIDTH``         7:6    Enc/dec width select:
                             - 0: block mode, for DES/AES it's 64-bit
                               (default)
                             - 1: 8-bit
                             - 2: 1-bit (stream cipher)

                           Invalid value treated as 0. Value other than 0 seem useless.
  ``IV_CHANGE``     8      If set, read IV from ``IV_INi``. Only valid for channel 0
  ``KEYLEN``        10:9   Key length select:

                           For AES:
                             - 0: 128 bit
                             - 1: 192 bit
                             - 2: 256 bit

                           For 3DES:
                             - 0: 2 keys (encrypt, decrypt)
                             - 3: 3 keys (encrypt, decrypt, encrypt)

                           Invalid value treated as 0.
  ``KEY_FROM_MKL``  13     If set, use key from Key Ladder, otherwise use key of ID ``KEY_ID``.
  ``KEY_ID``        16:14  Select which key slot to use (``CHANn_KEYi``). Normally it's the channel ID.

                           Untested for other values.
  ``WEIGHT``        31:22  Priority? (Untested)
  ================  =====  ===================================================

.. table:: ``INT_*``

  ==========================  =====  =========================================
  Name                        Bits   Description
  ==========================  =====  =========================================
  ``INT_CHANn_IN_BUF``        n      Enables (indicates) interrupt for exhausting input buffers of channel n (except 0)
  ``INT_CHAN0_DATA_DISPOSE``  8      Enables (indicates) interrupt for finishing request of channel 0
  ``INT_CHANn_OUT_BUF``       8 + n  Enables (indicates) interrupt for exhausting output buffers of channel n (except 0)
  ``INT_SEC_EN``              30     Enables secure interrupts, see below
  ``INT_NSEC_EN``             31     Enables insecure interrupts, see below
  ==========================  =====  =========================================

.. table:: ``CHAN0_CFG`` (``+0x1410``)

  =========  ====  ===========================================================
  Name       Bits  Description
  =========  ====  ===========================================================
  ``START``  0     Emit a request for channel 0
  ``BUSY``   1     The request of channel 0 is not finished
  =========  ====  ===========================================================

.. table:: ``IN_ST3`` (``+0x1430``) (inferred)

  ============  =====  =======================================================
  Name          Bits   Description
  ============  =====  =======================================================
  ``CHAN_PTR``  2:0    current channel being scanned
  ``DECRYPT``   14
  ``MODE``      17:15
  ``ALG``       19:18
  ``WIDTH``     21:20
  ``KEYLEN``    24:23
  ``CHAN``      30:28  channel to be applied the above ctrl
  ``READY``     31
  ============  =====  =======================================================

Register behaviors:

- ``IN_BUF_CNT``: Written value (treated as *un*-signed 16-bit integer) is added into register, only if the result is <= ``BUF_NUM``.
- ``OUT_BUF_CNT``: Written value (treated as signed 16-bit integer) is added into register, only if the result is <= ``BUF_NUM``.
- ``IN_EMPTY_CNT`` / ``OUT_FULL_CNT``: Written value (treated as signed 16-bit integer) is subtracted from register, only if the result is <= ``BUF_NUM``.
- ``LST_PTR``: Read-only. Wrapping only happens at ``== BUF_NUM``. If the value already ``> BUF_NUM``, no wrapping to 0 happens.
- ``INT_RAW``: Write the interrupt mask to clear the interrupts.

Ring buffers
------------

Ring buffers use the following structure.

.. code-block:: c

  struct hica_muc_buf {
        u32 addr;
        u32 flags;
        u32 len;  /* max GENMASK(19, 0) */
        u32 iv_addr;
  } __packed;

.. table:: Buffer flags

  ============  ====  ========================================================
  Name          Bits  Description
  ============  ====  ========================================================
  ``DUMMY``     20    For SMMU?
  ``SET_IV``    21    Read IV from ``iv_addr``
  ``LIST_EOL``  22    End of list (request)
  ============  ====  ========================================================

Quirks:

- Requests are always processed chunk by chunk - no matter the value of ctrl ``WIDTH``. This means you need to look after CFB / OFB / CTR requests, which are supposed to be stream ciphers and can have arbitrarily length of data.
- If ``SET_IV`` is set, length of such request must be exactly chunk size (can't be 0 either), otherwise hardware will panic.
- (3)DES cannot correctly output to <= 3-byte buffer at the end of request; check ``OUT_LEFT`` to detect data stuck. AES does not have this quirk.

Interrupts
----------

If TEE is present, non-secure interrupt (75) is used. Otherwise, secure interrupt (126) is exposed to user and non-secure interrupt is left unused.

To enable interrupts for non-TEE chips, ``SEC_CHAN_CFG`` (``+0x824``) needs to be configured prior to any writes to ``INT_CFG`` (``+0x1404``).
