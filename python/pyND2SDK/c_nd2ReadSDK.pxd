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

    # Open file for reading (and return file handle)
    int Lim_FileOpenForRead(wchar_t*wszFileName)

    # Close the file with given handle
    int Lim_FileClose(int file_handle);
