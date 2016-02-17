// OvrvisionProDLL.cpp : Defines the exported functions for the DLL application.
//
//
//MIT License
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWAR
//
// Oculus Rift : TM & Copyright Oculus VR, Inc. All Rights Reserved
// Unity : TM & Copyright Unity Technologies. All Rights Reserved

// The following ifdef block is the standard way of creating macros which make exporting 
// from a DLL simpler. All files within this DLL are compiled with the OVRVISIONPRODLL_EXPORTS
// symbol defined on the command line. This symbol should not be defined on any project
// that uses this DLL. This way any other project whose source files include this file see 
// OVRVISIONPRODLL_API functions as being imported from a DLL, whereas this DLL sees symbols
// defined with this macro as being exported.

#include "OvrvisionProCUDA.h"


namespace OVR
{
	// This is the constructor of a class that has been exported.
	// see OvrvisionProDLL.h for the class definition
	OvrvisionProCUDA::OvrvisionProCUDA(int width, int height, enum SHARING_MODE mode)
	{
		this->_size = Size(width, height);

		// TODO: check GPU memory size
#ifdef JETSON_TK1
		canZeroCopy = CudaMem::canMapHostMemory();
		_srcCuda.create(_size, CV_16UC1, CudaMem::ALLOC_ZEROCOPY); // share with CPU
		_lCuda.create(_size, CV_8UC3, CudaMem::ALLOC_ZEROCOPY); // share with CPU
		_rCuda.create(_size, CV_8UC3, CudaMem::ALLOC_ZEROCOPY); // share with CPU
		_srcMat = _srcCuda.createMatHeader();
		_src = _srcCuda.createGpuMatHeader();
		_l = _lCuda.createGpuMatHeader();
		_r = _rCuda.createGpuMatHeader();
		_L.create(_size, CV_8UC3);
		_R.create(_size, CV_8UC3);
#else
		_mapX[0] = new Mat();
		_mapY[0] = new Mat();
		_mapX[1] = new Mat();
		_mapY[1] = new Mat();
		canZeroCopy = false;
		_l.create(_size, CV_8UC3);
		_r.create(_size, CV_8UC3);
		_L.create(_size, CV_8UC3);
		_R.create(_size, CV_8UC3);
#endif
	}

	// Destructor
	OvrvisionProCUDA::~OvrvisionProCUDA()
	{
		_l.release();
		_r.release();
		_L.release();
		_R.release();
		//if (_remapAvailable)
		{
			//intrinsic.release();
			//distortion.release();
			//_mapX[0]->release();
			//_mapY[0]->release();
			//_mapX[1]->release();
			//_mapY[1]->release();
			//_mx[0].release();
			//_my[0].release();
			//_mx[1].release();
			//_my[1].release();
		}
	}

#ifdef JETSON_TK1
	unsigned char *OvrvisionProCUDA::GetBufferPtr()
	{
		return _srcMat.data;
	}

	void OvrvisionProCUDA::Demosaic()
	{
		bayerGB2BGR(_src, _l, _r);
	}
#endif

	// Demosaicing
	void OvrvisionProCUDA::Demosaic(const Mat src, Mat &left, Mat &right)
	{
		_src.upload(src);
		bayerGB2BGR(_src, _l, _r);
		_l.download(left);
		_r.download(right);
	}

	void OvrvisionProCUDA::Demosaic(const Mat src)
	{
		_src.upload(src);
		bayerGB2BGR(_src, _l, _r);
	}

	void OvrvisionProCUDA::Demosaic(const Mat src, GpuMat &left, GpuMat &right)
	{
		_src.upload(src);
		bayerGB2BGR(_src, left, right);
	}

