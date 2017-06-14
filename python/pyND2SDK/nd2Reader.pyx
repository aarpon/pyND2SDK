# ND2Reader
#
# Uses the Nikon SDK for accessing data and metadata from ND2 files.
import numpy as np
cimport numpy as np
np.import_array()

# from libc.stdlib cimport free
from libc.stddef cimport wchar_t


# Picture class
cdef class Picture:
    cdef LIMPICTURE picture
    cdef LIMLOCALMETADATA metadata
    cdef int width
    cdef int height
    cdef int bpc
    cdef int n_components
    cdef int seq_index
    cdef int stretch_mode

    def __cinit__(self, int width, int height, int bpc, int n_components,
                 LIMFILEHANDLE hFile, int seq_index):

        # Initialize stretch mode to default
        self.stretch_mode = LIMSTRETCH_LINEAR

        # Store some arguments for easier access
        self.width = width
        self.height = height
        self.bpc = bpc
        self.n_components = n_components
        self.seq_index = seq_index

        # Load the data into the LIMPicture structure
        cdef LIMPICTURE temp_pic
        if _Lim_InitPicture(&temp_pic, width, height, bpc, n_components) == 0:
            raise Exception("Could not initialize picture!")

        # Load the image and store it
        cdef LIMLOCALMETADATA temp_metadata
        load_image_data(hFile, &temp_pic, &temp_metadata, seq_index,
                        self.stretch_mode)
        self.picture = temp_pic
        self.metadata = temp_metadata

    def __dealloc__(self):
        """
        Destructor.

        When the Picture object is destroyed, we make sure
        to destroy also the LIM picture it refers to.
        """
        print("Deleting picture for sequence " + str(self.seq_index) + ".\n")
        _Lim_DestroyPicture(&self.picture)

    def __getitem__(self, comp):
        """
        Return image at given component number as numpy array (memoryview).

        Same as Picture.image(comp)

        @see image()

        :param comp: component number
        :type comp: int
        :return: image
        :rtype: np.array (memoryview)
        """
        return self.image(comp)

    def __repr__(self):
        return self.__str__()

    def __str__(self):
        """
        Display summary of the Picture.
        :return:
        :rtype:
        """

        # Get the geometry
        metadata = LIMLOCALMETADATA_to_dict(&self.metadata)

        str = "Picture:\n" \
              "   XY = (%dx%d), sequence index = %d, components = %d\n" \
              "   Metadata:\n" \
              "      X pos    : %f\n" \
              "      Y pos    : %f\n" \
              "      Z pos    : %f\n" \
              "      Time (ms): %f\n" % \
              (self.width, self.height, self.seq_index, self.n_components,
               metadata['dXPos'], metadata['dYPos'], metadata['dZPos'],
               metadata['dTimeMSec'])

        return str

    @property
    def n_components(self):
        return self.n_components

    @property
    def metadata(self):
        return LIMLOCALMETADATA_to_dict(&self.metadata)

    def image(self, comp):
        """
        Return image at given component number as numpy array (memoryview).
        :param comp: component number
        :type comp: int
        :return: image
        :rtype: np.array (memoryview)
        """

        cdef np.ndarray np_arr

        if comp >= self.n_components:
            raise Exception("The Picture only has " +
                            str(self.n_components) + " components!")

        # Create a memory view to the data
        if self.bpc == 8:
            np_arr = to_uint8_numpy_array(&self.picture, self.height,
                                          self.width, self.n_components, comp)
        elif 8 < self.bpc <= 16:
            np_arr = to_uint16_numpy_array(&self.picture, self.height,
                                           self.width, self.n_components, comp)
        elif self.bpc == 32:
            np_arr = to_float_numpy_array(&self.picture, self.height,
                                          self.width, self.n_components, comp)
        else:
            raise ValueError("Unexpected value for bpc!")

        return np_arr


