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

wzVector3  g_hmdGap;

/* -- Function prototype ------------------------------------------------- */

void UpdateFunc(void);	//!<Func

/* -- Functions ------------------------------------------------------------- */

/*
 * Initialize application
 */
int Initialize()
{
	AllocConsole();
	freopen("CONOUT$", "w", stdout);
	freopen("CONIN$", "r", stdin);

	//Initialize Wizapply library 
	wzInitCreateWizapply("Ovrvision", APPSCREEN_WIDTH, APPSCREEN_HEIGHT, WZ_CM_NOVSYNC);//|WZ_CM_FULLSCREEN|WZ_CM_FS_DEVICE

	/*------------------------------------------------------------------*/

	// Library setting
	wzSetClearColor(0.0f,0.0f,0.0f,1);
	wzSetSpriteScSize(APPSCREEN_WIDTH, APPSCREEN_HEIGHT);	// Sprite setting
	wzSetCursorScSize(APPSCREEN_WIDTH, APPSCREEN_HEIGHT);	// Screen cursor setting

	//Create Ovrvision object
	g_pOvrvision = new OVR::OvrvisionPro();
	if (g_pOvrvision->Open(0, OVR::OV_CAMVR_FULL) == 0) {	//Open 1280x960@45
		printf("Ovrvision Pro Open Error!\nPlease check whether OvrvisionPro is connected.");
	}

	//g_pOvrvision->SetCameraExposure(12960);
	g_pOvrvision->SetCameraSyncMode(false);

	//OculusRightGap
	g_hmdGap.x = g_pOvrvision->GetHMDRightGap(0) * -0.01f;
	g_hmdGap.y = g_pOvrvision->GetHMDRightGap(1) * 0.01f;
	g_hmdGap.z = g_pOvrvision->GetHMDRightGap(2) * 0.01f;

	g_camWidth = g_pOvrvision->GetCamWidth();
	g_camHeight = g_pOvrvision->GetCamHeight();

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

	if (g_pOvrvision->isOpen())
	{
		//Full Draw
		g_pOvrvision->PreStoreCamData(OVR::Camqt::OV_CAMQT_DMS);
		unsigned char* p = g_pOvrvision->GetCamImageBGRA(OVR::OV_CAMEYE_LEFT);
		unsigned char* p2 = g_pOvrvision->GetCamImageBGRA(OVR::OV_CAMEYE_RIGHT);

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