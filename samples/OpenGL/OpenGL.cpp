//
//


#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>

#include "ovrvision_pro.h"

#ifdef _WIN32
#include <windows.h> 
#include <GL/gl.h> 
#include <GL/glu.h> 

/* Windows globals, defines, and prototypes */ 
TCHAR szAppName[]=L"Win OpenGL"; 
HWND  ghWnd; 
HDC   ghDC; 
HGLRC ghRC; 

#define SWAPBUFFERS SwapBuffers(ghDC) 
#define BLACK_INDEX     0 
#define RED_INDEX       13 
#define GREEN_INDEX     14 
#define BLUE_INDEX      16 
#define WIDTH           300 
#define HEIGHT          200 

LONG WINAPI MainWndProc (HWND, UINT, WPARAM, LPARAM); 
BOOL bSetupPixelFormat(HDC); 

/* OpenGL globals, defines, and prototypes */ 
GLfloat latitude, longitude, latinc, longinc; 
GLdouble radius; 

#define GLOBE    1 
#define CYLINDER 2 
#define CONE     3 

GLvoid resize(GLsizei, GLsizei); 
GLvoid initializeGL(GLsizei, GLsizei); 
GLvoid drawScene(GLvoid); 
void polarView( GLdouble, GLdouble, GLdouble, GLdouble); 

int WINAPI WinMain (HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) 
{ 
	MSG        msg; 
	WNDCLASS   wndclass; 

	/* Register the frame class */ 
	wndclass.style         = 0; 
	wndclass.lpfnWndProc   = (WNDPROC)MainWndProc; 
	wndclass.cbClsExtra    = 0; 
	wndclass.cbWndExtra    = 0; 
	wndclass.hInstance     = hInstance; 
	wndclass.hIcon         = LoadIcon (hInstance, szAppName); 
	wndclass.hCursor       = LoadCursor (NULL,IDC_ARROW); 
	wndclass.hbrBackground = (HBRUSH)(COLOR_WINDOW+1); 
	wndclass.lpszMenuName  = szAppName; 
	wndclass.lpszClassName = szAppName; 

	if (!RegisterClass (&wndclass) ) 
		return FALSE; 

	/* Create the frame */ 
	ghWnd = CreateWindow (szAppName, 
		L"Generic OpenGL Sample", 
		WS_OVERLAPPEDWINDOW | WS_CLIPSIBLINGS | WS_CLIPCHILDREN, 
		CW_USEDEFAULT, 
		CW_USEDEFAULT, 
		WIDTH, 
		HEIGHT, 
		NULL, 
		NULL, 
		hInstance, 
		NULL); 

	/* make sure window was created */ 
	if (!ghWnd) 
		return FALSE; 

	/* show and update main window */ 
	ShowWindow (ghWnd, nCmdShow); 

	UpdateWindow (ghWnd); 

	/* animation loop */ 
	while (1) { 
		/* 
		*  Process all pending messages 
		*/ 

		while (PeekMessage(&msg, NULL, 0, 0, PM_NOREMOVE) == TRUE) 
		{ 
			if (GetMessage(&msg, NULL, 0, 0) ) 
			{ 
				TranslateMessage(&msg); 
				DispatchMessage(&msg); 
			} else { 
				return TRUE; 
			}
		}
		drawScene();
	}
}

