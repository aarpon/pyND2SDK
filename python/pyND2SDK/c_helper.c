#include "c_helper.h"
#include <stdio.h>

/* -----------------------------------------------------------------------------

    Debug functions: dump the LIM structures for control

----------------------------------------------------------------------------- */

void dump_LIMATTRIBUTES_struct(LIMATTRIBUTES *s)
{
    printf("uiWidth             = %d\n", (long)s->uiWidth);
    printf("uiWidthBytes        = %d\n", (long)s->uiWidthBytes);
    printf("uiHeight            = %d\n", (long)s->uiHeight);
    printf("uiComp              = %d\n", (long)s->uiComp);
    printf("uiBpcInMemory       = %d\n", (long)s->uiBpcInMemory);
    printf("uiBpcSignificant    = %d\n", (long)s->uiBpcSignificant);
    printf("uiSequenceCount     = %d\n", (long)s->uiSequenceCount);
    printf("uiTileWidth         = %d\n", (long)s->uiTileWidth);
    printf("uiTileHeight        = %d\n", (long)s->uiTileHeight);
    printf("uiCompression       = %d\n", (long)s->uiCompression);
    printf("uiQuality           = %d\n", (long)s->uiQuality);
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
	// Print just the metadata for the first two planes
	// @TODO: make sure that the correct number is given by 'uiPlaneCount'!
	for (int i = 0; i < (int)s->uiPlaneCount; i++)
	{
		LIMPICTUREPLANE_DESC p = s->pPlanes[i];
		printf("Plane %d\n", i);
		dump_LIMPICTUREPLANE_DESC_struct(&p);
	}
}

void dump_LIMTEXTINFO_struct(LIMTEXTINFO *s)
{
    printf("wszImageID          = %ls\n", (LIMWSTR)s->wszImageID);
    printf("wszType             = %ls\n", (LIMWSTR)s->wszType);
    printf("wszGroup            = %ls\n", (LIMWSTR)s->wszGroup);
    printf("wszSampleID         = %ls\n", (LIMWSTR)s->wszSampleID);
    printf("wszAuthor           = %ls\n", (LIMWSTR)s->wszAuthor);
    printf("wszDescription      = %ls\n", (LIMWSTR)s->wszDescription);
    printf("wszCapturing        = %ls\n", (LIMWSTR)s->wszCapturing);
    printf("wszSampling         = %ls\n", (LIMWSTR)s->wszSampling);
    printf("wszLocation         = %ls\n", (LIMWSTR)s->wszLocation);
    printf("wszDate             = %ls\n", (LIMWSTR)s->wszDate);
    printf("wszConclusion       = %ls\n", (LIMWSTR)s->wszConclusion);
    printf("wszInfo1            = %ls\n", (LIMWSTR)s->wszInfo1);
    printf("wszInfo2            = %ls\n", (LIMWSTR)s->wszInfo2);
    printf("wszOptics           = %ls\n", (LIMWSTR)s->wszOptics);
    printf("wszAppVersion       = %ls\n", (LIMWSTR)s->wszAppVersion);
}

void dump_LIMPICTUREPLANE_DESC_struct(LIMPICTUREPLANE_DESC *s)
{
    printf("    uiCompCount     = %d\n", (long)s->uiCompCount);
    printf("    uiColorRGB      = %d\n", (long)s->uiColorRGB);
    printf("    wszName         = %ls\n", (LIMWSTR)s->wszName);
    printf("    wszOCName       = %ls\n", (LIMWSTR)s->wszOCName);
    printf("    dEmissionWL     = %f\n", (double)s->dEmissionWL);
}

void dump_LIMEXPERIMENTLEVEL_struct(LIMEXPERIMENTLEVEL *s)
{
    printf("    uiExpType       = %d\n", (long)s->uiExpType);
    printf("    uiLoopSize      = %d\n", (long)s->uiLoopSize);
    printf("    dInterval       = %f\n", (double)s->dInterval);
}

void dump_LIMEXPERIMENT_struct(LIMEXPERIMENT *s)
{
    printf("uiLevelCount        = %d\n", (long)s->uiLevelCount);
    for (int i = 0; i < LIMMAXEXPERIMENTLEVEL; i++)
    {
        LIMEXPERIMENTLEVEL l = s->pAllocatedLevels[i];
        dump_LIMEXPERIMENTLEVEL_struct(&l);
    }
}

/* -----------------------------------------------------------------------------

    Map LIM structures to python dictionaries

----------------------------------------------------------------------------- */

