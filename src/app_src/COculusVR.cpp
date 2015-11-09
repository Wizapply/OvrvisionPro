// COculusVR.cpp
//
//MIT License
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.
//
// Oculus Rift : TM & Copyright Oculus VR, Inc. All Rights Reserved
// Unity : TM & Copyright Unity Technologies. All Rights Reserved

/////////// INCLUDE ///////////

#include "COculusVR.h"
#include "OculusLensShader.h"

/////////// VARS AND DEFS ///////////

#ifdef MACOSX
#define MB_OK   0
#define MessageBoxA(nu, mes, cmes, dat)  printf("%s[%s]\n",mes, cmes)
#endif

/////////// CLASS ///////////                        

COculusVR::COculusVR(bool latency)
{
	m_isReady = true;

	// Initializes LibOVR, and the Rift
    ovr_Initialize();

    Hmd = ovrHmd_Create(0);
    if (Hmd == NULL)
    {
       MessageBoxA(NULL, "Oculus Rift not detected.", "", MB_OK);
       return;
    }
    if (Hmd->ProductName[0] == '\0')
        MessageBoxA(NULL, "Rift detected, display not enabled.", "", MB_OK);

    if (Hmd->HmdCaps & ovrHmdCap_ExtendDesktop)
    {
        WindowSize = Hmd->Resolution;
    }
    else
    {
        // In Direct App-rendered mode, we can use smaller window size,
        // as it can have its own contents and isn't tied to the buffer.
        WindowSize = Sizei(1100, 618);//Sizei(960, 540); avoid rotated output bug.
    }

	ovrHmd_AttachToWindow(Hmd, wzGetWindowHandle(), NULL, NULL);

	// Configure Stereo settings.
	Sizei recommenedTex0Size = ovrHmd_GetFovTextureSize(Hmd, ovrEye_Left, Hmd->DefaultEyeFov[0], 1.0f);
	Sizei recommenedTex1Size = ovrHmd_GetFovTextureSize(Hmd, ovrEye_Right, Hmd->DefaultEyeFov[1], 1.0f);

    EyeRenderTargetSize.w = recommenedTex0Size.w + recommenedTex1Size.w;
    EyeRenderTargetSize.h = Alg::Max( recommenedTex0Size.h, recommenedTex1Size.h );

	//Create Framebuffer
	wzCreateRenderTarget(&m_screenRender);
	wzCreateRenderBufferDepth(&m_screenBuffer,EyeRenderTargetSize.w,EyeRenderTargetSize.h);
	wzCreateTexture(&m_screenTex,EyeRenderTargetSize.w,EyeRenderTargetSize.h,WZ_FORMATTYPE_RGB,NULL);
	//attach
	wzSetRenderBuffer(&m_screenRender,&m_screenBuffer);
	wzSetRenderTexture(&m_screenRender,&m_screenTex);

    // Initialize eye rendering information.
    // The viewport sizes are re-computed in case RenderTargetSize changed due to HW limitations.
    ovrFovPort eyeFov[2] = { Hmd->DefaultEyeFov[0], Hmd->DefaultEyeFov[1] } ;

    EyeRenderViewport[0].Pos  = Vector2i(0,0);
    EyeRenderViewport[0].Size = Sizei(EyeRenderTargetSize.w / 2, EyeRenderTargetSize.h);
    EyeRenderViewport[1].Pos  = Vector2i((EyeRenderTargetSize.w + 1) / 2, 0);
    EyeRenderViewport[1].Size = EyeRenderViewport[0].Size;

	//Shader vertex format
	wzVertexElements ve_var[] = {
		{WZVETYPE_FLOAT2,"position"},
		{WZVETYPE_FLOAT1,"timewarpLerpFactor"},
		{WZVETYPE_FLOAT1,"vignette"},
		{WZVETYPE_FLOAT2,"texCoord0"},
		{WZVETYPE_FLOAT2,"texCoord1"},
		{WZVETYPE_FLOAT2,"texCoord2"},
		WZVE_TMT()
	};

	//carete mesh
	for ( int eyeNum = 0; eyeNum < 2; eyeNum++ )
	{
		// Allocate mesh vertices, registering with renderer using the OVR vertex format.
		ovrDistortionMesh meshData;
		ovrHmd_CreateDistortionMesh(Hmd, (ovrEyeType) eyeNum, eyeFov[eyeNum],
									ovrDistortionCap_Chromatic | ovrDistortionCap_TimeWarp, &meshData);
		//Create datas
		wzVector2* vertex_pos = new wzVector2[meshData.VertexCount];
		float* vertex_posTimewarp = new float[meshData.VertexCount];
		float* vertex_posVignette = new float[meshData.VertexCount];
		wzVector2* vertex_textanR = new wzVector2[meshData.VertexCount];
		wzVector2* vertex_textanG = new wzVector2[meshData.VertexCount];
		wzVector2* vertex_textanB = new wzVector2[meshData.VertexCount];

		//data copy
		for(unsigned int i = 0; i < meshData.VertexCount; i++) {
			vertex_pos[i].x = meshData.pVertexData[i].ScreenPosNDC.x;
			vertex_pos[i].y = meshData.pVertexData[i].ScreenPosNDC.y;
			vertex_posTimewarp[i] = meshData.pVertexData[i].TimeWarpFactor;
			vertex_posVignette[i] = meshData.pVertexData[i].VignetteFactor;
			vertex_textanR[i].x = meshData.pVertexData[i].TanEyeAnglesR.x;
			vertex_textanR[i].y = meshData.pVertexData[i].TanEyeAnglesR.y;
			vertex_textanG[i].x = meshData.pVertexData[i].TanEyeAnglesG.x;
			vertex_textanG[i].y = meshData.pVertexData[i].TanEyeAnglesG.y;
			vertex_textanB[i].x = meshData.pVertexData[i].TanEyeAnglesB.x;
			vertex_textanB[i].y = meshData.pVertexData[i].TanEyeAnglesB.y;
		}

		void* vertex_pointer[] = {vertex_pos,vertex_posTimewarp,vertex_posVignette,vertex_textanR,vertex_textanG,vertex_textanB};

		if(wzCreateMesh(&MeshBuffer[eyeNum], vertex_pointer, ve_var,
			meshData.pIndexData, meshData.VertexCount, meshData.IndexCount))
		{	
			MessageBoxA(NULL, "Lens Distort Mesh Error.", "", MB_OK);
				
			delete[] vertex_pos;
			delete[] vertex_posTimewarp;
			delete[] vertex_posVignette;
			delete[] vertex_textanR;
			delete[] vertex_textanG;
			delete[] vertex_textanB;

			return;	//error
		}
		wzChangeDrawMode(&MeshBuffer[eyeNum],WZ_MESH_DF_TRIANGLELIST);

		delete[] vertex_pos;
		delete[] vertex_posTimewarp;
		delete[] vertex_posVignette;
		delete[] vertex_textanR;
		delete[] vertex_textanG;
		delete[] vertex_textanB;

		ovrHmd_DestroyDistortionMesh(&meshData);

		//Create eye render description for use later
		EyeRenderDesc[eyeNum] = ovrHmd_GetRenderDesc(Hmd, (ovrEyeType) eyeNum,  eyeFov[eyeNum]);

		//Do scale and offset
		ovrHmd_GetRenderScaleAndOffset(eyeFov[eyeNum],EyeRenderTargetSize, EyeRenderViewport[eyeNum], UVScaleOffset[eyeNum]);
	}

	//Create shader
	if(wzCreateShader(&LensShader, ols_vertexshader,ols_flagshader, ve_var)) {
		MessageBoxA(NULL, "Lens Shader Compile Error.", "", MB_OK);
		return;
	}

    if(latency) ovrHmd_SetEnabledCaps(Hmd, ovrHmdCap_DynamicPrediction);	//ovrHmdCap_LowPersistence
	// Start the sensor which informs of the Rift's pose and motion
	ovrHmd_ConfigureTracking(Hmd, ovrTrackingCap_Orientation |
								ovrTrackingCap_MagYawCorrection, 0);		//not use : ovrTrackingCap_Position

	m_isReady = false;
}

