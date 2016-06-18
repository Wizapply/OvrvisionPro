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
using namespace cv::cuda;
#endif
#include <opencv2/imgproc/imgproc.hpp>


namespace OVR
{
	namespace CUDA
	{
		struct Bayer2BGR
		{
			ushort patch[4][4];
			__device__ void shr_8()
			{
				patch[0][0] >>= 8;
				patch[0][1] >>= 8;
				patch[0][2] >>= 8;
				patch[0][3] >>= 8;
				patch[1][0] >>= 8;
				patch[1][1] >>= 8;
				patch[1][2] >>= 8;
				patch[1][3] >>= 8;
				patch[2][0] >>= 8;
				patch[2][1] >>= 8;
				patch[2][2] >>= 8;
				patch[2][3] >>= 8;
				patch[3][0] >>= 8;
				patch[3][1] >>= 8;
				patch[3][2] >>= 8;
				patch[3][3] >>= 8;
			}

			__device__ void apply(int x, int y, PtrStepSz<uchar3> dst)
			{
				uchar3 bgr[2][2];
				ushort p[4][4];
				p[0][0] = patch[0][0] & 0xff;
				p[0][1] = patch[0][1] & 0xff;
				p[0][2] = patch[0][2] & 0xff;
				p[0][3] = patch[0][3] & 0xff;
				p[1][0] = patch[1][0] & 0xff;
				p[1][1] = patch[1][1] & 0xff;
				p[1][2] = patch[1][2] & 0xff;
				p[1][3] = patch[1][3] & 0xff;
				p[2][0] = patch[2][0] & 0xff;
				p[2][1] = patch[2][1] & 0xff;
				p[2][2] = patch[2][2] & 0xff;
				p[2][3] = patch[2][3] & 0xff;
				p[3][0] = patch[3][0] & 0xff;
				p[3][1] = patch[3][1] & 0xff;
				p[3][2] = patch[3][2] & 0xff;
				p[3][3] = patch[3][3] & 0xff;

				bgr[0][0].x = (uchar)((p[0][1] + p[2][1]) >> 1); // B 
				bgr[0][0].y = (uchar)(p[1][1]); // G
				bgr[0][0].z = (uchar)((p[1][0] + p[1][2]) >> 1); // R

				bgr[0][1].x = (uchar)(p[2][1]); // B
				bgr[0][1].y = (uchar)((p[2][0] + p[2][2] + p[1][1] + p[3][1]) >> 2); // G
				bgr[0][1].z = (uchar)((p[1][0] + p[3][0] + p[1][2] + p[3][2]) >> 2); // R

				bgr[1][0].x = (uchar)((p[0][1] + p[2][1] + p[0][3] + p[2][3]) >> 2); // B
				bgr[1][0].y = (uchar)((p[0][2] + p[2][2] + p[1][1] + p[1][3]) >> 2); // G
				bgr[1][0].z = (uchar)(p[1][2]); // R
					
				bgr[1][1].x = (uchar)((p[2][1] + p[2][3]) >> 1); // B 
				bgr[1][1].y = (uchar)(p[2][2]); // G
				bgr[1][1].z = (uchar)((p[1][2] + p[3][2]) >> 1); // R

				// store result
				((uchar3 *)dst.ptr(y))[x] = bgr[0][0];
				((uchar3 *)dst.ptr(y))[x + 1] = bgr[1][0];
				((uchar3 *)dst.ptr(y + 1))[x] = bgr[0][1];
				((uchar3 *)dst.ptr(y + 1))[x + 1] = bgr[1][1];
			}

