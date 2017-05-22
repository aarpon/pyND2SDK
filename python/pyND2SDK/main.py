from pyND2SDK import nd2Reader
import matplotlib.pyplot as plt
from pprint import pprint
import os


if __name__ == "__main__":

    currDir = os.path.dirname(os.path.realpath(__file__).replace("\\", "/"))

    filename = os.path.join(currDir, "tests/files/file03.nd2")

    print(filename)

    r = nd2Reader.nd2Reader()

    r.open(filename)

    if not r.is_open():
        print('Could not open ND2 file!')
        exit(1)

    # Retrieve the attributes
    attr = r.get_attributes()
    pprint(attr)

    # Retrieve the metadata
    meta = r.get_metadata()
    pprint(meta)

    # Retrieve the text info
    info = r.get_text_info()
    pprint(info)

    # Retrieve the experiment info
    exp = r.get_experiment()
    pprint(exp)

    # Get the coordinates for the first sequence
    coords = r.get_coords()
    pprint(coords)

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
