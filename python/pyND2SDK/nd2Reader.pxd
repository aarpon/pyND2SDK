# Wrapper for nd2ReadSDK.h
#
# Uses the Nikon SDK for accessing data and metadata from ND2 files.

from libc.stddef cimport wchar_t
from libc.stdint cimport uint16_t, uint8_t

cdef extern from "Python.h":
    wchar_t* PyUnicode_AsWideCharString(object, Py_ssize_t *)

cdef extern from "wchar.h":
    int wprintf(const wchar_t *, ...)

cdef extern from "nd2Reader_helper.h":

    ctypedef int LIMFILEHANDLE
    ctypedef unsigned int LIMUINT

    # DEBUG functions
    void dump_LIMATTRIBUTES_struct(LIMATTRIBUTES *s)
    void dump_LIMMETADATA_DESC_struct(LIMMETADATA_DESC *s)
    void dump_LIMTEXTINFO_struct(LIMTEXTINFO *s)
    void dump_LIMPICTUREPLANE_DESC_struct(LIMPICTUREPLANE_DESC *s)
    void dump_LIMEXPERIMENTLEVEL_struct(LIMEXPERIMENTLEVEL *s)
    void dump_LIMEXPERIMENT_struct(LIMEXPERIMENT *s)
    void dump_LIMPICTURE_struct(LIMPICTURE *s)
    void dump_LIMLOCALMETADATA_struct(const LIMLOCALMETADATA *p)

    # Structure to  dictionary functions
    object LIMATTRIBUTES_to_dict(LIMATTRIBUTES *s)
    object LIMMETADATA_DESC_to_dict(LIMMETADATA_DESC *s)
    object LIMTEXTINFO_to_dict(LIMTEXTINFO * s)
    object LIMPICTUREPLANE_DESC_to_dict(LIMPICTUREPLANE_DESC *s)
    object LIMEXPERIMENTLEVEL_to_dict(LIMEXPERIMENTLEVEL * s)
    object LIMEXPERIMENT_to_dict(LIMEXPERIMENT * s)
    object LIMLOCALMETADATA_to_dict(const LIMLOCALMETADATA * s)

    # Data functions
    float * get_float_pointer_to_picture_data(LIMPICTURE * p)
    uint16_t * get_uint16_pointer_to_picture_data(LIMPICTURE * p)
    uint8_t * get_uint8_pointer_to_picture_data(LIMPICTURE * p)
    void load_image_data(int hFile, LIMPICTURE *p, LIMLOCALMETADATA *m, int uiSeqIndex)

    # Metadata functions
    object index_to_subscripts(LIMUINT seq_index, LIMEXPERIMENT *exp, LIMUINT *coords)
    LIMUINT subscripts_to_index(LIMEXPERIMENT *exp, LIMUINT *coords)
    object parse_stage_coords(LIMFILEHANDLE f, LIMATTRIBUTES a, int iUseAlignment)

