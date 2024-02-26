Naming
======

HiSilicon name their products on a very random basis. We need a more unified naming scheme.


Inferred and proposed naming scheme
-----------------------------------

.. _S40:
.. _S5:

- S40 = A53 + peripherals [#]_
- S5 = A9 + peripherals [#]_

This also implys S40 platform is 64-bit core with 32-bit bus (based on S5).

.. [#] ``arch/arm/mach-hi3798mx/core.c`` and similar files: ``S40_IOCH1`` and ``S40_IOCH2``
.. [#] ``arch/arm/mach-hi3798mx/include/mach/io.h``: ``Only for s5 platform``

Notable nontrivial abbreviations
--------------------------------

- ca: Conditional Access
- crg: Clock Reset Generator
- perictrl: Peripheral Controller
- sysctrl: System Controller
- x5hd2: Hislicon X5 HD II
