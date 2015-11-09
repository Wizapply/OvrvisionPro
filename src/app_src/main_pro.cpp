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

/* -- Macro definition ------------------------------------------------------- */

//Oculus Rift screen size
#define RIFTSCREEN_WIDTH	(1920)
#define RIFTPSCREEN_HEIGHT	(1080)

//Application screen size
#define APPSCREEN_WIDTH		(1280)
#define APPSCREEN_HEIGHT	(960)

/* -- Global variable definition ----------------------------------------------- */

//Objects
OVR::OvrvisionPro* g_pOvrvision;

//Screen texture
wzTexture g_screen_texture;
int g_camWidth;
int g_camHeight;

/* -- Function prototype ------------------------------------------------- */

void UpdateFunc(void);	//!<関数

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
	wzInitCreateWizapply("Ovrvision",RIFTSCREEN_WIDTH,RIFTPSCREEN_HEIGHT,WZ_CM_NOVSYNC);//|WZ_CM_FULLSCREEN|WZ_CM_FS_DEVICE

	/*------------------------------------------------------------------*/

	// Library setting
	wzSetClearColor(0.2f,0.2f,0.2f,1);
	wzSetSpriteScSize(RIFTSCREEN_WIDTH, RIFTPSCREEN_HEIGHT);	// Sprite setting
	wzSetCursorScSize(RIFTSCREEN_WIDTH, RIFTPSCREEN_HEIGHT);	// Screen cursor setting

	//Create Ovrvision object
	g_pOvrvision = new OVR::OvrvisionPro();
	if (g_pOvrvision->Open(0, OVR::OV_CAMHD_FULL) == 0) {	//Open 1280x960@45
		printf("ERROR");
	}

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
	wzSetDepthTest(FALSE);		//Depth off
	wzSetCullFace(WZ_CLF_NONE);	//Culling off
	
	wzClear();

	if (g_pOvrvision->isOpen()) {
		//Full Draw
		g_pOvrvision->PreStoreCamData();
		unsigned char* p = g_pOvrvision->GetCamImageBGR(OVR::OV_CAMEYE_LEFT);

		wzChangeTextureBuffer(&g_screen_texture, 0, 0, g_camWidth, g_camHeight, WZ_FORMATTYPE_C_BGRA, (char*)p, 0);
		wzSetSpritePosition(0.0f, 70.0f, 0.0f);
		wzSetSpriteColor(1.0f, 1.0f, 1.0f, 1.0f);
		wzSetSpriteTexCoord(0.0f, 0.0f, 1.0f, 1.0f);
		wzSetSpriteSizeLeftUp((float)g_camWidth, (float)g_camHeight);
		wzSetSpriteTexture(&g_screen_texture);
		wzSpriteDraw();	//Draw

		p = g_pOvrvision->GetCamImageBGR(OVR::OV_CAMEYE_RIGHT);

		wzChangeTextureBuffer(&g_screen_texture, 0, 0, g_camWidth, g_camHeight, WZ_FORMATTYPE_C_BGRA, (char*)p, 0);
		wzSetSpritePosition(960.0f, 70.0f, 0.0f);
		wzSetSpriteColor(1.0f, 1.0f, 1.0f, 1.0f);
		wzSetSpriteTexCoord(0.0f, 0.0f, 1.0f, 1.0f);
		wzSetSpriteSizeLeftUp((float)g_camWidth, (float)g_camHeight);
		wzSetSpriteTexture(&g_screen_texture);
		wzSpriteDraw();	//Draw
	}

	// Debug infomation
	wzSetSpriteColor(1.0f, 1.0f, 1.0f, 1.0f);
	wzSetSpriteRotate(0.0f);
	wzFontSize(12);

	wzPrintf(20, 30, "Ovrvision DemoApp Pro");
	wzPrintf(20, 60, "Draw:%.2f" ,wzGetDrawFPS());
}

void OculusEndFrame()
{
}


//EOF