from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize
from numpy import get_include

from pyND2SDK.settings import SDKIncludePath, SDKLibPath

setup(
    ext_modules=cythonize([
        Extension("c_nd2ReadSDK", ["c_nd2ReadSDK.pyx", "c_helper.c",
                                   "data_access_helper.c"],
                  include_dirs=[SDKIncludePath, get_include()],
                  libraries=['v6_w32_nd2ReadSDK'],
                  library_dirs=[SDKLibPath]
                  )
    ])
)
