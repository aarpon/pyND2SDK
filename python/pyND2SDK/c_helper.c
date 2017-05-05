#include "c_helper.h"
#include <stdio.h>

/* -----------------------------------------------------------------------------

    Debug functions: dump the LIM structures for control

----------------------------------------------------------------------------- */

void dump_LIMATTRIBUTES_struct(LIMATTRIBUTES *s)
{
    printf("uiWidth          = %d\n", (long)s->uiWidth);
    printf("uiWidthBytes     = %d\n", (long)s->uiWidthBytes);
    printf("uiHeight         = %d\n", (long)s->uiHeight);
    printf("uiComp           = %d\n", (long)s->uiComp);
    printf("uiBpcInMemory    = %d\n", (long)s->uiBpcInMemory);
    printf("uiBpcSignificant = %d\n", (long)s->uiBpcSignificant);
    printf("uiSequenceCount  = %d\n", (long)s->uiSequenceCount);
    printf("uiTileWidth      = %d\n", (long)s->uiTileWidth);
    printf("uiTileHeight     = %d\n", (long)s->uiTileHeight);
    printf("uiCompression    = %d\n", (long)s->uiCompression);
    printf("uiQuality        = %d\n", (long)s->uiQuality);
}

void dump_LIMMETADATA_DESC_struct(LIMMETADATA_DESC *s)
{
	printf("dTimeStart          = %f\n", (double)s->dTimeStart);
	printf("dAngle              = %f\n", (double)s->dAngle);
	printf("dCalibration        = %f\n", (double)s->dCalibration);
	printf("dObjectiveMag       = %f\n", (double)s->dObjectiveMag);
	printf("dObjectiveNA        = %f\n", (double)s->dObjectiveNA);
	printf("dRefractIndex1      = %f\n", (double)s->dRefractIndex1);
	printf("dRefractIndex2      = %f\n", (double)s->dRefractIndex2);
	printf("dPinholeRadius      = %f\n", (double)s->dPinholeRadius);
	printf("dZoom               = %f\n", (double)s->dZoom);
	printf("dProjectiveMag      = %f\n", (double)s->dProjectiveMag);
	printf("uiImageType         = %d\n", (LIMUINT)s->uiImageType);
	printf("uiPlaneCount        = %d\n", (LIMUINT)s->uiPlaneCount);
	printf("uiComponentCount    = %d\n", (LIMUINT)s->uiComponentCount);
	printf("wszObjectiveName    = %ls\n", (LIMWSTR)s->wszObjectiveName);
	// @todo Still missing: LIMPICTUREPLANE_DESC pPlanes[LIMMAXPICTUREPLANES];
}

/* -----------------------------------------------------------------------------

    Map LIM structures to python dictionaries

----------------------------------------------------------------------------- */

PyObject* LIMATTRIBUTES_to_dict(LIMATTRIBUTES *s)
{
    // Create a dictionary
    PyObject* d = PyDict_New();

    // Add values
    PyDict_SetItemString(d, "uiWidth",          PyLong_FromLong((long)s->uiWidth));
    PyDict_SetItemString(d, "uiWidthBytes",     PyLong_FromLong((long)s->uiWidthBytes));
    PyDict_SetItemString(d, "uiHeight",         PyLong_FromLong((long)s->uiHeight));
    PyDict_SetItemString(d, "uiComp",           PyLong_FromLong((long)s->uiComp));
    PyDict_SetItemString(d, "uiBpcInMemory",    PyLong_FromLong((long)s->uiBpcInMemory));
    PyDict_SetItemString(d, "uiBpcSignificant", PyLong_FromLong((long)s->uiBpcSignificant));
    PyDict_SetItemString(d, "uiSequenceCount",  PyLong_FromLong((long)s->uiSequenceCount));
    PyDict_SetItemString(d, "uiTileWidth",      PyLong_FromLong((long)s->uiTileWidth));
    PyDict_SetItemString(d, "uiTileHeight",     PyLong_FromLong((long)s->uiTileHeight));
    PyDict_SetItemString(d, "uiCompression",    PyLong_FromLong((long)s->uiCompression));
    PyDict_SetItemString(d, "uiQuality",        PyLong_FromLong((long)s->uiQuality));

    // Return
    return d;
}

PyObject* LIMMETADATA_DESC_to_dict(LIMMETADATA_DESC *s)
{
    // Create a dictionary
    PyObject* d = PyDict_New();

    // Add values
    PyDict_SetItemString(d, "dTimeStart",           PyFloat_FromDouble((double)s->dTimeStart));
    PyDict_SetItemString(d, "dAngle",               PyFloat_FromDouble((double)s->dAngle));
    PyDict_SetItemString(d, "dCalibration",         PyFloat_FromDouble((double)s->dCalibration));
    PyDict_SetItemString(d, "dObjectiveMag",        PyFloat_FromDouble((double)s->dObjectiveMag));
    PyDict_SetItemString(d, "dObjectiveNA",         PyFloat_FromDouble((double)s->dObjectiveNA));
    PyDict_SetItemString(d, "dRefractIndex1",       PyFloat_FromDouble((double)s->dRefractIndex1));
    PyDict_SetItemString(d, "dRefractIndex2",       PyFloat_FromDouble((double)s->dRefractIndex2));
    PyDict_SetItemString(d, "dPinholeRadius",       PyFloat_FromDouble((double)s->dPinholeRadius));
    PyDict_SetItemString(d, "dZoom",                PyFloat_FromDouble((double)s->dZoom));
    PyDict_SetItemString(d, "dProjectiveMag",       PyFloat_FromDouble((double)s->dProjectiveMag));
    PyDict_SetItemString(d, "uiPlaneCount",         PyLong_FromLong((long)s->uiPlaneCount));
    PyDict_SetItemString(d, "uiComponentCount",     PyLong_FromLong((long)s->uiComponentCount));
    PyDict_SetItemString(d, "wszObjectiveName",     PyUnicode_FromWideChar((LIMWSTR)s->wszObjectiveName, -1));
    PyDict_SetItemString(d, "LIMPICTUREPLANE_DESC", PyLong_FromLong(0));  // @todo Still missing!

    // Return
    return d;
}
