#include "stdafx.h"
#include "helper.h"
#include "nd2ReadSDK.h"

/**
Convert a wchar_t * array to a std::string.
*/
std::string wchart_to_string(wchar_t *wc)
{
	std::wstring ws(wc);
	std::string str(ws.begin(), ws.end());
	return str;
}

void dump_LIMATTRIBUTES_struct(LIMATTRIBUTES *s)
{
	std::cout << "uiWidth          = " << (long)s->uiWidth << std::endl;
	std::cout << "uiWidthBytes     = " << (long)s->uiWidthBytes << std::endl;
	std::cout << "uiHeight         = " << (long)s->uiHeight << std::endl;
	std::cout << "uiComp           = " << (long)s->uiComp << std::endl;
	std::cout << "uiBpcInMemory    = " << (long)s->uiBpcInMemory << std::endl;
	std::cout << "uiBpcSignificant = " << (long)s->uiBpcSignificant << std::endl;
	std::cout << "uiSequenceCount  = " << (long)s->uiSequenceCount << std::endl;
	std::cout << "uiTileWidth      = " << (long)s->uiTileWidth << std::endl;
	std::cout << "uiTileHeight     = " << (long)s->uiTileHeight << std::endl;
	std::cout << "uiCompression    = " << (long)s->uiCompression << std::endl;
	std::cout << "uiQuality        = " << (long)s->uiQuality << std::endl;
}

void dump_LIMMETADATA_DESC_struct(LIMMETADATA_DESC *s)
{
	// Some conversions
	std::wstring objName = s->wszObjectiveName;

	std::cout << "dTimeStart          = " << (double)s->dTimeStart << std::endl;
	std::cout << "dAngle              = " << (double)s->dAngle << std::endl;
	std::cout << "dCalibration        = " << (double)s->dCalibration << std::endl;
	std::cout << "dObjectiveMag       = " << (double)s->dObjectiveMag << std::endl;
	std::cout << "dObjectiveNA        = " << (double)s->dObjectiveNA << std::endl;
	std::cout << "dRefractIndex1      = " << (double)s->dRefractIndex1 << std::endl;
	std::cout << "dRefractIndex2      = " << (double)s->dRefractIndex2 << std::endl;
	std::cout << "dPinholeRadius      = " << (double)s->dPinholeRadius << std::endl;
	std::cout << "dZoom               = " << (double)s->dZoom << std::endl;
	std::cout << "dProjectiveMag      = " << (double)s->dProjectiveMag << std::endl;
	std::cout << "uiImageType         = " << (LIMUINT)s->uiImageType << std::endl;
	std::cout << "uiPlaneCount        = " << (LIMUINT)s->uiPlaneCount << std::endl;
	std::cout << "uiComponentCount    = " << (LIMUINT)s->uiComponentCount << std::endl;
	// @todo Still missing: LIMPICTUREPLANE_DESC pPlanes[LIMMAXPICTUREPLANES];

	std::cout << "wszObjectiveName    = ";std::wcout << objName.c_str();std::cout << std::endl;
}

void dump_LIMTEXTINFO_struct(LIMTEXTINFO *s)
{

	// Some conversions
	std::wstring wszImageID = s->wszImageID;
	std::wstring wszType = s->wszType;
	std::wstring wszGroup = s->wszGroup;
	std::wstring wszSampleID = s->wszSampleID;
	std::wstring wszAuthor = s->wszAuthor;
	std::wstring wszDescription = s->wszDescription;
	std::wstring wszCapturing = s->wszCapturing;
	std::wstring wszSampling = s->wszSampling;
	std::wstring wszLocation = s->wszLocation;
	std::wstring wszDate = s->wszDate;
	std::wstring wszConclusion = s->wszConclusion;
	std::wstring wszInfo1 = s->wszInfo1;
	std::wstring wszInfo2 = s->wszInfo2;
	std::wstring wszOptics = s->wszOptics;
	std::wstring wszAppVersion = s->wszAppVersion;

	std::cout << "wszImageID     = "; std::wcout << wszImageID.c_str(); std::cout << std::endl;
	std::cout << "wszType        = "; std::wcout << wszType.c_str(); std::cout << std::endl;
	std::cout << "wszGroup       = "; std::wcout << wszGroup.c_str(); std::cout << std::endl;
	std::cout << "wszSampleID    = "; std::wcout << wszSampleID.c_str(); std::cout << std::endl;
	std::cout << "wszAuthor      = "; std::wcout << wszAuthor.c_str(); std::cout << std::endl;
	std::cout << "wszDescription = "; std::wcout << wszDescription.c_str(); std::cout << std::endl;
	std::cout << "wszCapturing   = "; std::wcout << wszCapturing.c_str(); std::cout << std::endl;
	std::cout << "wszSampling    = "; std::wcout << wszSampling.c_str(); std::cout << std::endl;
	std::cout << "wszLocation    = "; std::wcout << wszLocation.c_str(); std::cout << std::endl;
	std::cout << "wszDate        = "; std::wcout << wszDate.c_str(); std::cout << std::endl;
	std::cout << "wszConclusion  = "; std::wcout << wszConclusion.c_str(); std::cout << std::endl;
	std::cout << "wszInfo1       = "; std::wcout << wszInfo1.c_str(); std::cout << std::endl;
	std::cout << "wszInfo2       = "; std::wcout << wszInfo2.c_str(); std::cout << std::endl;
	std::cout << "wszOptics      = "; std::wcout << wszOptics.c_str(); std::cout << std::endl;
	std::cout << "wszAppVersion  = "; std::wcout << wszAppVersion.c_str(); std::cout << std::endl;
}
