/************************************************************************************
Filename    :   Win32_RoomTiny_Main.cpp
Content     :   First-person view test application for Oculus Rift
Created     :   11th May 2015
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
/// This is an entry-level sample, showing a minimal VR sample, 
/// in a simple environment.  Use WASD keys to move around, and cursor keys.
/// Dismiss the health and safety warning by tapping the headset, 
/// or pressing any key. 
/// It runs with DirectX11.
// Editor : Wizapply : Ovrvision Team

// Include DirectX
#include "Win32_DirectXAppUtil.h"

// Include the Oculus SDK
#include "OVR_CAPI_D3D.h"

// OvrvisionPro
#include <ovrvision_pro.h>

extern int InitializeCamPlane(ID3D11Device* Device, ID3D11DeviceContext* DeviceContext, int w, int h, float zsize, float ipd);
extern int RendererCamPlane(ID3D11Device* Device, ID3D11DeviceContext* DeviceContext, bool right);
extern int SetCamImage(ID3D11DeviceContext* DeviceContext, unsigned char* camImage, unsigned int imagesize);
extern int CleanCamPlane();

//------------------------------------------------------------
// ovrSwapTextureSet wrapper class that also maintains the render target views
// needed for D3D11 rendering.
struct OculusTexture
{
	ovrSession               Session;
	ovrTextureSwapChain      TextureChain;
	std::vector<ID3D11RenderTargetView*> TexRtv;

	OculusTexture() :
		Session(nullptr),
		TextureChain(nullptr)
	{
	}

	bool Init(ovrSession session, int sizeW, int sizeH)
	{
		Session = session;

		ovrTextureSwapChainDesc desc = {};
		desc.Type = ovrTexture_2D;
		desc.ArraySize = 1;
		desc.Format = OVR_FORMAT_R8G8B8A8_UNORM_SRGB;
		desc.Width = sizeW;
		desc.Height = sizeH;
		desc.MipLevels = 1;
		desc.SampleCount = 1;
		desc.MiscFlags = ovrTextureMisc_DX_Typeless;
		desc.BindFlags = ovrTextureBind_DX_RenderTarget;
		desc.StaticImage = ovrFalse;

		ovrResult result = ovr_CreateTextureSwapChainDX(session, DIRECTX.Device, &desc, &TextureChain);
		if (!OVR_SUCCESS(result))
			return false;

		int textureCount = 0;
		ovr_GetTextureSwapChainLength(Session, TextureChain, &textureCount);
		for (int i = 0; i < textureCount; ++i)
		{
			ID3D11Texture2D* tex = nullptr;
			ovr_GetTextureSwapChainBufferDX(Session, TextureChain, i, IID_PPV_ARGS(&tex));
			D3D11_RENDER_TARGET_VIEW_DESC rtvd = {};
			rtvd.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
			rtvd.ViewDimension = D3D11_RTV_DIMENSION_TEXTURE2D;
			ID3D11RenderTargetView* rtv;
			DIRECTX.Device->CreateRenderTargetView(tex, &rtvd, &rtv);
			TexRtv.push_back(rtv);
			tex->Release();
		}

		return true;
	}

	~OculusTexture()
	{
		for (int i = 0; i < (int)TexRtv.size(); ++i)
		{
			Release(TexRtv[i]);
		}
		if (TextureChain)
		{
			ovr_DestroyTextureSwapChain(Session, TextureChain);
		}
	}

	ID3D11RenderTargetView* GetRTV()
	{
		int index = 0;
		ovr_GetTextureSwapChainCurrentIndex(Session, TextureChain, &index);
		return TexRtv[index];
	}

	// Commit changes
	void Commit()
	{
		ovr_CommitTextureSwapChain(Session, TextureChain);
	}
};

// return true to retry later (e.g. after display lost)
static bool MainLoop(bool retryCreate)
{
	// Initialize these to nullptr here to handle device lost failures cleanly
	ovrMirrorTexture mirrorTexture = nullptr;
	OculusTexture  * pEyeRenderTexture[2] = { nullptr, nullptr };
	DepthBuffer    * pEyeDepthBuffer[2] = { nullptr, nullptr };
	Scene          * roomScene = nullptr;
	Camera         * mainCam = nullptr;
	ovrMirrorTextureDesc mirrorDesc = {};
	bool isVisible = true;
	long long frameIndex = 0;

	OVR::OvrvisionPro ovrvision;
	int width = 0, height = 0, pixelsize = 4;

	ovrSession session;
	ovrGraphicsLuid luid;
	ovrResult result = ovr_Create(&session, &luid);
	if (!OVR_SUCCESS(result))
		return retryCreate;

	ovrHmdDesc hmdDesc = ovr_GetHmdDesc(session);

	// Setup Device and Graphics
	// Note: the mirror window can be any size, for this sample we use 1/2 the HMD resolution
	if (!DIRECTX.InitDevice(hmdDesc.Resolution.w / 2, hmdDesc.Resolution.h / 2, reinterpret_cast<LUID*>(&luid)))
		goto Done;

	// Make the eye render buffers (caution if actual size < requested due to HW limits). 
	ovrRecti         eyeRenderViewport[2];

	for (int eye = 0; eye < 2; ++eye)
	{
		ovrSizei idealSize = ovr_GetFovTextureSize(session, (ovrEyeType)eye, hmdDesc.DefaultEyeFov[eye], 1.0f);
		pEyeRenderTexture[eye] = new OculusTexture();
		if (!pEyeRenderTexture[eye]->Init(session, idealSize.w, idealSize.h))
		{
			if (retryCreate) goto Done;
			VALIDATE(OVR_SUCCESS(result), "Failed to create eye texture.");
		}
		pEyeDepthBuffer[eye] = new DepthBuffer(DIRECTX.Device, idealSize.w, idealSize.h);
		eyeRenderViewport[eye].Pos.x = 0;
		eyeRenderViewport[eye].Pos.y = 0;
		eyeRenderViewport[eye].Size = idealSize;
		if (!pEyeRenderTexture[eye]->TextureChain)
		{
			if (retryCreate) goto Done;
			VALIDATE(false, "Failed to create texture.");
		}
	}

	// Create a mirror to see on the monitor.
	mirrorDesc.Format = OVR_FORMAT_R8G8B8A8_UNORM_SRGB;
	mirrorDesc.Width = DIRECTX.WinSizeW;
	mirrorDesc.Height = DIRECTX.WinSizeH;
	result = ovr_CreateMirrorTextureDX(session, DIRECTX.Device, &mirrorDesc, &mirrorTexture);
	if (!OVR_SUCCESS(result))
	{
		if (retryCreate) goto Done;
		VALIDATE(false, "Failed to create mirror texture.");
	}

	// Create the room model
	roomScene = new Scene(false);

	// Create camera
	mainCam = new Camera(&XMVectorSet(0.0f, 0.0f, 0.0f, 0), &XMQuaternionIdentity());

	// FloorLevel will give tracking poses where the floor height is 0
	ovr_SetTrackingOriginType(session, ovrTrackingOrigin_FloorLevel);

	int locationID = 0;
	OVR::Camprop cameraMode = OVR::OV_CAMVR_FULL;
	if (__argc > 2) {
		printf("Ovrvisin Pro mode changed.");
		//__argv[0]; ApplicationPath
		locationID = atoi(__argv[1]);
		cameraMode = (OVR::Camprop)atoi(__argv[2]);
	}

	if (ovrvision.Open(locationID, cameraMode,NULL,2, DIRECTX.Device)) {
		width = ovrvision.GetCamWidth();
		height = ovrvision.GetCamHeight();
		pixelsize = ovrvision.GetCamPixelsize();

		ovrvision.SetCameraSyncMode(false);

		InitializeCamPlane(DIRECTX.Device, DIRECTX.Context, width, height, 1.2f, 0.3f);
	}

	// Main loop
	while (DIRECTX.HandleMessages())
	{
		/*
		XMVECTOR forward = XMVector3Rotate(XMVectorSet(0, 0, -0.05f, 0), mainCam->Rot);
		XMVECTOR right = XMVector3Rotate(XMVectorSet(0.05f, 0, 0, 0), mainCam->Rot);
		if (DIRECTX.Key['W'] || DIRECTX.Key[VK_UP])	  mainCam->Pos = XMVectorAdd(mainCam->Pos, forward);
		if (DIRECTX.Key['S'] || DIRECTX.Key[VK_DOWN]) mainCam->Pos = XMVectorSubtract(mainCam->Pos, forward);
		if (DIRECTX.Key['D'])                         mainCam->Pos = XMVectorAdd(mainCam->Pos, right);
		if (DIRECTX.Key['A'])                         mainCam->Pos = XMVectorSubtract(mainCam->Pos, right);
		static float Yaw = 0;
		if (DIRECTX.Key[VK_LEFT])  mainCam->Rot = XMQuaternionRotationRollPitchYaw(0, Yaw += 0.02f, 0);
		if (DIRECTX.Key[VK_RIGHT]) mainCam->Rot = XMQuaternionRotationRollPitchYaw(0, Yaw -= 0.02f, 0);
		*/

		// Animate the cube
		static float cubeClock = 0;
		roomScene->Models[0]->Pos = XMFLOAT3(9 * sin(cubeClock), 3, 9 * cos(cubeClock += 0.015f));

		// Call ovr_GetRenderDesc each frame to get the ovrEyeRenderDesc, as the returned values (e.g. HmdToEyeOffset) may change at runtime.
		ovrEyeRenderDesc eyeRenderDesc[2];
		eyeRenderDesc[0] = ovr_GetRenderDesc(session, ovrEye_Left, hmdDesc.DefaultEyeFov[0]);
		eyeRenderDesc[1] = ovr_GetRenderDesc(session, ovrEye_Right, hmdDesc.DefaultEyeFov[1]);

		// Get both eye poses simultaneously, with IPD offset already included. 
		ovrPosef         EyeRenderPose[2];
		ovrVector3f      HmdToEyeOffset[2] = { eyeRenderDesc[0].HmdToEyeOffset,
			eyeRenderDesc[1].HmdToEyeOffset };

		double sensorSampleTime;    // sensorSampleTime is fed into the layer later
		ovr_GetEyePoses(session, frameIndex, ovrTrue, HmdToEyeOffset, EyeRenderPose, &sensorSampleTime);

		ovrvision.PreStoreCamData(OVR::Camqt::OV_CAMQT_DMSRMP);

		// Render Scene to Eye Buffers
		if (isVisible)
		{
			for (int eye = 0; eye < 2; ++eye)
			{
				// Clear and set up rendertarget
				DIRECTX.SetAndClearRenderTarget(pEyeRenderTexture[eye]->GetRTV(), pEyeDepthBuffer[eye]);
				DIRECTX.SetViewport((float)eyeRenderViewport[eye].Pos.x, (float)eyeRenderViewport[eye].Pos.y,
					(float)eyeRenderViewport[eye].Size.w, (float)eyeRenderViewport[eye].Size.h);

				//Camera View
				if (eye == 0)
					SetCamImage(DIRECTX.Context, ovrvision.GetCamImageBGRA(OVR::Cameye::OV_CAMEYE_LEFT), width*pixelsize);
				else
					SetCamImage(DIRECTX.Context, ovrvision.GetCamImageBGRA(OVR::Cameye::OV_CAMEYE_RIGHT), width*pixelsize);

				RendererCamPlane(DIRECTX.Device, DIRECTX.Context, bool(eye));

				// Commit rendering to the swap chain
				pEyeRenderTexture[eye]->Commit();
			}
		}

		// Initialize our single full screen Fov layer.
		ovrLayerEyeFov ld = {};
		ld.Header.Type = ovrLayerType_EyeFov;
		ld.Header.Flags = 0;

		for (int eye = 0; eye < 2; ++eye)
		{
			ld.ColorTexture[eye] = pEyeRenderTexture[eye]->TextureChain;
			ld.Viewport[eye] = eyeRenderViewport[eye];
			ld.Fov[eye] = hmdDesc.DefaultEyeFov[eye];
			ld.RenderPose[eye] = EyeRenderPose[eye];
			ld.SensorSampleTime = sensorSampleTime;
		}

		ovrLayerHeader* layers = &ld.Header;
		result = ovr_SubmitFrame(session, frameIndex, nullptr, &layers, 1);
		// exit the rendering loop if submit returns an error, will retry on ovrError_DisplayLost
		if (!OVR_SUCCESS(result))
			goto Done;

		isVisible = (result == ovrSuccess);

		ovrSessionStatus sessionStatus;
		ovr_GetSessionStatus(session, &sessionStatus);
		if (sessionStatus.ShouldQuit)
			goto Done;
		if (sessionStatus.ShouldRecenter)
			ovr_RecenterTrackingOrigin(session);

		// Render mirror
		ID3D11Texture2D* tex = nullptr;
		ovr_GetMirrorTextureBufferDX(session, mirrorTexture, IID_PPV_ARGS(&tex));
		DIRECTX.Context->CopyResource(DIRECTX.BackBuffer, tex);
		tex->Release();
		DIRECTX.SwapChain->Present(0, 0);

		frameIndex++;
	}

	// Release resources
Done:
	delete mainCam;
	delete roomScene;
	if (mirrorTexture)
		ovr_DestroyMirrorTexture(session, mirrorTexture);
	for (int eye = 0; eye < 2; ++eye)
	{
		delete pEyeRenderTexture[eye];
		delete pEyeDepthBuffer[eye];
	}
	DIRECTX.ReleaseDevice();
	ovr_Destroy(session);

	ovrvision.Close();
	CleanCamPlane();

	// Retry on ovrError_DisplayLost
	return retryCreate || OVR_SUCCESS(result) || (result == ovrError_DisplayLost);
}

//-------------------------------------------------------------------------------------
int WINAPI WinMain(HINSTANCE hinst, HINSTANCE, LPSTR, int)
{
	// Initializes LibOVR, and the Rift
	ovrResult result = ovr_Initialize(nullptr);
	VALIDATE(OVR_SUCCESS(result), "Failed to initialize libOVR.");

	VALIDATE(DIRECTX.InitWindow(hinst, L"Ovrvision Pro for OculusSDK CV1"), "Failed to open window.");

	DIRECTX.Run(MainLoop);

	ovr_Shutdown();
	return(0);
}