PyObject* LIMATTRIBUTES_to_dict(LIMATTRIBUTES *s)
{
    // Create a dictionary
    PyObject* d = PyDict_New();

    // Add values
    PyDict_SetItemString(d, "uiWidth",
            PyLong_FromLong((long)s->uiWidth));
    PyDict_SetItemString(d, "uiWidthBytes",
            PyLong_FromLong((long)s->uiWidthBytes));
    PyDict_SetItemString(d, "uiHeight",
            PyLong_FromLong((long)s->uiHeight));
    PyDict_SetItemString(d, "uiComp",
            PyLong_FromLong((long)s->uiComp));
    PyDict_SetItemString(d, "uiBpcInMemory",
            PyLong_FromLong((long)s->uiBpcInMemory));
    PyDict_SetItemString(d, "uiBpcSignificant",
            PyLong_FromLong((long)s->uiBpcSignificant));
    PyDict_SetItemString(d, "uiSequenceCount",
            PyLong_FromLong((long)s->uiSequenceCount));
    PyDict_SetItemString(d, "uiTileWidth",
            PyLong_FromLong((long)s->uiTileWidth));
    PyDict_SetItemString(d, "uiTileHeight",
            PyLong_FromLong((long)s->uiTileHeight));
    PyDict_SetItemString(d, "uiCompression",
            PyLong_FromLong((long)s->uiCompression));
    PyDict_SetItemString(d, "uiQuality",
            PyLong_FromLong((long)s->uiQuality));

    // Return
    return d;
}

PyObject* LIMMETADATA_DESC_to_dict(LIMMETADATA_DESC *s)
{

    // Create a dictionary
    PyObject* d = PyDict_New();

    // Add (single) values
    PyDict_SetItemString(d, "dTimeStart",
            PyFloat_FromDouble((double)s->dTimeStart));
    PyDict_SetItemString(d, "dAngle",
            PyFloat_FromDouble((double)s->dAngle));
    PyDict_SetItemString(d, "dCalibration",
            PyFloat_FromDouble((double)s->dCalibration));
    PyDict_SetItemString(d, "dObjectiveMag",
            PyFloat_FromDouble((double)s->dObjectiveMag));
    PyDict_SetItemString(d, "dObjectiveNA",
            PyFloat_FromDouble((double)s->dObjectiveNA));
    PyDict_SetItemString(d, "dRefractIndex1",
            PyFloat_FromDouble((double)s->dRefractIndex1));
    PyDict_SetItemString(d, "dRefractIndex2",
            PyFloat_FromDouble((double)s->dRefractIndex2));
    PyDict_SetItemString(d, "dPinholeRadius",
            PyFloat_FromDouble((double)s->dPinholeRadius));
    PyDict_SetItemString(d, "dZoom",
            PyFloat_FromDouble((double)s->dZoom));
    PyDict_SetItemString(d, "dProjectiveMag",
            PyFloat_FromDouble((double)s->dProjectiveMag));
    PyDict_SetItemString(d, "uiPlaneCount",
            PyLong_FromLong((long)s->uiPlaneCount));
    PyDict_SetItemString(d, "uiComponentCount",
            PyLong_FromLong((long)s->uiComponentCount));
    PyDict_SetItemString(d, "wszObjectiveName",
            PyUnicode_FromWideChar((LIMWSTR)s->wszObjectiveName, -1));

    // Create a list to add the LIMPICTUREPLANE_DESC objects.
    // @TODO: make sure that the correct number is given by 'uiPlaneCount'!
    PyObject* l = PyList_New((Py_ssize_t) s->uiPlaneCount);

    for (int i = 0; i < (Py_ssize_t) s->uiPlaneCount; i++)
    {
        // Map the LIMPICTUREPLANE_DESC struct (plane) to a dictionary
        PyObject* p = LIMPICTUREPLANE_DESC_to_dict(&(s->pPlanes[i]));

        // Store it
        PyList_SetItem(l, i, p);
    }

    // Add the list
    PyDict_SetItemString(d, "pPlanes", l);

    // Return
    return d;
}

