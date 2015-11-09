// ovrvision.h
// Version 2.0 : 31/Oct/2014
//
//MIT License
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.
//
// Oculus Rift : TM & Copyright Oculus VR, Inc. All Rights Reserved
// Unity : TM & Copyright Unity Technologies. All Rights Reserved

using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Threading;
using System.Drawing;
using System.Drawing.Imaging;

namespace ovrvision_app
{
	public class COvrvision
	{
		//Ovrvision Dll import
		//ovrvision_csharp.cpp
		////////////// Main Ovrvision System //////////////
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern int ovOpen(int locationID, float arMeter, int hmdType);
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern int ovClose();
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern void ovPreStoreCamData();
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern void ovGetCamImage(System.IntPtr img, int eye, int qt);
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern void ovGetCamImageBGR(System.IntPtr img, int eye, int qt);
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern void ovGetCamImageForUnity(System.IntPtr pImagePtr_Left, System.IntPtr pImagePtr_Right, int qt);
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern void ovGetCamImageWithAR(System.IntPtr img, int eye, int qt);
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern void ovGetCamImageBGRWithAR(System.IntPtr img, int eye, int qt);
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern void ovGetCamImageForUnityWithAR(System.IntPtr pImagePtr_Left, System.IntPtr pImagePtr_Right, int qt);
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern int ovGetPixelSize();
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern int ovGetBufferSize();
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern int ovGetImageWidth();
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern int ovGetImageHeight();
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern int ovGetImageRate();

		//Set camera properties
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern void ovSetExposure(int value);
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern void ovSetWhiteBalance(int value);
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern void ovSetContrast(int value);
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern void ovSetSaturation(int value);
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern void ovSetBrightness(int value);
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern void ovSetSharpness(int value);
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern void ovSetGamma(int value);
		//Get camera properties
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern int ovGetExposure();
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern int ovGetWhiteBalance();
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern int ovGetContrast();
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern int ovGetSaturation();
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern int ovGetBrightness();
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern int ovGetSharpness();
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern int ovGetGamma();
		////////////// Ovrvision AR System //////////////
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern void ovARRender();
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern int ovARGetData(System.IntPtr mdata, int datasize);
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern void ovARSetMarkerSize(int value);
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern int ovARGetMarkerSize();
		////////////// Ovrvision Calibration //////////////
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern void ovCalibInitialize(int pattern_size_w, int pattern_size_h, double chessSizeMM);
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern int ovCalibFindChess(int hmdtype);
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern void ovCalibSolveStereoParameter();
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern int ovCalibGetImageCount();

		//Ovrvision config read write
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern int ovSetParamXMLfromFile(byte[] filename);
		[DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
		static extern int ovSaveParamXMLtoFile(byte[] filename);

		//Macro Define
		public const int VERSION2_DK2 = 2;
		public const int VERSION2_DK1 = 1;
		public const int VERSION2_OHR = 0;
		//camera select define
		private const int OV_CAMEYE_LEFT = 0;
		private const int OV_CAMEYE_RIGHT = 1;
		private const int OV_SET_AUTOMODE = (-1);
		//renderer quality
		private const int OV_PSQT_NONE = 0;		//No Processing quality
		private const int OV_PSQT_LOW = 1;		//Low Processing quality
		private const int OV_PSQT_HIGH = 2;		//High Processing quality
		//private const int OV_PSQT_REFSET = 3;	//Ref Processing quality
		//Ar Macro define
		private const int MARKERGET_MAXNUM10 = 100; //max marker is 10
		private const int MARKERGET_ARG10 = 10;
		private const int MARKERGET_RECONFIGURE_NUM = 10;

		//public setting var
		//Camera status
		public bool camStatus = false;
		public bool useOvrvisionAR = false;
		public int useProcessingQuality = OV_PSQT_NONE;

		//property
		public COvrvisionProperty camProp = new COvrvisionProperty();
		public Bitmap imageDataLeft;
		public Bitmap imageDataRight;

		public int imageSizeW, imageSizeH;

		////////////// COvrvision ////////////////////////////////////////////

		//Class
		public COvrvision()
		{
			//Awake
			camProp.AwakePropSaveToXML();

			imageSizeW = 640;
			imageSizeH = 480;

			//Create bitmap
			imageDataLeft = new Bitmap(imageSizeW, imageSizeH, PixelFormat.Format24bppRgb);
			imageDataRight = new Bitmap(imageSizeW, imageSizeH, PixelFormat.Format24bppRgb);
		}

		//Open Ovrvision
		public bool Open()
		{
			if (camStatus)
				return false;

			//Open camera
			if (ovOpen(0, 0.15f, VERSION2_DK2) == 0)
			{
				camStatus = true;
			} else {
				camStatus = false;
			}

			return camStatus;
		}

		public void UpdateCamera()
		{
			if (!camStatus)
				return;

			ovPreStoreCamData();
		}

		//Update left camera data
		public void UpdateLeft()
		{
			if (!camStatus)
				return;

			BitmapData dataLeft = imageDataLeft.LockBits(new Rectangle(0, 0, imageSizeW, imageSizeH),
				ImageLockMode.WriteOnly, PixelFormat.Format24bppRgb);

			//get image data
			ovGetCamImageBGR(dataLeft.Scan0, OV_CAMEYE_LEFT, useProcessingQuality);

			imageDataLeft.UnlockBits(dataLeft);
		}

		//Update right camera data
		public void UpdateRight()
		{
			if (!camStatus)
				return;

			BitmapData dataRight = imageDataRight.LockBits(new Rectangle(0, 0, imageSizeW, imageSizeH),
				ImageLockMode.WriteOnly, PixelFormat.Format24bppRgb);

			//get image data
			ovGetCamImageBGR(dataRight.Scan0, OV_CAMEYE_RIGHT, useProcessingQuality);

			imageDataRight.UnlockBits(dataRight);
		}

		//Close the Ovrvision
		public bool Close()
		{
			if (!camStatus)
				return false;

			//Close camera
			if (ovClose() != 0)
				return false;

			camStatus = false;
			return true;
		}

		//Calibration
		public void InitializeCalibration(int pattern_size_w, int pattern_size_h, double chessSizeMM)
		{
			ovCalibInitialize(pattern_size_w, pattern_size_h, chessSizeMM);
		}
		//ovCalibFindChess
		public int CalibFindChess()
		{
			return ovCalibFindChess(VERSION2_DK2);
		}
		//ovCalibSolveStereoParameter
		public void CalibSolveStereoParameter()
		{
			ovCalibSolveStereoParameter();
		}
		//ovCalibGetImageCount
		public int CalibGetImageCount()
		{
			return ovCalibGetImageCount();
		}

	}
}
