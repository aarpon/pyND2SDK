import unittest
from pyND2SDK import c_nd2ReadSDK


class TestFileOne(unittest.TestCase):

    def setUp(self):

        # Open the test file
        self.filename = "F:/Data/openBIS_test_data/microscopy/Performance_Issue/beads001.nd2"
        self.file_handle = c_nd2ReadSDK.LIM_FileOpenForRead(self.filename)
        self.assertNotEqual(self.file_handle, 0, "Failed opening file!")

    def test_readAttributes(self):

        # Retrieve the attributes
        self.attr = c_nd2ReadSDK.Lim_FileGetAttributes(self.file_handle)

        # Test them
        self.assertEqual(self.attr['uiWidth'], 512)
        self.assertEqual(self.attr['uiWidthBytes'], 2048)
        self.assertEqual(self.attr['uiHeight'], 512)
        self.assertEqual(self.attr['uiComp'], 2)
        self.assertEqual(self.attr['uiBpcInMemory'], 16)
        self.assertEqual(self.attr['uiBpcSignificant'], 16)
        self.assertEqual(self.attr['uiSequenceCount'], 1536)
        self.assertEqual(self.attr['uiTileWidth'], 512)
        self.assertEqual(self.attr['uiTileHeight'], 512)
        self.assertEqual(self.attr['uiCompression'], 2)
        self.assertEqual(self.attr['uiQuality'], -99)

    def test_readMetadata(self):
        # Retrieve the metadata
        self.meta = c_nd2ReadSDK.Lim_FileGetMetadata(self.file_handle)

        # Test it
        self.assertAlmostEqual(self.meta['dTimeStart'], 2457043.0893508564)
        self.assertAlmostEqual(self.meta['dAngle'], -3.0673787194256086)
        self.assertAlmostEqual(self.meta['dCalibration'], 2.597161251608632)
        self.assertAlmostEqual(self.meta['dObjectiveMag'], -1.0)
        self.assertAlmostEqual(self.meta['dObjectiveNA'], 0.3)
        self.assertAlmostEqual(self.meta['dRefractIndex1'], 1.0)
        self.assertAlmostEqual(self.meta['dRefractIndex2'], 1.0)
        self.assertAlmostEqual(self.meta['dPinholeRadius'], 0.0)
        self.assertAlmostEqual(self.meta['dZoom'], 1.0)
        self.assertAlmostEqual(self.meta['dProjectiveMag'], -1)
        self.assertEqual(self.meta['uiPlaneCount'], 2)
        self.assertEqual(self.meta['uiComponentCount'], 2)
        self.assertEqual(self.meta['wszObjectiveName'],
                          "Plan Fluor 10x Ph1 DLL")

    def tearDown(self):
        result = c_nd2ReadSDK.LIM_FileClose(self.file_handle)
        self.assertEqual(result, 0, "Failed opening file!")

if __name__ == '__main__':
    unittest.main()