cdef class nd2Reader:
    """
    ND2 Reader class.
    """

    cdef LIMFILEHANDLE file_handle
    cdef LIMEXPERIMENT exp
    cdef LIMATTRIBUTES attr
    cdef LIMMETADATA_DESC meta
    cdef LIMTEXTINFO info

    cdef public file_name
    cdef dict Pictures

    def __cinit__(self):
        self.file_name = ""
        self.file_handle = 0
        self.Pictures = {}

    def __dealloc__(self):
        # Close the file, if open
        if self.is_open():
            self.close()


    def __repr__(self):
        return self.__str__()

    def __str__(self):
        """
        Display summary of the reader state.
        :return:
        :rtype:
        """
        if not self.is_open():
            return "ND2Reader: no file opened"
        else:

            # Get the geometry
            geometry = self.get_geometry()

            str = "File opened: %s\n" \
                  "   XYZ = (%dx%dx%d), C = %d, T = %d\n" \
                  "   Number of positions = %d (other = %d)\n" \
                  "   %dbit (%d significant)\n" % \
                  (self.file_name,
                   geometry[0], geometry[1], geometry[2],
                   geometry[3], geometry[4], geometry[5],
                   geometry[6], geometry[7], geometry[8])

            return str

    def close(self):
        """
        Closes the file.
        """

        # Close the file
        if self.is_open():
            print("Closing file " + self.file_name + ".\n")
            self.file_handle = _Lim_FileClose(self.file_handle)

        return self.file_handle

    def get_attributes(self):
        """
        Retrieves the file attributes or throws an Exception if it failed.

        The attributes are the LIMATTRIBUTES C structure mapped to a
        python dictionary.

        :return: File attributes.
        :rtype: dict
        """

        if not self.is_open():
            return {}

        # Convert the attribute structure to dict
        return LIMATTRIBUTES_to_dict(&self.attr)

    def get_custom_data(self):
        """
        Return the custom data entities stored.
        :return: custom data
        :rtype: dict
        """

        if not self.is_open():
            return {}

        return get_custom_data(self.file_handle)

    def get_custom_data_count(self):
        """
        Return the number of custom data entities stored.
        :return: count of custom data
        :rtype: int
        """

        if not self.is_open():
            return 0

        return _Lim_GetCustomDataCount(self.file_handle)

    def get_experiment(self):
        """
        Retrieves the experiment info or throws an Exception if it failed.

        The experiment is the LIMEXPERIMENT C structure mapped to a
        python dictionary.

        :return: experiment
        :rtype: dict
        """
        if not self.is_open():
            return {}

        # Convert the experiment structure to dict
        return LIMEXPERIMENT_to_dict(&self.exp)

    def get_geometry(self):
        """
        Returns the geometry of the dataset.

        [x, y, z, c, t, m, o, g, b, s]

            x: width
            y: height
            z: number of planes
            c: number of channels
            t: number of time points
            m: number of positions
            o: other
            g: total number of sequences
            b: bit depth
            s: significant bits

        :return: geometry vector
        :rtype: array
        """

        if not self.is_open():
            return [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

        # Get data in pythonic form
        exp = self.get_experiment()
        attr = self.get_attributes()

        x = 0 # Width
        y = 0 # Height
        z = 1 # Number of planes
        c = 1 # Number of channels
        t = 1 # Number of timepoints
        m = 1 # Number of positions
        o = 0 # Other (?)
        g = 0 # Total number of sequences
        b = 0 # Bit depth
        s = 0 # Significant bits

        cdef int n_levels = exp['uiLevelCount']
        for i in range(n_levels):
            if exp['pAllocatedLevels'][i]['uiExpType'] == LIMLOOP_TIME:
                t = exp['pAllocatedLevels'][i]['uiLoopSize']
            elif exp['pAllocatedLevels'][i]['uiExpType'] == LIMLOOP_MULTIPOINT:
                m = exp['pAllocatedLevels'][i]['uiLoopSize']
            elif exp['pAllocatedLevels'][i]['uiExpType'] == LIMLOOP_Z:
                z = exp['pAllocatedLevels'][i]['uiLoopSize']
            elif exp['pAllocatedLevels'][i]['uiExpType'] == LIMLOOP_OTHER:
                o = exp['pAllocatedLevels'][i]['uiLoopSize']
            else:
                raise Exception("Unexpected experiment level!")

        g = attr['uiSequenceCount']
        x = attr['uiWidth']
        y = attr['uiHeight']
        c = attr['uiComp']
        b = attr['uiBpcInMemory']
        s = attr['uiBpcSignificant']

        return [x, y, z, c, t, m, o, g, b, s]

    def get_metadata(self):
        """
        Retrieves the file metadata or throws an Exception if it failed.

        The metadata is the LIMMETADATA_DESC C structure mapped to a
        python dictionary.

        :return: file metadata
        :rtype: dict
        """

        if not self.is_open():
            return {}

        # Convert metadata structure to dict
        return LIMMETADATA_DESC_to_dict(&self.meta)

    def get_position_names(self):
        """
        Return the names of the positions
        :return: list of position names
        :rtype: list
        """

        if not self.is_open():
            return []

        return get_multi_point_names(self.file_handle, self.positions)

    def get_recorded_data(self):
        """
        Get the recorded data and return it in a python dictionary.
        :return: recorded data
        :rtype: dict
        """

        if not self.is_open():
            return {}

        # Initialize the dictionary
        d = {}

        # Retrieve the data
        double_data = get_recorded_data_double(self.file_handle,
                                               self.attr)

        int_data = get_recorded_data_int(self.file_handle,
                                         self.attr)

        string_data = get_recorded_data_string(self.file_handle,
                                               self.attr)

        # Store it
        d['double_data'] = double_data
        d['integer_data'] = int_data
        d['string_data'] = string_data

        # Return it
        return d

    def get_stage_coordinates(self, use_alignment=0):
        """
        Get stage coordinates.
        :param use_alignment:
        :type use_alignment:
        :return:
        :rtype:
        """
        # Make sure the file is open
        if not self.is_open():
            return []

        # Make sure the attributes have ben read
        self.get_attributes()

        stage_coords = parse_stage_coords(self.file_handle,
                                          self.attr,
                                          use_alignment)

        return stage_coords

    def get_text_info(self):
        """
        Retrieves the text info or throws an Exception if it failed.

        The text info is the LIMTEXTINFO C structure mapped to a
        python dictionary.

        :return: file text info
        :rtype: dict
        """

        if not self.is_open():
            return {}

        if _Lim_FileGetTextinfo(self.file_handle, &self.info) != LIM_OK:
            raise Exception("Could not retrieve the text info!")

        # Convert to dict
        return LIMTEXTINFO_to_dict(&self.info)

    def get_z_stack_home(self):
        """
        Return the Z stack home.
        :return: Z stack home
        :rtype: int
        """
        cdef LIMINT home = 0

        if not self.is_open():
            return None

        # Get the experiment as a python dictionary
        exp = self.get_experiment()

        # Retrieve the home value if we have a z stack only
        for i in range(exp['uiLevelCount']):
            if exp['pAllocatedLevels'][i]['uiExpType'] == LIMLOOP_Z:
                home = _Lim_GetZStackHome(self.file_handle)
                if home < 0:
                    home = 0

        return home

    def is_open(self):
        """
        Checks if the file is open.
        :return: True if the file is open, False otherwise.
        :rtype: bool
        """
        return self.file_handle != 0

    def load(self, LIMUINT time, LIMUINT point, LIMUINT plane,
             LIMUINT other = 0, LIMUINT width=-1, LIMUINT height=-1):
        """Loads, stores a return the picture.

        :param index: index of the sequence (image) to load
        :type height: unsigned int

        :return: Picture object
        :rtype: PyND2SDK.Picture
        """

        if not self.is_open():
            return None

        # Map the subs to a linear index
        index = self.map_subscripts_to_index(time, point, plane, other)

        # Load the Picture
        p = self.load_by_index(index, width, height)

        # Return the Picture
        return p

    def load_by_index(self, LIMUINT index, LIMUINT width=-1, LIMUINT height=-1):
        """Loads, stores a return the picture at given index.

        Optionally, it can resize to requested (width x height) on loading;
        in this case, however, the image is not cached.

        :type width: unsignded int
        :param index: index of the sequence (image) to load
        :type height: unsigned int

        :return: Picture object
        :rtype: PyND2SDK.Picture
        """

        if not self.is_open():
            return None

        # If the image was loaded already, return it from the cache
        if index in self.Pictures and width == -1 and height == -1:
            print("Returning picture from cache.")
            return self.Pictures[index]

        # Get the attributes
        attr = self.get_attributes()

        if index >= attr['uiSequenceCount']:
            raise Exception("The requested sequence does not exist in the file!")

        # Create a new Picture objects that loads the requested image
        store = False
        if width == -1:
            width = attr['uiWidth']
            store = True
        if height == -1:
            height = attr['uiHeight']
            store = True

        p = Picture(width,
                    height,
                    attr['uiBpcSignificant'],
                    attr['uiComp'],
                    self.file_handle,
                    index)

        # Store the picture if full size
        if store:
            print("Adding Picture to the cache.")
            self.Pictures[index] = p
        else:
            print("The Picture is resized and is NOT being added to the cache.")

        # Return the Picture
        return p

    def map_index_to_subscripts(self, seq_index):
        """
        Map linear index to subscripts.
        :param seq_index:
        :type seq_index:
        :return:
        :rtype:
        """
        if not self.is_open():
            return None

        cdef LIMUINT[LIMMAXEXPERIMENTLEVEL] pExpCoords;
        return index_to_subscripts(seq_index, &self.exp, pExpCoords)

    def map_subscripts_to_index(self, time, point, plane, other = 0):
        """
        Map subscripts to linear index.
        :param time:
        :type time:
        :param point:
        :type point:
        :param plane:
        :type plane:
        :param other:
        :type other:
        :return:
        :rtype:
        """
        if not self.is_open():
            return {}

        cdef LIMUINT[LIMMAXEXPERIMENTLEVEL] pExpCoords;
        pExpCoords[0] = time
        pExpCoords[1] = point
        pExpCoords[2] = plane
        pExpCoords[3] = other

        return subscripts_to_index(&self.exp, pExpCoords)

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
        if self.file_handle == 0:
            raise Exception("Could not open file " + filename + "!")

        # Load the experiment
        if _Lim_FileGetExperiment(self.file_handle, &self.exp) != LIM_OK:
            raise Exception("Could not retrieve the experiment info!")

        # Load the attributes
        if _Lim_FileGetAttributes(self.file_handle, &self.attr) != LIM_OK:
            raise Exception("Could not retrieve the file attributes!")

        # Load the metadata
        if _Lim_FileGetMetadata(self.file_handle, &self.meta) != LIM_OK:
            raise Exception("Could not retrieve the file metadata!")

        return self.file_handle

    @property
    def width(self):
        return self.get_geometry()[0]

    @property
    def height(self):
        return self.get_geometry()[1]

    @property
    def planes(self):
        return self.get_geometry()[2]

    @property
    def channels(self):
        return self.get_geometry()[3]

    @property
    def timepoints(self):
        return self.get_geometry()[4]

    @property
    def positions(self):
        return self.get_geometry()[5]

    @property
    def other(self):
        return self.get_geometry()[6]

    @property
    def sequences(self):
        return self.get_geometry()[7]

    @property
    def bits(self):
        return self.get_geometry()[8]

    @property
    def significant_bits(self):
        return self.get_geometry()[9]


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

    # Get a uint8_t pointer to the picture data
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

    # Get a uint16_t pointer to the picture data
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

    # Get a float pointer to the picture data
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
