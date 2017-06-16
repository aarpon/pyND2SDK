.. pyND2SDK documentation master file, created by
   sphinx-quickstart on Wed Jun  7 15:57:55 2017.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

pyND2SDK documentation
======================

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   examples.rst

The pyND2SDK module is a python/cython wrapper around the Nikon ND2 SDK v9.00 (http://www.nd2sdk.com) for Windows.
It tries to be a thin interface on top of the SDK.

Installation
------------

Download the Nikon ND2 SDK
..........................

Download and extract the Nikon ND2 SDK from http://www.nd2sdk.com. You will need to sign up to download the archive. Extract the nd2ReadSDK_v9.zip archive to some place of your liking.

Now set the environment variable `SDKRootPath` to point to the extracted `SDK` folder.

Clone the pyND2SDK repository
.............................

Clone the pyND2SDK repository from github (URL to follow).

Build the nd2Reader module
..........................

To build the pyND2SDK.nd2Reader module, execute:

.. code-block:: bash

	python setup.py build_ext --inplace

Public API
----------

.. autoclass:: pyND2SDK.nd2Reader.nd2Reader
   :members:

.. autoclass:: pyND2SDK.nd2Reader.Picture
   :members:

.. autoclass:: pyND2SDK.nd2Reader.Binary
   :members:
