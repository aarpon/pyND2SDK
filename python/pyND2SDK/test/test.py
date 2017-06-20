import os
import unittest
from pyND2SDK import nd2Reader


class TestFileOne(unittest.TestCase):

    def setUp(self):

        self.maxDiff = None

        currDir = os.path.dirname(os.path.realpath(__file__).replace("\\", "/"))
        self.filename = os.path.join(currDir, "files/file01.nd2")

        # Open the test file
        self.reader = nd2Reader.nd2Reader()
        self.reader.open(self.filename)
        self.assertTrue(self.reader.is_open())

    def test_readAttributes(self):

        # Retrieve the attributes
        self.attr = self.reader.get_attributes()

        # Test them
        self.assertEqual(self.attr['uiWidth'], 1024)
        self.assertEqual(self.attr['uiWidthBytes'], 6144)
        self.assertEqual(self.attr['uiHeight'], 1024)
        self.assertEqual(self.attr['uiComp'], 3)
        self.assertEqual(self.attr['uiBpcInMemory'], 16)
        self.assertEqual(self.attr['uiBpcSignificant'], 12)
        self.assertEqual(self.attr['uiSequenceCount'], 1)
        self.assertEqual(self.attr['uiTileWidth'], 1024)
        self.assertEqual(self.attr['uiTileHeight'], 1024)
        self.assertEqual(self.attr['uiCompression'], 2)
        self.assertEqual(self.attr['uiQuality'], 0)

    def test_readMetadata(self):
        # Retrieve the metadata
        self.meta = self.reader.get_metadata()

        # Test it
        self.assertAlmostEqual(self.meta['dTimeStart'], 2456415.222695139)
        self.assertAlmostEqual(self.meta['dAngle'], 3.1403190735224413)
        self.assertAlmostEqual(self.meta['dCalibration'], 0.1241751041301025)
        self.assertAlmostEqual(self.meta['dObjectiveMag'], -1.0)
        self.assertAlmostEqual(self.meta['dObjectiveNA'], 1.3)
        self.assertAlmostEqual(self.meta['dRefractIndex1'], 1.515)
        self.assertAlmostEqual(self.meta['dRefractIndex2'], 1.515)
        self.assertAlmostEqual(self.meta['dPinholeRadius'], 0.0)
        self.assertAlmostEqual(self.meta['dZoom'], 2.0)
        self.assertAlmostEqual(self.meta['dProjectiveMag'], 1.0)
        self.assertEqual(self.meta['uiPlaneCount'], 3)
        self.assertEqual(self.meta['uiComponentCount'], 3)
        self.assertEqual(self.meta['wszObjectiveName'], "Plan Fluor 100x Oil DIC H N2")
        self.assertAlmostEqual(self.meta['pPlanes'][0]['dEmissionWL'], 450.0)
        self.assertEqual(self.meta['pPlanes'][0]['uiColorRGB'], 16711680)
        self.assertEqual(self.meta['pPlanes'][0]['uiCompCount'], 1)
        self.assertEqual(self.meta['pPlanes'][0]['wszName'], "DAPI")
        self.assertEqual(self.meta['pPlanes'][0]['wszOCName'], "")
        self.assertAlmostEqual(self.meta['pPlanes'][1]['dEmissionWL'], 525.0)
        self.assertEqual(self.meta['pPlanes'][1]['uiColorRGB'], 65280)
        self.assertEqual(self.meta['pPlanes'][1]['uiCompCount'], 1)
        self.assertEqual(self.meta['pPlanes'][1]['wszName'], "EGFP")
        self.assertEqual(self.meta['pPlanes'][1]['wszOCName'], "")
        self.assertAlmostEqual(self.meta['pPlanes'][2]['dEmissionWL'], 595.0)
        self.assertEqual(self.meta['pPlanes'][2]['uiColorRGB'], 255)
        self.assertEqual(self.meta['pPlanes'][2]['uiCompCount'], 1)
        self.assertEqual(self.meta['pPlanes'][2]['wszName'], "mCherry")
        self.assertEqual(self.meta['pPlanes'][2]['wszOCName'], "")

    def test_readTestInfo(self):
        # Retrieve the text info
        self.info = self.reader.get_text_info()

        # Test it
        self.assertEqual(self.info['wszImageID'], "")
        self.assertEqual(self.info['wszType'], "")
        self.assertEqual(self.info['wszGroup'], "")
        self.assertEqual(self.info['wszSampleID'], "")
        self.assertEqual(self.info['wszAuthor'], "")
        self.assertEqual(self.info['wszDescription'],
                         'Numerical Aperture: 1.3\r\n' 
                         'Refractive Index: 1.515\r\n'
                         'Number of Picture Planes: 3\r\n'
                         'Plane #1:\r\n'
                         ' Name: DAPI\r\n'
                         ' Component Count: 1\r\n'
                         ' Modality: Widefield Fluorescence, Laser Scan Confocal\r\n'
                         ' Camera Settings:                 \r\n'
                         '  {Scanner Selection}: Galvano\r\n'
                         '  {Detector Selection}: DU4\r\n'
                         '  {Optical Path Mode}: Auto\r\n'
                         '  {First Dichroic Mirror}: 405/488/561\r\n'
                         '  {First Filter Cube}: 450/50\r\n'
                         '  {Second Filter Cube}: 525/50\r\n'
                         '  {Third Filter Cube}: 595/50\r\n'
                         '  CH1\t{Laser Wavelength}: 403.2\t{Laser Power}: 11.6\r\n'
                         '  \t{PMT HV}: 107\t{PMT Offset}: 0\r\n'
                         '  CH2\t{Laser Wavelength}: 487.7\t{Laser Power}: 4.7\r\n'
                         '  \t{PMT HV}: 132\t{PMT Offset}: -12\r\n'
                         '  CH3\t{Laser Wavelength}: 561.6\t{Laser Power}: 6.4\r\n'
                         '  \t{PMT HV}: 88\t{PMT Offset}: -27\r\n'
                         '  {Pinhole Size(um)}: 120.1\r\n'
                         '  {Scan Direction}: One way\r\n'
                         '  {Scanner Zoom}: 1.000\r\n'
                         '  {Scan Speed}: 1/2\r\n'
                         '  {Channel Series Mode}: Custom\r\n'
                         '  {Channel Series Pass}: [CH1][CH2,TD][CH3]\r\n'
                         '  {Line Skip}: None\r\n'
                         '  {Frame Skip}: 0\r\n'
                         '  {Line Average Mode}: Average\r\n'
                         '  {Line Average/Integrate Count}: 8\r\n'
                         '  Stim1\t{Type}: Nothing\r\n'
                         '  \t{Scan Speed}: 1\r\n'
                         '  Stim2\t{Type}: Nothing\r\n'
                         '  \t{Scan Speed}: 1\r\n'
                         '  Stim3\t{Type}: Nothing\r\n'
                         '  \t{Scan Speed}: 1\r\n'
                         '  \r\n\r\n'
                         ' Microscope Settings:   Microscope: Ti Microscope\r\n'
                         '  Nikon Ti, FilterChanger(Turret1): 1\r\n'
                         '  Nikon Ti, Illuminator(Illuminator-DIA): Remote Switch Off\r\n'
                         '  Nikon Ti, Illuminator(Illuminator-DIA): Off\r\n'
                         '  Nikon Ti, Illuminator(Illuminator-DIA) Voltage: -1.0\r\n'
                         '  LightPath: L100\r\n'
                         '  Analyzer: Extracted\r\n'
                         '  Condenser: 3 (DICN2)\r\n'
                         '  PFS, state: Off\r\n'
                         '  PFS, offset: 2175\r\n'
                         '  PFS, mirror: Inserted\r\n'
                         '  Zoom: 1.00x\r\n'
                         'Plane #2:\r\n'
                         ' Name: EGFP\r\n'
                         ' Component Count: 1\r\n'
                         ' Modality: Widefield Fluorescence, Laser Scan Confocal\r\n'
                         ' Camera Settings:                 \r\n'
                         '  {Scanner Selection}: Galvano\r\n'
                         '  {Detector Selection}: DU4\r\n'
                         '  {Optical Path Mode}: Auto\r\n'
                         '  {First Dichroic Mirror}: 405/488/561\r\n'
                         '  {First Filter Cube}: 450/50\r\n'
                         '  {Second Filter Cube}: 525/50\r\n'
                         '  {Third Filter Cube}: 595/50\r\n'
                         '  CH1\t{Laser Wavelength}: 403.2\t{Laser Power}: 11.6\r\n'
                         '  \t{PMT HV}: 107\t{PMT Offset}: 0\r\n'
                         '  CH2\t{Laser Wavelength}: 487.7\t{Laser Power}: 4.7\r\n'
                         '  \t{PMT HV}: 132\t{PMT Offset}: -12\r\n'
                         '  CH3\t{Laser Wavelength}: 561.6\t{Laser Power}: 6.4\r\n'
                         '  \t{PMT HV}: 88\t{PMT Offset}: -27\r\n'
                         '  {Pinhole Size(um)}: 120.1\r\n'
                         '  {Scan Direction}: One way\r\n'
                         '  {Scanner Zoom}: 1.000\r\n'
                         '  {Scan Speed}: 1/2\r\n'
                         '  {Channel Series Mode}: Custom\r\n'
                         '  {Channel Series Pass}: [CH1][CH2,TD][CH3]\r\n'
                         '  {Line Skip}: None\r\n'
                         '  {Frame Skip}: 0\r\n'
                         '  {Line Average Mode}: Average\r\n'
                         '  {Line Average/Integrate Count}: 8\r\n'
                         '  Stim1\t{Type}: Nothing\r\n'
                         '  \t{Scan Speed}: 1\r\n'
                         '  Stim2\t{Type}: Nothing\r\n'
                         '  \t{Scan Speed}: 1\r\n'
                         '  Stim3\t{Type}: Nothing\r\n'
                         '  \t{Scan Speed}: 1\r\n'
                         '  \r\n\r\n'
                         ' Microscope Settings:   Microscope: Ti Microscope\r\n'
                         '  Nikon Ti, FilterChanger(Turret1): 1\r\n'
                         '  Nikon Ti, Illuminator(Illuminator-DIA): Remote Switch Off\r\n'
                         '  Nikon Ti, Illuminator(Illuminator-DIA): Off\r\n'
                         '  Nikon Ti, Illuminator(Illuminator-DIA) Voltage: -1.0\r\n'
                         '  LightPath: L100\r\n'
                         '  Analyzer: Extracted\r\n'
                         '  Condenser: 3 (DICN2)\r\n'
                         '  PFS, state: Off\r\n'
                         '  PFS, offset: 2175\r\n'
                         '  PFS, mirror: Inserted\r\n'
                         '  Zoom: 1.00x\r\n'
                         'Plane #3:\r\n'
                         ' Name: mCherry\r\n'
                         ' Component Count: 1\r\n'
                         ' Modality: Widefield Fluorescence, Laser Scan Confocal\r\n'
                         ' Camera Settings:                 \r\n'
                         '  {Scanner Selection}: Galvano\r\n'
                         '  {Detector Selection}: DU4\r\n'
                         '  {Optical Path Mode}: Auto\r\n'
                         '  {First Dichroic Mirror}: 405/488/561\r\n'
                         '  {First Filter Cube}: 450/50\r\n'
                         '  {Second Filter Cube}: 525/50\r\n'
                         '  {Third Filter Cube}: 595/50\r\n'
                         '  CH1\t{Laser Wavelength}: 403.2\t{Laser Power}: 11.6\r\n'
                         '  \t{PMT HV}: 107\t{PMT Offset}: 0\r\n'
                         '  CH2\t{Laser Wavelength}: 487.7\t{Laser Power}: 4.7\r\n'
                         '  \t{PMT HV}: 132\t{PMT Offset}: -12\r\n'
                         '  CH3\t{Laser Wavelength}: 561.6\t{Laser Power}: 6.4\r\n'
                         '  \t{PMT HV}: 88\t{PMT Offset}: -27\r\n'
                         '  {Pinhole Size(um)}: 120.1\r\n'
                         '  {Scan Direction}: One way\r\n'
                         '  {Scanner Zoom}: 1.000\r\n'
                         '  {Scan Speed}: 1/2\r\n'
                         '  {Channel Series Mode}: Custom\r\n'
                         '  {Channel Series Pass}: [CH1][CH2,TD][CH3]\r\n'
                         '  {Line Skip}: None\r\n'
                         '  {Frame Skip}: 0\r\n'
                         '  {Line Average Mode}: Average\r\n'
                         '  {Line Average/Integrate Count}: 8\r\n'
                         '  Stim1\t{Type}: Nothing\r\n'
                         '  \t{Scan Speed}: 1\r\n'
                         '  Stim2\t{Type}: Nothing\r\n'
                         '  \t{Scan Speed}: 1\r\n'
                         '  Stim3\t{Type}: Nothing\r\n'
                         '  \t{Scan Speed}: 1\r\n'
                         '  \r\n\r\n'
                         ' Microscope Settings:   Microscope: Ti Microscop'
                         )
        self.assertEqual(self.info['wszCapturing'],
                         'Nikon A1plus\r\n'
                         '              \r\n'
                         '{Scanner Selection}: Galvano\r\n'
                         '{Detector Selection}: DU4\r\n'
                         '{Optical Path Mode}: Auto\r\n'
                         '{First Dichroic Mirror}: 405/488/561\r\n'
                         '{First Filter Cube}: 450/50\r\n'
                         '{Second Filter Cube}: 525/50\r\n'
                         '{Third Filter Cube}: 595/50\r\n'
                         'CH1\t{Laser Wavelength}: 403.2\t{Laser Power}: 11.6\r\n'
                         '\t{PMT HV}: 107\t{PMT Offset}: 0\r\n'
                         'CH2\t{Laser Wavelength}: 487.7\t{Laser Power}: 4.7\r\n'
                         '\t{PMT HV}: 132\t{PMT Offset}: -12\r\n'
                         'CH3\t{Laser Wavelength}: 561.6\t{Laser Power}: 6.4\r\n'
                         '\t{PMT HV}: 88\t{PMT Offset}: -27\r\n'
                         '{Pinhole Size(um)}: 120.1\r\n'
                         '{Scan Direction}: One way\r\n'
                         '{Scanner Zoom}: 1.000\r\n'
                         '{Scan Speed}: 1/2\r\n'
                         '{Channel Series Mode}: Custom\r\n'
                         '{Channel Series Pass}: [CH1][CH2,TD][CH3]\r\n'
                         '{Line Skip}: None\r\n'
                         '{Frame Skip}: 0\r\n'
                         '{Line Average Mode}: Average\r\n'
                         '{Line Average/Integrate Count}: 8\r\n'
                         'Stim1\t{Type}: Nothing\r\n'
                         '\t{Scan Speed}: 1\r\n'
                         'Stim2\t{Type}: Nothing\r\n'
                         '\t{Scan Speed}: 1\r\n'
                         'Stim3\t{Type}: Nothing\r\n'
                         '\t{Scan Speed}: 1\r\n'
                         '\r\n'
                         )
        self.assertEqual(self.info['wszSampling'], "")
        self.assertEqual(self.info['wszLocation'], "")
        self.assertEqual(self.info['wszDate'], "02/05/2013  10:20:40")
        self.assertEqual(self.info['wszConclusion'], "")
        self.assertEqual(self.info['wszInfo1'], "")
        self.assertEqual(self.info['wszInfo2'], "")
        self.assertEqual(self.info['wszOptics'], "Plan Fluor 100x Oil DIC H N2")
        self.assertEqual(self.info['wszAppVersion'], "4.13.00 (Build 914)")

    def testReadGeometry(self):
        self.assertEqual(self.reader.get_geometry(),
                         [1024, 1024, 1, 3, 1, 1, 0, 1, 16, 12])

    def testReadExperiment(self):
        exp = self.reader.get_experiment()
        self.assertEqual(exp['pAllocatedLevels'], [])
        self.assertEqual(exp['uiLevelCount'], 0)

    def testGetStageCoordinates(self):
        coords = self.reader.get_stage_coordinates()
        self.assertEqual(len(coords), 1)
        self.assertAlmostEqual(coords[0], [3918.5, -10112.4, 671.1005])

    def tearDown(self):
        self.reader.close()
        self.assertFalse(self.reader.is_open())

if __name__ == '__main__':
    unittest.main()

