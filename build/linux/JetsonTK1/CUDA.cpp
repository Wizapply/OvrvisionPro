// OvrvisionProDLL.cpp : Defines the exported functions for the DLL application.
//

#include "stdafx.h"
#include "OvrvisionProCUDA.h"
#include <opencv2/core.hpp>
#include <opencv2/core/cuda.hpp>
#include <opencv2/cudawarping.hpp>

#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/calib3d.hpp>

using namespace cv;

namespace OVR
{
	// This is the constructor of a class that has been exported.
	// see OvrvisionProDLL.h for the class definition
	OvrvisionProCUDA::OvrvisionProCUDA(int width, int height, enum SHARING_MODE mode)
	{
		this->_size = Size(width, height);
		_mapX[0] = new Mat();
		_mapY[0] = new Mat();
		_mapX[1] = new Mat();
		_mapY[1] = new Mat();
		// TODO: check GPU memory size
		_l.create(_size, CV_8UC3);
		_r.create(_size, CV_8UC3);
		_L.create(_size, CV_8UC3);
		_R.create(_size, CV_8UC3);
	}

	// Destructor
	OvrvisionProCUDA::~OvrvisionProCUDA()
	{
		_l.release();
		_r.release();
		_L.release();
		_R.release();
		if (_remapAvailable)
		{
			//intrinsic.release();
			//distortion.release();
			_mapX[0]->release();
			_mapY[0]->release();
			_mapX[1]->release();
			_mapY[1]->release();
			_mx[0].release();
			_my[0].release();
			_mx[1].release();
			_my[1].release();
		}
	}

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

	// Demosaicing
	void OvrvisionProCUDA::Demosaic(const Mat src, Mat &left, Mat &right)
	{
		_src.upload(src);
		bayerGB2BGR(_src, _l, _r);
		_l.download(left);
		_r.download(right);
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
}