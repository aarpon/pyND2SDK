## Introduction

The **pyND2SDK** package is a python/cython wrapper around the Nikon ND2 SDK v9.00 (http://www.nd2sdk.com) for Windows. It tries to be a thin interface on top of the SDK.

## Installation

* Download and extract the Nikon ND2 SDK from http://www.nd2sdk.com.
	* You will need to sign up to download the archive.
	* Extract the `nd2ReadSDK_v9.zip` archive to some place of your liking.
	* Now set the environment variable `SDKRootPath` to point to the extracted SDK folder.
* Clone the pyND2SDK repository
* Build the pyND2SDK.nd2Reader module:
```bash
python setup.py build_ext --inplace
```

## Notes

Please notice that you might have to install the Microsoft Visual C++ 2008 SP1 Redistributable Package:
* x86: https://www.microsoft.com/en-us/download/details.aspx?id=5582
* x64: https://www.microsoft.com/en-us/download/confirmation.aspx?id=2092
