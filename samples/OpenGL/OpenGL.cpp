//
//

#include "ovrvision_pro.h"

#include <GL/gl.h> 
#include <GL/glu.h> 

void SWAPBUFFERS();	// platform depend function

#if 1
#define GL_API_CHECK(x)	x
#else
HWND g_hWnd;

#define GL_API_CHECK(x)do{ \
    x;\
    GLenum err = glGetError(); \
    if (GL_NO_ERROR!=err) \
	{ \
    ShowWindow(g_hWnd, SW_MINIMIZE); \
    printf("GL error: %d    Happened for the following expression:\n   %s;\n    file %s, line %d\n press any key to exit...\n", err, #x, __FILE__, __LINE__);\
    return FALSE; \
	} \
}while(0)

#define GENERAL_API_CHECK(x, str)do{ \
    if(!(x))\
	{ \
    ShowWindow(g_hWnd, SW_MINIMIZE); \
    printf("Critical error: %s  Happened for the following expression:\n   %s;\n    file %s, line %d\n press any key to exit...\n", str, #x, __FILE__, __LINE__);\
    return FALSE; \
	}; \
}while(0)

#define CL_API_CHECK(x)do{ \
    cl_int ERR = (x); \
    if(ERR != CL_SUCCESS)\
	{\
    ShowWindow(g_hWnd, SW_MINIMIZE); \
    printf("OpenCL error: %s\n   Happened for the following expression:\n   %s;\n file %s, line %d\n  press any key to exit...\n", opencl_error_to_str(ERR).c_str(), #x, __FILE__, __LINE__);\
    return FALSE; \
	} \
}while(0)
#endif


GLuint textureIDs[2];


OVR::OvrvisionPro ovrvision;	// OvrvisionPro camera

GLvoid createObjects();

/* OpenGL code */
GLvoid initializeGL(GLsizei width, GLsizei height)
{
	GL_API_CHECK(glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE));

	//init OpenGL color buffer and viewport
	GL_API_CHECK(glClearColor(0.0, 0.0, 0.0, 1.0));
	GL_API_CHECK(glViewport(0, 0, width, height));

	//setup camera
	GL_API_CHECK(glMatrixMode(GL_MODELVIEW));
	GL_API_CHECK(glLoadIdentity());
	GL_API_CHECK(glMatrixMode(GL_PROJECTION));
	GL_API_CHECK(glOrtho(-1.0, 1.0, -1.0, 1.0, -1.0, 1.0));


	//no lighting or depth testing, just texturing please
	GL_API_CHECK(glDisable(GL_DEPTH_TEST));
	GL_API_CHECK(glDisable(GL_LIGHTING));
	GL_API_CHECK(glEnable(GL_TEXTURE_2D));

	if (ovrvision.Open(0, OVR::Camprop::OV_CAMHD_FULL, 0) == 0)
		puts("Can't open OvrvisionPro");

	createObjects();
}

GLvoid resize(GLsizei width, GLsizei height)
{
	GLfloat aspect;

	glViewport(0, 0, width, height);

	aspect = (GLfloat)width / height;

	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluPerspective(45.0, aspect, 3.0, 7.0);
	glMatrixMode(GL_MODELVIEW);
}

GLvoid createObjects()
{
	// Create textures
	glGenTextures(2, textureIDs);
	OVR::ROI size = ovrvision.SetSkinScale(2);
	ovrvision.CreateSkinTextures(size.width, size.height, (void *)textureIDs[0], (void *)textureIDs[1]);
}


GLvoid drawScene(GLvoid)
{
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	// Step6. テクスチャの画像指定
	ovrvision.Capture(OVR::Camqt::OV_CAMQT_DMSRMP);
	ovrvision.UpdateSkinTextures((void *)textureIDs[0], (void *)textureIDs[1]);

	glEnable(GL_TEXTURE_2D);
	glBindTexture(GL_TEXTURE_2D, textureIDs[0]); // texture of left hand 
	glBegin(GL_QUADS);
	glTexCoord2f(0.0f, 0.0f);
	glVertex3f(-1.0f, -1.0f, 0.1f);

	glTexCoord2f(1.0f, 0.0f);
	glVertex3f(1.0f, -1.0f, 0.1f);

	glTexCoord2f(1.0f, 1.0f);
	glVertex3f(1.0f, 1.0f, 0.1f);

	glTexCoord2f(0.0f, 1.0f);
	glVertex3f(-1.0f, 1.0f, 0.1f);
	glEnd();
	glDisable(GL_TEXTURE_2D);

	SWAPBUFFERS();
}
