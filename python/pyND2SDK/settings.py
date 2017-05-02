import os

if "SDKRootPath" in os.environ:
    SDKRootPath = os.environ['SDKRootPath']
else:
    raise Exception("Please set environment variable 'SDKRootPath' to ' \
     point to '.../ND2SDK/SDK'.")

SDKRootPath = SDKRootPath.replace('/', '\\')
SDKIncludePath = os.path.join(SDKRootPath, 'include').replace('/', '\\')
SDKLibPath = os.path.join(SDKRootPath, 'lib\\x64').replace('/', '\\')
SDKDllPath = os.path.join(SDKRootPath, 'bin\\x64').replace('/', '\\')

# Add path to the SDK DLLs to the system path
os.environ['PATH'] += ';' + SDKDllPath
