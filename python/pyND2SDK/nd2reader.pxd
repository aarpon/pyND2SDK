# ND2Reader
#
# Uses the Nikon SDK for accessing data and metadata from ND2 files.

from libc.stddef cimport wchar_t

cdef extern from "Python.h":
	wchar_t* PyUnicode_AsWideCharString(object, Py_ssize_t *)

cdef extern from "wchar.h":
	int wprintf(const wchar_t *, ...)

cdef extern from "nd2ReadSDK.h":
	ctypedef int LIMFILEHANDLE
	LIMFILEHANDLE Lim_FileOpenForRead(const wchar_t* wszFileName)
