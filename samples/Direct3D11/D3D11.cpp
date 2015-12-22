//
//

#include "D3D11.h"


D3D11::D3D11(HWND hwnd) : _hWnd(hwnd)
{
	Init();
}


D3D11::~D3D11()
{
	Release();
}


void D3D11::Init()
{
	// クライアント領域の大きさを取得
	RECT rc;
	GetClientRect(_hWnd, &rc);
	UINT clientWidth = rc.right - rc.left;
	UINT clientHeight = rc.bottom - rc.top;

	UINT deviceflags = 0;
#ifdef _DEBUG
	deviceflags |= D3D11_CREATE_DEVICE_DEBUG;
#endif

	// 使用するドライバを設定
	D3D_DRIVER_TYPE drivertype = D3D_DRIVER_TYPE_HARDWARE;

	//  サポートする機能レベルを列挙
	D3D_FEATURE_LEVEL featurelevels[] = {
		D3D_FEATURE_LEVEL_11_1,
		D3D_FEATURE_LEVEL_11_0,
		//D3D_FEATURE_LEVEL_10_1,
		//D3D_FEATURE_LEVEL_10_0,
	};
	UINT num_featureleves = sizeof(featurelevels) / sizeof(featurelevels[0]);
	D3D_FEATURE_LEVEL client_supported_featurelevel;

	// スワップチェインの設定
	DXGI_SWAP_CHAIN_DESC swapchain_desc = { 0 };
	swapchain_desc.BufferCount = 2;
	swapchain_desc.BufferDesc.Width = clientWidth;
	swapchain_desc.BufferDesc.Height = clientHeight;
	swapchain_desc.BufferDesc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
	swapchain_desc.BufferDesc.RefreshRate.Numerator = 60;
	swapchain_desc.BufferDesc.RefreshRate.Denominator = 1;
	swapchain_desc.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;
	swapchain_desc.OutputWindow = _hWnd;
	swapchain_desc.SampleDesc.Count = 1;
	swapchain_desc.SampleDesc.Quality = 0;
	swapchain_desc.Windowed = true;

	HRESULT hr = S_OK;

	hr = D3D11CreateDeviceAndSwapChain(
		nullptr,
		drivertype,
		NULL,
		deviceflags,
		featurelevels,
		num_featureleves,
		D3D11_SDK_VERSION,
		&swapchain_desc,
		&_swapChain,
		&_device,
		&client_supported_featurelevel,
		&_context
		);

	// スワップチェインのバックバッファを取得する
	ID3D11Texture2D* backbuffer;
	hr = _swapChain->GetBuffer(0, __uuidof(ID3D11Texture2D), (void**)&backbuffer);
	// RenderTargetViewの作成
	hr = _device->CreateRenderTargetView(backbuffer, NULL, &_backbufferRTV);
	// レンダリングパイプラインに関連付け
	_context->OMSetRenderTargets(1, &_backbufferRTV, NULL);
	// お片づけ
	backbuffer->Release();

	D3D11_VIEWPORT vp;
	vp.Width = static_cast<float>(clientWidth);
	vp.Height = static_cast<float>(clientHeight);
	vp.MinDepth = 0.0f;
	vp.MaxDepth = 1.0f;
	vp.TopLeftX = 0.0f;
	vp.TopLeftY = 0.0f;
	_context->RSSetViewports(1, &vp);

	// OvrvisionPro
	_ovrvision = new OVR::OvrvisionPro();
	if (_ovrvision->Open(0, OVR::Camprop::OV_CAMHD_FULL, 2, _device) == 0)
	{ 
		MessageBox(_hWnd, L"FAILED TO OPEN", L"OvrvisionPro", IDOK);
	}
	_size = _ovrvision->SetSkinScale(2);	// Set scale 1/2
	//_ovrvision->CreateSkinTextures(_size.width, _size.height, _textureL, _textureR);	// Create textures 
	_left.create(_size.height, _size.width, CV_8UC4);
	_right.create(_size.height, _size.width, CV_8UC4);
}

void D3D11::Release()
{
	if (_backbufferRTV != nullptr) _backbufferRTV->Release();
	if (_device != nullptr) _device->Release();
	if (_context != nullptr) _context->Release();
	if (_swapChain != nullptr) _swapChain->Release();
	if (_ovrvision != NULL) delete _ovrvision;
}

void D3D11::Render()
{
	float clearcolor[4] = { 0.0f, 0.341f, 0.588f, 1.0f };
	_ovrvision->Capture(OVR::Camqt::OV_CAMQT_DMSRMP);		// Capture image
//	_ovrvision->UpdateSkinTextures(_textureL, _textureR);	// Update texture

	_ovrvision->InspectTextures(_left.data, _right.data, 0); // Get HSV images
	cv::imshow("Left", _left);
	cv::imshow("Right", _right);

	_context->ClearRenderTargetView(_backbufferRTV, clearcolor);
	_context->Draw(0, 0);
	_swapChain->Present(0, 0);
}