			// First row of image
			__device__ void applyUpper(int x, int y, PtrStepSz<uchar3> dst)
			{
				uchar3 bgr[2][2];
				ushort p[4][4];
				p[0][0] = patch[0][0] & 0xff;
				p[0][1] = patch[0][1] & 0xff;
				p[0][2] = patch[0][2] & 0xff;
				p[0][3] = patch[0][3] & 0xff;
				p[1][0] = patch[1][0] & 0xff;
				p[1][1] = patch[1][1] & 0xff;
				p[1][2] = patch[1][2] & 0xff;
				p[1][3] = patch[1][3] & 0xff;
				p[2][0] = patch[2][0] & 0xff;
				p[2][1] = patch[2][1] & 0xff;
				p[2][2] = patch[2][2] & 0xff;
				p[2][3] = patch[2][3] & 0xff;
				p[3][0] = patch[3][0] & 0xff;
				p[3][1] = patch[3][1] & 0xff;
				p[3][2] = patch[3][2] & 0xff;
				p[3][3] = patch[3][3] & 0xff;

				bgr[0][0].x = (uchar)((p[0][1] + p[2][1]) >> 1); // B 
				bgr[0][0].y = (uchar)(p[1][1]); // G
				bgr[0][0].z = (uchar)((p[1][0] + p[1][2]) >> 1); // R

				bgr[0][1].x = (uchar)(p[2][1]); // B
				bgr[0][1].y = (uchar)((p[2][0] + p[2][2] + p[1][1] + p[3][1]) >> 2); // G
				bgr[0][1].z = (uchar)((p[1][0] + p[3][0] + p[1][2] + p[3][2]) >> 2); // R

				bgr[1][0].x = (uchar)((p[0][1] + p[2][1] + p[0][3] + p[2][3]) >> 2); // B
				bgr[1][0].y = (uchar)((p[0][2] + p[2][2] + p[1][1] + p[1][3]) >> 2); // G
				bgr[1][0].z = (uchar)(p[1][2]); // R
					
				bgr[1][1].x = (uchar)((p[2][1] + p[2][3]) >> 1); // B 
				bgr[1][1].y = (uchar)(p[2][2]); // G
				bgr[1][1].z = (uchar)((p[1][2] + p[3][2]) >> 1); // R

				// store result
				((uchar3 *)dst.ptr(y))[x] = bgr[0][0];
				((uchar3 *)dst.ptr(y))[x + 1] = bgr[1][0];
				((uchar3 *)dst.ptr(y + 1))[x] = bgr[0][1];
				((uchar3 *)dst.ptr(y + 1))[x + 1] = bgr[1][1];
			}
		};