/* main window procedure */
LONG WINAPI MainWndProc(
	HWND    hWnd,
	UINT    uMsg,
	WPARAM  wParam,
	LPARAM  lParam)
{
	LONG    lRet = 1;
	PAINTSTRUCT    ps;
	RECT rect;

	switch (uMsg) {

	case WM_CREATE:
		ghDC = GetDC(hWnd);
		if (!bSetupPixelFormat(ghDC))
			PostQuitMessage(0);

		ghRC = wglCreateContext(ghDC);
		wglMakeCurrent(ghDC, ghRC);
		GetClientRect(hWnd, &rect);
		initializeGL(rect.right, rect.bottom);
		break;

	case WM_PAINT:
		BeginPaint(hWnd, &ps);
		EndPaint(hWnd, &ps);
		break;

	case WM_SIZE:
		GetClientRect(hWnd, &rect);
		resize(rect.right, rect.bottom);
		break;

	case WM_CLOSE:
		if (ghRC)
			wglDeleteContext(ghRC);
		if (ghDC)
			ReleaseDC(hWnd, ghDC);
		ghRC = 0;
		ghDC = 0;

		DestroyWindow(hWnd);
		break;

	case WM_DESTROY:
		if (ghRC)
			wglDeleteContext(ghRC);
		if (ghDC)
			ReleaseDC(hWnd, ghDC);

		PostQuitMessage(0);
		break;

	case WM_KEYDOWN:
		switch (wParam) {
		case VK_LEFT:
			longinc += 0.5F;
			break;
		case VK_RIGHT:
			longinc -= 0.5F;
			break;
		case VK_UP:
			latinc += 0.5F;
			break;
		case VK_DOWN:
			latinc -= 0.5F;
			break;
		}

	default:
		lRet = DefWindowProc(hWnd, uMsg, wParam, lParam);
		break;
	}

	return lRet;
}

BOOL bSetupPixelFormat(HDC hdc)
{
	PIXELFORMATDESCRIPTOR pfd, *ppfd;
	int pixelformat;

	ppfd = &pfd;

	ppfd->nSize = sizeof(PIXELFORMATDESCRIPTOR);
	ppfd->nVersion = 1;
	ppfd->dwFlags = PFD_DRAW_TO_WINDOW | PFD_SUPPORT_OPENGL |
		PFD_DOUBLEBUFFER;
	ppfd->dwLayerMask = PFD_MAIN_PLANE;
	ppfd->iPixelType = PFD_TYPE_COLORINDEX;
	ppfd->cColorBits = 8;
	ppfd->cDepthBits = 16;
	ppfd->cAccumBits = 0;
	ppfd->cStencilBits = 0;

	pixelformat = ChoosePixelFormat(hdc, ppfd);

	if ((pixelformat = ChoosePixelFormat(hdc, ppfd)) == 0)
	{
		MessageBox(NULL, L"ChoosePixelFormat failed", L"Error", MB_OK);
		return FALSE;
	}

	if (SetPixelFormat(hdc, pixelformat, ppfd) == FALSE)
	{
		MessageBox(NULL, L"SetPixelFormat failed", L"Error", MB_OK);
		return FALSE;
	}

	return TRUE;
}

/* OpenGL code */

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
	GLUquadricObj *quadObj;

	glNewList(GLOBE, GL_COMPILE);
	quadObj = gluNewQuadric();
	gluQuadricDrawStyle(quadObj, GLU_LINE);
	gluSphere(quadObj, 1.5, 16, 16);
	glEndList();

	glNewList(CONE, GL_COMPILE);
	quadObj = gluNewQuadric();
	gluQuadricDrawStyle(quadObj, GLU_FILL);
	gluQuadricNormals(quadObj, GLU_SMOOTH);
	gluCylinder(quadObj, 0.3, 0.0, 0.6, 15, 10);
	glEndList();

	glNewList(CYLINDER, GL_COMPILE);
	glPushMatrix();
	glRotatef((GLfloat)90.0, (GLfloat)1.0, (GLfloat)0.0, (GLfloat)0.0);
	glTranslatef((GLfloat)0.0, (GLfloat)0.0, (GLfloat)-1.0);
	quadObj = gluNewQuadric();
	gluQuadricDrawStyle(quadObj, GLU_FILL);
	gluQuadricNormals(quadObj, GLU_SMOOTH);
	gluCylinder(quadObj, 0.3, 0.3, 0.6, 12, 2);
	glPopMatrix();
	glEndList();
}

