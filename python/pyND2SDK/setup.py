from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

from pyND2SDK.settings import SDKIncludePath, SDKLibPath

setup(
    ext_modules=cythonize([
        Extension("nd2reader", ["nd2reader.pyx"],
                  include_dirs=[SDKIncludePath],
                  libraries=['v6_w32_nd2ReadSDK'],
                  library_dirs=[SDKLibPath]
                  )
    ])
)
