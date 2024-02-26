DMA Controller
==============

:Kernel option: ``HISTB_DMA``
:Driver file: ``drivers/dma/histb_dma.c``
:Devive tree:

.. code-block:: dts

  dmac@f9870000 {
    compatible = "hisilicon,hi3798mv100-dmac";
    reg = <0xf9870000 0x10000>;
    interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
    clocks = <&crg HISTB_DMAC_CLK>;
    resets = <&crg 0xa4 4>;
  };
