from pyND2SDK import nd2Reader
import matplotlib.pyplot as plt
from pprint import pprint
import os


if __name__ == "__main__":

    currDir = os.path.dirname(os.path.realpath(__file__).replace("\\", "/"))

    filename = os.path.join(currDir, "test/files/file01.nd2")

    print(filename)

    r = nd2Reader.nd2Reader()

    r.open(filename)

    if not r.is_open():
        print('Could not open ND2 file!')
        exit(1)

    print(r.get_geometry())

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

    # Test index to subx
    subs = r.map_index_to_subscripts(0)
    pprint(subs)
    index = r.map_subscripts_to_index(0, 0, 0, 0)
    pprint(index)

    # Get the coordinates
    coords = r.get_stage_coordinates()
    pprint(coords)

    # Create an empty picture with the correct size
    picture = r.load(0)

    for i in range(picture.n_components):

        print("\nImage %d (5x5 extract):\n" % i)
        img = picture[i]
        metadata = picture.metadata
        pprint(metadata)

        print(img[0:5, 0:5])

        plt.imshow(img, cmap='gray')
        plt.title("Close the figure to continue")
        plt.show()

    print(img.shape)
    print(img.dtype)

    # Close the file
    print(r.close())
    if r.is_open():
        print('Could not close ND2 file!')
        exit(1)
