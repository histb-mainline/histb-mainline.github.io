Welcome to histb-mainline's documentation!
==========================================

What is histb
-------------

**histb** represents the family of `IPTV STB <https://en.wikipedia.org/wiki/Set-top_box>`_ ARM SoCs from `HiSilicon Technology <https://www.hisilicon.com/>`_, a Chinese fabless semiconductor company. See `official introduction <https://www.hisilicon.com/products/smart-media/STB/>`_.

.. admonition:: Disclamer
  :class: danger

  **This project is not endorsed, sponsored, or supported by HiSilicon Technology in any way. All trademarks, logos and brand names are the property of their respective owners. Reference in this website to any specific commercial products, processes, or services, or the use of any trade, firm, or corporation name is for the information and convenience of the public and does not constitute an endorsement, recommendation, or favoring by this project.**

.. toctree::
  :maxdepth: 2
  :titlesonly:
  :caption: Contents

  ./hardware/index
  ./software/index
  ./installation/index
  ./appendix/index

Why histb?
----------

The SoC series features MCU with IR module, which can hibernate the ARM core and resume when receives remote controls' signal, a feature usually expected on every STB. Proper MCU configuration, alongside CRG module, is crucial to mainline kernel support.

LICENSE
-------

`CC BY 3.0 <https://creativecommons.org/licenses/by/3.0/>`_ for docs, `Public Domain <https://creativecommons.org/share-your-work/public-domain/pdm/>`_ for code snippets not otherwise licensed.
