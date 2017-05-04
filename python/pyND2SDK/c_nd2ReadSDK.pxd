# Wrapper for nd2ReadSDK.h
#
# Uses the Nikon SDK for accessing data and metadata from ND2 files.

from libc.stddef cimport wchar_t

cdef extern from "Python.h":
    wchar_t* PyUnicode_AsWideCharString(object, Py_ssize_t *)

cdef extern from "wchar.h":
    int wprintf(const wchar_t *, ...)

cdef extern from "nd2ReadSDK.h":

    # Constants (i.e. #DEFINEs)
    #
    # Defining them as enum allows declarations such as array[number]
    enum: LIMMAXPICTUREPLANES

    # File handle
    ctypedef int LIMFILEHANDLE

    # Result of operation
    ctypedef int LIMRESULT

    # Unsigned integer
    ctypedef unsigned int LIMUINT

    # Wide char
    ctypedef wchar_t LIMWCHAR

    # Wide char string (python unicode will be cast to it)
    ctypedef wchar_t* LIMWSTR

    # Constant pointer to wide char string (python unicode will be cast to it)
    ctypedef const wchar_t* LIMCWSTR

    # Picture plane description
    ctypedef struct LIMPICTUREPLANE_DESC:
        unsigned int uiCompCount   # Number of physical components
        unsigned int uiColorRGB    # RGB color for display
        wchar_t wszName[256]       # Name for display
        wchar_t wszOCName[256]     # Name of the Optical Configuration
        double  dEmissionWL        # Emission wavelength

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
    LIMRESULT Lim_FileOpenForRead(LIMCWSTR wszFileName)

    # Close the file with given handle
    LIMRESULT Lim_FileClose(LIMFILEHANDLE file_handle)

    # Get the attributes
    LIMRESULT Lim_FileGetAttributes(LIMFILEHANDLE hFile, LIMATTRIBUTES* attr)

