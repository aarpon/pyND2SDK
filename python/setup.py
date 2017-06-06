from setuptools import setup
from setuptools.extension import Extension
from Cython.Build import cythonize
from numpy import get_include

from pyND2SDK.settings import SDKIncludePath, SDKLibPath

setup(
    name='pyND2SDK',
    description='Python wrapper for the Nikon ND2 SDK C library.',
    author='Aaron Ponti',
    url='http://www.scs2.net',
    author_email='aaron.ponti@bsse.ethz.ch',
    packages=["pyND2SDK"],
    package_dir={'pyND2SDK': 'pyND2SDK'},
    package_data={'pyND2SDK': ['pyND2SDK/test/files/*.nd2']},
    version='0.0.1',
    ext_modules=cythonize([
        Extension("pyND2SDK.nd2Reader", ["pyND2SDK/nd2Reader.pyx",
                                         "pyND2SDK/nd2Reader_helper.c"],
                  include_dirs=[SDKIncludePath, get_include()],
                  libraries=['v6_w32_nd2ReadSDK'],
                  library_dirs=[SDKLibPath]
                  )
    ]),
    install_requires=['python_version>"3.4"'],
    requires=["Cython", "numpy"]
)
