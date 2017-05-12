# ND2Reader
#
# Uses the Nikon SDK for accessing data and metadata from ND2 files.
import numpy as np
cimport numpy as np
np.import_array()

# from libc.stdlib cimport free
from libc.stddef cimport wchar_t

DEBUG = False

# (Hybrid) picture class
cdef class pLIMPICTURE:
    cdef LIMPICTURE picture
    cdef np.ndarray np_arr

    def __init__(self, width, height, bpc, components):
        cdef LIMPICTURE temp
        if _Lim_InitPicture(&temp, width, height, bpc, components) == 0:
            raise Exception("Could not initialize picture!")

        if DEBUG:
            dump_LIMPICTURE_struct(&temp)

        # Create a memory view to the data
        if bpc == 8:
            self.np_arr = to_uint8_numpy_array(&temp, height, width)
        elif 8 < bpc <= 16:
            self.np_arr = to_uint16_numpy_array(&temp, height, width)
        elif bpc == 32:
            self.np_arr = to_float_numpy_array(&temp, height, width)
        else:
            raise ValueError("Unexpected value for bpc!")

        self.picture = temp

    def __dealloc__(self):
        # When the pLIMPICTURE object is destroyed,
        # we make sure to destroy also the LIM picture
        # it refers to.
        _Lim_DestroyPicture(&self.picture)

    @property
    def np_arr(self):
        return self.np_arr

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
    :return: LIMTEXTINFO structure mapped to a python dictionary
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

def Lim_FileGetExperiment(int file_handle):
    """
    Retrieves the experiment info or throws an Exception if it failed.
    :param file_handle: handle of the open file.
    :type file_handle: int
    :return: LIMMETADATA_DESC structure mapped to a python dictionary
    :rtype: dict
    """
    cdef LIMEXPERIMENT exp;
    if _Lim_FileGetExperiment(file_handle, &exp) !=0:
        raise Exception("Could not retrieve the experiment info!")

    # Convert to dict
    d = LIMEXPERIMENT_to_dict(&exp)

    if DEBUG:
        import pprint
        dump_LIMEXPERIMENT_struct(&exp)
        pprint.pprint(d)

    return d

# Data access
def Lim_InitPicture(LIMUINT width, LIMUINT height, LIMUINT bpc, LIMUINT components):
    """
    Initializes a picture.
    :param width: width of the picture
    :type width: unsigned int
    :param height: height of the picture
    :type height: unsigned int
    :param bpc: bits per component: 8, 10, 12, 14, 16, 32
    :type bpc: unsigned int
    :param components: number of components
    :type components: unsigned int
    :return: picture
    :rtype: numpy array
    """
    p = pLIMPICTURE(width, height, bpc, components)
    return p

# Clean (own) memory when finalizing the array
cdef class _finalizer:
    cdef void *_data

    def __dealloc__(self):
        # The data is deleted by Lim_DestroyPicture in the
        # pLIMPICTURE destructor.
        #if self._data is not NULL:
        #    free(self._data)
        pass

# Convenience function to create a _finalizer
cdef void set_base(np.ndarray arr, void *carr):
    cdef _finalizer f = _finalizer()
    f._data = <void*>carr
    np.set_array_base(arr, f)

# Create a numpy array with a memory view on the data (i.e. no copy!)
# Please notice that if the LIMPICTURE object that owns the data is
# destroyed, the memoryview will be invalid!!
cdef to_float_numpy_array(LIMPICTURE * pPicture, int nrows, int ncols):
    cdef float *mat = get_float_pointer_to_picture_data(pPicture)
    cdef float[:, ::1] mv = <float[:nrows, :ncols]>mat
    cdef np.ndarray arr = np.asarray(mv)
    set_base(arr, mat)
    return arr

# Create a numpy array with a memory view on the data (i.e. no copy!)
# Please notice that if the LIMPICTURE object that owns the data is
# destroyed, the memoryview will be invalid!!
cdef to_uint16_numpy_array(LIMPICTURE * pPicture, int nrows, int ncols):
    cdef unsigned short *mat = get_uint16_pointer_to_picture_data(pPicture)
    cdef unsigned short[:, ::1] mv = <unsigned short[:nrows, :ncols]>mat
    cdef np.ndarray arr = np.asarray(mv)
    set_base(arr, mat)
    return arr

# Create a numpy array with a memory view on the data (i.e. no copy!)
# Please notice that if the LIMPICTURE object that owns the data is
# destroyed, the memoryview will be invalid!!
cdef to_uint8_numpy_array(LIMPICTURE * pPicture, int nrows, int ncols):
    cdef char *mat = get_uint8_pointer_to_picture_data(pPicture)
    cdef char[:, ::1] mv = <char[:nrows, :ncols]>mat
    cdef np.ndarray arr = np.asarray(mv)
    set_base(arr, mat)
    return arr