COculusVR::~COculusVR()
{
	if(m_isReady)
		return;

	//release
	wzDeleteRenderTarget(&m_screenRender);
	wzDeleteRenderBuffer(&m_screenBuffer);
	wzDeleteTexture(&m_screenTex);

	wzDeleteShader(&LensShader);
	wzDeleteMesh(&MeshBuffer[0]);
	wzDeleteMesh(&MeshBuffer[1]);

	ovrHmd_SetEnabledCaps(Hmd, ovrHmdCap_DynamicPrediction);	//ovrHmdCap_LowPersistence

	if (Hmd)
    {
        ovrHmd_Destroy(Hmd);
        Hmd = 0;
    }

	ovr_Shutdown();

	m_isReady = true;
}

//Pre-Renderer
void COculusVR::BeginDrawRender()
{
	ovrHmd_BeginFrameTiming(Hmd, 0); 

	//Chenge the render target
	wzUseRenderTarget(&m_screenRender);
	wzSetClearColor(0.0f,0.0f,0.0f,0.0f);
	wzClearBufferRenderTarget(&m_screenRender);
}

void COculusVR::EndDrawRender()
{
	// Clear screen
	wzUseRenderTarget(NULL);
	wzSetClearColor(0.0f,0.0f,0.0f,1.0f);
	wzSetViewport(0,0,0,0);	//Full
}

