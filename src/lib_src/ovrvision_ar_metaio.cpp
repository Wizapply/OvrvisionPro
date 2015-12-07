// ovrvision_ar.cpp
//
//MIT License
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWAR
//
// Oculus Rift : TM & Copyright Oculus VR, Inc. All Rights Reserved
// Unity : TM & Copyright Unity Technologies. All Rights Reserved

#ifdef __OVRVISION_METAIO_AR__

/////////// INCLUDE ///////////

#include "ovrvision_ar.h"

/////////// VARS AND DEFS ///////////

#define OV_RGB_DATASIZE		(3)	//24bit
#define OV_RGBA_DATASIZE	(4)	//32bit

//ctrl : unsigned int
#define CT_NON		(0x00)
#define CT_PSSTART	(0x01)
#define CT_PSNCOMP	(0x02)
#define CT_PSCOMP	(0x03)
#define CT_ERR1		(0x04)
#define CT_ERR2		(0x05)

#define CT_ITSTART	(0x10)
#define CT_ITRECVOK	(0x11)

#define CT_NITSTART		(0x20)
#define CT_NITRECVOK	(0x21)

#define CT_ENDCODE	(0xFF)

//byte
typedef unsigned char byte;
HANDLE g_hMapping;
volatile byte* g_pMappingView;

/////////// CLASS ///////////

