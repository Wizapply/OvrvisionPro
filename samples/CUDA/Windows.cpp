//

#include "OvrvisionCUDA.h"
#include <opencv2/highgui.hpp>
#include <opencv2/core/opengl.hpp>

using namespace OVR;

void drawTexture_cb(void* userdata)
{
	cv::ogl::Texture2D* texture = static_cast<cv::ogl::Texture2D*>(userdata);
	cv::ogl::render(*texture);
}

int main(int argc, char *argv[])
{
	CUDA::OvrvisionPro ovrvision;
	if (ovrvision.Open(0, OV_CAMHD_FULL, 0) == 0)
		puts("Can't open OvrvisionPro");

	// ogl::Texture2D‚ðŽg‚Á‚½•\Ž¦
	cv::namedWindow("highgui(Texture2D)", cv::WINDOW_OPENGL);
	cv::ogl::Texture2D texture(d_dst);
	cv::resizeWindow("highgui(Texture2D)", d_dst.cols, d_dst.rows);
	cv::setOpenGlContext("highgui(Texture2D)");
	cv::setOpenGlDrawCallback("highgui(Texture2D)", drawTexture_cb, &texture);
	cv::updateWindow("highgui(Texture2D)");

	return 0;
}