#include "Python.h"
#include "nd2ReadSDK.h"

#ifndef __C_HELPER_H__
#define __C_HELPER_H__

/* -----------------------------------------------------------------------------

    Debug functions: dump the LIM structures for control

----------------------------------------------------------------------------- */

void dump_LIMATTRIBUTES_struct(LIMATTRIBUTES *s);
void dump_LIMMETADATA_DESC_struct(LIMMETADATA_DESC *s);
void dump_LIMTEXTINFO_struct(LIMTEXTINFO *s);
void dump_LIMPICTUREPLANE_DESC_struct(LIMPICTUREPLANE_DESC *s);
void dump_LIMEXPERIMENTLEVEL_struct(LIMEXPERIMENTLEVEL *s);
void dump_LIMEXPERIMENT_struct(LIMEXPERIMENT *s);

/* -----------------------------------------------------------------------------

    Conversion functions: map LIM structures to python dictionaries

----------------------------------------------------------------------------- */

PyObject* LIMATTRIBUTES_to_dict(LIMATTRIBUTES *s);
PyObject* LIMMETADATA_DESC_to_dict(LIMMETADATA_DESC *s);
PyObject* LIMTEXTINFO_to_dict(LIMTEXTINFO * s);
PyObject* LIMPICTUREPLANE_DESC_to_dict(LIMPICTUREPLANE_DESC * s);
PyObject* LIMEXPERIMENTLEVEL_to_dict(LIMEXPERIMENTLEVEL * s);
PyObject* LIMEXPERIMENT_to_dict(LIMEXPERIMENT * s);

#endif
