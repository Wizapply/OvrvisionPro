// OvrvisionProTest.cpp : Defines the entry point for the console application.
//

#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>

#include "../src/OvrvisionProDLL.h"

#define WIDTH 1280
#define HEIGHT 960
#define BUFFER_SIZE	(WIDTH * HEIGHT)

using namespace cv;
using namespace OVR;

int callback(void *pItem,
	const char *deviceName,
	const char *opencl_version,
	const char *deviceExtension,
	const int majorVersion,
	const int minorVersion)
{
	printf("DEVICE: %s\nOPENCL: %s\nEXTENSION:%s\n", deviceName, opencl_version, deviceExtension);
	return majorVersion;
}

bool readImage(const char *filename, Mat *image)
{
	FILE *file;
	errno_t result = fopen_s(&file, filename, "rb");
	if (file != NULL)
	{
		//Mat image(HEIGHT, WIDTH, CV_16UC1), dst(HEIGHT, WIDTH, CV_16UC1);

		for (int y = 0; y < image->rows; y++)
		{
			ushort *buffer = image->ptr<ushort>(y);
			fread(buffer, 2, image->cols, file);
		}
		fclose(file);
		return true;
	}
	else
	{
		return false;
	}
}

int main(int argc, char* argv[])
{
	ushort *image = new ushort[BUFFER_SIZE];
	Mat *left = new Mat(Size(WIDTH, HEIGHT), CV_8UC4);
	Mat *right = new Mat(Size(WIDTH, HEIGHT), CV_8UC4);

	if (3 < argc)
	{
		const char *input_file = argv[1];
		const char *kernel_file = argv[2];
		const char *config_file = argv[3];

		printf("INPUT: %s\nKERNEL: %s\nCONFIG: %s\n", input_file, kernel_file, config_file);

		FILE *file;
		errno_t result = fopen_s(&file, input_file, "rb");
		if (file != NULL)
		{
			fread(image, 2, BUFFER_SIZE, file);
			fclose(file);

			try
			{
				OvrvisionPro ovrvision(WIDTH, HEIGHT);
				ovrvision.createProgram(argv[3]);
				//ovrvision.saveBinary("binary.nvidia");
				//ovrvision.SaveSettings("ovrvision.xml");
				ovrvision.LoadCameraParams(argv[2]);

				int64 start = getTickCount();

				ovrvision.DemosaicRemap(image, *left, *right);

				int64 stop = getTickCount();
				printf("%f usec\n", (stop - start) * 1000000 / getTickFrequency());
			}
			catch (std::runtime_error e)
			{
				printf("FATAL ERROR: %s\n", e.what());
			}

			imshow("Left", *left);
			imshow("Right", *right);

			int key;
			while ((key = waitKey(100)) != 'q')
			{
				if (key == 's')
				{
					imwrite("Left.png", *left);
					imwrite("Right.png", *right);
				}
			}
		}
	}
	delete left;
	delete right;
	delete image;
}

