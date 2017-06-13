#include "Python.h"
#include "nd2ReadSDK.h"
#include <inttypes.h>
#include <stdint.h>

#ifndef __C_HELPER_H__
#define __C_HELPER_H__

/* -----------------------------------------------------------------------------

    Debug functions: dump the LIM structures for control

    These functions are only compiled if a DEBUG build is asked.

----------------------------------------------------------------------------- */

#ifdef DEBUG

void dump_LIMATTRIBUTES_struct(const LIMATTRIBUTES *s);
void dump_LIMMETADATA_DESC_struct(const LIMMETADATA_DESC *s);
void dump_LIMTEXTINFO_struct(const LIMTEXTINFO *s);
void dump_LIMPICTUREPLANE_DESC_struct(const LIMPICTUREPLANE_DESC *s);
void dump_LIMEXPERIMENTLEVEL_struct(const LIMEXPERIMENTLEVEL *s);
void dump_LIMEXPERIMENT_struct(const LIMEXPERIMENT *s);
void dump_LIMPICTURE_struct(const LIMPICTURE *p);
void dump_LIMLOCALMETADATA_struct(const LIMLOCALMETADATA *p);

#endif

/* -----------------------------------------------------------------------------

    Conversion functions: map LIM structures to python dictionaries;
    and other mappings

----------------------------------------------------------------------------- */

PyObject* LIMATTRIBUTES_to_dict(const LIMATTRIBUTES *s);
PyObject* LIMMETADATA_DESC_to_dict(const LIMMETADATA_DESC *s);
PyObject* LIMTEXTINFO_to_dict(const LIMTEXTINFO * s);
PyObject* LIMPICTUREPLANE_DESC_to_dict(const LIMPICTUREPLANE_DESC * s);
PyObject* LIMEXPERIMENTLEVEL_to_dict(const LIMEXPERIMENTLEVEL * s);
PyObject* LIMEXPERIMENT_to_dict(const LIMEXPERIMENT * s);
PyObject* LIMLOCALMETADATA_to_dict(const LIMLOCALMETADATA * s);


/* -----------------------------------------------------------------------------

    Data access/conversion functions

----------------------------------------------------------------------------- */

float *get_float_pointer_to_picture_data(const LIMPICTURE * p);
uint16_t *get_uint16_pointer_to_picture_data(const LIMPICTURE * p);
uint8_t *get_uint8_pointer_to_picture_data(const LIMPICTURE * p);
void load_image_data(LIMFILEHANDLE hFile, LIMPICTURE *p, LIMLOCALMETADATA *m, unsigned int uiSeqIndex);
void to_rgb(LIMPICTURE *dstPicBuf, const LIMPICTURE *srcPicBuf);

/* -----------------------------------------------------------------------------

    Metadata access functions

----------------------------------------------------------------------------- */

PyObject* index_to_subscripts(LIMUINT seq_index, LIMEXPERIMENT *exp, LIMUINT *coords);
LIMUINT subscripts_to_index(LIMEXPERIMENT *exp, LIMUINT *coords);
PyObject* parse_stage_coords(LIMFILEHANDLE f_handle, LIMATTRIBUTES attr, int iUseAlignment);
PyObject* get_recorded_data_int(LIMFILEHANDLE f_handle, LIMATTRIBUTES attr);
PyObject* get_recorded_data_double(LIMFILEHANDLE f_handle, LIMATTRIBUTES attr);
PyObject* get_recorded_data_string(LIMFILEHANDLE f_handle, LIMATTRIBUTES attr);
PyObject* get_custom_data(LIMFILEHANDLE f_handle);

#endif