		// Stereo bayer to RGB conversion
		// each thread calculates pixels of interest
		//
		// G|RG|R
		// ------
		// B|GB|G GB -- pixels of interest
		// G|RG|R RG -- pixels of interest
		// ------
		// B|GB|G
		// 
		__global__ void bayer2BGR(const PtrStepSz<ushort> src, PtrStepSz<uchar3> left, PtrStepSz<uchar3> right)
		{
			int s_x = 2 * ((blockIdx.x * blockDim.x) + threadIdx.x);
			int s_y = 2 * ((blockIdx.y * blockDim.y) + threadIdx.y);

			// pixels of interest
			Bayer2BGR bayer;

			if (0 < s_y && s_y < src.rows - 2 && 0 < s_x && s_x < src.cols - 2)
			{
				bayer.patch[0][0] = src.ptr(s_y - 1)[s_x - 1];
				bayer.patch[0][1] = src.ptr(s_y - 1)[s_x];
				bayer.patch[0][2] = src.ptr(s_y - 1)[s_x + 1];
				bayer.patch[0][3] = src.ptr(s_y - 1)[s_x + 2];
				//
				bayer.patch[1][0] = src.ptr(s_y)[s_x - 1];
				bayer.patch[1][1] = src.ptr(s_y)[s_x];
				bayer.patch[1][2] = src.ptr(s_y)[s_x + 1];
				bayer.patch[1][3] = src.ptr(s_y)[s_x + 2];
				//
				bayer.patch[2][0] = src.ptr(s_y + 1)[s_x - 1];
				bayer.patch[2][1] = src.ptr(s_y + 1)[s_x];
				bayer.patch[2][2] = src.ptr(s_y + 1)[s_x + 1];
				bayer.patch[2][3] = src.ptr(s_y + 1)[s_x + 2];
				//
				bayer.patch[3][0] = src.ptr(s_y + 2)[s_x - 1];
				bayer.patch[3][1] = src.ptr(s_y + 2)[s_x];
				bayer.patch[3][2] = src.ptr(s_y + 2)[s_x + 1];
				bayer.patch[3][3] = src.ptr(s_y + 2)[s_x + 2];

				bayer.apply(s_x, s_y, left); // Lower bytes for Left
				bayer.shr_8();
				bayer.apply(s_x, s_y, right); // Higher bytes for Right
			}
			else if (0 == s_y) // first row
			{
				bayer.patch[1][1] = src.ptr(s_y)[s_x];
				bayer.patch[1][2] = src.ptr(s_y)[s_x + 1];
				//
				bayer.patch[2][1] = src.ptr(s_y + 1)[s_x];
				bayer.patch[2][2] = src.ptr(s_y + 1)[s_x + 1];
				//
				bayer.patch[3][1] = src.ptr(s_y + 2)[s_x];
				bayer.patch[3][2] = src.ptr(s_y + 2)[s_x + 1];
				//
				if (s_x == 0)
				{
					bayer.patch[1][0] = bayer.patch[1][2];
					bayer.patch[2][0] = bayer.patch[2][2];
					bayer.patch[3][0] = bayer.patch[3][2];
					bayer.patch[1][3] = src.ptr(s_y)[s_x + 2];
					bayer.patch[2][3] = src.ptr(s_y + 1)[s_x + 2];
					bayer.patch[3][3] = src.ptr(s_y + 2)[s_x + 2];
				} 
				else if (s_x == src.cols)
				{
					bayer.patch[1][0] = src.ptr(s_y)[s_x - 1];
					bayer.patch[2][0] = src.ptr(s_y + 1)[s_x - 1];
					bayer.patch[3][0] = src.ptr(s_y + 2)[s_x - 1];
					bayer.patch[1][3] = bayer.patch[1][1];
					bayer.patch[2][3] = bayer.patch[2][1];
					bayer.patch[3][3] = bayer.patch[3][1];
				}
				else 
				{
					bayer.patch[1][0] = src.ptr(s_y)[s_x - 1];
					bayer.patch[2][0] = src.ptr(s_y + 1)[s_x - 1];
					bayer.patch[3][0] = src.ptr(s_y + 2)[s_x - 1];
					bayer.patch[1][3] = src.ptr(s_y)[s_x + 2];
					bayer.patch[2][3] = src.ptr(s_y + 1)[s_x + 2];
					bayer.patch[3][3] = src.ptr(s_y + 2)[s_x + 2];
				}

				bayer.patch[0][0] = bayer.patch[2][0];
				bayer.patch[0][1] = bayer.patch[2][1];
				bayer.patch[0][2] = bayer.patch[2][2];
				bayer.patch[0][3] = bayer.patch[2][3];

				bayer.apply(s_x, s_y, left); // Lower bytes for Left
				bayer.shr_8();
				bayer.apply(s_x, s_y, right); // Higher bytes for Right
			}
			else if (s_y == src.rows - 2) // last row
			{
				bayer.patch[0][1] = src.ptr(s_y - 1)[s_x];
				bayer.patch[0][2] = src.ptr(s_y - 1)[s_x + 1];
				//
				bayer.patch[1][1] = src.ptr(s_y)[s_x];
				bayer.patch[1][2] = src.ptr(s_y)[s_x + 1];
				//
				bayer.patch[2][1] = src.ptr(s_y + 1)[s_x];
				bayer.patch[2][2] = src.ptr(s_y + 1)[s_x + 1];
				//
				if (s_x == 0)
				{
					bayer.patch[0][0] = bayer.patch[0][2];
					bayer.patch[1][0] = bayer.patch[1][2];
					bayer.patch[2][0] = bayer.patch[2][2];
					bayer.patch[0][3] = src.ptr(s_y - 1)[s_x + 2];
					bayer.patch[1][3] = src.ptr(s_y)[s_x + 2];
					bayer.patch[2][3] = src.ptr(s_y + 1)[s_x + 2];
				} 
				else if (s_x == src.cols)
				{
					bayer.patch[0][0] = src.ptr(s_y - 1)[s_x - 1];
					bayer.patch[1][0] = src.ptr(s_y)[s_x - 1];
					bayer.patch[2][0] = src.ptr(s_y + 1)[s_x - 1];
					bayer.patch[0][3] = bayer.patch[0][1];
					bayer.patch[1][3] = bayer.patch[1][1];
					bayer.patch[2][3] = bayer.patch[2][1];
				}
				else 
				{
					bayer.patch[0][0] = src.ptr(s_y - 1)[s_x - 1];
					bayer.patch[1][0] = src.ptr(s_y)[s_x - 1];
					bayer.patch[2][0] = src.ptr(s_y + 1)[s_x - 1];
					bayer.patch[0][3] = src.ptr(s_y - 1)[s_x + 2];
					bayer.patch[1][3] = src.ptr(s_y)[s_x + 2];
					bayer.patch[2][3] = src.ptr(s_y + 1)[s_x + 2];
				}

				bayer.patch[3][0] = bayer.patch[1][0];
				bayer.patch[3][1] = bayer.patch[1][1];
				bayer.patch[3][2] = bayer.patch[1][2];
				bayer.patch[3][3] = bayer.patch[1][3];

				bayer.apply(s_x, s_y, left); // Lower bytes for Left
				bayer.shr_8();
				bayer.apply(s_x, s_y, right); // Higher bytes for Right
			}
			else if (0 == s_x) // first col
			{
				bayer.patch[0][1] = src.ptr(s_y - 1)[s_x];
				bayer.patch[0][2] = src.ptr(s_y - 1)[s_x + 1];
				bayer.patch[0][3] = src.ptr(s_y - 1)[s_x + 2];
				//
				bayer.patch[1][1] = src.ptr(s_y)[s_x];
				bayer.patch[1][2] = src.ptr(s_y)[s_x + 1];
				bayer.patch[1][3] = src.ptr(s_y)[s_x + 2];
				//
				bayer.patch[2][1] = src.ptr(s_y + 1)[s_x];
				bayer.patch[2][2] = src.ptr(s_y + 1)[s_x + 1];
				bayer.patch[2][3] = src.ptr(s_y + 1)[s_x + 2];
				//
				bayer.patch[3][1] = src.ptr(s_y + 2)[s_x];
				bayer.patch[3][2] = src.ptr(s_y + 2)[s_x + 1];
				bayer.patch[3][3] = src.ptr(s_y + 2)[s_x + 2];

				bayer.patch[0][0] = bayer.patch[0][2];
				bayer.patch[1][0] = bayer.patch[1][2];
				bayer.patch[2][0] = bayer.patch[2][2];
				bayer.patch[3][0] = bayer.patch[3][2];

				bayer.apply(s_x, s_y, left); // Lower bytes for Left
				bayer.shr_8();
				bayer.apply(s_x, s_y, right); // Higher bytes for Right
			}
			else // last col
			{
				bayer.patch[0][0] = src.ptr(s_y - 1)[s_x - 1];
				bayer.patch[0][1] = src.ptr(s_y - 1)[s_x];
				bayer.patch[0][2] = src.ptr(s_y - 1)[s_x + 1];
				//
				bayer.patch[1][0] = src.ptr(s_y)[s_x - 1];
				bayer.patch[1][1] = src.ptr(s_y)[s_x];
				bayer.patch[1][2] = src.ptr(s_y)[s_x + 1];
				//
				bayer.patch[2][0] = src.ptr(s_y + 1)[s_x - 1];
				bayer.patch[2][1] = src.ptr(s_y + 1)[s_x];
				bayer.patch[2][2] = src.ptr(s_y + 1)[s_x + 1];
				//
				bayer.patch[3][0] = src.ptr(s_y + 2)[s_x - 1];
				bayer.patch[3][1] = src.ptr(s_y + 2)[s_x];
				bayer.patch[3][2] = src.ptr(s_y + 2)[s_x + 1];
				//
				bayer.patch[0][3] = bayer.patch[0][1];
				bayer.patch[1][3] = bayer.patch[1][1];
				bayer.patch[2][3] = bayer.patch[2][1];
				bayer.patch[3][3] = bayer.patch[3][1];

				bayer.apply(s_x, s_y, left); // Lower bytes for Left
				bayer.shr_8();
				bayer.apply(s_x, s_y, right); // Higher bytes for Right
			}
		}

		double bayerGB2BGR(GpuMat src, GpuMat left, GpuMat right)
		{
			dim3 threads(16, 16);
			dim3 grid((src.cols / 2) / (threads.x), (src.rows / 2) / (threads.y));
			cudaThreadSynchronize();
			int64 start = getTickCount();
			bayer2BGR<<<grid, threads>>>(src, left, right);
			int64 stop = getTickCount();
			cudaThreadSynchronize();
			return (stop - start) * 1000000 / getTickFrequency();
			//return 0;
		}

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
			remap_kernel << <grid, threads >> >(src, mapx, mapy, dst);
			int64 stop = getTickCount();

			cudaThreadSynchronize();
			return (stop - start) * 1000000 / getTickFrequency();
		}
	}
}
