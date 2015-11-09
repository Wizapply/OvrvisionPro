// main.cpp
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
// Wizapply Framework : (C)Wizapply.com

/* -- Include files -------------------------------------------- */

// Entrypoint
#include <EntryPoint.h>		//!<Cross platform for common entry point
#ifdef WIN32
#include <ovrvision.h>		//Ovrvision SDK
#include <ovrvision_ar.h>
#else
#include <OvrvisionSDK/ovrvision.h>		//Ovrvision SDK
#include <OvrvisionSDK/ovrvision_ar.h>
#define ShowCursor(x)
#endif

//Oculus SDK
#include "COculusVR.h"

//3DModel
#include "C3DCubeModel.h"

/* -- Macro definition ------------------------------------------------------- */

//Oculus Rift screen size
#define RIFTSCREEN_WIDTH	(1920)
#define RIFTPSCREEN_HEIGHT	(1080)

//Application screen size
#define APPSCREEN_WIDTH		(1280)
#define APPSCREEN_HEIGHT	(800)

//Camera image size
#define CAM_WIDTH			640
#define CAM_HEIGHT			480

/* -- Global variable definition ----------------------------------------------- */

//Objects
OVR::Ovrvision* g_pOvrvision;
OVR::OvrvisionAR* g_pOvrvisionAR;

//Screen texture
wzTexture g_screen_texture;
wzTexture g_screen_texture2;

COculusVR* g_pOculus;
C3DCubeModel* g_pCubeModel;
wzMatrix   g_projMat[2];	//left and right projection matrix
wzVector3  g_oculusGap;

//Interocular distance
float eye_interocular = 0.0f;
//Eye scale
float eye_scale = 0.9f;
//Quality
int processer_quality = OV_PSQT_HIGH;
//use AR
bool useOvrvisionAR = false;

/* -- Function prototype ------------------------------------------------- */

void UpdateFunc(void);	//!<関数

/* -- Functions ------------------------------------------------------------- */

/*
 * Initialize application
 */
int Initialize()
{
	//Debug Console ( debug mode )
#ifdef DEBUG
	AllocConsole();
	freopen ( "CONOUT$", "w", stdout ); 
	freopen ( "CONIN$", "r", stdin );
#endif

	//Initialize Wizapply library 
	wzInitCreateWizapply("Ovrvision",RIFTSCREEN_WIDTH,RIFTPSCREEN_HEIGHT,WZ_CM_NOVSYNC);//|WZ_CM_FULLSCREEN|WZ_CM_FS_DEVICE

	//Create HMD object
	g_pOculus = new COculusVR();

	/*------------------------------------------------------------------*/
	// Library setting
	wzSetClearColor(0.0f,0.0f,0.0f,1);
	wzSetSpriteScSize(APPSCREEN_WIDTH, APPSCREEN_HEIGHT);	// Sprite setting
	wzSetCursorScSize(APPSCREEN_WIDTH, APPSCREEN_HEIGHT);	// Screen cursor setting

	//Create ovrvision object
	g_pOvrvision = new OVR::Ovrvision();
	if(g_pOculus->GetHMDType() == ovrHmd_DK2) {
		//Rift DK2
		g_pOvrvision->Open(0,OVR::OV_CAMVGA_FULL);	//Open
	} else {
		//Rift DK1
		g_pOvrvision->Open(0,OVR::OV_CAMVGA_FULL,OV_HMD_OCULUS_DK1);	//Open
	}
	//Create ovrvision ar object
	g_pOvrvisionAR = new OVR::OvrvisionAR(0.15f,CAM_WIDTH,CAM_HEIGHT,g_pOvrvision->GetFocalPoint());

	//Create Projection
	wzMatrixPerspectiveFovLH(&g_projMat[0], g_pOculus->GetHMDFov(0), g_pOculus->GetHMDAspect(), 0.1f, 1000.0f);
	wzMatrixPerspectiveFovLH(&g_projMat[1], g_pOculus->GetHMDFov(1), g_pOculus->GetHMDAspect(), 0.1f, 1000.0f);

	g_pCubeModel = new C3DCubeModel();
	if(!g_pCubeModel->CreateModel(1.5f))
		printf("Create model error!");

	//OculusRightGap
	g_oculusGap.x = g_pOvrvision->GetOculusRightGap(0) * -0.01f;
	g_oculusGap.y = g_pOvrvision->GetOculusRightGap(1) * 0.01f;
	g_oculusGap.z = g_pOvrvision->GetOculusRightGap(2) * 0.01f;

	//Hide cursor
	ShowCursor(FALSE);

	//Create texture
	wzCreateTextureBuffer(&g_screen_texture, CAM_WIDTH, CAM_HEIGHT, WZ_FORMATTYPE_RGB);
	wzCreateTextureBuffer(&g_screen_texture2, CAM_WIDTH, CAM_HEIGHT, WZ_FORMATTYPE_RGB);

	/*------------------------------------------------------------------*/

	//Set update function 
	wzSetUpdateThread(60,UpdateFunc);	// UpdateFunc

	return 0;
}