cdef extern from "nd2ReadSDK.h":

    # Constants (i.e. #DEFINEs)
    #
    # Defining them as enum allows declarations such as array[number]
    enum: LIMMAXPICTUREPLANES
    enum: LIMMAXEXPERIMENTLEVEL
    enum: LIMMAXBINARIES
    enum: LIM_OK
    enum: LIMLOOP_TIME
    enum: LIMLOOP_MULTIPOINT
    enum: LIMLOOP_Z
    enum: LIMLOOP_OTHER
    enum: LIMSTRETCH_QUICK
    enum: LIMSTRETCH_SPLINES
    enum: LIMSTRETCH_LINEAR

    # File handle
    ctypedef int LIMFILEHANDLE

    # Result of operation
    ctypedef int LIMRESULT

    # Unsigned integer
    ctypedef unsigned int LIMUINT

    # Signed integer
    ctypedef int LIMINT

    # "Bool"
    ctypedef int LIMBOOL

    # Wide char
    ctypedef wchar_t LIMWCHAR "wchar_t"

    # Wide char string (python unicode will be cast to it)
    ctypedef wchar_t* LIMWSTR "wchar_t *"

    # Constant pointer to wide char string (python unicode will be cast to it)
    ctypedef const wchar_t* LIMCWSTR "const wchar_t *"

    # Size (unsigned)
    ctypedef size_t LIMSIZE "size_t"

    # Struct LIMATTRIBUTES
    ctypedef struct LIMATTRIBUTES:
        pass

    # Struct LIMMETADATA_DESC
    ctypedef struct LIMMETADATA_DESC:
        pass

    # Struct LIMTEXTINFO
    ctypedef struct LIMTEXTINFO:
        pass

    # Struct LIMPICTUREPLANE_DESC
    ctypedef struct LIMPICTUREPLANE_DESC:
        pass

    # Struct LIMEXPERIMENTLEVEL
    ctypedef struct LIMEXPERIMENTLEVEL:
        pass

    # Struct LIMEXPERIMENT
    ctypedef struct LIMEXPERIMENT:
        pass

    ctypedef struct LIMPICTURE:
        pass

    ctypedef struct LIMLOCALMETADATA:
        pass

    # Open file for reading (and return file handle)
    LIMRESULT _Lim_FileOpenForRead \
            "Lim_FileOpenForRead"(LIMCWSTR wszFileName)

    # Close the file with given handle
    LIMRESULT _Lim_FileClose \
            "Lim_FileClose"(LIMFILEHANDLE file_handle)

    # Get the attributes
    LIMRESULT _Lim_FileGetAttributes \
            "Lim_FileGetAttributes"(LIMFILEHANDLE hFile,
                                    LIMATTRIBUTES* attr)

    # Get the metadata
    LIMRESULT _Lim_FileGetMetadata \
            "Lim_FileGetMetadata"(LIMFILEHANDLE hFile,
                                  LIMMETADATA_DESC* meta)

    # Get the the text info
    LIMRESULT _Lim_FileGetTextinfo \
            "Lim_FileGetTextinfo"(LIMFILEHANDLE hFile,
                                  LIMTEXTINFO* info)

    # Get the experiment
    LIMRESULT _Lim_FileGetExperiment \
            "Lim_FileGetExperiment"(LIMFILEHANDLE hFile,
                                    LIMEXPERIMENT* exp)

    # Initialize a picture
    LIMSIZE _Lim_InitPicture \
            "Lim_InitPicture"(LIMPICTURE* pPicture,
                              LIMUINT width,
                              LIMUINT height,
                              LIMUINT bpc,
                              LIMUINT components)

    # Get image data
    LIMRESULT _Lim_FileGetImageData \
            "Lim_FileGetImageData"(LIMFILEHANDLE hFile,
                                   LIMUINT uiSeqIndex,
                                   LIMPICTURE* pPicture,
                                   LIMLOCALMETADATA* pImgInfo)

    # Destroy a picture
    void _Lim_DestroyPicture \
            "Lim_DestroyPicture"(LIMPICTURE* pPicture)

    # Get sequence index from coordinates
    LIMUINT _Lim_GetSeqIndexFromCoords \
            "Lim_GetSeqIndexFromCoords"(LIMEXPERIMENT* pExperiment,
                                        LIMUINT* pExpCoords)

    # Get coordinates from sequence index
    void _Lim_GetCoordsFromSeqIndex \
            "Lim_GetCoordsFromSeqIndex"(LIMEXPERIMENT* pExperiment,
                                        LIMUINT uiSeqIdx,
                                        LIMUINT* pExpCoords)

    # Read the stage coordinates
    LIMRESULT _Lim_GetStageCoordinates \
            "Lim_GetStageCoordinates"(LIMFILEHANDLE hFile,
                                      LIMUINT uiPosCount,
                                      LIMUINT* puiSeqIdx,
                                      LIMUINT* puiXPos,
                                      LIMUINT* puiYPos,
                                      double* pdXPos,
                                      double *pdYPos,
                                      double *pdZPos,
                                      LIMINT iUseAlignment)


    # Get the Z stack home
    LIMINT _Lim_GetZStackHome \
            "Lim_GetZStackHome"(LIMFILEHANDLE hFile)


    # @TODO: Implement python code
    # Get recorded integer data
    LIMRESULT _Lim_GetRecordedDataInt \
                    "Lim_GetRecordedDataInt"(LIMFILEHANDLE hFile,
                                             LIMCWSTR wszName,
                                             LIMINT uiSeqIndex,
                                             LIMINT *piData)

    # @TODO: Implement python code
    # Get recorded double data
    LIMRESULT _Lim_GetRecordedDataDouble \
                    "Lim_GetRecordedDataDouble"(LIMFILEHANDLE hFile,
                                                LIMCWSTR wszName,
                                                LIMINT uiSeqIndex,
                                                double* pdData)

    # @TODO: Implement python code
    # Get recorded string data
    LIMRESULT _Lim_GetRecordedDataString \
                    "Lim_GetRecordedDataString"(LIMFILEHANDLE hFile,
                                                LIMCWSTR wszName,
                                                LIMINT uiSeqIndex,
                                                LIMWSTR wszData);
    # @TODO: Implement python code
    #  Read the alignment points
    LIMRESULT _Lim_GetAlignmentPoints \
            "Lim_GetAlignmentPoints"(LIMFILEHANDLE hFile,
                                     LIMUINT* puiPosCount,
                                     LIMUINT* puiSeqIdx,
                                     LIMUINT* puiXPos,
                                     LIMUINT* puiYPos,
                                     double *pdXPos,
                                     double *pdYPos)

