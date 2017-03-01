// COvrvision.cs
// Version 1.0 : 11/Nov/2015
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
        static extern int ovOpen(int locationID, float arMeter, int type);
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern int ovClose();
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern int ovRelease();
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern void ovPreStoreCamData(int qt);
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern void ovGetCamImageBGRA(System.IntPtr img, int eye);
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern void ovGetCamImageRGB(System.IntPtr img, int eye);
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern void ovGetCamImageBGR(System.IntPtr img, int eye);
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern void ovGetCamImageForUnity(System.IntPtr pImagePtr_Left, System.IntPtr pImagePtr_Right);

        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern void ovGetCamImageForUnityNative(System.IntPtr pTexPtr_Left, System.IntPtr pTexPtr_Right);

        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern int ovGetImageWidth();
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern int ovGetImageHeight();
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern int ovGetImageRate();
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern int ovGetBufferSize();
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern int ovGetPixelSize();

        //Set camera properties
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern void ovSetExposure(int value);
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern int ovSetExposurePerSec(float value);
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern void ovSetGain(int value);
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern void ovSetBLC(int value);
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern void ovSetWhiteBalanceR(int value);
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern void ovSetWhiteBalanceG(int value);
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern void ovSetWhiteBalanceB(int value);
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern void ovSetWhiteBalanceAuto(int value);
        //Get camera properties
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern int ovGetExposure();
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern int ovGetGain();
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern int ovGetBLC();
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern int ovGetWhiteBalanceR();
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern int ovGetWhiteBalanceG();
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern int ovGetWhiteBalanceB();
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern int ovGetWhiteBalanceAuto();

        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern float ovGetFocalPoint();
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern float ovGetHMDRightGap(int at);

        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern float ovSetCamSyncMode(int at);

        ////////////// Ovrvision AR System //////////////
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern void ovARRender();
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern int ovARGetData(System.IntPtr mdata, int datasize);
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern void ovARSetMarkerSize(int value);
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern int ovARGetMarkerSize();

        ////////////// Ovrvision Tracking System //////////////
        //testing
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern void ovTrackRender(bool calib, bool point);
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern int ovGetTrackData(System.IntPtr mdata);
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern void ovTrackingCalibReset();

        ////////////// Ovrvision Calibration //////////////
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern void ovCalibInitialize(int pattern_size_w, int pattern_size_h, double chessSizeMM);
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern int ovCalibClose();
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern int ovCalibFindChess();
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern void ovCalibSolveStereoParameter();
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern int ovCalibGetImageCount();

        //Ovrvision config save status
        [DllImport("ovrvision", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        static extern bool ovSaveCamStatusToEEPROM();

        //Macro Define

        //camera type select define
        public const int OV_CAM5MP_FULL = 0;	//2560x1920 @15fps x2
        public const int OV_CAM5MP_FHD = 1;		//1920x1080 @30fps x2
        public const int OV_CAMHD_FULL = 2;		//1280x960  @45fps x2
        public const int OV_CAMVR_FULL = 3; 	//960x950   @60fps x2
        public const int OV_CAMVR_WIDE = 4;		//1280x800  @60fps x2
        public const int OV_CAMVR_VGA = 5;		//640x480   @90fps x2
        public const int OV_CAMVR_QVGA = 6;		//320x240   @120fps x2
        //camera select define
        public const int OV_CAMEYE_LEFT = 0;
        public const int OV_CAMEYE_RIGHT = 1;
        //renderer quality
        public const int OV_CAMQT_DMSRMP = 0;	//Demosaic&remap Processing quality
        public const int OV_CAMQT_DMS = 1;		//Demosaic Processing quality
        public const int OV_CAMQT_NONE = 2;		//None Processing quality
        //Ar Macro define
        private const int MARKERGET_MAXNUM10 = 100; //max marker is 10
        private const int MARKERGET_ARG10 = 10;
        private const int MARKERGET_RECONFIGURE_NUM = 10;

        private const int AR_FALSE = 0;

        //public setting var
        //Camera status
        public bool camStatus = false;
        public bool useOvrvisionAR = false;
        public int useProcessingQuality = OV_CAMQT_DMSRMP;

        //property
        public Bitmap imageDataLeft;
        public Bitmap imageDataRight;

        public int imageSizeW, imageSizeH;

        ////////////// COvrvision ////////////////////////////////////////////

        //Class
        public COvrvision()
        {
            //Awake
            imageSizeW = imageSizeH = 0;
        }

        public void Release()
        {
            ovRelease();
        }

        //Open Ovrvision
        public bool Open(int opentype)
        {
            if (camStatus)
                return false;

            //Open camera
            if (ovOpen(0, 0.15f, opentype) == 0)
            {
                imageSizeW = ovGetImageWidth();
                imageSizeH = ovGetImageHeight();

                //Create bitmap
                imageDataLeft = new Bitmap(imageSizeW, imageSizeH, PixelFormat.Format24bppRgb);
                imageDataRight = new Bitmap(imageSizeW, imageSizeH, PixelFormat.Format24bppRgb);

                camStatus = true;
            }
            else
            {
                camStatus = false;
            }

            return camStatus;
        }

        public void UpdateCamera()
        {
            if (!camStatus)
                return;

            ovPreStoreCamData(useProcessingQuality);
        }

        //Update left camera data
        public void UpdateLeft()
        {
            if (!camStatus)
                return;

            BitmapData dataLeft = imageDataLeft.LockBits(new Rectangle(0, 0, imageSizeW, imageSizeH),
                ImageLockMode.WriteOnly, PixelFormat.Format24bppRgb);

            //get image data
            ovGetCamImageBGR(dataLeft.Scan0, OV_CAMEYE_LEFT);

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
            ovGetCamImageBGR(dataRight.Scan0, OV_CAMEYE_RIGHT);

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

            imageDataLeft = null;
            imageDataRight = null;

            camStatus = false;
            return true;
        }

        //Propatry
        public void SetExposure(int value)
        {
            if (!camStatus)
                return;
            ovSetExposure(value);
        }
        public int SetExposurePerSec(float fps)
        {
            if (!camStatus)
                return 0;

            return ovSetExposurePerSec(fps);
        }
        public void SetGain(int value)
        {
            if (!camStatus)
                return;
            ovSetGain(value);
        }
        public void SetBLC(int value)
        {
            if (!camStatus)
                return;
            ovSetBLC(value);
        }
        public void SetWhiteBalanceR(int value)
        {
            if (!camStatus)
                return;
            ovSetWhiteBalanceR(value);
        }
        public void SetWhiteBalanceG(int value)
        {
            if (!camStatus)
                return;
            ovSetWhiteBalanceG(value);
        }
        public void SetWhiteBalanceB(int value)
        {
            if (!camStatus)
                return;
            ovSetWhiteBalanceB(value);
        }
        public void SetWhiteBalanceAutoMode(bool value)
        {
            if (!camStatus)
                return;
            ovSetWhiteBalanceAuto(value ? 1:0);
        }

        public int GetExposure()
        {
            if (!camStatus)
                return 0;
            return ovGetExposure();
        }
        public int GetGain()
        {
            if (!camStatus)
                return 0;
            return ovGetGain();
        }
        public int GetBLC()
        {
            if (!camStatus)
                return 0;
            return ovGetBLC();
        }
        public int GetWhiteBalanceR()
        {
            if (!camStatus)
                return 0;
            return ovGetWhiteBalanceR();
        }
        public int GetWhiteBalanceG()
        {
            if (!camStatus)
                return 0;
            return ovGetWhiteBalanceG();
        }
        public int GetWhiteBalanceB()
        {
            if (!camStatus)
                return 0;
            return ovGetWhiteBalanceB();
        }
        public bool GetWhiteBalanceAutoMode()
        {
            if (!camStatus)
                return false;
            return ovGetWhiteBalanceAuto()==1;
        }

        //Save
        public bool SaveCamStatusToEEPROM()
        {
            if (!camStatus)
                return false;

            return ovSaveCamStatusToEEPROM();
        }

        /*
        public Vector3 HMDCameraRightGap()
        {
            return new Vector3(ovGetHMDRightGap(0) * 0.001f,
                            ovGetHMDRightGap(1) * 0.001f,
                            ovGetHMDRightGap(2) * 0.001f);	//1/1000
        }
        */
        public float GetFloatPoint()
        {
            if (!camStatus)
                return 0.0f;

            return ovGetFocalPoint() * 0.001f;	//1/1000
        }

        //AR
        public int OvrvisionGetAR(System.IntPtr mdata, int datasize)
        {
            return ovARGetData(mdata, datasize);
        }

        //Tracking
        public void OvrvisionTrackRender(bool calib, bool point)
        {
            ovTrackRender(calib, point);
        }
        public int OvrvisionGetTrackingVec3(System.IntPtr mdata)
        {
            return ovGetTrackData(mdata);
        }
        public void OvrvisionTrackReset()
        {
            ovTrackingCalibReset();
        }

        //Calibration
        public void InitializeCalibration(int pattern_size_w, int pattern_size_h, double chessSizeMM)
        {
            ovCalibInitialize(pattern_size_w, pattern_size_h, chessSizeMM);
        }
        //ovCalibFindChess
        public int CalibFindChess()
        {
            return ovCalibFindChess();
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