/*
 * Application exit
 */
int Terminate()
{
	//Delete object
	delete g_pOvrvision;
	delete g_pOvrvisionAR;
	delete g_pOculus;
	delete g_pCubeModel;

	wzDeleteTexture(&g_screen_texture);
	wzDeleteTexture(&g_screen_texture2);

	ShowCursor(TRUE);

	/*------------------------------------------------------------------*/

	//Shutdown Wizapply library
	wzExitWizapply();

	return 0;
}

/*
 * Draw Thread Function
 */
void DrawLoop(void)
{
	wzSetDepthTest(TRUE);		//Depth off
	wzSetCullFace(WZ_CLF_NONE);	//Culling off
	wzVector2 half_pos = {APPSCREEN_WIDTH/2/2,APPSCREEN_HEIGHT/2};

	if(!g_pOculus->isReady())
	{
		// Get ovrvision image
		g_pOvrvision->PreStoreCamData();	//renderer
		unsigned char* p = g_pOvrvision->GetCamImage(OVR::OV_CAMEYE_LEFT, (OvPSQuality)processer_quality);
		unsigned char* p2 = g_pOvrvision->GetCamImage(OVR::OV_CAMEYE_RIGHT, (OvPSQuality)processer_quality);

		//AR
		if(useOvrvisionAR) {
			g_pOvrvisionAR->SetImageRGB(p);	//left
			g_pOvrvisionAR->Render();
		}

		//render
		g_pOculus->BeginDrawRender();

		// Screen clear
		wzClear();

		// Left eye
		g_pOculus->SetViewport(0);
		wzSetSpriteScSize(APPSCREEN_WIDTH/2, APPSCREEN_HEIGHT);

		if(p != NULL) {
			wzChangeTextureBuffer(&g_screen_texture, 0, 0, CAM_WIDTH, CAM_HEIGHT, WZ_FORMATTYPE_RGB, (char*)p, 0);
			wzSetSpritePosition(eye_interocular + half_pos.x, half_pos.y, 0.0f);
			wzSetSpriteColor(1.0f, 1.0f, 1.0f, 1.0f);
			wzSetSpriteTexCoord(0.0f, 0.0f, 1.0f, 1.0f);
			wzSetSpriteSize((float)CAM_WIDTH * eye_scale, (float)CAM_HEIGHT * eye_scale);
			wzSetSpriteTexture(&g_screen_texture);
			wzSpriteDraw();	//Draw
		}

		//3DCube left Renderer
		if(useOvrvisionAR) {
			OVR::OvMarkerData* dt = g_pOvrvisionAR->GetMarkerData();
			for(int i=0; i < g_pOvrvisionAR->GetMarkerDataSize(); i++)
				if(dt[i].id==64) g_pCubeModel->DrawARModel(&dt[i], &g_projMat[0]);	//id=64
		}

		// Right eye
		g_pOculus->SetViewport(1);
		wzSetSpriteScSize(APPSCREEN_WIDTH/2, APPSCREEN_HEIGHT);

		if(p2 != NULL) {
			wzChangeTextureBuffer(&g_screen_texture2, 0, 0, CAM_WIDTH, CAM_HEIGHT, WZ_FORMATTYPE_RGB, (char*)p2, 0);
			wzSetSpritePosition((-eye_interocular)+half_pos.x, half_pos.y, 0.0f);
			wzSetSpriteColor(1.0f, 1.0f, 1.0f, 1.0f);
			wzSetSpriteTexCoord(0.0f, 0.0f, 1.0f, 1.0f);
			wzSetSpriteSize((float)CAM_WIDTH * eye_scale, (float)CAM_HEIGHT * eye_scale);
			wzSetSpriteTexture(&g_screen_texture2);
			wzSpriteDraw();	//Draw
		}

		//3DCube right Renderer
		if(useOvrvisionAR) {
			OVR::OvMarkerData* dt = g_pOvrvisionAR->GetMarkerData();
			for(int i=0; i < g_pOvrvisionAR->GetMarkerDataSize(); i++)
				if(dt[i].id==64) g_pCubeModel->DrawARModel(&dt[i], &g_projMat[1], &g_oculusGap);
		}

		//EndRender
		g_pOculus->EndDrawRender();

		//ScreenDraw
		g_pOculus->DrawScreen();
	} else {
		// Screen clear
		wzClear();
	}

	/*------------------------------------------------------------------*/

	wzSetDepthTest(FALSE);		//Depth off
	//Full Draw
	wzSetViewport( 0, 0, 0, 0 );
	wzSetSpriteScSize(APPSCREEN_WIDTH, APPSCREEN_HEIGHT);

	// Debug infomation
	wzSetSpriteColor(1.0f, 1.0f, 1.0f, 1.0f);
	wzSetSpriteRotate(0.0f);
	wzFontSize(12);

	wzPrintf(20, 30, "Ovrvision DemoApp v2");
	wzPrintf(20, 60, "Update:%.2f, Draw:%.2f", wzGetUpdateFPS(),wzGetDrawFPS());
	wzPrintf(20, 75, "EYE DISTANCE :%.2f , EYE SCALE :%.2f PS_QT :%d", eye_interocular, eye_scale, processer_quality);

	wzPrintf(20, 735, "EYE DISTANCE SETTING: Left Key & Right Key");
	wzPrintf(20, 750, "PROCESS QUALITY: 1,2,3 Key TOGGLE AR MODE : A Key");

	//AR infomation
	if(useOvrvisionAR) {
		wzPrintf(20, 100, "Ovrvision AR mode!");

		OVR::OvMarkerData* dt = g_pOvrvisionAR->GetMarkerData();
		for(int i=0; i < g_pOvrvisionAR->GetMarkerDataSize(); i++)
		{
			wzPrintf(20, 115+(i*20), "ARMarker:%d, T:%.2f,%.2f,%.2f Q:%.2f%.2f,%.2f,%.2f", dt[i].id, 
				dt[i].translate.x, dt[i].translate.y, dt[i].translate.z,
				dt[i].quaternion.x, dt[i].quaternion.y, dt[i].quaternion.z, dt[i].quaternion.w);
		}
	}

	//Error infomation
	if(g_pOvrvision->GetCameraStatus() == OVR::OV_CAMCLOSED) {
		wzSetSpriteColor(1.0f, 0.0f, 0.0f, 1.0f);
		wzPrintf(20, 120, "[ERROR]Ovrvision not found.");
	}
	if(g_pOculus->isReady()) {
		wzSetSpriteColor(1.0f, 0.0f, 0.0f, 1.0f);
		wzPrintf(20, 140, "[ERROR]The configuration of the Oculus Rift fails.");
	}
}

void OculusEndFrame()
{
	if(!g_pOculus->isReady()) g_pOculus->EndFrameTiming();
}

/*
 * Update Thread
 * This function is called every fixed interval of 60fps.
 */
void UpdateFunc(void)
{
	//Control program
	if(wzGetKeyStateTrigger(WZ_KEY_UP))
		eye_scale -= 0.01f;
	if(wzGetKeyStateTrigger(WZ_KEY_DOWN))
		eye_scale += 0.01f;
	if(wzGetKeyStateTrigger(WZ_KEY_LEFT))
		eye_interocular -= 3.0f;
	if(wzGetKeyStateTrigger(WZ_KEY_RIGHT))
		eye_interocular += 3.0f;

	if(wzGetKeyStateTrigger(WZ_KEY_1))
		processer_quality = OV_PSQT_NONE;
	if(wzGetKeyStateTrigger(WZ_KEY_2))
		processer_quality = OV_PSQT_LOW;
	if(wzGetKeyStateTrigger(WZ_KEY_3))
		processer_quality = OV_PSQT_HIGH;

	if(wzGetKeyStateTrigger(WZ_KEY_A))
		useOvrvisionAR ^= true;
}

//EOF