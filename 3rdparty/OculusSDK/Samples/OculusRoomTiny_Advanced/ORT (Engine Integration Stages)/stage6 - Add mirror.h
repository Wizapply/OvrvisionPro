
// STAGE 6
// =======
// Finally, we provide the means for the output to be mirrored onto
// the desktop monitor. 

#define STAGE6_CreateMirrorForMonitor   ovrTexture* mirrorTexture = nullptr;                                        \
                                        D3D11_TEXTURE2D_DESC td = {};                                               \
                                        td.ArraySize = 1;                                                           \
                                        td.Format = DXGI_FORMAT_R8G8B8A8_UNORM_SRGB;                                \
                                        td.Width = DIRECTX.WinSizeW;                                                \
                                        td.Height = DIRECTX.WinSizeH;                                               \
                                        td.Usage = D3D11_USAGE_DEFAULT;                                             \
                                        td.SampleDesc.Count = 1;                                                    \
                                        td.MipLevels = 1;                                                           \
                                        ovr_CreateMirrorTextureD3D11(HMD, DIRECTX.Device, &td, 0, &mirrorTexture);  \

#define STAGE6_RenderMirror             ovrD3D11Texture* tex = (ovrD3D11Texture*)mirrorTexture;                     \
                                        DIRECTX.Context->CopyResource(DIRECTX.BackBuffer, tex->D3D11.pTexture);     \
                                        DIRECTX.SwapChain->Present(0, 0);

#define STAGE6_ReleaseMirror            ovr_DestroyMirrorTexture(HMD, mirrorTexture);


// Actual code
//============
{
    STAGE5_DeclareOculusTexture
    STAGE2_InitSDK
    STAGE1_InitEngine(L"Stage6", &luid);
    STAGE5_CreateEyeBuffers
    STAGE4_ConfigureVR
    STAGE6_CreateMirrorForMonitor   /*NEW*/
    STAGE1_InitModelsAndCamera
    STAGE1_MainLoopReadingInput
    {
        STAGE1_MoveCameraFromInputs
        STAGE4_GetEyePoses
        STAGE3_ForEachEye
        {
            STAGE5_SetEyeRenderTarget
            STAGE4_GetMatrices
            STAGE1_RenderModels
        }
        STAGE5_DistortAndPresent
        STAGE6_RenderMirror         /*NEW*/
    }
	STAGE6_ReleaseMirror            /*NEW*/
    STAGE5_ReleaseOculusTextures
    STAGE2_ReleaseSDK
    STAGE1_ReleaseEngine;
}