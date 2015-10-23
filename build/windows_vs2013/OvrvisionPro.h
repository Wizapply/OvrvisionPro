#pragma once
//
// OvrvisionPro gpu class definition
//


#include <opencv2/core/core.hpp>
#include <opencv2/core/ocl.hpp>
#include <CL/opencl.h>

#include "OvrvisionSettings.h"

using namespace cv;

using namespace cv;

namespace OVR
{
	class OvrvisionPro
	{
	public:
		OvrvisionPro(int width, int height);
		virtual ~OvrvisionPro();

		// Select GPU device
		cl_device_id SelectGPU(const char *platform, const char *version);

		// Load Kernel Program
		void CreateProgram(const char *filename, bool binary = false);

		// Load camera parameters
		bool LoadCameraParams(const char *filename);

		//////////////// KERNEL EXECUTION FUNCTIONS
		// Demosaicing
		void Demosaic(const ushort *src, Mat &left, Mat &right);
		void Demosaic(const Mat src, Mat &left, Mat &right);

		// Demosaic and Remap
		void DemosaicRemap(const ushort *src, Mat &left, Mat &right);
		void DemosaicRemap(const Mat src, Mat &left, Mat &right);

	protected:
		OvrvisionSetting _settings;
		Size	_size;
		bool	_remapAvailable;
		Mat		*_mapX[2], *_mapY[2]; // camera parameter

		// OpenCL variables
		cl_platform_id	_platformId;
		cl_device_id	_deviceId;
		cl_context		_context;
		cl_program		_program;
		cl_kernel		_demosaic;
		cl_kernel		_remap;
		cl_command_queue _commandQueue;
		cl_image_format	_format16UC1;
		cl_image_format	_format8UC4;
		cl_image_format _formatMap;
		cl_int			_errorCode;

	private:
		cl_mem	_src;
		cl_mem	_l, _r, _L, _R;
		cl_mem	_mx[2], _my[2]; // map for remap in GPU
	};

}