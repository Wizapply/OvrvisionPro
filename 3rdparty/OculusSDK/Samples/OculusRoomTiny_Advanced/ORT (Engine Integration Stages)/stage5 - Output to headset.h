
// STAGE 5
// =======
// This is a big stage.   We create special Oculus textures, for feeding into the SDK.
// We render to these, and then we pass these into the 'layer' system of the SDK.
// For this simple example, there is just a simple basic layer.
// This carries out the distortion, and outputs the results to the Rift.

#define STAGE5_DeclareOculusTexture  struct OculusTexture                                                                                 \
                                     {                                                                                                    \
                                         ovrSwapTextureSet      * TextureSet;                                                             \
                                         ID3D11RenderTargetView * TexRtv[3];                                                              \
										 OculusTexture(ovrHmd hmd, int sizeW, int sizeH)                                                  \
                                         {                                                                                                \
                                             D3D11_TEXTURE2D_DESC dsDesc;                                                                 \
                                             dsDesc.Width = sizeW;                                                                        \
                                             dsDesc.Height = sizeH;                                                                       \
                                             dsDesc.MipLevels = 1;                                                                        \
                                             dsDesc.ArraySize = 1;                                                                        \
                                             dsDesc.Format = DXGI_FORMAT_R8G8B8A8_UNORM_SRGB;                                             \
                                             dsDesc.SampleDesc.Count = 1;                                                                 \
                                             dsDesc.SampleDesc.Quality = 0;                                                               \
                                             dsDesc.Usage = D3D11_USAGE_DEFAULT;                                                          \
                                             dsDesc.CPUAccessFlags = 0;                                                                   \
                                             dsDesc.MiscFlags = 0;                                                                        \
                                             dsDesc.BindFlags = D3D11_BIND_SHADER_RESOURCE | D3D11_BIND_RENDER_TARGET;                    \
											 ovr_CreateSwapTextureSetD3D11(hmd, DIRECTX.Device, &dsDesc, ovrSwapTextureSetD3D11_Typeless, &TextureSet);              \
                                             for (int i = 0; i < TextureSet->TextureCount; ++i)                                           \
                                             {                                                                                            \
											     ovrD3D11Texture* tex = (ovrD3D11Texture*)&TextureSet->Textures[i];						  \
												 D3D11_RENDER_TARGET_VIEW_DESC rtvd = {};												  \
												 rtvd.Format = DXGI_FORMAT_R8G8B8A8_UNORM;												  \
												 rtvd.ViewDimension = D3D11_RTV_DIMENSION_TEXTURE2D;									  \
												 DIRECTX.Device->CreateRenderTargetView(tex->D3D11.pTexture, &rtvd, &TexRtv[i]);		  \
											 }                                                                                            \
                                         }                                                                                                \
                                         void Increment()                                                                                 \
                                         {                                                                                                \
                                             TextureSet->CurrentIndex = (TextureSet->CurrentIndex + 1) % TextureSet->TextureCount;        \
                                         }                                                                                                \
                                         void Release(ovrHmd hmd)                                                                         \
                                         {                                                                                                \
                                             ovr_DestroySwapTextureSet(hmd, TextureSet);                                               \
                                         }                                                                                                \
                                     };



#define STAGE5_CreateEyeBuffers      OculusTexture  * pEyeRenderTexture[2];                                                                \
                                     DepthBuffer    * pEyeDepthBuffer[2];                                                                  \
                                     ovrRecti         eyeRenderViewport[2];                                                                \
                                     for (int eye = 0; eye < 2; eye++)                                                                     \
                                     {                                                                                                     \
                                         ovrSizei idealSize = ovr_GetFovTextureSize(HMD, (ovrEyeType)eye, HMDInfo.DefaultEyeFov[eye], 1.0f);  \
                                         pEyeRenderTexture[eye] = new OculusTexture(HMD, idealSize.w, idealSize.h);                        \
                                         pEyeDepthBuffer[eye] = new DepthBuffer(DIRECTX.Device, idealSize.w, idealSize.h);                 \
										 eyeRenderViewport[eye].Pos.x = 0;                                                                 \
										 eyeRenderViewport[eye].Pos.y = 0;                                                                 \
										 eyeRenderViewport[eye].Size = idealSize;                                                          \
                                     }


#define STAGE5_SetEyeRenderTarget    pEyeRenderTexture[eye]->Increment();                                                                  \
                                     int texIndex = pEyeRenderTexture[eye]->TextureSet->CurrentIndex;                                      \
                                     DIRECTX.SetAndClearRenderTarget(pEyeRenderTexture[eye]->TexRtv[texIndex], pEyeDepthBuffer[eye]);      \
									 DIRECTX.SetViewport((float)eyeRenderViewport[eye].Pos.x, (float)eyeRenderViewport[eye].Pos.y,         \
									                     (float)eyeRenderViewport[eye].Size.w, (float)eyeRenderViewport[eye].Size.h);

#define STAGE5_DistortAndPresent     ovrViewScaleDesc viewScaleDesc;                                                                       \
                                     viewScaleDesc.HmdSpaceToWorldScaleInMeters = 1.0f;                                                    \
                                     viewScaleDesc.HmdToEyeViewOffset[0] = HmdToEyeViewOffset[0];                                          \
                                     viewScaleDesc.HmdToEyeViewOffset[1] = HmdToEyeViewOffset[1];                                          \
                                     ovrLayerEyeFov ld;                                                                                    \
                                     ld.Header.Type = ovrLayerType_EyeFov;                                                                 \
                                     ld.Header.Flags = 0;                                                                                  \
                                     for (int eye = 0; eye < 2; eye++)                                                                     \
                                     {                                                                                                     \
                                         ld.ColorTexture[eye] = pEyeRenderTexture[eye]->TextureSet;                                        \
                                         ld.Viewport[eye] = eyeRenderViewport[eye];                                                        \
                                         ld.Fov[eye] = HMDInfo.DefaultEyeFov[eye];                                                         \
                                         ld.RenderPose[eye] = EyeRenderPose[eye];                                                          \
                                     }                                                                                                     \
                                     ovrLayerHeader* layers = &ld.Header;                                                                  \
                                     isVisible = ovr_SubmitFrame(HMD, 0, &viewScaleDesc, &layers, 1) == ovrSuccess;                                           
                                                                                                                                       
#define STAGE5_ReleaseOculusTextures pEyeRenderTexture[0]->Release(HMD);                                                                   \
                                     pEyeRenderTexture[1]->Release(HMD);                                                               



// Actual code
//============
{
    STAGE5_DeclareOculusTexture         /*NEW*/
    STAGE2_InitSDK
    STAGE1_InitEngine(L"Stage5", &luid);
    STAGE5_CreateEyeBuffers            /*REPLACEMENT*/
    STAGE4_ConfigureVR
    STAGE1_InitModelsAndCamera
    STAGE1_MainLoopReadingInput
    {
        STAGE1_MoveCameraFromInputs
        STAGE4_GetEyePoses
        STAGE3_ForEachEye
        {
            STAGE5_SetEyeRenderTarget   /*REPLACEMENT*/
            STAGE4_GetMatrices
            STAGE1_RenderModels
        }
        STAGE5_DistortAndPresent        /*REPLACEMENT*/
    }
    STAGE5_ReleaseOculusTextures        /*NEW*/
    STAGE2_ReleaseSDK
    STAGE1_ReleaseEngine;
}