//SetViewPort
void COculusVR::SetViewport(int eye)
{
	wzSetViewport( EyeRenderViewport[eye].Pos.x,EyeRenderViewport[eye].Pos.y,
		EyeRenderViewport[eye].Size.w, EyeRenderViewport[eye].Size.h);
}

//Draw
void COculusVR::DrawScreen()
{
	//clear
	wzClear();

	// Adjust eye position and rotation from controls, maintaining y position from HMD.
	static float BodyYaw(3.141592f);
	static Vector3f HeadPos(0.0f, 0.0f, -5.0f);
    static ovrTrackingState HmdState;
	static ovrPosef eyeRenderPose[2];

    ovrVector3f hmdToEyeViewOffset[2] = { EyeRenderDesc[0].HmdToEyeViewOffset, EyeRenderDesc[1].HmdToEyeViewOffset };
    ovrHmd_GetEyePoses(Hmd, 0, hmdToEyeViewOffset, eyeRenderPose, &HmdState);

	/* debug
		wzSetSpriteScSize(1920, 1080);
		wzSetSpritePosition(0.0f, 0.0f, 0.0f);
		wzSetSpriteColor(1.0f, 1.0f, 1.0f, 1.0f);
		wzSetSpriteTexCoord(0.0f, 0.0f, 1.0f, 1.0f);
		wzSetSpriteSizeLeftUp((float)1920, (float)1080);
		wzSetSpriteTexture(&m_screenTex);
		wzSpriteDraw();	//Draw
	*/

	// Setup shader
	wzUseShader(&LensShader);
	wzSetTexture("texture0", &m_screenTex, 0);

	for ( int eyeNum = 0; eyeNum < 2; eyeNum++ )
	{
		wzVector2 uvScale = {UVScaleOffset[eyeNum][0].x,-UVScaleOffset[eyeNum][0].y};
		wzVector2 uvOffset = {UVScaleOffset[eyeNum][1].x,UVScaleOffset[eyeNum][1].y};
		wzMatrix rotStart,rotEnd;
		wzUniformVector2("eyeToSourceUVscale", &uvScale);
		wzUniformVector2("eyeToSourceUVoffset", &uvOffset);

 		ovrMatrix4f timeWarpMatrices[2];
		ovrHmd_GetEyeTimewarpMatrices(Hmd, (ovrEyeType)eyeNum, eyeRenderPose[eyeNum], timeWarpMatrices);
		memcpy(&rotStart.m,&timeWarpMatrices[0],sizeof(ovrMatrix4f));
		memcpy(&rotEnd.m,&timeWarpMatrices[1],sizeof(ovrMatrix4f));
		wzUniformMatrix("eyeRotationStart", &rotStart);	//Nb transposed when set
		wzUniformMatrix("eyeRotationEnd", &rotEnd);
		
		//Draw Mesh
		wzDrawMesh(&MeshBuffer[eyeNum]);
	}

	//DK2 Latency Tester
	unsigned char latencyColor[3];
	ovrBool drawDk2LatencyQuad = ovrHmd_GetLatencyTest2DrawColor(Hmd, latencyColor);
	if(drawDk2LatencyQuad)
    {
		const int latencyQuadSize = 20; // only needs to be 1-pixel, but larger helps visual debugging
		wzSetViewport(Hmd->Resolution.w - latencyQuadSize, 0, latencyQuadSize, latencyQuadSize);
		wzSetClearColor(latencyColor[0] / 255.0f, latencyColor[1] / 255.0f, latencyColor[2] / 255.0f,0.0f);
		wzClear();
	}
}

void COculusVR::EndFrameTiming()
{
	//EndFrame
	ovrHmd_EndFrameTiming(Hmd);
}

//Proparty
bool COculusVR::isReady()
{
	return m_isReady;
}

//Hmd type
ovrHmdType COculusVR::GetHMDType()
{
	if(m_isReady)
		return ovrHmd_None;

	return Hmd->Type;
}

float COculusVR::GetHMDFov(int eyeidx)
{
	if(m_isReady)
		return 110.0f;

	float atanup = TO_DEGREE(atan(Hmd->DefaultEyeFov[eyeidx].UpTan));
	float atandown = TO_DEGREE(atan(Hmd->DefaultEyeFov[eyeidx].DownTan));

	return atanup + atandown;
}

float COculusVR::GetHMDAspect()
{
	if(m_isReady)
		return 1.0f;

	return ((float)Hmd->Resolution.w*0.5f) / (float)Hmd->Resolution.h;
}
