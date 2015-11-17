// overvision_app_opengl_sample.cpp : コンソール アプリケーションのエントリ ポイントを定義します。
//

#include "stdafx.h"
#include "ovrvision_pro.h"
#include <CL/opencl.h>


#include <GL/glew.h>
#if defined (_WIN32)
#include <GL/wglew.h>
#endif
#include <GL/freeglut.h>

// GL
int iGLUTWindowHandle;                      // handle to the GLUT window
int iGLUTMenuHandle;                        // handle to the GLUT menu
int iGraphicsWinWidth = 512;                // GL Window width
int iGraphicsWinHeight = 512;               // GL Window height
cl_int image_width = iGraphicsWinWidth;     // teapot image width
cl_int image_height = iGraphicsWinHeight;   // teapot image height
GLuint tex_screen;                          // (offscreen) render target

// pbo variables
GLuint pbo_source;
GLuint pbo_dest;
unsigned int size_tex_data;
unsigned int num_texels;
unsigned int num_values;

int main(int argc, char* argv[])
{
	return 0;
}

// Display callback
//*****************************************************************************
void DisplayGL()
{

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
	//glBindBuffer(GL_PIXEL_PACK_BUFFER_ARB, 0);
	//glBindBuffer(GL_PIXEL_UNPACK_BUFFER_ARB, 0);
}

// Initialize GL
//*****************************************************************************
bool InitGL(int* argc, char **argv)
{
	// init GLUT and GLUT window
	glutInit(argc, argv);
	glutInitDisplayMode(GLUT_RGBA | GLUT_ALPHA | GLUT_DOUBLE | GLUT_DEPTH);
	glutInitWindowPosition(glutGet(GLUT_SCREEN_WIDTH) / 2 - iGraphicsWinWidth / 2,
		glutGet(GLUT_SCREEN_HEIGHT) / 2 - iGraphicsWinHeight / 2);
	glutInitWindowSize(iGraphicsWinWidth, iGraphicsWinHeight);
	iGLUTWindowHandle = glutCreateWindow("OpenCL/OpenGL post-processing");
#if !(defined (__APPLE__) || defined(MACOSX))
	glutSetOption(GLUT_ACTION_ON_WINDOW_CLOSE, GLUT_ACTION_GLUTMAINLOOP_RETURNS);
#endif

	// register GLUT callbacks
	glutDisplayFunc(DisplayGL);
	//glutKeyboardFunc(KeyboardGL);
	//glutReshapeFunc(Reshape);
	//glutTimerFunc(REFRESH_DELAY, timerEvent, 0);

	// create GLUT menu
	//iGLUTMenuHandle = glutCreateMenu(mainMenu);
	glutAddMenuEntry("Toggle Post-processing (Blur filter) ON/OFF <spacebar>", ' ');
	glutAddMenuEntry("Toggle Processor between GPU and CPU [p]", 'p');
	glutAddMenuEntry("Toggle GL animation (rotation) ON/OFF [a]", 'a');
	glutAddMenuEntry("Increment blur radius [+ or =]", '=');
	glutAddMenuEntry("Decrement blur radius [- or _]", '-');
	glutAddMenuEntry("Quit <esc>", '\033');
	glutAttachMenu(GLUT_RIGHT_BUTTON);

	// init GLEW
	glewInit();
	GLboolean bGLEW = glewIsSupported("GL_VERSION_2_0 GL_ARB_pixel_buffer_object");
	//oclCheckErrorEX(bGLEW, shrTRUE, pCleanup);

	// default initialization
	glClearColor(0.5, 0.5, 0.5, 1.0);
	glDisable(GL_DEPTH_TEST);

	// viewport
	glViewport(0, 0, iGraphicsWinWidth, iGraphicsWinHeight);

	// projection
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluPerspective(60.0, (GLfloat)iGraphicsWinWidth / (GLfloat)iGraphicsWinHeight, 0.1, 10.0);
	glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
	glEnable(GL_LIGHT0);
	float red[] = { 1.0, 0.1, 0.1, 1.0 };
	float white[] = { 1.0, 1.0, 1.0, 1.0 };
	glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, red);
	glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, white);
	glMaterialf(GL_FRONT_AND_BACK, GL_SHININESS, 60.0);

	return true;
}

// Create PBO
//*****************************************************************************
void createPBO(GLuint* pbo)
{
	// set up data parameter
	num_texels = image_width * image_height;
	num_values = num_texels * 4;
	size_tex_data = sizeof(GLubyte) * num_values;

	// create buffer object
	glGenBuffers(1, pbo);
	glBindBuffer(GL_ARRAY_BUFFER, *pbo);

	// buffer data
	glBufferData(GL_ARRAY_BUFFER, size_tex_data, NULL, GL_DYNAMIC_DRAW);

	glBindBuffer(GL_ARRAY_BUFFER, 0);
}

// Delete PBO
//*****************************************************************************
void deletePBO(GLuint* pbo)
{
	glBindBuffer(GL_ARRAY_BUFFER, *pbo);
	glDeleteBuffers(1, pbo);

	*pbo = 0;
}

// render a simple 3D scene
//*****************************************************************************
void renderScene()
{
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluPerspective(60.0, (GLfloat)iGraphicsWinWidth / (GLfloat)iGraphicsWinHeight, 0.1, 10.0);

	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	glTranslatef(0.0, 0.0, -3.0);
	//glRotatef(rotate[0], 1.0, 0.0, 0.0);
	//glRotatef(rotate[1], 0.0, 1.0, 0.0);
	//glRotatef(rotate[2], 0.0, 0.0, 1.0);

	glViewport(0, 0, iGraphicsWinWidth, iGraphicsWinHeight);

	glEnable(GL_LIGHTING);
	glEnable(GL_DEPTH_TEST);
	glDepthFunc(GL_LESS);

	glutSolidTeapot(1.0);
}