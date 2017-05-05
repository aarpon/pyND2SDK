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
        self.assertTrue(self.attr['uiWidth'] == 512)
        self.assertTrue(self.attr['uiWidthBytes'] == 2048)
        self.assertTrue(self.attr['uiHeight'] == 512)
        self.assertTrue(self.attr['uiComp'] == 2)
        self.assertTrue(self.attr['uiBpcInMemory'] == 16)
        self.assertTrue(self.attr['uiBpcSignificant'] == 16)
        self.assertTrue(self.attr['uiSequenceCount'] == 1536)
        self.assertTrue(self.attr['uiTileWidth'] == 512)
        self.assertTrue(self.attr['uiTileHeight'] == 512)
        self.assertTrue(self.attr['uiCompression'] == 2)
        self.assertTrue(self.attr['uiQuality'] == -99)

    def test_readMetadata(self):
        # Retrieve the metadata
        self.meta = c_nd2ReadSDK.LIM_FileGetMetadata(self.file_handle)

        # Test it
        self.assertAlmostEquals(self.meta['dTimeStart'], 2.45704e+06)
        self.assertAlmostEquals(self.meta['dAngle'] == -3.06738)
        self.assertAlmostEquals(self.meta['dCalibration'] == 2.59716)
        self.assertAlmostEquals(self.meta['dObjectiveMag'] == -1)
        self.assertAlmostEquals(self.meta['dObjectiveNA'] == 0.3)
        self.assertAlmostEquals(self.meta['dRefractIndex1'] == 1)
        self.assertAlmostEquals(self.meta['dRefractIndex2'] == 1)
        self.assertAlmostEquals(self.meta['dPinholeRadius'] == -9.25596e+61)
        self.assertAlmostEquals(self.meta['dZoom'] == 1)
        self.assertAlmostEquals(self.meta['dProjectiveMag'] == -1)
        self.assertAlmostEquals(self.meta['uiImageType'] == 0)
        self.assertEquals(self.meta['uiPlaneCount'] == 2)
        self.assertEquals(self.meta['uiComponentCount'] == 2)
        self.assertEquals(self.meta['wszObjectiveName'] ==
                          "Plan Fluor 10x Ph1 DLL")

    def tearDown(self):
        result = c_nd2ReadSDK.LIM_FileClose(self.file_handle)
        self.assertEqual(result, 0, "Failed opening file!")

if __name__ == '__main__':
    unittest.main()
