from pyND2SDK import c_nd2ReadSDK

if __name__ == "__main__":

    filename = "F:/Data/openBIS_test_data/microscopy/Performance_Issue/beads001.nd2"

    file_handle = c_nd2ReadSDK.LIM_FileOpenForRead(filename)
    if file_handle == 0:
        print('Could not open ND2 file!')
    else:
        print('ND2 file opened successfully!')

        # Retrieve the attributes
        attr = c_nd2ReadSDK.Lim_FileGetAttributes(file_handle)

        # Close the file
        result = c_nd2ReadSDK.LIM_FileClose(file_handle)
        print(result)

