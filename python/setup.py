from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize
from numpy import get_include

from pyND2SDK.settings import SDKIncludePath, SDKLibPath

setup(
    name="pyND2SDK",
    description='Python wrapper for the Nikon ND2 SDK C library.',
    author='Aaron Ponti',
    author_email='aaron.ponti@bsse.ethz.ch',
    packages=["", "tests"],
    package_dir={'': 'pyND2SDK',
                 'tests': 'pyND2SDK/tests'},
    package_data={'tests': ['pyND2SDK/tests/files/*.nd2']},
    version='0.0.1',
    ext_modules=cythonize([
        Extension("nd2Reader", ["pyND2SDK/nd2Reader.pyx",
                                 "pyND2SDK/nd2Reader_helper.c"],
                  include_dirs=[SDKIncludePath, get_include()],
                  libraries=['v6_w32_nd2ReadSDK'],
                  library_dirs=[SDKLibPath]
                  )
    ]),
    requires=["Cython", "numpy"]
)
