#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <opencv2/core/core.hpp>
using namespace cv;
#ifdef OPENCV_VERSION_2_4
#include <opencv2/gpu/gpu.hpp>
using namespace cv::gpu;
#else
#include <opencv2/core/cuda.hpp>
#include <opencv2/core/cuda/saturate_cast.hpp>
using namespace cv::cuda;
#endif

#include <opencv2/imgproc/imgproc.hpp>


using namespace cv;

namespace OVR
{
	//namespace CUDA
	//{
		__global__ void remap_kernel(const PtrStepSz<uchar3> src, const PtrStep<float> mapx, const PtrStep<float> mapy, PtrStepSz<uchar3> dst)
		{
			const int x = blockDim.x * blockIdx.x + threadIdx.x;
			const int y = blockDim.y * blockIdx.y + threadIdx.y;

			if (x < dst.cols && y < dst.rows)
			{
				float xcoo = mapx.ptr(y)[x];
				float ycoo = mapy.ptr(y)[x];
				int X = trunc(xcoo);
				int Y = trunc(ycoo);
				float xfrac = xcoo - X;
				float yfrac = ycoo - Y;
				if (0 <= X && X < src.cols && 0 <= Y && Y < src.rows)
				{
					//uchar3 p[2][2];
					uchar3 p00 = src(Y, X);
					uchar3 p10 = src(Y + 1, X);
					uchar3 p01 = src(Y, X + 1);
					uchar3 p11 = src(Y + 1, X + 1);
					// bilinear interpolation 
					dst.ptr(y)[x].x = (p00.x * (1 - xfrac) + p01.x * xfrac) * (1 - yfrac) + (p10.x * (1 - xfrac) + p11.x * xfrac) * yfrac;
					dst.ptr(y)[x].y = (p00.y * (1 - xfrac) + p01.y * xfrac) * (1 - yfrac) + (p10.y * (1 - xfrac) + p11.y * xfrac) * yfrac;
					dst.ptr(y)[x].z = (p00.z * (1 - xfrac) + p01.z * xfrac) * (1 - yfrac) + (p10.z * (1 - xfrac) + p11.z * xfrac) * yfrac;
				}
			}
		}

		double remap(const GpuMat src, GpuMat dst, const GpuMat mapx, const GpuMat mapy)
		{
			dim3 threads(16, 16);
			dim3 grid((src.cols) / (threads.x), (src.rows) / (threads.y));

			int64 start = getTickCount();
			remap_kernel<<<grid, threads>>>(src, mapx, mapy, dst);
			int64 stop = getTickCount();

			cudaThreadSynchronize();
			return (stop - start) * 1000000 / getTickFrequency();
		}
	//}
}
