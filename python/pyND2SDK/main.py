from pyND2SDK import nd2Reader
import matplotlib.pyplot as plt

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
    sequence = r.load(0)

    for i in range(sequence.n_components):

        print("\nImage %d (5x5 extract):\n" % i)
        img = sequence.image(i)

        print(img[0:5, 0:5])

        plt.imshow(img, cmap='gray')
        plt.title("Close the figure to continue")
        plt.show()

    print(img.shape)
    print(img.dtype)

    # Close the file
    r.close()
    if r.is_open():
        print('Could not close ND2 file!')
        exit(1)
