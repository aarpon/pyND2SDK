import unittest
from pyND2SDK import c_nd2ReadSDK
import numpy as np

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

    def test_readTestInfo(self):
        # Retrieve the text info
        self.info = c_nd2ReadSDK.Lim_FileGetTextinfo(self.file_handle)

        # Test it
        self.assertEqual(self.info['wszImageID'], "")
        self.assertEqual(self.info['wszType'], "")
        self.assertEqual(self.info['wszGroup'], "")
        self.assertEqual(self.info['wszSampleID'], "")
        self.assertEqual(self.info['wszAuthor'], "")
        self.assertEqual(self.info['wszDescription'],
                         'Metadata:\r\n'
                         'Dimensions: XY(1536) x λ(2)\r\n'
                         'Camera Name: Flash4.0, SN:850249\r\n'
                         'Numerical Aperture: 0.3\r\n'
                         'Refractive Index: 1\r\n'
                         'Number of Picture Planes: 2\r\n'
                         'Plane #1:\r\n'
                         ' Name: gfp\r\n'
                         ' Component Count: 1\r\n'
                         ' Modality: Brightfield\r\n'
                         ' Camera Settings:   Exposure: 4 ms\r\n'
                         '  Binning: 4x4\r\n'
                         ' Microscope Settings:   Microscope: Ti Microscope\r\n'
                         '  Nikon Ti, FilterChanger(Turret1): 2\r\n'
                         '  Nikon Ti, FilterChanger(Turret2): 1\r\n'
                         '  Spectra/Aura, Shutter(Spectra): Closed\r\n'
                         '  NIDAQ, Shutter(DIA): Active\r\n'
                         '  LightPath: L100\r\n'
                         '  PFS, state: On\r\n'
                         '  PFS, offset: 2462\r\n'
                         '  PFS, mirror: Inserted\r\n'
                         '  Zoom: 1.00x\r\n'
                         '  Spectra/Aura, MultiLaser(Spectra):\r\n'
                         '     Line:1; ExW:395; Power:  8.0; Off\r\n'
                         '     Line:2; ExW:440; Power:  6.0; Off\r\n'
                         '     Line:3; ExW:470; Power: 79.0; Off\r\n'
                         '     Line:4; ExW:508; Power:  7.0; Off\r\n'
                         '     Line:5; ExW:555; Power:  6.0; Off\r\n'
                         '     Line:6; ExW:640; Power: 94.0; Off\r\n'
                         '\r\n'
                         'Plane #2:\r\n'
                         ' Name: gfp\r\n'
                         ' Component Count: 1\r\n'
                         ' Modality: Widefield Fluorescence\r\n'
                         ' Camera Settings:   Exposure: 700 ms\r\n'
                         '  Binning: 4x4\r\n'
                         ' Microscope Settings:   Microscope: Ti Microscope\r\n'
                         '  Nikon Ti, FilterChanger(Turret1): 6 (Cy5H)\r\n'
                         '  Nikon Ti, FilterChanger(Turret2): 1\r\n'
                         '  Spectra/Aura, Shutter(Spectra): Active\r\n'
                         '  NIDAQ, Shutter(DIA): Closed\r\n'
                         '  LightPath: L100\r\n'
                         '  PFS, state: On\r\n'
                         '  PFS, offset: 2462\r\n'
                         '  PFS, mirror: Inserted\r\n'
                         '  Zoom: 1.00x\r\n'
                         '  Spectra/Aura, MultiLaser(Spectra):\r\n'
                         '     Line:1; ExW:395; Power:  8.0; Off\r\n'
                         '     Line:2; ExW:440; Power:  6.0; Off\r\n'
                         '     Line:3; ExW:470; Power: 79.0; Off\r\n'
                         '     Line:4; ExW:508; Power:  7.0; Off\r\n'
                         '     Line:5; ExW:555; Power:  6.0; Off\r\n'
                         '     Line:6; ExW:640; Power: 78.0; On'
                         )
        self.assertEqual(self.info['wszCapturing'],
                         'Flash4.0, SN:850249\r\n'
                         'Sample 1:\r\n'
                         '  Exposure: 4 ms\r\n'
                         '  Binning: 4x4\r\n'
                         'Sample 2:\r\n'
                         '  Exposure: 700 ms\r\n'
                         '  Binning: 4x4',
                         )
        self.assertEqual(self.info['wszSampling'], "")
        self.assertEqual(self.info['wszLocation'], "")
        self.assertEqual(self.info['wszDate'], "1/20/2015  3:08:39 PM")
        self.assertEqual(self.info['wszConclusion'], "")
        self.assertEqual(self.info['wszInfo1'], "")
        self.assertEqual(self.info['wszInfo2'], "")
        self.assertEqual(self.info['wszOptics'], "Plan Fluor 10x Ph1 DLL")
        self.assertEqual(self.info['wszAppVersion'], "4.30.01 (Build 1021)")

    def test_finalizer(self):
        arr = c_nd2ReadSDK.make_matrix(100, 100)
        self.assertTrue(type(arr.base) is c_nd2ReadSDK._finalizer)
        self.assertTrue(type(arr) is np.ndarray)
        arr = None

    def tearDown(self):
        result = c_nd2ReadSDK.LIM_FileClose(self.file_handle)
        self.assertEqual(result, 0, "Failed opening file!")

if __name__ == '__main__':
    unittest.main()

