Example usage
=============

.. toctree::
   :maxdepth: 2
   :caption: Contents:


.. code-block:: python

	>>> from pyND2SDK.nd2Reader import nd2Reader
	>>> r = nd2Reader()
	>>> r.open('./file01.nd2')
	1024
	
	>>> r
	File opened: file01.nd2
	    XYZ = (1024x1024x1), C = 3, T = 1
	    Number of positions = 1 (other = 0)
	    16 bits (12 significant)
