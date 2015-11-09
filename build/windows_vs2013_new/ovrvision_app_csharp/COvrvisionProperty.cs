using System.Collections;
using System.Runtime.InteropServices;

namespace ovrvision_app
{
	[System.Serializable]
	public class COvrvisionProperty
	{

		//OVRVISION Dll import
		//ovrvision_csharp.cpp
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern void ovSaveParamXMLtoTempFile(int[] config1, float[] config2);

		//properties
		public int exposure;
		public int whitebalance;
		public int contrast;
		public int saturation;
		public int brightness;
		public int sharpness;
		public int gamma;
		public float IPDHorizontal;
		public float focalPoint;

		private const int OV_SET_AUTOMODE = (-1);

		//initialize value
		public COvrvisionProperty()
		{
			//Default
			DefaultConfig();
		}

		//config reset
		public void DefaultConfig()
		{
			//Default
			exposure = OV_SET_AUTOMODE;
			whitebalance = OV_SET_AUTOMODE;
			contrast = 30;
			saturation = 40;
			brightness = 90;
			sharpness = 2;
			gamma = 7;
			IPDHorizontal = 0.0f;
			focalPoint = -327.99f;
		}

		//Save initialize config datas.
		public void AwakePropSaveToXML()
		{
			int[] config1 = new int[7];
			float[] config2 = new float[2];

			//set data
			config1[0] = exposure;
			config1[1] = whitebalance;
			config1[2] = contrast;
			config1[3] = saturation;
			config1[4] = brightness;
			config1[5] = sharpness;
			config1[6] = gamma;

			config2[0] = IPDHorizontal;
			config2[1] = focalPoint;

			//save
			ovSaveParamXMLtoTempFile(config1, config2);
		}
	}
}