from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize
from numpy import get_include

from pyND2SDK.settings import SDKIncludePath, SDKLibPath

setup(
    name="pyND2SDK",
    ext_modules=cythonize([
        Extension("pyND2SDK.nd2Reader", ["nd2Reader.pyx", "nd2Reader_helper.c"],
                  include_dirs=[SDKIncludePath, get_include()],
                  libraries=['v6_w32_nd2ReadSDK'],
                  library_dirs=[SDKLibPath]
                  )
    ])
)
