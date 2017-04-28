import os
import sys

SDKRootPath = "C:/Users/pontia/Devel/third-party/ND2SDK/SDK"


SDKRootPath = SDKRootPath.replace('/','\\')
SDKIncludePath = os.path.join(SDKRootPath, 'include')
SDKLibPath = os.path.join(SDKRootPath, 'lib/x64')
SDKDllPath = os.path.join(SDKRootPath, 'bin/x64')

# Add path to the SDK DLLs to the system path
os.environ['PATH'] += ';' + SDKDllPath