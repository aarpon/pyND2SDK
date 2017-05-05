# Wrapper for nd2ReadSDK.h
#
# Uses the Nikon SDK for accessing data and metadata from ND2 files.

from libc.stddef cimport wchar_t

cdef extern from "Python.h":
    wchar_t* PyUnicode_AsWideCharString(object, Py_ssize_t *)

cdef extern from "wchar.h":
    int wprintf(const wchar_t *, ...)

cdef extern from "c_helper.h":

    # DEBUG functions
    void dump_LIMATTRIBUTES_struct(LIMATTRIBUTES *s)

    # Structure to  dictionary functions
    object LIMATTRIBUTES_to_dict(LIMATTRIBUTES *s)

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
    ctypedef wchar_t LIMWCHAR "wchar_t"

    # Wide char string (python unicode will be cast to it)
    ctypedef wchar_t* LIMWSTR "wchar_t *"

    # Constant pointer to wide char string (python unicode will be cast to it)
    ctypedef const wchar_t* LIMCWSTR "const wchar_t *"

    # Picture plane description
    ctypedef struct LIMPICTUREPLANE_DESC:
        pass

    # Struct LIMATTRIBUTES
    ctypedef struct LIMATTRIBUTES:
        pass

    # Open file for reading (and return file handle)
    LIMRESULT _Lim_FileOpenForRead "Lim_FileOpenForRead"(LIMCWSTR wszFileName)

    # Close the file with given handle
    LIMRESULT _Lim_FileClose "Lim_FileClose"(LIMFILEHANDLE file_handle)

    # Get the attributes
    LIMRESULT _Lim_FileGetAttributes "Lim_FileGetAttributes"(LIMFILEHANDLE hFile, LIMATTRIBUTES* attr)

