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
    cdef int width
    cdef int height
    cdef int bpc
    cdef int n_components

    def __init__(self, width, height, bpc, n_components, hFile, seqIndex):

        # Store some arguments for easier access
        self.width = width
        self.height = height
        self.bpc = bpc
        self.n_components = n_components

        # Load the data into the LIMPicture structure
        cdef LIMPICTURE temp
        if _Lim_InitPicture(&temp, width, height, bpc, n_components) == 0:
            raise Exception("Could not initialize picture!")

        # Load the image and store it
        load_image_data(hFile, &temp, seqIndex)
        self.picture = temp

    cdef dump(self):
        dump_LIMPICTURE_struct(&self.picture)

    def __dealloc__(self):
        """
        Destructor.

        When the Picture object is destroyed, we make sure
        to destroy also the LIM picture it refers to.
        """
        _Lim_DestroyPicture(&self.picture)

    def image(self, comp):
        """
        Return image at given component number as numpy array (memoryview).
        :param comp: component number
        :type comp: int
        :return: image
        :rtype: np.array (memoryview)
        """

        cdef LIMPICTURE pic = self.picture
        cdef np.ndarray np_arr

        # Create a memory view to the data
        if self.bpc == 8:
            np_arr = to_uint8_numpy_array(&pic, self.height, self.width,
                                          self.n_components, comp)
        elif 8 < self.bpc <= 16:
            np_arr = to_uint16_numpy_array(&pic, self.height, self.width,
                                           self.n_components, comp)
        elif self.bpc == 32:
            np_arr = to_float_numpy_array(&pic, self.height, self.width,
                                          self.n_components, comp)
        else:
            raise ValueError("Unexpected value for bpc!")

        return np_arr

    @property
    def n_components(self):
        return self.n_components


class nd2Reader:

    def __init__(self):
        self.attr = None
        self.meta = None
        self.file_name = ""
        self.file_handle = 0
        self.Pictures = {}

    def __del__(self):
        # Close the file, if open
        if self.is_open():
            self.close()

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
        if self.is_open():
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
        components = attr['uiComp']

        # Create a new Picture objects that loads the requested image
        p = Picture(width, height, bpc, components, self.file_handle, index)

        # Store the picture
        self.Pictures[index] = p

        # Return the Picture
        return p

    def get_picture(self, seqIndex):
        """
        Return the Picture as given sequence index. The sequence is loaded
        if necessary.
        :param seqIndex: index of the sequence to load
        :type n: int
        :return: picture
        :rtype: Picture
        """
        if seqIndex not in self.Pictures:
            self.load(seqIndex)

        return self.Pictures[seqIndex]


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

# Create a memoryview for the requested component from the picture data
# stored in the LIMPICTURE structure (no copies are made of the data).
# The view is returned and can be used an numpy array with type np.uint8.
#
# Please notice that if the LIMPICTURE object that owns the data is
# destroyed, the memoryview will be invalid!!
cdef to_uint8_numpy_array(LIMPICTURE * pPicture, int n_rows, int n_cols,
                          int n_components, int component):

    # Get a uint16_t pointer to the picure data
    cdef uint8_t *mat = get_uint8_pointer_to_picture_data(pPicture)

    # Create a contiguous 1D memory view over the whole array
    n_elements = n_rows * n_cols * n_components
    cdef uint8_t[:] mv = <uint8_t[:n_elements]>mat

    # Now skip over the number of components
    mv = mv[component::n_components]

    # Now reshape the view as a 2D numpy array
    cdef np.ndarray arr = np.asarray(mv).reshape(n_rows, n_cols).view(np.uint8)

    # Set the base of the array to the picture data location
    set_base(arr, mat)

    return arr

# Create a memoryview for the requested component from the picture data
# stored in the LIMPICTURE structure (no copies are made of the data).
# The view is returned and can be used an numpy array with type np.uint16.
#
# Please notice that if the LIMPICTURE object that owns the data is
# destroyed, the memoryview will be invalid!!
cdef to_uint16_numpy_array(LIMPICTURE * pPicture, int n_rows, int n_cols,
                           int n_components, int component):

    # Get a uint16_t pointer to the picure data
    cdef uint16_t *mat = get_uint16_pointer_to_picture_data(pPicture)

    # Create a contiguous 1D memory view over the whole array
    n_elements = n_rows * n_cols * n_components
    cdef uint16_t[:] mv = <uint16_t[:n_elements]>mat

    # Now skip over the number of components
    mv = mv[component::n_components]

    # Now reshape the view as a 2D numpy array
    cdef np.ndarray arr = np.asarray(mv).reshape(n_rows, n_cols).view(np.uint16)

    # Set the base of the array to the picture data location
    set_base(arr, mat)

    return arr

# Create a memoryview for the requested component from the picture data
# stored in the LIMPICTURE structure (no copies are made of the data).
# The view is returned and can be used an numpy array with type np.float32.
#
# Please notice that if the LIMPICTURE object that owns the data is
# destroyed, the memoryview will be invalid!!
cdef to_float_numpy_array(LIMPICTURE * pPicture, int n_rows, int n_cols,
                          int n_components, int component):

    # Get a uint16_t pointer to the picure data
    cdef float *mat = get_float_pointer_to_picture_data(pPicture)

    # Create a contiguous 1D memory view over the whole array
    n_elements = n_rows * n_cols * n_components
    cdef float[:] mv = <float[:n_elements]>mat

    # Now skip over the number of components
    mv = mv[component::n_components]

    # Now reshape the view as a 2D numpy array
    cdef np.ndarray arr = np.asarray(mv).reshape(n_rows, n_cols).view(np.float32)

    # Set the base of the array to the picture data location
    set_base(arr, mat)

    return arr
