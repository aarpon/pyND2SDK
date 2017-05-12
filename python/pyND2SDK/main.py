from pyND2SDK import nd2Reader

if __name__ == "__main__":

    filename = "F:/Data/openBIS_test_data/microscopy/Performance_Issue/beads001.nd2"

    file_handle = nd2Reader.LIM_FileOpenForRead(filename)
    if file_handle == 0:
        print('Could not open ND2 file!')
    else:
        print('ND2 file opened successfully!')

        # Retrieve the attributes
        attr = nd2Reader.Lim_FileGetAttributes(file_handle)

        # Retrieve the metadata
        meta = nd2Reader.Lim_FileGetMetadata(file_handle)

        # Retrieve the text info
        info = nd2Reader.Lim_FileGetTextinfo(file_handle)

        # Retrieve the experiment info
        exp = nd2Reader.Lim_FileGetExperiment(file_handle)

        # Create a picture
        picture = nd2Reader.Lim_InitPicture(16, 16, 32, 1)
        print(picture.np_arr)

        # Close the file
        result = nd2Reader.LIM_FileClose(file_handle)
        print(result)

