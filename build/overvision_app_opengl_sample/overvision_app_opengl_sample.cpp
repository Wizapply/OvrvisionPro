// overvision_app_opengl_sample.cpp : コンソール アプリケーションのエントリ ポイントを定義します。
//

#include "stdafx.h"
#include "ovrvision_pro.h"
#include <CL/opencl.h>

extern "C" {
#include <GL/glew.h>
#if defined (_WIN32)
#include <GL/wglew.h>
#endif
}

// GL
int iGLUTWindowHandle;                      // handle to the GLUT window
int iGLUTMenuHandle;                        // handle to the GLUT menu
int iGraphicsWinWidth = 512;                // GL Window width
int iGraphicsWinHeight = 512;               // GL Window height
cl_int image_width = iGraphicsWinWidth;     // teapot image width
cl_int image_height = iGraphicsWinHeight;   // teapot image height
GLuint tex_screen;                          // (offscreen) render target

int main(int argc, char* argv[])
{
	return 0;
}

void displayImage()
{
	// render a screen sized quad
	glDisable(GL_DEPTH_TEST);
	glDisable(GL_LIGHTING);
	glEnable(GL_TEXTURE_2D);
	glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);

	glMatrixMode(GL_PROJECTION);
	glPushMatrix();
	glLoadIdentity();
	glOrtho(-1.0, 1.0, -1.0, 1.0, -1.0, 1.0);

	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();

	glViewport(0, 0, iGraphicsWinWidth, iGraphicsWinHeight);

	glBegin(GL_QUADS);

	glTexCoord2f(0.0, 0.0);
	glVertex3f(-1.0, -1.0, 0.5);

	glTexCoord2f(1.0, 0.0);
	glVertex3f(1.0, -1.0, 0.5);

	glTexCoord2f(1.0, 1.0);
	glVertex3f(1.0, 1.0, 0.5);

	glTexCoord2f(0.0, 1.0);
	glVertex3f(-1.0, 1.0, 0.5);

	glEnd();

	glMatrixMode(GL_PROJECTION);
	glPopMatrix();

	glDisable(GL_TEXTURE_2D);
	glBindBuffer(GL_PIXEL_PACK_BUFFER_ARB, 0);
	glBindBuffer(GL_PIXEL_UNPACK_BUFFER_ARB, 0);
}
