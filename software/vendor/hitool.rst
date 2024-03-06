HiTool
======

**HiTool** is the HiSilicon official device buring tool [#]_.

.. _ChipProperties:

ChipProperties
--------------

:Location: ``Resources/Common/ChipProperties/*.chip``

.. code-block:: python

  from Cryptodome.Cipher import AES
  from Cryptodome.Util.Padding import unpad
  import hashlib

  PASSPHASE = b'HiReg-5D765B15-8F5B-46DC-9B7C-80322B8F74E4'
  KEY = hashlib.md5(PASSPHASE).digest()
  CIPHER = AES.new(KEY, AES.MODE_ECB)

  def decrypt(data):
      return unpad(CIPHER.decrypt(data), AES.block_size)

  def normalize(src):
      return src.decode('GBK').replace('\r', '')

  import glob

  for fn in glob.glob('*.chip'):
      print(fn)
      with open(fn, 'rb') as f:
          ciphertext = f.read()
      plaintext = decrypt(ciphertext)
      data = normalize(plaintext)
      with open(fn[:-5] + '.ini', 'w') as f:
          f.write(data)

ChipFrameSettingConstants
-------------------------

:Location: ``Resources/Common/ChipFrameSettingConstants/*.fsc``

Decryption routine is the same as ChipProperties.

ChipHome
--------

:Location: ``Resources/HiReg/ChipHome/*/*.chip``

Contains chip register descriptions.

.. code-block:: python

  from Cryptodome.Cipher import DES3
  from Cryptodome.Util.Padding import unpad
  # import javaobj

  def decrypt(stream):
      keystream = stream.read(282)
      ciphertext = stream.read()

      # keyobj = javaobj.loads(keystream)
      # key = bytes(i & 0xff for i in keyobj.encoded)
      key = keystream[172:172 + 24]
      cipher = DES3.new(key, DES3.MODE_ECB)
      return unpad(cipher.decrypt(ciphertext), DES3.block_size)

  def normalize(src):
      return src.decode('GBK').replace('\r', '')

  import glob

  for fn in glob.glob('*.chip'):
      print(fn)
      with open(fn, 'rb') as f:
          plaintext = decrypt(f)
      # quick fix
      plaintext = plaintext.replace(b'\xa1\x4b', b'\xa1\xad')
      data = normalize(plaintext).replace(' encoding="GBK"', '')
      with open(fn[:-5] + '.xml', 'w') as f:
          f.write(data)

LibBootrom
----------

.. seealso::
  :ref:`Serial Boot`

.. [#] https://github.com/OpenIPC/LoTool/blob/master/src/main/java/org/openipc/lotool/Main.java
