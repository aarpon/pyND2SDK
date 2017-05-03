from pyND2SDK import nd2reader

if __name__ == "__main__":

    filename = "F:/Data/openBIS_test_data/microscopy/Performance_Issue/beads001.nd2"

    file_handle = nd2reader.LIM_FileOpenForRead(filename)
    if file_handle == 0:
        print('Could not open ND2 file!')
    else:
        print('ND2 file opened successfully!')

        # Retrieve the attributes
        attr = nd2reader.Lim_FileGetAttributes(file_handle)
        print(attr)

        # Close the file
        result = nd2reader.LIM_FileClose(file_handle)
        print(result)