//OVR Group
namespace OVR {

//Constructor/Destructor
OvrvisionAR::OvrvisionAR(float markersize, int w, int h, float focalPoint)
{
	//create alloc
	m_detector = new aruco::MarkerDetector();
	m_cameraParam = new aruco::CameraParameters();

	//Marker detector settings
	m_detector->setCornerRefinementMethod(aruco::MarkerDetector::LINES);
	m_detector->setThresholdMethod(aruco::MarkerDetector::ADPT_THRES);

	m_markerSize_Meter = markersize;
	m_pMarkerData = NULL;
	m_markerDataSize = 0;

	//initialize
	m_width = w;
	m_height = h;
	m_isReady = true;

	m_pImageSrc = NULL;
	m_pImageOpenCVMat = NULL;

	float focalPointScale = 1.0f;
	//Adjustment calc
	if (w > 1280) {
		focalPointScale = 2.0f;
	}
	else if (w <= 640) {
		if (w <= 320)
			focalPointScale = 0.25f;
		else
			focalPointScale = 0.5f;
	}

	//Default camera matrix
	cv::Mat cameramat(3,3,CV_32FC1);
	cameramat.at<float>(0) = focalPoint * focalPointScale;	//f=3.1mm
	cameramat.at<float>(1) = 0.0f;
	cameramat.at<float>(2) = (float)(m_width / 2);
	cameramat.at<float>(3) = 0.0f;
	cameramat.at<float>(4) = focalPoint * focalPointScale;
	cameramat.at<float>(5) = (float)(m_height / 2);
	cameramat.at<float>(6) = 0.0f;
	cameramat.at<float>(7) = 0.0f;
	cameramat.at<float>(8) = 1.0f;

	cv::Mat distorsionCoeff(4,1,CV_32FC1,0);
	m_cameraParam->setParams(cameramat,distorsionCoeff,cv::Size(m_width,m_height));	//set param

	{
		char buf[512];
		char parambuf[128];
		GetCurrentDirectoryA(512,buf);
		strcat(buf, "\\arcl\\metaioar_cl.exe");

		sprintf(parambuf, "%d %d %.3f", w, h, focalPoint*focalPointScale);
		ShellExecuteA(NULL, "open", buf, parambuf, "", SW_SHOWMINNOACTIVE);

		g_hMapping = NULL;
		int count = 0;
		while(1) {
			g_hMapping = OpenFileMapping(
				FILE_MAP_ALL_ACCESS,
				FALSE,
				L"OvrvisionARShareMem"
			);
			if(g_hMapping != NULL) {
				break;
			}else{
				count++;
				if(count > 10)
					return;
			}
			Sleep(1000);
		}
		g_pMappingView = (byte*)::MapViewOfFile(g_hMapping, FILE_MAP_ALL_ACCESS, 0, 0, 0);
		if(g_pMappingView == NULL) {
			return;
		}
	}
}

//OvrvisionAR::OvrvisionAR(int markersize){}

OvrvisionAR::~OvrvisionAR()
{
	delete m_detector;
	delete m_cameraParam;

	if(m_pMarkerData)
		delete[] m_pMarkerData;

	//End
	g_pMappingView[0] = CT_ENDCODE;

	//Close
	UnmapViewOfFile((LPCVOID)g_pMappingView);
	CloseHandle(g_hMapping);
}

//Private Methods
//Rotation Matrix to Quaternion
void OvrvisionAR::RotMatToQuaternion( OvVector4D* outQuat, const float* inMat )
{
	float s;
	float tr = inMat[0] + inMat[5] + inMat[10] + 1.0f;
	if( tr >= 1.0f ){
		s = 0.5f / sqrtf( tr );
		outQuat->w = 0.25f / s;
		outQuat->x = (inMat[6] - inMat[9]) * s;
		outQuat->y = (inMat[8] - inMat[2]) * s;
		outQuat->z = (inMat[1] - inMat[4]) * s;
		return;
	} else {
		float max;
		max = inMat[5] > inMat[10] ? inMat[5] : inMat[10];

		if( max < inMat[0] ){
			s = sqrtf( inMat[0] - inMat[5] - inMat[10] + 1.0f );
			float x = s * 0.5f;
			s = 0.5f / s;
			outQuat->x = x;
			outQuat->y = (inMat[1] + inMat[4]) * s;
			outQuat->z = (inMat[8] + inMat[2]) * s;
			outQuat->w = (inMat[6] - inMat[9]) * s;
			return;
		} else if ( max == inMat[5] ) {
			s = sqrtf( -inMat[0] + inMat[5] - inMat[10] + 1.0f );
			float y = s * 0.5f;
			s = 0.5f / s;
			outQuat->x = (inMat[1] + inMat[4]) * s;
			outQuat->y = y;
			outQuat->z = (inMat[6] + inMat[9]) * s;
			outQuat->w = (inMat[8] - inMat[2]) * s;
			return;
		} else {
			s = sqrtf( -inMat[0] - inMat[5] + inMat[10] + 1.0f );
			float z = s * 0.5f;
			s = 0.5f / s;
			outQuat->x = (inMat[8] + inMat[2]) * s;
			outQuat->y = (inMat[6] + inMat[9]) * s;
			outQuat->z = z;
			outQuat->w = (inMat[1] - inMat[4]) * s;
			return;
		}
	}
}

//Multiply Quaternion
OvVector4D OvrvisionAR::MultiplyQuaternion(OvVector4D* a, OvVector4D* b)
{
	OvVector4D ans;
	ans.w = a->w * b->w - a->x * b->x - a->y * b->y - a->z * b->z;
	ans.x = a->w * b->x + b->w * a->x + a->y * b->z - b->y * a->z;
	ans.y = a->w * b->y + b->w * a->y + a->z * b->x - b->z * a->x;
	ans.z = a->w * b->z + b->w * a->z + a->x * b->y - b->x * a->y;
	return ans;
}

//Methods

//image set
void OvrvisionAR::SetImageBGRA(unsigned char* pImage)
{
	m_pImageSrc = pImage;
	m_pImageOpenCVMat = NULL;
}

void OvrvisionAR::SetImageOpenCVImage(ovMat* pImageMat)
{
	m_pImageSrc = NULL;
	m_pImageOpenCVMat = pImageMat;
}

//Detectmarker
void OvrvisionAR::Render()
{
	//opencv var
	cv::Mat	pCamBGRAImg;
	std::vector<aruco::Marker> markers;

	if(m_pImageSrc == NULL && m_pImageOpenCVMat == NULL)
		return;

	//create image
	pCamBGRAImg = cv::Mat(cv::Size(m_width, m_height), CV_MAKETYPE(CV_8U, OV_RGB_DATASIZE), m_pImageSrc);
	
	//detect
	memcpy((void*)&g_pMappingView[1], pCamBGRAImg.data,
		pCamBGRAImg.rows * pCamBGRAImg.cols * OV_RGBA_DATASIZE);

	g_pMappingView[0] = CT_PSSTART;
	while(g_pMappingView[0] == CT_PSSTART);	//wait

	int idata = 0;
	const int coordnum = 240;
	float vmatrix[coordnum];	//30 part
	if(g_pMappingView[0] == CT_PSCOMP) {
		float* mm = (float*)&g_pMappingView[4];
		memcpy(vmatrix,mm,sizeof(float)*coordnum);	//mat
		idata = g_pMappingView[1];
	}

	//edit data
	m_markerDataSize = idata;
	if(m_pMarkerData)
		delete[] m_pMarkerData;
	m_pMarkerData = new OVR::OvMarkerData[m_markerDataSize];

	//insert
	for(int i=0; i < m_markerDataSize; i++) {
		OvVector4D aj = {0.7f, 0.0f, 0.0f, -0.7f};
		float* offiv = &vmatrix[i*8];
		OvMarkerData* dt = &m_pMarkerData[i];

		dt->id = (int)offiv[7];
		dt->centerPtOfImage.x = 0.0f;
		dt->centerPtOfImage.y = 0.0f;

		dt->translate.x = offiv[0] * 0.01f;		//X
		dt->translate.y = offiv[1] * 0.01f;		//Y
		dt->translate.z = -offiv[2] * 0.01f;	//Z
		
		dt->quaternion.x = offiv[3];
		dt->quaternion.y = offiv[4];
		dt->quaternion.z = -offiv[5];
		dt->quaternion.w = -offiv[6];
		dt->quaternion = MultiplyQuaternion(&dt->quaternion, &aj);
	}
}

//Get marker data
int	OvrvisionAR::GetMarkerDataSize()
{
	return m_markerDataSize;
}

OVR::OvMarkerData* OvrvisionAR::GetMarkerData()
{
	return m_pMarkerData;
}
OVR::OvMarkerData* OvrvisionAR::GetMarkerData(int idx)
{
	if(m_markerDataSize < idx)
		return NULL;

	return &m_pMarkerData[idx];
}

void OvrvisionAR::SetInstantTraking(bool value)
{
	if(value) {
		g_pMappingView[0] = CT_ITSTART;
		while(g_pMappingView[0] == CT_ITRECVOK);	//wait
	} else {
		g_pMappingView[0] = CT_NITSTART;
		while(g_pMappingView[0] == CT_NITRECVOK);	//wait
	}
}

};

#endif __OVRVISION_METAIO_AR__