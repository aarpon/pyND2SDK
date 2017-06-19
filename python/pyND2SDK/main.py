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

    pprint(r.get_large_image_dimensions())

    pprint(r.get_alignment_points())

    pprint(r.get_geometry())

    pprint(r.get_user_events())

    # Retrieve the attributes
    pprint(r.get_attributes())

    # Retrieve the metadata
    pprint(r.get_metadata())

    # Retrieve the text info
    pprint(r.get_text_info())

    # Retrieve the experiment info
    pprint(r.get_experiment())

    # Get recorded data
    pprint(r.get_recorded_data())

    # Get custom data
    pprint(r.get_custom_data())

    # Custom data count
    pprint(r.get_custom_data_count())

    # Test index to subx
    pprint(r.map_index_to_subscripts(0))
    pprint(r.map_subscripts_to_index(0, 0, 0, 0))

    # Get the coordinates
    pprint(r.get_stage_coordinates())

    # Get the Z stack home
    pprint(r.get_z_stack_home())

    # Load the first image by index
    picture = r.load_by_index(0)

    # Load the first index by subscripts
    picture2 = r.load(0, 0, 0)

    A = picture[0]
    B = picture2[0]
    print(A[10:15, 10:15] == B[10:15, 10:15])

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
