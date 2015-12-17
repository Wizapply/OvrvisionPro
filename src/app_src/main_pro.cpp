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
#include <EntryPoint.h>		//Cross platform for common entry point
#include <ovrvision_pro.h>	//Ovrvision SDK

#include <ovrvision_tracking.h>

/* -- Macro definition ------------------------------------------------------- */

//Application screen size
#define APPSCREEN_WIDTH		(1920)
#define APPSCREEN_HEIGHT	(1080)

/* -- Global variable definition ----------------------------------------------- */

//Objects
OVR::OvrvisionPro* g_pOvrvision;
OVR::OvrvisionTracking* g_pOvrTrack;
//Screen texture
wzTexture g_screen_texture;
int g_camWidth;
int g_camHeight;
OVR::Camqt g_processMode = OVR::Camqt::OV_CAMQT_DMS;

wzVector3  g_hmdGap;

/* -- Function prototype ------------------------------------------------- */

void UpdateFunc(void);	//!<Func

/* -- Functions ------------------------------------------------------------- */

/*
 * Initialize application
 */
int Initialize()
{
	int locationID = 0;
    OVR::Camprop cameraMode = OVR::OV_CAMVR_FULL;

#ifdef WIN32
	AllocConsole();
	freopen("CONOUT$", "w", stdout);
	freopen("CONIN$", "r", stdin);

	if (__argc > 2) {
		printf("Ovrvisin Pro mode changed.");
		//__argv[0]; ApplicationPath
		locationID = atoi(__argv[1]);
		cameraMode = (OVR::Camprop)atoi(__argv[2]);
	}
#endif
	//Initialize Wizapply library 
	wzInitCreateWizapply("Ovrvision", APPSCREEN_WIDTH, APPSCREEN_HEIGHT, WZ_CM_NOVSYNC);//|WZ_CM_FULLSCREEN|WZ_CM_FS_DEVICE

	/*------------------------------------------------------------------*/

	// Library setting
	wzSetClearColor(0.0f,0.0f,0.0f,1);
	wzSetSpriteScSize(APPSCREEN_WIDTH, APPSCREEN_HEIGHT);	// Sprite setting
	wzSetCursorScSize(APPSCREEN_WIDTH, APPSCREEN_HEIGHT);	// Screen cursor setting

	//Create Ovrvision object
	g_pOvrvision = new OVR::OvrvisionPro();
	if (g_pOvrvision->Open(locationID, cameraMode) == 0) {	//Open 960x950@60 default
		printf("Ovrvision Pro Open Error!\nPlease check whether OvrvisionPro is connected.");
	}

	//g_pOvrvision->SetCameraExposure(12960);
	//g_pOvrvision->SetCameraSyncMode(false);

	//OculusRightGap
	g_hmdGap.x = g_pOvrvision->GetHMDRightGap(0) * -0.01f;
	g_hmdGap.y = g_pOvrvision->GetHMDRightGap(1) * 0.01f;
	g_hmdGap.z = g_pOvrvision->GetHMDRightGap(2) * 0.01f;

	g_camWidth = g_pOvrvision->GetCamWidth();
	g_camHeight = g_pOvrvision->GetCamHeight();

	g_pOvrvision->SetCameraWhiteBalanceAuto(false);
	g_pOvrTrack = new OVR::OvrvisionTracking(g_camWidth, g_camHeight, g_pOvrvision->GetCamFocalPoint());

	//Create texture
	wzCreateTextureBuffer(&g_screen_texture, g_camWidth, g_camHeight, WZ_FORMATTYPE_BGRA_RGBA);

	/*------------------------------------------------------------------*/

	return 0;
}

/*
 * Application exit
 */
int Terminate()
{
	//Delete object
	delete g_pOvrvision;
	wzDeleteTexture(&g_screen_texture);
	delete g_pOvrTrack;

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
	wzVector2 half_pos = { APPSCREEN_WIDTH / 2 / 2, APPSCREEN_HEIGHT / 2 };
    
	if (wzGetKeyStateTrigger(WZ_KEY_P))
	{
		if (g_processMode == OVR::Camqt::OV_CAMQT_DMS)
			g_processMode = OVR::Camqt::OV_CAMQT_DMSRMP;
		else
			g_processMode = OVR::Camqt::OV_CAMQT_DMS;
	}

	if (g_pOvrvision->isOpen())
	{
		//Full Draw
        
        g_pOvrvision->PreStoreCamData(g_processMode);
		unsigned char* p = g_pOvrvision->GetCamImageBGRA(OVR::OV_CAMEYE_LEFT);
		unsigned char* p2 = g_pOvrvision->GetCamImageBGRA(OVR::OV_CAMEYE_RIGHT);

		/*
		g_pOvrTrack->SetImageBGRA(p, p2);
		g_pOvrTrack->Render(true, true);

		if (wzGetKeyStateTrigger(WZ_KEY_SPACE))
			g_pOvrTrack->SetHue();
		*/

		wzClear();

		// Left eye
		wzSetViewport(0, 0, APPSCREEN_WIDTH / 2, APPSCREEN_HEIGHT);
		wzSetSpriteScSize(APPSCREEN_WIDTH / 2, APPSCREEN_HEIGHT);

		wzChangeTextureBuffer(&g_screen_texture, 0, 0, g_camWidth, g_camHeight, WZ_FORMATTYPE_C_BGRA, (char*)p, 0);
		wzSetSpritePosition(half_pos.x, half_pos.y, 0.0f);
		wzSetSpriteColor(1.0f, 1.0f, 1.0f, 1.0f);
		wzSetSpriteTexCoord(0.0f, 0.0f, 1.0f, 1.0f);
		wzSetSpriteSize((float)g_camWidth, (float)g_camHeight);
		wzSetSpriteTexture(&g_screen_texture);
		wzSpriteDraw();	//Draw

		// Right eye
		wzSetViewport(APPSCREEN_WIDTH / 2, 0, APPSCREEN_WIDTH / 2, APPSCREEN_HEIGHT);
		wzSetSpriteScSize(APPSCREEN_WIDTH / 2, APPSCREEN_HEIGHT);

		wzChangeTextureBuffer(&g_screen_texture, 0, 0, g_camWidth, g_camHeight, WZ_FORMATTYPE_C_BGRA, (char*)p2, 0);
		wzSetSpritePosition(half_pos.x, half_pos.y, 0.0f);
		wzSetSpriteColor(1.0f, 1.0f, 1.0f, 1.0f);
		wzSetSpriteTexCoord(0.0f, 0.0f, 1.0f, 1.0f);
		wzSetSpriteSize((float)g_camWidth, (float)g_camHeight);
		wzSetSpriteTexture(&g_screen_texture);
		wzSpriteDraw();	//Draw

	} else 
		wzClear();

	// Debug infomation
	wzSetDepthTest(FALSE);		//Depth off
	wzSetViewport(0, 0, 0, 0);
	wzSetSpriteScSize(APPSCREEN_WIDTH, APPSCREEN_HEIGHT);
	wzSetSpriteColor(1.0f, 1.0f, 1.0f, 1.0f);
	wzSetSpriteRotate(0.0f);
	wzFontSize(12);

	wzPrintf(20, 30, "Ovrvision Pro DemoApp");
	wzPrintf(20, 60, "Draw:%.2f", wzGetDrawFPS());

	//Error infomation
	if (!g_pOvrvision->isOpen()) {
		wzSetSpriteColor(1.0f, 0.0f, 0.0f, 1.0f);
		wzPrintf(20, 120, "[ERROR]Ovrvision not found.");
	}
}

void OculusEndFrame(){}

//EOF