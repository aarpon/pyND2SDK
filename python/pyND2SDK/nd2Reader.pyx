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
cdef class Picture:
    cdef LIMPICTURE picture
    cdef np.ndarray np_arr

    def __init__(self, width, height, bpc, components, hFile, seqIndex):
        cdef LIMPICTURE temp
        if _Lim_InitPicture(&temp, width, height, bpc, components) == 0:
            raise Exception("Could not initialize picture!")

        # Load the image
        load_image_data(hFile, &temp, seqIndex)

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

    cdef dump(self):
        dump_LIMPICTURE_struct(&self.picture)

    def __dealloc__(self):
        # When the pLIMPICTURE object is destroyed,
        # we make sure to destroy also the LIM picture
        # it refers to.
        _Lim_DestroyPicture(&self.picture)

    @property
    def np_arr(self):
        return self.np_arr


class nd2Reader:

    def __init__(self):
        self.attr = None
        self.meta = None
        self.file_name = ""
        self.file_handle = 0
        self.Pictures = {}

    def open(self, filename):
        """
        Opens the file 'filename' for reading and returns the file handle.
        :param filename: with file full path
        :type filename: unicode string
        :return: file handle
        :rtype: int
        """

        # Make sure the string is unicode
        self.file_name = unicode(filename)
        cdef Py_ssize_t length
        cdef wchar_t *w_filename = PyUnicode_AsWideCharString(self.file_name, &length)

        # Open the file and return the handle
        self.file_handle = _Lim_FileOpenForRead(w_filename)
        return self.file_handle

    def is_open(self):
        return self.file_handle != 0

    def close(self):
        """
        Closes the file with given handle.
        :param file_handle: file handle returned by LIM_FileOpenForRead()
        :type file_handle: int
        :return: result of closing the file
        :rtype: int
        """

        # Close the file
        self.file_handle = _Lim_FileClose(self.file_handle)
        return self.file_handle

    def get_attributes(self):
        """
        Retrieves the file attributes or throws an Exception if it failed.
        :param file_handle: handle of the open file.
        :type file_handle: int
        :return: LIMATTRIBUTES structure mapped to a python dictionary
        :rtype: dict
        """
        cdef LIMATTRIBUTES attr;
        if _Lim_FileGetAttributes(self.file_handle, &attr) !=0:
            raise Exception("Could not retrieve the file attributes!")

        # Convert to dict
        d = LIMATTRIBUTES_to_dict(&attr)

        if DEBUG:
            import pprint
            dump_LIMATTRIBUTES_struct(&attr)
            pprint.pprint(d)

        return d

    def get_metadata(self):
        """
        Retrieves the file metadata or throws an Exception if it failed.
        :param file_handle: handle of the open file.
        :type file_handle: int
        :return: LIMMETADATA_DESC structure mapped to a python dictionary
        :rtype: dict
        """
        cdef LIMMETADATA_DESC meta;
        if _Lim_FileGetMetadata(self.file_handle, &meta) !=0:
            raise Exception("Could not retrieve the file metadata!")

        # Convert to dict
        d = LIMMETADATA_DESC_to_dict(&meta)

        if DEBUG:
            import pprint
            dump_LIMMETADATA_DESC_struct(&meta)
            pprint.pprint(d)

        return d

    def get_text_info(self):
        """
        Retrieves the text info or throws an Exception if it failed.
        :param file_handle: handle of the open file.
        :type file_handle: int
        :return: LIMTEXTINFO structure mapped to a python dictionary
        :rtype: dict
        """
        cdef LIMTEXTINFO info;
        if _Lim_FileGetTextinfo(self.file_handle, &info) !=0:
            raise Exception("Could not retrieve the text info!")

        # Convert to dict
        d = LIMTEXTINFO_to_dict(&info)

        if DEBUG:
            import pprint
            dump_LIMTEXTINFO_struct(&info)
            pprint.pprint(d)

        return d

    def get_experiment(self):
        """
        Retrieves the experiment info or throws an Exception if it failed.
        :param file_handle: handle of the open file.
        :type file_handle: int
        :return: LIMMETADATA_DESC structure mapped to a python dictionary
        :rtype: dict
        """
        cdef LIMEXPERIMENT exp;
        if _Lim_FileGetExperiment(self.file_handle, &exp) !=0:
            raise Exception("Could not retrieve the experiment info!")

        # Convert to dict
        d = LIMEXPERIMENT_to_dict(&exp)

        if DEBUG:
            import pprint
            dump_LIMEXPERIMENT_struct(&exp)
            pprint.pprint(d)

        return d

    # Data access
    def load(self, LIMUINT index):
        """Loads and stores a picture.

        :param index: index of the sequence (image) to load
        :type height: unsigned int
        :return: image a numpy array
        :rtype: numpy array
        """

        if self.file_handle is None:
            return False

        # Get the attributes
        attr = self.get_attributes()
 
        # Create a new Picture object
        width = attr['uiWidth']
        height = attr['uiHeight']
        bpc = attr['uiBpcSignificant']
        components = 1

        # Create a new Picture objects that loads the requested image
        p = Picture(width, height, bpc, components, self.file_handle, index)

        # Store the picture
        self.Pictures[uiSeqIndex] = p

        # Return the array
        return p.np_arr


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
    cdef np.ndarray arr = np.asarray(mv).view(np.uint8)
    set_base(arr, mat)
    return arr
