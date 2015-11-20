/************************************************************************************
Filename    :   Win32_RoomTiny_Main.cpp
Content     :   First-person view test application for Oculus Rift
Created     :   18th Dec 2014
Authors     :   Tom Heath
Copyright   :   Copyright 2012 Oculus, Inc. All Rights reserved.

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
/// This sample demonstrates multi-sample anti-aliasing,
/// which can be compared to its absence by holding the '1' key.

#define   OVR_D3D_VERSION 11
#include "../Common/Win32_DirectXAppUtil.h" // DirectX
#include "../Common/Win32_BasicVR.h"  // Basic VR

struct MSAA : BasicVR
{
    MSAA(HINSTANCE hinst) : BasicVR(hinst, L"MSAA") {}

    void MainLoop()
    {
	    Layer[0] = new VRLayer(HMD);

        // Make MSAA textures and depth buffers
        static const int sampleCount = 4;
        Texture     * MSAATexture[2];
	    DepthBuffer * MSAADepthBuffer[2];
        for (int eye = 0; eye < 2; ++eye)
	    {
		    MSAATexture[eye] = new Texture(true, Layer[0]->pEyeRenderTexture[eye]->SizeW,
			                                     Layer[0]->pEyeRenderTexture[eye]->SizeH, 0, sampleCount);
		    MSAADepthBuffer[eye] = new DepthBuffer(DIRECTX.Device, Layer[0]->pEyeRenderTexture[eye]->SizeW,
			                                                       Layer[0]->pEyeRenderTexture[eye]->SizeH, sampleCount);
	    }

	    while (HandleMessages())
	    {
		    ActionFromInput();
		    Layer[0]->GetEyePoses();

		    for (int eye = 0; eye < 2; ++eye)
		    {
                if (DIRECTX.Key['1'])
                {
                    // Without MSAA, for comparison
                    Layer[0]->RenderSceneToEyeBuffer(MainCam, RoomScene, eye);
                }
                else
                {
                    // Render to higher resolution texture
                    Layer[0]->RenderSceneToEyeBuffer(MainCam, RoomScene, eye, MSAATexture[eye]->TexRtv, 0, 1, 1, 1, 1, 1, 0.2f, 1000.0f, true, MSAADepthBuffer[eye]);
                    // Then resolve down into smaller buffer
                    int destIndex = Layer[0]->pEyeRenderTexture[eye]->TextureSet->CurrentIndex;
                    auto dstTex = reinterpret_cast<ovrD3D11Texture*>(&(Layer[0]->pEyeRenderTexture[eye]->TextureSet->Textures[destIndex]))->D3D11.pTexture;
                    DIRECTX.Context->ResolveSubresource(dstTex, 0, MSAATexture[eye]->Tex, 0, DXGI_FORMAT_R8G8B8A8_UNORM);
                }
		    }

		    Layer[0]->PrepareLayerHeader();
		    DistortAndPresent(1);
	    }

        for (int eye = 0; eye < 2; ++eye)
	    {
		    delete MSAATexture[eye];
		    delete MSAADepthBuffer[eye];
	    }
    }
};

//-------------------------------------------------------------------------------------
int WINAPI WinMain(HINSTANCE hinst, HINSTANCE, LPSTR, int)
{
	MSAA app(hinst);
    return app.Run();
}
