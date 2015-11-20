/************************************************************************************
Content     :   First-person view test application for Oculus Rift
Created     :   19th June 2015
Authors     :   Tom Heath
Copyright   :   Copyright 2015 Oculus, Inc. All Rights reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*************************************************************************************/
/// Renders tracked triangles on the Rift, press Escape to quit.
/// Contains everything in one file, including DirectX11 support.
/// Otherwise, just includes standard libs and the Oculus SDK.

#include "d3d11.h"
#include "d3dcompiler.h"
#include "OVR_CAPI_D3D.h"
#include "DirectXMath.h"
using namespace DirectX;
#pragma comment(lib, "d3dcompiler.lib")
#pragma comment(lib, "dxgi.lib")
#pragma comment(lib, "d3d11.lib")

//-------------------------------------------------------------------------------------------------
int WINAPI wWinMain(HINSTANCE hInstance, HINSTANCE, LPWSTR, int)
{
	// Init Rift
	ovrHmd hmd;
    ovrGraphicsLuid luid;
    ovrHmdDesc hmdDesc;

	ovr_Initialize(0);
	ovr_Create(&hmd, &luid);
    hmdDesc = ovr_GetHmdDesc(hmd);

	// Init Window, device and swapchain
	WNDCLASSEXW wcex = { sizeof(WNDCLASSEX), 0, DefWindowProc, 0, 0, hInstance, 0, 0, 0, 0, L"VR" };
	RegisterClassExW(&wcex);
	HWND HWnd = CreateWindowW(wcex.lpszClassName, L"VR in Rift only", WS_VISIBLE, 0, 0, 0, 0, 0, 0, hInstance, 0);
	IDXGIFactory        * DXGIFactory;
	IDXGIAdapter        * DXGIAdapter;
	ID3D11Device        * Device;
	IDXGISwapChain      * SwapChain;
	ID3D11DeviceContext * Context;
	ID3D11Texture2D        * BackBuffer;
	ID3D11RenderTargetView * BackBufferRT;
	CreateDXGIFactory1(__uuidof(IDXGIFactory), (void**)(&DXGIFactory));
	DXGIFactory->EnumAdapters(0, &DXGIAdapter);
	D3D11CreateDevice(DXGIAdapter, D3D_DRIVER_TYPE_UNKNOWN, 0, 0, 0, 0, D3D11_SDK_VERSION, &Device, 0, &Context);
	DXGI_MODE_DESC       BufferDesc = { 0, 0, { 0, 1 }, DXGI_FORMAT_R8G8B8A8_UNORM_SRGB };
	DXGI_SWAP_CHAIN_DESC scDesc = { BufferDesc, { 1, 0 }, DXGI_USAGE_RENDER_TARGET_OUTPUT, 2, HWnd, true };
	DXGIFactory->CreateSwapChain(Device, &scDesc, &SwapChain);
	SwapChain->GetBuffer(0, __uuidof(ID3D11Texture2D), (LPVOID*)&BackBuffer);
	Device->CreateRenderTargetView(BackBuffer, 0, &BackBufferRT);
	Context->OMSetRenderTargets(1, &BackBufferRT, 0);

	// Compile shaders and create layout
	ID3D11VertexShader * VertexShader;
	ID3D11PixelShader  * PixelShader;
	ID3D11InputLayout  * InputLayout;
	ID3D10Blob         * pBlob;
	CHAR* vShader = "float4x4 m; void VS( in float4 p1 : POSITION, out float4 p2 : SV_Position ) { p2 = mul(m, p1); }";
	D3DCompile(vShader, strlen(vShader), "VS", 0, 0, "VS", "vs_4_0", 0, 0, &pBlob, 0);
	Device->CreateVertexShader(pBlob->GetBufferPointer(), pBlob->GetBufferSize(), 0, &VertexShader);
	D3D11_INPUT_ELEMENT_DESC elements[] = { { "POSITION", 0, DXGI_FORMAT_R32G32B32_FLOAT }, };
	Device->CreateInputLayout(elements, 1, pBlob->GetBufferPointer(), pBlob->GetBufferSize(), &InputLayout);
	CHAR* pShader = "void PS(out float4 colorOut : SV_Target) { colorOut = float4(0.1,0.5,0.1,1); }";
	D3DCompile(pShader, strlen(pShader), "PS", 0, 0, "PS", "ps_4_0", 0, 0, &pBlob, 0);
	Device->CreatePixelShader(pBlob->GetBufferPointer(), pBlob->GetBufferSize(), 0, &PixelShader);

	// Create triangle vertex buffer
	ID3D11Buffer* VertexBuffer;
    #define V(n) (n&1?+1.0f:-1.0f), (n&2?-1.0f:+1.0f), (n&4?+1.0f:-1.0f) 
	float vertices[] = { V(0), V(3), V(2), V(6), V(3), V(7), V(4), V(2), V(6), V(1), V(5), V(3), V(4), V(1), V(0), V(5), V(4), V(7) };
	D3D11_BUFFER_DESC bd = { sizeof(vertices), D3D11_USAGE_DEFAULT, D3D11_BIND_VERTEX_BUFFER };
	D3D11_SUBRESOURCE_DATA initData = { vertices };
	Device->CreateBuffer(&bd, &initData, &VertexBuffer);

	// Init device context
	UINT stride = sizeof(float)* 3U;
	UINT offset = 0;
	Context->IASetInputLayout(InputLayout);
	Context->IASetVertexBuffers(0, 1, &VertexBuffer, &stride, &offset);
	Context->IASetPrimitiveTopology(D3D11_PRIMITIVE_TOPOLOGY_TRIANGLELIST);
	Context->VSSetShader(VertexShader, 0, 0);
	Context->PSSetShader(PixelShader, 0, 0);

	// Create eye render buffers
	ovrVector3f              hmdToEyeViewOffset[2];
	ID3D11RenderTargetView * eyeRenderTexRtv[2];
	ovrLayerEyeFov           ld = { { ovrLayerType_EyeFov } };
	for (int i = 0; i < 2; i++)
	{
		ld.Fov[i] = hmdDesc.DefaultEyeFov[i];
		ld.Viewport[i].Size = ovr_GetFovTextureSize(hmd, (ovrEyeType)i, ld.Fov[i], 1.0f);
        D3D11_TEXTURE2D_DESC dsDesc = { static_cast<unsigned>(ld.Viewport[i].Size.w), static_cast<unsigned>(ld.Viewport[i].Size.h), 1, 1, DXGI_FORMAT_R8G8B8A8_UNORM_SRGB,
		{ 1, 0 }, D3D11_USAGE_DEFAULT, D3D11_BIND_SHADER_RESOURCE | D3D11_BIND_RENDER_TARGET };
		hmdToEyeViewOffset[i] = ovr_GetRenderDesc(hmd, (ovrEyeType)i, ld.Fov[i]).HmdToEyeViewOffset;
		ovr_CreateSwapTextureSetD3D11(hmd, Device, &dsDesc, 0, &ld.ColorTexture[i]);        
        Device->CreateRenderTargetView(((ovrD3D11Texture*)&ld.ColorTexture[i]->Textures[0])->D3D11.pTexture, NULL, &eyeRenderTexRtv[i]);
	}

	// Main render loop
	MSG msg;
	while (!((PeekMessage(&msg, NULL, 0, 0, PM_REMOVE)) && (msg.wParam == VK_ESCAPE)))
	{
		// Calculate Eye Poses from tracking state
		ovrPosef pose[2];
		double dispMidSeconds = ovr_GetPredictedDisplayTime(hmd, 0);
        ovrTrackingState hmdState = ovr_GetTrackingState(hmd, dispMidSeconds, ovrTrue);
		ovr_CalcEyePoses(hmdState.HeadPose.ThePose, hmdToEyeViewOffset, pose);

		// Render to each eye
		for (int i = 0; i < 2; i++)
		{
			// Set and clear render target
			float blue[] = { 0.1f, 0.1f, 0.5f, 0 };
			Context->OMSetRenderTargets(1, &eyeRenderTexRtv[i], 0);
			Context->ClearRenderTargetView(eyeRenderTexRtv[i], blue);
			D3D11_VIEWPORT D3Dvp = { 0, 0, (float)ld.Viewport[i].Size.w, (float)ld.Viewport[i].Size.h, 0, 1 };
			Context->RSSetViewports(1, &D3Dvp);

			// Calculate matrix from view and projection
			XMVECTOR rot = XMVectorSet(pose[i].Orientation.x, pose[i].Orientation.y, pose[i].Orientation.z, pose[i].Orientation.w);
			XMVECTOR pos = XMVectorSet(pose[i].Position.x, pose[i].Position.y, pose[i].Position.z, 0);
			XMVECTOR up = XMVector3Rotate(XMVectorSet(0, 1, 0, 0), rot);
			XMVECTOR forward = XMVector3Rotate(XMVectorSet(0, 0, -1, 0), rot);
			XMMATRIX view = XMMatrixLookAtRH(pos, XMVectorAdd(pos, forward), up);
			ovrMatrix4f p = ovrMatrix4f_Projection(hmdDesc.DefaultEyeFov[i], 0.2f, 1000.0f, ovrProjection_RightHanded);
			XMMATRIX proj = XMMatrixSet(p.M[0][0], p.M[1][0], p.M[2][0], p.M[3][0], p.M[0][1], p.M[1][1], p.M[2][1], p.M[3][1],
				p.M[0][2], p.M[1][2], p.M[2][2], p.M[3][2], p.M[0][3], p.M[1][3], p.M[2][3], p.M[3][3]);
			XMMATRIX shaderMat = XMMatrixMultiply(view, proj);

			// Send matrix to shader, and render triangles
			ID3D11Buffer * ConstantBuffer;
			D3D11_BUFFER_DESC desc = { sizeof(shaderMat), D3D11_USAGE_DYNAMIC, D3D11_BIND_CONSTANT_BUFFER, D3D11_CPU_ACCESS_WRITE };
			D3D11_SUBRESOURCE_DATA initData = { &shaderMat, 0, 0 };
			Device->CreateBuffer(&desc, &initData, &ConstantBuffer);
			Context->VSSetConstantBuffers(0, 1, &ConstantBuffer);
			Context->Draw(sizeof(vertices) / 3, 0);
		}

		// Send rendered eye buffers to HMD
		for (int i = 0; i < 2; i++) ld.RenderPose[i] = pose[i];
		ovrLayerHeader* layers[1] = { &ld.Header };
        // Note: this minimal example doesn't handle ovrError_DisplayLost, something most apps will want to do
		ovr_SubmitFrame(hmd, 0, nullptr, layers, 1);
	}

	// Release resources
	for (int i = 0; i < 2; i++) ovr_DestroySwapTextureSet(hmd, ld.ColorTexture[i]);
	ovr_Destroy(hmd);
	ovr_Shutdown();
}

