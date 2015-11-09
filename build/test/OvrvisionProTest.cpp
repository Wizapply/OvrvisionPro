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
	ushort *image = new ushort[BUFFER_SIZE];
	Mat *left = new Mat(Size(WIDTH, HEIGHT), CV_8UC4);
	Mat *right = new Mat(Size(WIDTH, HEIGHT), CV_8UC4);

	if (3 < argc)
	{
		const char *input_file = argv[1];
		const char *kernel_file = argv[2];
		const char *config_file = argv[3];

		printf("INPUT: %s\nKERNEL: %s\nCONFIG: %s\n", input_file, kernel_file, config_file);

	}
	delete left;
	delete right;
	delete image;
}

