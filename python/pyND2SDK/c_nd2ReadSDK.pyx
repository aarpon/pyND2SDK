# ND2Reader
#
# Uses the Nikon SDK for accessing data and metadata from ND2 files.

from libc.stddef cimport wchar_t

DEBUG = True

def LIM_FileOpenForRead(unicode filename):
    """
    Opens the file 'filename' for reading and returns the file handle.
    :param filename: with file full path
    :type filename: unicode string
    :return: file handle
    :rtype: int
    """

    # Make sure the string is unicode
    filename = unicode(filename)
    cdef Py_ssize_t length
    cdef wchar_t *w_filename = PyUnicode_AsWideCharString(filename, &length)

    # Open the file and return the handle
    return _Lim_FileOpenForRead(w_filename)

def LIM_FileClose(int file_handle):
    """
    Closes the file with given handle.
    :param file_handle: file handle returned by LIM_FileOpenForRead()
    :type file_handle: int
    :return: result of closing the file
    :rtype: int
    """

    # Close the file
    return _Lim_FileClose(file_handle)

def Lim_FileGetAttributes(int file_handle):
    """
    Retrieves the file attributes or throws an Exception if it failed.
    :param file_handle: handle of the open file.
    :type file_handle: int
    :return: LIMATTRIBUTES structure mapped to a python dictionary
    :rtype: dict
    """
    cdef LIMATTRIBUTES attr;
    if _Lim_FileGetAttributes(file_handle, &attr) !=0:
        raise Exception("Could not retrieve the file attributes!")

    # Convert to dict
    d = LIMATTRIBUTES_to_dict(&attr)

    if DEBUG:
        import pprint
        dump_LIMATTRIBUTES_struct(&attr)
        pprint.pprint(d)

    return d

def Lim_FileGetMetadata(int file_handle):
    """
    Retrieves the file metadata or throws an Exception if it failed.
    :param file_handle: handle of the open file.
    :type file_handle: int
    :return: LIMMETADATA_DESC structure mapped to a python dictionary
    :rtype: dict
    """
    cdef LIMMETADATA_DESC meta;
    if _Lim_FileGetMetadata(file_handle, &meta) !=0:
        raise Exception("Could not retrieve the file metadata!")

    # Convert to dict
    d = LIMMETADATA_DESC_to_dict(&meta)

    if DEBUG:
        import pprint
        dump_LIMMETADATA_DESC_struct(&meta)
        pprint.pprint(d)

    return d

def Lim_FileGetTextinfo(int file_handle):
    """
    Retrieves the text info or throws an Exception if it failed.
    :param file_handle: handle of the open file.
    :type file_handle: int
    :return: LIMMETADATA_DESC structure mapped to a python dictionary
    :rtype: dict
    """
    cdef LIMTEXTINFO info;
    if _Lim_FileGetTextinfo(file_handle, &info) !=0:
        raise Exception("Could not retrieve the text info!")

    # Convert to dict
    d = LIMTEXTINFO_to_dict(&info)

    if DEBUG:
        import pprint
        dump_LIMTEXTINFO_struct(&info)
        pprint.pprint(d)

    return d
