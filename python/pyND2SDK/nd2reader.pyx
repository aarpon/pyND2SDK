# ND2Reader
#
# Uses the Nikon SDK for accessing data and metadata from ND2 files.

from libc.stddef cimport wchar_t
cimport c_nd2ReadSDK as SDK

def LIM_FileOpenForRead(filename):
    """
    Opens the file 'filename' for reading and returns the file handle.
    :param filename: with file full patg
    :type filename: unicode string
    :return: file handle
    :rtype: int
    """

    # Make sure the string is unicode
    filename = unicode(filename)
    cdef Py_ssize_t length
    cdef wchar_t *w_filename = SDK.PyUnicode_AsWideCharString(filename, &length)

    # Open the file and
    file_handle = SDK.Lim_FileOpenForRead(w_filename)

    return file_handle

def LIM_FileClose(file_handle):
    """
    Closes the file with given handle.
    :param file_handle: file handle returned by LIM_FileOpenForRead()
    :type file_handle: int
    :return: result of closing the file
    :rtype: int
    """

    return SDK.Lim_FileClose(file_handle)

def Lim_FileGetAttributes(file_handle):
    """
    Retrieves the file attributes or throws an Exception if it failed.
    :param file_handle: handle of the open file.
    :type file_handle: int
    :return: LIM_ATTRIBUTES structure
    :rtype: struct
    """
    cdef SDK.LIMATTRIBUTES attr;
    if SDK.Lim_FileGetAttributes(file_handle, &attr) !=0:
        raise Exception("Could not retrieve the file attributes!")

    return attr