PyObject* LIMTEXTINFO_to_dict(LIMTEXTINFO * s)
{
    // Create a dictionary
    PyObject* d = PyDict_New();

    // Add values
    PyDict_SetItemString(d, "wszImageID",
            PyUnicode_FromWideChar((LIMWSTR)s->wszImageID, -1));
    PyDict_SetItemString(d, "wszType",
            PyUnicode_FromWideChar((LIMWSTR)s->wszType, -1));
    PyDict_SetItemString(d, "wszGroup",
            PyUnicode_FromWideChar((LIMWSTR)s->wszGroup, -1));
    PyDict_SetItemString(d, "wszSampleID",
            PyUnicode_FromWideChar((LIMWSTR)s->wszSampleID, -1));
    PyDict_SetItemString(d, "wszAuthor",
            PyUnicode_FromWideChar((LIMWSTR)s->wszAuthor, -1));
    PyDict_SetItemString(d, "wszDescription",
            PyUnicode_FromWideChar((LIMWSTR)s->wszDescription, -1));
    PyDict_SetItemString(d, "wszCapturing",
            PyUnicode_FromWideChar((LIMWSTR)s->wszCapturing, -1));
    PyDict_SetItemString(d, "wszSampling",
            PyUnicode_FromWideChar((LIMWSTR)s->wszSampling, -1));
    PyDict_SetItemString(d, "wszLocation",
            PyUnicode_FromWideChar((LIMWSTR)s->wszLocation, -1));
    PyDict_SetItemString(d, "wszDate",
            PyUnicode_FromWideChar((LIMWSTR)s->wszDate, -1));
    PyDict_SetItemString(d, "wszConclusion",
            PyUnicode_FromWideChar((LIMWSTR)s->wszConclusion, -1));
    PyDict_SetItemString(d, "wszInfo1",
            PyUnicode_FromWideChar((LIMWSTR)s->wszInfo1, -1));
    PyDict_SetItemString(d, "wszInfo2",
            PyUnicode_FromWideChar((LIMWSTR)s->wszInfo2, -1));
    PyDict_SetItemString(d, "wszOptics",
            PyUnicode_FromWideChar((LIMWSTR)s->wszOptics, -1));
    PyDict_SetItemString(d, "wszAppVersion",
            PyUnicode_FromWideChar((LIMWSTR)s->wszAppVersion, -1));

    // Return
    return d;
}

PyObject* LIMPICTUREPLANE_DESC_to_dict(LIMPICTUREPLANE_DESC * s)
{
    // Create a dictionary
    PyObject* d = PyDict_New();

    // Add values
    PyDict_SetItemString(d, "uiCompCount",
            PyLong_FromLong((long)s->uiCompCount));
    PyDict_SetItemString(d, "uiColorRGB",
            PyLong_FromLong((long)s->uiColorRGB));
    PyDict_SetItemString(d, "wszName",
            PyUnicode_FromWideChar((LIMWSTR)s->wszName, -1));
    PyDict_SetItemString(d, "wszOCName",
            PyUnicode_FromWideChar((LIMWSTR)s->wszOCName, -1));
    PyDict_SetItemString(d, "dEmissionWL",
            PyLong_FromDouble((double)s->dEmissionWL));

    // Return
    return d;
}

PyObject* LIMEXPERIMENTLEVEL_to_dict(LIMEXPERIMENTLEVEL * s)
{
    // Create a dictionary
    PyObject* d = PyDict_New();

    // Add values
    PyDict_SetItemString(d, "uiExpType",
            PyLong_FromLong((long)s->uiExpType));
    PyDict_SetItemString(d, "uiLoopSize",
            PyLong_FromLong((long)s->uiLoopSize));
    PyDict_SetItemString(d, "dInterval",
            PyLong_FromDouble((double)s->dInterval));

    // Return
    return d;
}

PyObject* LIMEXPERIMENT_to_dict(LIMEXPERIMENT * s)
{
    // Create a dictionary
    PyObject* d = PyDict_New();

    // Add values
    PyDict_SetItemString(d, "uiLevelCount",
            PyLong_FromLong((long)s->uiLevelCount));

    // Create a list to add the LIMEXPERIMENTLEVEL objects.
    PyObject* l = PyList_New((Py_ssize_t) LIMMAXEXPERIMENTLEVEL);

    for (int i = 0; i < (Py_ssize_t) LIMMAXEXPERIMENTLEVEL; i++)
    {
        // Map the LIMEXPERIMENTLEVEL struct to a dictionary
        PyObject* p = LIMEXPERIMENTLEVEL_to_dict(&(s->pAllocatedLevels[i]));

        // Store it
        PyList_SetItem(l, i, p);
    }

    // Add the list
    PyDict_SetItemString(d, "pAllocatedLevels", l);


    // Return
    return d;
}
