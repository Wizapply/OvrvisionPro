// main for Windows
//


#include <windows.h> 
#include <GL/gl.h> 
#include <GL/glu.h> 

/* OpenGL functions */
GLvoid resize(GLsizei, GLsizei);
GLvoid initializeGL(GLsizei, GLsizei);
GLvoid drawScene(GLvoid);

/* Windows globals, defines, and prototypes */
TCHAR szAppName[] = L"Win OpenGL";
HWND  ghWnd;
HDC   ghDC;
HGLRC ghRC;


#define WIDTH           640
#define HEIGHT          480 

LONG WINAPI MainWndProc(HWND, UINT, WPARAM, LPARAM);
BOOL bSetupPixelFormat(HDC);


int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
	MSG        msg;
	WNDCLASS   wndclass;

	wndclass.style = 0;
	wndclass.lpfnWndProc = (WNDPROC)MainWndProc;
	wndclass.cbClsExtra = 0;
	wndclass.cbWndExtra = 0;
	wndclass.hInstance = hInstance;
	wndclass.hIcon = LoadIcon(hInstance, szAppName);
	wndclass.hCursor = LoadCursor(NULL, IDC_ARROW);
	wndclass.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);
	wndclass.lpszMenuName = szAppName;
	wndclass.lpszClassName = szAppName;

	if (!RegisterClass(&wndclass))
		return FALSE;

	/* Create the frame */
	ghWnd = CreateWindow(szAppName,
		L"Generic OpenGL Sample",
		WS_OVERLAPPEDWINDOW | WS_CLIPSIBLINGS | WS_CLIPCHILDREN,
		CW_USEDEFAULT,
		CW_USEDEFAULT,
		WIDTH * 2,
		HEIGHT,
		NULL,
		NULL,
		hInstance,
		NULL);

	if (!ghWnd)
		return FALSE;

	ShowWindow(ghWnd, nCmdShow);
	UpdateWindow(ghWnd);

	while (1) {
		while (PeekMessage(&msg, NULL, 0, 0, PM_NOREMOVE) == TRUE)
		{
			if (GetMessage(&msg, NULL, 0, 0))
			{
				TranslateMessage(&msg);
				DispatchMessage(&msg);
			}
			else {
				return TRUE;
			}
		}
		drawScene(); // Draw OpenGL
	}
}

/* main window procedure */
LONG WINAPI MainWndProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
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
//			longinc += 0.5F;
			break;
		case VK_RIGHT:
//			longinc -= 0.5F;
			break;
		case VK_UP:
//			latinc += 0.5F;
			break;
		case VK_DOWN:
//			latinc -= 0.5F;
			break;
		case 'q':
			PostMessage(hWnd, WM_CLOSE, 0, 0);
		}

	default:
		lRet = DefWindowProc(hWnd, uMsg, wParam, lParam);
		break;
	}

	return lRet;
}

BOOL bSetupPixelFormat(HDC hdc)
{
	int pixelformat;

	PIXELFORMATDESCRIPTOR pfd = {
		sizeof(PIXELFORMATDESCRIPTOR),
		1,
		0
		| PFD_DRAW_TO_WINDOW
		| PFD_SUPPORT_OPENGL
		| PFD_DOUBLEBUFFER
		,
		PFD_TYPE_RGBA,
		32,     // color
		0, 0,   // R
		0, 0,   // G
		0, 0,   // B
		0, 0,   // A
		0, 0, 0, 0, 0,      // AC R G B A
		32,     // depth
		8,      // stencil
		0,      // aux
		0,      // layertype
		0,  // reserved
		0,  // layermask
		0,  // visiblemask
		0   // damagemask
	};
	/*
	pfd.nSize = sizeof(PIXELFORMATDESCRIPTOR);
	pfd.nVersion = 1;
	pfd.dwFlags = PFD_DRAW_TO_WINDOW | PFD_SUPPORT_OPENGL | PFD_DOUBLEBUFFER;
	pfd.dwLayerMask = PFD_MAIN_PLANE;
	pfd.iPixelType = PFD_TYPE_RGBA;
	pfd.cColorBits = 8;
	pfd.cDepthBits = 24;
	pfd.cAccumBits = 0;
	pfd.cStencilBits = 0;
	*/
	if ((pixelformat = ChoosePixelFormat(hdc, &pfd)) == 0)
	{
		MessageBox(NULL, L"ChoosePixelFormat failed", L"Error", MB_OK);
		return FALSE;
	}
	if (SetPixelFormat(hdc, pixelformat, &pfd) == FALSE)
	{
		MessageBox(NULL, L"SetPixelFormat failed", L"Error", MB_OK);
		return FALSE;
	}

	return TRUE;
}

void SWAPBUFFERS()
{
	SwapBuffers(ghDC);
}