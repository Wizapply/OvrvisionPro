//
//

#pragma once

#include <d3d11.h>
#include <CL/opencl.h>
#include "ovrvision_pro.h"

#pragma comment(lib, "ovrvision.lib")

class D3D11
{
protected:
	HWND _hWnd;
	ID3D11Device *_device;
	ID3D11DeviceContext *_context;
	IDXGISwapChain*         _swapChain;
	// Resource View
	ID3D11RenderTargetView* _backbufferRTV;
	ID3D11Texture2D* _texture;
	OVR::OvrvisionPro* _ovrvision;
	cl_mem _left, _right;

public:
	D3D11(HWND hwnd);

	~D3D11();

	void Init();

	void Render();

	void Release();
};

