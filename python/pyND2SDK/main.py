from pyND2SDK import nd2Reader

if __name__ == "__main__":

    filename = "F:/Data/openBIS_test_data/microscopy/Performance_Issue/beads001.nd2"

    r = nd2Reader.nd2Reader()

    r.open(filename)

    if not r.is_open():
        print('Could not open ND2 file!')
        exit(1)

    # Retrieve the attributes
    attr = r.get_attributes()

    # Retrieve the metadata
    meta = r.get_metadata()

    # Retrieve the text info
    info = r.get_text_info()

    # Retrieve the experiment info
    exp = r.get_experiment()

    # Create an empty picture with the correct size
    data = r.load(0)
    print(data.shape)
    print(data.dtype)

    # Close the file
    r.close()
    if r.is_open():
        print('Could not close ND2 file!')
        exit(1)
