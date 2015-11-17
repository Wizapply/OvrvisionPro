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

int main(int argc, char* argv[])
{
	ushort *pImage = new ushort[BUFFER_SIZE];
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
			fread(pImage, 2, BUFFER_SIZE, file);
			fclose(file);
			try
			{
				OvrvisionPro ovrvision(WIDTH, HEIGHT);
				//ovrvision.LoadCameraParams(config_file);
				//if (ovrvision.createProgram(kernel_file))
				{
					//ovrvision.DemosaicRemap(pImage, *left, *right);
					ovrvision.Demosaic(pImage, *left, *right);

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
				//else{
				//	printf("ERROR: can't create OpenCL kernel\n%s\n", kernel_file);
				//}
			}
			catch (cv::Exception e)
			{
				printf("OpenCV Exception: %s\n", e.msg);
			}
			catch (std::runtime_error e)
			{
				printf("FATAL ERROR: %s\n", e.what());
			}
		}
	}
	//left.release();
	//right.release();
	delete left;
	delete right;
	delete[] pImage;
}

