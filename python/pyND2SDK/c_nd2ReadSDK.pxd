# Wrapper for nd2ReadSDK.h
#
# Uses the Nikon SDK for accessing data and metadata from ND2 files.

from libc.stddef cimport wchar_t

cdef extern from "Python.h":
    wchar_t*PyUnicode_AsWideCharString(object, Py_ssize_t *)

cdef extern from "wchar.h":
    int wprintf(const wchar_t *, ...)

cdef extern from "nd2ReadSDK.h":
    # File handle
    int LIMFILEHANDLE

    # Result of operation
    int LIMRESULT

    # Struct LIMATTRIBUTES
    ctypedef struct LIMATTRIBUTES:
        int uiWidth           # Width of images
        int uiWidthBytes      # Line length 4-byte aligned
        int uiHeight          # Height of images
        int uiComp            # Number of components
        int uiBpcInMemory     # Bits per component 8 or 16
        int uiBpcSignificant  # Bits per component used 8 .. 16
        int uiSequenceCount   # Number of images in the sequence
        int uiTileWidth       # If image is tiled: width of tile/strip or 0
        int uiTileHeight      # If image is tiled: height of tile/strip or 0
        int uiCompression     # Compression: 0 (lossless), 1 (lossy), 2 (None)
        int uiQuality         # Compression quality: 0 (worst) - 100 (best)

    # Open file for reading (and return file handle)
    int Lim_FileOpenForRead(wchar_t*wszFileName)

    # Close the file with given handle
    int Lim_FileClose(int file_handle)

    # Get the attributes
    int Lim_FileGetAttributes(int hFile, LIMATTRIBUTES* attr)