	// Demosaic and Remap
	void OvrvisionProCUDA::DemosaicRemap(const Mat src, Mat &left, Mat &right)
	{
		_src.upload(src);
		bayerGB2BGR(_src, _l, _r);
		// Undistotion
		if (_remapAvailable)
		{
			remap(_l, _L, _mx[0], _my[0]);
			remap(_r, _R, _mx[1], _my[1]);
		}
		_L.download(left);
		_R.download(right);
	}

	void OvrvisionProCUDA::DemosaicRemap(const Mat src, GpuMat &left, GpuMat &right)
	{
		_src.upload(src);
		bayerGB2BGR(_src, _l, _r);
		// Undistotion
		if (_remapAvailable)
		{
			remap(_l, left, _mx[0], _my[0]);
			remap(_r, right, _mx[1], _my[1]);
		}
	}

#if 0
		// TODO: separate l/r camera param
		bool OvrvisionProCUDA::LoadCameraParams(const char *filename)
	{
		printf("%s\n", filename);
#if 1
		if (_settings.Read(filename))
		{
			// Left camera
			_settings.GetUndistortionMatrix(OV_CAMEYE_LEFT, *_mapX[0], *_mapY[0], _size.width, _size.height);
			//initUndistortRectifyMap(_settings.m_leftCameraInstric, _settings.m_leftCameraDistortion, _settings.m_R1,
			//	getOptimalNewCameraMatrix(_settings.m_leftCameraInstric, _settings.m_leftCameraDistortion, size, 1, size, 0),
			//	size, CV_32FC1, *mapX[0], *mapY[0]);

			// TODO: check GPU capability
			_mx[0].upload(*_mapX[0]);
			_my[0].upload(*_mapY[0]);

			// Right camera
			_settings.GetUndistortionMatrix(OV_CAMEYE_RIGHT, *_mapX[1], *_mapY[1], _size.width, _size.height);
			//initUndistortRectifyMap(_settings.m_rightCameraInstric, _settings.m_rightCameraDistortion, _settings.m_R2,
			//	getOptimalNewCameraMatrix(_settings.m_rightCameraInstric, _settings.m_rightCameraDistortion, size, 1, size, 0),
			//	size, CV_32FC1, *mapX[1], *mapY[1]);

			// TODO: check GPU capability
			_mx[1].upload(*_mapX[1]);
			_my[1].upload(*_mapY[1]);

			_remapAvailable = true;

			return true;
		}
		else
		{
			return false;
		}
#else
		FileStorage storage;
		if (storage.open(filename, FileStorage::READ | FileStorage::FORMAT_XML))
		{
			Mat intrinsic, distortion;
			storage["intrinsic"] >> intrinsic;
			storage["distortion"] >> distortion;
			//storage.release();
			initUndistortRectifyMap(intrinsic, distortion, Mat(),
				getOptimalNewCameraMatrix(intrinsic, distortion, _size, 1, _size, 0),
				_size, CV_32FC1, *_mapX[0], *_mapY[0]);
			_mapX[0]->copyTo(*_mapX[1]);
			_mapY[0]->copyTo(*_mapY[1]);

			// TODO: check GPU capability 
			_mx[0].upload(*_mapX[0]);
			_my[0].upload(*_mapY[0]);
			_mx[1].upload(*_mapX[1]);
			_my[1].upload(*_mapY[1]);

			_remapAvailable = true;

			return true;
		}
		else
		{
			return false;
		}
#endif
	}

	bool LoadCameraParams(OvrvisionSetting* ovrset)
	{
		// Left camera
		ovrset->GetUndistortionMatrix(OV_CAMEYE_LEFT, *_mapX[0], *_mapY[0], _size.width, _size.height);
		_mx[0].upload(*_mapX[0]);
		_my[0].upload(*_mapY[0]);

		// Right camera
		ovrset->GetUndistortionMatrix(OV_CAMEYE_RIGHT, *_mapX[1], *_mapY[1], _size.width, _size.height);
		_mx[1].upload(*_mapX[1]);
		_my[1].upload(*_mapY[1]);
	}
#endif
}
