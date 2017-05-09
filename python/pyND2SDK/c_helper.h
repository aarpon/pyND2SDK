#include "Python.h"
#include "nd2ReadSDK.h"

void dump_LIMATTRIBUTES_struct(LIMATTRIBUTES *s);
void dump_LIMMETADATA_DESC_struct(LIMMETADATA_DESC *s);
void dump_LIMTEXTINFO_struct(LIMTEXTINFO *s);

PyObject* LIMATTRIBUTES_to_dict(LIMATTRIBUTES *s);
PyObject* LIMMETADATA_DESC_to_dict(LIMMETADATA_DESC *s);
PyObject* LIMTEXTINFO_to_dict(LIMTEXTINFO * s);
