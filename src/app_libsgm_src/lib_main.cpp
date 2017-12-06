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

//SGM
#include <libsgm.h>
#include <ovrvision_pro.h>	//Ovrvision SDK

/* -- Macro definition ------------------------------------------------------- */

//Exporter
#ifdef WIN32
#define CSHARP_EXPORT __declspec(dllexport)
#elif MACOSX
#define CSHARP_EXPORT 
#else //LINUX
#define CSHARP_EXPORT
#endif

/* -- Global variable definition ----------------------------------------------- */

//SGM
sgm::StereoSGM* g_ssgm = nullptr;
unsigned char* g_output_data8 = nullptr;

/* -- Function prototype ------------------------------------------------- */


/* -- Functions ------------------------------------------------------------- */

//C language
#ifdef __cplusplus
extern "C" {
#endif

/*
 * Initialize
 */
CSHARP_EXPORT int ovSGMInit(int width, int height, int disparty_size)
{
	if (g_ssgm != nullptr)
	{
		delete g_ssgm;
		g_ssgm = nullptr;
	}

	g_ssgm = new sgm::StereoSGM(width, height, disparty_size, 8, 8, sgm::EXECUTE_INOUT_HOST2HOST);
	g_output_data8 = new unsigned char[width * height];
	return 0;
}

/*
* Close
*/
CSHARP_EXPORT int ovSGMRelease()
{
	if (g_ssgm == nullptr)
		return 1;
	
	delete g_ssgm;
	g_ssgm = nullptr;

	delete[] g_output_data8;
	g_output_data8 = nullptr;

	return 0;
}

/*
 * SGMAnalytics
 */
CSHARP_EXPORT int ovSGMAnalytics(void* object, unsigned char* pDepthImage)
{
	if (g_ssgm == nullptr)
		return 1;

	if (object == nullptr)
		return 1;
	if (pDepthImage == nullptr)
		return 1;

	OVR::OvrvisionPro* ovr = (OVR::OvrvisionPro*)object;

	/////// Analtyics ///////
	if (ovr->isOpen())
	{
		int width = ovr->GetCamWidth();
		int height = ovr->GetCamHeight();

		unsigned char* pLeft = new unsigned char[width*height];
		unsigned char* pRight = new unsigned char[width*height];

		ovr->Grayscale(pLeft, pRight);

		//SGM
		g_ssgm->execute(pLeft, pRight, (void**)&g_output_data8);

		delete[] pLeft;
		delete[] pRight;
		
		for (int i = 0; i < height; i++) {
			for (int j = 0; j < width; j++) {

				int ds = (i*width * 4) + (j * 4);
				int os = (i*width) + (j);
				unsigned int data_dub = (unsigned int)g_output_data8[os] * 4;
				if (data_dub >= 256){
					data_dub = 255;
				}

				pDepthImage[ds + 0] = (unsigned char)(data_dub);
				pDepthImage[ds + 1] = (unsigned char)(data_dub);
				pDepthImage[ds + 2] = (unsigned char)(data_dub);
				pDepthImage[ds + 3] = 0xFF;
			}
		}
	}



	//float da = ovr->GetCamFocalPoint() / (float)g_output_data8[post];
	return 0;
}


#ifdef __cplusplus
}
#endif

//EOF
