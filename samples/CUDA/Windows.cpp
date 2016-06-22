//

#include "OvrvisionCUDA.h"
#include <opencv2/highgui.hpp>
#include <opencv2/core/opengl.hpp>

using namespace OVR;

#define WIDTH 1280
#define HEIGHT	960

void drawTexture_cb(void* userdata)
{
	cv::ogl::Texture2D* texture = static_cast<cv::ogl::Texture2D*>(userdata);
	cv::ogl::render(*texture);
}

int main(int argc, char *argv[])
{
	GpuMat left(960, 1280, CV_8UC3), right(HEIGHT, WIDTH, CV_8UC3);
	Mat l(960, 1280, CV_8UC3), r(960, 1280, CV_8UC3);
	CUDA::OvrvisionPro ovrvision;
	if (ovrvision.Open(0, OV_CAMHD_FULL, 0) == 0)
		puts("Can't open OvrvisionPro");

	// ogl::Texture2D‚ðŽg‚Á‚½•\Ž¦
	cv::namedWindow("highgui(Texture2D)", cv::WINDOW_OPENGL);
	cv::resizeWindow("highgui(Texture2D)", WIDTH, HEIGHT);
	cv::setOpenGlContext("highgui(Texture2D)");
	cv::ogl::Texture2D texture(left);
	cv::setOpenGlDrawCallback("highgui(Texture2D)", drawTexture_cb, &texture);

	for (bool loop = true; loop;)
	{
#ifdef _DEBUG
		ovrvision.GetStereoImageBGRA(l, r);
		imshow("Left", l);
#else
		ovrvision.GetStereoImageBGRA(left, right);
		right.download(r);
		imshow("Right", r);
		//cv::updateWindow("highgui(Texture2D)");
#endif
		switch (waitKey(10))
		{
		case 'q':
			loop = false;
			break;

		case ' ':
			cv::namedWindow("highgui(OpenGL)", cv::WINDOW_AUTOSIZE | cv::WINDOW_OPENGL);
			cv::imshow("highgui(OpenGL)", right);
			break;
		}
	}
	return 0;
}
