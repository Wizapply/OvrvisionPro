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

#include <ovrvision_pro.h>	//Ovrvision SDK

/* -- Macro definition ------------------------------------------------------- */

/* -- Global variable definition ----------------------------------------------- */

//Objects
OVR::OvrvisionPro* g_pOvrvision;

/* -- Function prototype ------------------------------------------------- */

/* -- Functions ------------------------------------------------------------- */

int main(int argc, const char **argv)
{
	printf("OvrvisionPro : EEPROM user data elimination Tool\n");

	//Create Ovrvision object
	g_pOvrvision = new OVR::OvrvisionPro();
	if (g_pOvrvision->Open(0, OVR::OV_CAMVR_VGA) == 0) {	//Open
		printf("Ovrvision Pro Open Error!\nPlease check whether OvrvisionPro is connected.\n");
		return 0;
	}

	printf("The EEPROM data of OvrvisionPro is eliminated.\n");

	g_pOvrvision->CameraParamResetEEPROM();

	printf("Elimination was completed.\n");
	
	//Wait
	getchar();

	delete g_pOvrvision;

	return 0;
}

//EOF