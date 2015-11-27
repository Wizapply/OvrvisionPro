//
//

#include <windows.h>

LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wp, LPARAM lp)
{
	switch (msg)
	{
	case WM_KEYDOWN:
		if (wp == VK_ESCAPE)
			PostQuitMessage(0);
		return 0;
	case WM_DESTROY:
		PostQuitMessage(0);
		return 0;
	default:
		return DefWindowProc(hwnd, msg, wp, lp);
	}
}

int WINAPI WinMain(HINSTANCE hinstance, HINSTANCE hprev, LPSTR str, int cmdshow)
{
	WNDCLASSEX wc;
	wc.cbSize = sizeof(WNDCLASSEX);
	wc.style = CS_HREDRAW | CS_VREDRAW;
	wc.lpfnWndProc = WndProc;
	wc.cbClsExtra = 0;
	wc.cbWndExtra = 0;
	wc.hInstance = hinstance;
	wc.hIcon = LoadIcon(NULL, IDI_APPLICATION);
	wc.hIconSm = 0;
	wc.hCursor = LoadCursor(NULL, IDI_APPLICATION);
	wc.hbrBackground = (HBRUSH)(COLOR_WINDOW + 2);
	wc.lpszMenuName = NULL;
	wc.lpszClassName = L"DefaultWindowClass";
	RegisterClassEx(&wc);

	HWND hwnd = CreateWindowEx(
		WS_EX_COMPOSITED,
		L"DefaultWindowClass",
		L"WindowTitle",
		WS_OVERLAPPEDWINDOW,
		CW_USEDEFAULT,
		CW_USEDEFAULT,
		600,
		400,
		NULL,
		NULL,
		hinstance,
		NULL);

	ShowWindow(hwnd, cmdshow);

	// Direct3D11 d3d11app(hwnd);

	MSG msg = {};
	while (msg.message != WM_QUIT)
	{
		if (PeekMessage(&msg, NULL, 0, 0, PM_REMOVE))
		{
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
		else
		{
			// d3d11app.Render();
			Sleep(1);
		}
	}

	return 0;
}