// nikonmdparser.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>
#include "nd2ReadSDK.h"
#include <string>
#include "helper.h"

class ND2File
{
private:
	
	LIMFILEHANDLE m_FileHandle;
	LIMATTRIBUTES m_Attr;
	LIMMETADATA_DESC m_Metadata;
	LIMTEXTINFO m_TextInfo;

	LIMWCHAR m_filename[256];

public:

	ND2File(std::wstring filename)
	{
		// Store the file name
		if (filename.length() > 0)
		{
			wcscpy_s(m_filename, filename.c_str());
		}
		else
		{
			wcscpy_s(m_filename, L"");
		}
	}

	bool parse() 
	{
		if (m_FileHandle)
			Lim_FileClose(m_FileHandle);

		// Try opening the file
		m_FileHandle = Lim_FileOpenForRead(m_filename);

		if (!m_FileHandle)
		{
			std::cerr << "Could not open file!" << std::endl;
			return false;
		}
	
		// Read the attributes (result is 0 on success)
		if (Lim_FileGetAttributes(m_FileHandle, &m_Attr) != 0)
		{
			std::cerr << "Could not read file attributes!" << std::endl;
			return false;
		}

		// Print attributes
		std::cout << "LIMATTRIBUTES:" << std::endl;
		dump_LIMATTRIBUTES_struct(&m_Attr);

		// Read the metadata (result is 0 on success)
		if (Lim_FileGetMetadata(m_FileHandle, &m_Metadata) != 0)
		{
			std::cerr << "Could not read file metadata!" << std::endl;
			return false;
		}

		// Print metadata
		std::cout << std::endl << "LIMMETADATA_DESC:" << std::endl;
		dump_LIMMETADATA_DESC_struct(&m_Metadata);

		// Read the text info (result is 0 on success)
		if (Lim_FileGetTextinfo(m_FileHandle, &m_TextInfo) != 0)
		{
			std::cerr << "Could not read file text info!" << std::endl;
			return false;
		}

		// Print metadata
		std::cout << std::endl << "LIMTEXTINFO:" << std::endl;
		dump_LIMTEXTINFO_struct(&m_TextInfo);

		return true;
	}

	void close()
	{
		if (m_FileHandle)
			Lim_FileClose(m_FileHandle);
	}

};

int main(int argc, char *argv[])
{

	//std::wstring filename = L"F:/Data/openBIS_test_data/microscopy/Experiment 2/Captured for 4.nd2";
	std::wstring filename = L"F:/Data/openBIS_test_data/microscopy/Performance_Issue/beads001.nd2";

	ND2File n = ND2File(filename);

	// Try parsing the file
	if (! n.parse())
	{
		std::cout << "Could not open or parse the file!." << std::endl;
	}

	// Close the file (if open)
	n.close();

	return 0;
}

