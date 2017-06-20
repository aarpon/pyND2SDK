from setuptools import setup, find_packages
from setuptools.extension import Extension
from Cython.Build import cythonize
from numpy import get_include

from pyND2SDK.settings import SDKIncludePath, SDKLibPath

# To create a debug build, change the line:
#
#     define_macros=[]
#
# into:
#
#     define_macros=[('DEBUG', '1')]
#
# For exceptionally verbose output, set:
#
#     define_macros=[('DEBUG', '1'), ('VERBOSE', '1')]
#
# Moreover, change the line:
#
#    DEF DEBUG = False
#
# into:
#
#    DEF DEBUG = True
#
# in nd2Reader.pyx.


setup(
    name='pyND2SDK',
    description='Python wrapper for the Nikon ND2 SDK C library.',
    author='Aaron Ponti',
    url='http://www.scs2.net',
    author_email='aaron.ponti@bsse.ethz.ch',
    packages={'pyND2SDK': 'pyND2SDK',
              'pyND2SDK.test': 'pyND2SDK/test'},
    package_dir={'pyND2SDK': 'pyND2SDK',
                 'pyND2SDK.test': 'pyND2SDK/test'},
    package_data={'pyND2SDK.test': ['files/*.nd2']},
    version='0.0.1',
    ext_modules=cythonize([
        Extension("pyND2SDK.nd2Reader", ["pyND2SDK/nd2Reader.pyx",
                                         "pyND2SDK/nd2Reader_helper.c"],
                  include_dirs=[SDKIncludePath, get_include()],
                  libraries=['v6_w32_nd2ReadSDK'],
                  library_dirs=[SDKLibPath],
                  define_macros=[]
                  )
    ]),
    requires=["Cython", "numpy"]
)