GLvoid initializeGL(GLsizei width, GLsizei height)
{
	GLfloat     maxObjectSize, aspect;
	GLdouble    near_plane, far_plane;

	glClearIndex((GLfloat)BLACK_INDEX);
	glClearDepth(1.0);

	glEnable(GL_DEPTH_TEST);

	glMatrixMode(GL_PROJECTION);
	aspect = (GLfloat)width / height;
	gluPerspective(45.0, aspect, 3.0, 7.0);
	glMatrixMode(GL_MODELVIEW);

	near_plane = 3.0;
	far_plane = 7.0;
	maxObjectSize = 3.0F;
	radius = near_plane + maxObjectSize / 2.0;

	latitude = 0.0F;
	longitude = 0.0F;
	latinc = 6.0F;
	longinc = 2.5F;

	createObjects();
}

void polarView(GLdouble radius, GLdouble twist, GLdouble latitude,
	GLdouble longitude)
{
	glTranslated(0.0, 0.0, -radius);
	glRotated(-twist, 0.0, 0.0, 1.0);
	glRotated(-latitude, 1.0, 0.0, 0.0);
	glRotated(longitude, 0.0, 0.0, 1.0);

}

GLvoid drawScene(GLvoid)
{
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	glPushMatrix();

	latitude += latinc;
	longitude += longinc;

	polarView(radius, 0, latitude, longitude);

	glIndexi(RED_INDEX);
	glCallList(CONE);

	glIndexi(BLUE_INDEX);
	glCallList(GLOBE);

	glIndexi(GREEN_INDEX);
	glPushMatrix();
	glTranslatef(0.8F, -0.65F, 0.0F);
	glRotatef(30.0F, 1.0F, 0.5F, 1.0F);
	glCallList(CYLINDER);
	glPopMatrix();

	glPopMatrix();

	SWAPBUFFERS;
}

#else
#include <GL/freeglut.h>


using namespace cv;
using namespace OVR;

const int width = 640;
const int height = 480;
VideoCapture camera; 
GLuint g_texID;

extern "C" {
	void onDisplay()
	{
		static const GLfloat vtx[] = {
			200, 120,
			440, 120,
			440, 360,
			200, 360,
		};
		glVertexPointer(2, GL_FLOAT, 0, vtx);

		// Step5. テクスチャの領域指定
		static const GLfloat texuv[] = {
			0.0f, 1.0f,
			1.0f, 1.0f,
			1.0f, 0.0f,
			0.0f, 0.0f,
		};
		glTexCoordPointer(2, GL_FLOAT, 0, texuv);

		// Step6. テクスチャの画像指定
		glBindTexture(GL_TEXTURE_2D, g_texID);

		// Step7. テクスチャの描画
		glEnable(GL_TEXTURE_2D);
		glEnableClientState(GL_VERTEX_ARRAY);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		glDrawArrays(GL_QUADS, 0, 4);
		glDisableClientState(GL_TEXTURE_COORD_ARRAY);
		glDisableClientState(GL_VERTEX_ARRAY);
		glDisable(GL_TEXTURE_2D);
	}

	void onKeyboard(unsigned char key, int x, int y)
	{
		switch (toupper(key))
		{
		case 'Q':
			exit(1);
			break;
		}
	}
}


int main(int argc, char *argv[])
{
	if (camera.open(0))
	{
		Mat frame;
		camera >> frame;
		glGenTextures(1, &g_texID);
		glBindTexture(GL_TEXTURE_2D, g_texID);

		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, frame.data);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	}
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glOrtho(0.0f, width, 0.0f, height, -1.0f, 1.0f);

	// Execute
	glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_RGBA | GL_DOUBLE);
	glutInitWindowSize(width, height);
	glutCreateWindow("OvrvisionPro OpenGL sharing");
	glutDisplayFunc(onDisplay);
	//glutReshapeFunc(onResize);
	glutKeyboardFunc(onKeyboard);

	glClearColor(0.0, 0.0, 1.0, 1.0);
	glutMainLoop();

	return 0;
}
#endif