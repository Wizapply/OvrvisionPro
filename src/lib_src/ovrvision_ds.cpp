// ovrvision_ds.cpp
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

///// LIMIT /////

//Windows only
#ifdef WIN32

/////////// INCLUDE ///////////

#include "ovrvision_ds.h"

//Group
namespace OVR
{

/////////// VARS AND DEFS ///////////

//Enable Multithread
#define OV_COM_MULTI_THREADED

// Utility function
template<typename T>
inline void SAFE_RELEASE(T **p)
{
    if((*p)) {
        (*p)->Release();
        (*p) = NULL;
    }
}

template <typename T>
inline void SAFE_DELETE(T*& p){
	if(p != NULL) {
		delete (p);
		(p) = NULL;
	}
}

template <typename T>
inline void SAFE_DELETEARRAY(T*& p){
	if(p != NULL) {
		delete[] (p);
		(p) = NULL;
	}
}

// Get filter pins
static IPin *OV_GetPin(IBaseFilter *pFilter, PIN_DIRECTION PinDir)
{
	BOOL       bFound = FALSE;
	IEnumPins  *pEnum;
	IPin       *pPin;

	//Enum pins
	pFilter->EnumPins(&pEnum);
	while(pEnum->Next(1, &pPin, 0) == S_OK)
	{
		PIN_DIRECTION PinDirThis;
		pPin->QueryDirection(&PinDirThis);
		if (bFound = (PinDir == PinDirThis)) 
			//Exit if Pin that you specify
			break;
		pPin->Release();
	}
	pEnum->Release();
	return (bFound ? pPin : 0);
}

//Buffer max size
#define OV_MAX_BUFFERNUMBYTE	(10240000)	//10MB

/////////// CALLBACK CLASS ///////////

//SampleGrabberCallback
class OVSampleGrabberCB : public ISampleGrabberCB
{
public:
	OVSampleGrabberCB() : ISampleGrabberCB()
	{
		//Initialize
		InitializeCriticalSection(&m_critSection);
		m_hEvent = CreateEvent(NULL, true, false, NULL);

		m_LatestBufferLength = 0;
		
		m_pPixels = new unsigned char[OV_MAX_BUFFERNUMBYTE];
		memset(m_pPixels,0x00,sizeof(unsigned char)*OV_MAX_BUFFERNUMBYTE);

		m_get_callback = NULL;
	}

	~OVSampleGrabberCB()
	{
		//End
		DeleteCriticalSection(&m_critSection);
		CloseHandle(m_hEvent);
		delete[] m_pPixels;
	}

	//Method

    STDMETHODIMP_(ULONG) AddRef() { return 1; }
    STDMETHODIMP_(ULONG) Release() { return 2; }

    STDMETHODIMP QueryInterface(REFIID riid, void **ppvObject)
	{
        *ppvObject = static_cast<ISampleGrabberCB*>(this);
        return S_OK;
    }
    
    //This method is meant to have less overhead
    STDMETHODIMP SampleCB(double time, IMediaSample *pSample)
	{
		unsigned char* ptrBuffer;
		
		if(WaitForSingleObject(m_hEvent, 0) == WAIT_OBJECT_0)
			return S_OK;

		if(SUCCEEDED(pSample->GetPointer(&ptrBuffer)))
		{
			m_LatestBufferLength = pSample->GetActualDataLength();

			//Deta copy
			EnterCriticalSection(&m_critSection);
  				memcpy(m_pPixels, ptrBuffer, m_LatestBufferLength);
			LeaveCriticalSection(&m_critSection);

			SetEvent(m_hEvent);

			//Callback
			if (m_get_callback != NULL)
				m_get_callback();
		}

		return S_OK;
    }
    
    //This method is meant to have more overhead
    STDMETHODIMP BufferCB(double Time, BYTE *pBuffer, long BufferLen)
	{
    	return E_NOTIMPL;
    }

	//Var
	int m_LatestBufferLength;
	unsigned char* m_pPixels;
	void(*m_get_callback)(void);

	//Thread var
	CRITICAL_SECTION m_critSection;
	HANDLE m_hEvent;	
};

/////////// CLASS ///////////

//OvrvisionDirectShow
OvrvisionDirectShow::OvrvisionDirectShow()
{
	HRESULT hr = ::CoInitializeEx(NULL, COINIT_MULTITHREADED);
	if (hr == S_OK) m_comInit = true;
	else m_comInit = false;

	//Var init
	m_devstatus = OVR::OV_DEVNONE;
	m_width = 0;
	m_height = 0;
	m_rate = 0;
	m_latestPixelDataSize = 0;
	m_maxPixelDataSize = 0;
	memset(&m_nDeviceName, 0x00, sizeof(m_nDeviceName));

	//Var null
	m_pGraph = NULL;
	m_pSrcFilter = NULL;
	m_pDestFilter = NULL;
	m_pGrabberFilter = NULL;
	m_pSGrabber = NULL;
	m_pMediaControl = NULL;

	m_pAMVideoProcAmp = NULL;
	m_pIAMCameraControl = NULL;

	m_pSGCallback = NULL;
}

OvrvisionDirectShow::~OvrvisionDirectShow()
{
	//Delete device
	DeleteDevice();

	if (m_comInit)
		::CoUninitialize();
}

// Private method

// GetMediaSubtypeAsString
void OvrvisionDirectShow::GetMediaSubtypeAsString(GUID type, char* typeAsString)
{
#define MSS_TEMPSIZE	(8)

	char tmpStr[MSS_TEMPSIZE];
	if( type == MEDIASUBTYPE_RGB8) sprintf_s(tmpStr, sizeof(tmpStr), "RGB8");
	else if(type == MEDIASUBTYPE_RGB24) sprintf_s(tmpStr, sizeof(tmpStr), "RGB24");
	else if(type == MEDIASUBTYPE_RGB32) sprintf_s(tmpStr, sizeof(tmpStr), "RGB32");
	else if(type == MEDIASUBTYPE_RGB555)sprintf_s(tmpStr, sizeof(tmpStr), "RGB555");
	else if(type == MEDIASUBTYPE_RGB565)sprintf_s(tmpStr, sizeof(tmpStr), "RGB565");
	else if(type == MEDIASUBTYPE_MJPG) 	sprintf_s(tmpStr, sizeof(tmpStr), "MJPG");
	else if(type == MEDIASUBTYPE_YUY2) 	sprintf_s(tmpStr, sizeof(tmpStr), "YUY2");
	else if(type == MEDIASUBTYPE_YVYU) 	sprintf_s(tmpStr, sizeof(tmpStr), "YVYU");
	else if(type == MEDIASUBTYPE_YUYV) 	sprintf_s(tmpStr, sizeof(tmpStr), "YUYV");
	else if(type == MEDIASUBTYPE_IYUV) 	sprintf_s(tmpStr, sizeof(tmpStr), "IYUV");
	else if(type == MEDIASUBTYPE_UYVY)  sprintf_s(tmpStr, sizeof(tmpStr), "UYVY");
	else if(type == MEDIASUBTYPE_YV12)  sprintf_s(tmpStr, sizeof(tmpStr), "YV12");
	else if(type == MEDIASUBTYPE_YVU9)  sprintf_s(tmpStr, sizeof(tmpStr), "YVU9");
	else if(type == MEDIASUBTYPE_Y411) 	sprintf_s(tmpStr, sizeof(tmpStr), "Y411");
	else if(type == MEDIASUBTYPE_Y41P) 	sprintf_s(tmpStr, sizeof(tmpStr), "Y41P");
	else if(type == MEDIASUBTYPE_Y211)  sprintf_s(tmpStr, sizeof(tmpStr), "Y211");
	else if(type == MEDIASUBTYPE_AYUV) 	sprintf_s(tmpStr, sizeof(tmpStr), "AYUV");
	else sprintf_s(tmpStr, sizeof(tmpStr), "OTHER");

	memcpy(typeAsString, tmpStr, sizeof(tmpStr));
}

//GetSrcFilterFromID
IBaseFilter* OvrvisionDirectShow::GetSrcFilterFromID(ICreateDevEnum* pDev,
													 usb_id vid, usb_id pid, int skip)
{
	HRESULT hr;
	IBaseFilter* filter = NULL;
	IEnumMoniker *pClassEnum = NULL;

	//USB Camera Cupture Filter
	hr = pDev->CreateClassEnumerator(CLSID_VideoInputDeviceCategory, &pClassEnum, 0);

	if(SUCCEEDED(hr) && pClassEnum != NULL)
	{
		ULONG cFetched;
		IMoniker *pMoniker;

		//Class enumerator
		while (pClassEnum->Next(1, &pMoniker, &cFetched) == S_OK)
		{
			if (filter == NULL)
			{
				// Bind the first moniker to an object
				IPropertyBag *pPropBag;
				if (SUCCEEDED(pMoniker->BindToStorage(
					0, 0, IID_IPropertyBag, (void **)&pPropBag)))
				{
					bool ok_usbid = false;
					VARIANT varName;
					VariantInit(&varName);

					//ID
					if (SUCCEEDED(pPropBag->Read(L"DevicePath", &varName, 0)))
					{
						int count = 0;
						memset(&m_nDeviceName, 0x00, sizeof(m_nDeviceName));
						while (varName.bstrVal[count] != 0x00 && count < OV_DEVICENAMENUM) {
							m_nDeviceName[count] = (char)varName.bstrVal[count];
							count++;
						}

						//id cmp
						if (UsbidCmp(m_nDeviceName, vid, pid) == RESULT_OK) {
							if (skip <= 0) {
								pMoniker->BindToObject(NULL, NULL, IID_IBaseFilter, (void**)&filter);
							}
							skip--;
						}
					}

					VariantClear(&varName);
					pPropBag->Release();
				}
			}
			pMoniker->Release();
		}
		pClassEnum->Release();
	}

	return filter;
}

//GetStringToUSBID
int OvrvisionDirectShow::UsbidCmp(char* deviceString, usb_id vid, usb_id pid)
{
#define MAX_CATEGORYNUM	(10)

	//local var
	char* tp[MAX_CATEGORYNUM];
	char deviceTemp[OV_DEVICENAMENUM];
	int tp_i = 0;
	char* nexttp = NULL;

	//Template copy
	memcpy(&deviceTemp,deviceString,sizeof(char)*OV_DEVICENAMENUM);

	//Main category
	tp[tp_i] = strtok_s(deviceTemp, "#", &nexttp);
	while(tp[tp_i] != NULL)
		tp[++tp_i] = strtok_s(NULL,"#", &nexttp);

	for(int i = 0; tp[i]!=NULL; i++) {
		int clear = 2;	//two
		char* tp2[MAX_CATEGORYNUM];
		int tp_i2 = 0;

		//Sub category
		tp2[tp_i2] = strtok_s(tp[i], "&", &nexttp);
		while(tp2[tp_i2] != NULL)
			tp2[++tp_i2] = strtok_s(NULL,"&", &nexttp);

		for(int j = 0; tp2[j]!=NULL; j++) {
			char* p = tp2[j];
			if(strlen(tp2[j]) <= 4)
				continue;

			//vid_
			if(p[0]=='v' && p[1]=='i' && p[2]=='d' && p[3]=='_') {
				if(strtol(&p[4], NULL, 16) == vid) clear--;
			}
			//pid_
			if(p[0]=='p' && p[1]=='i' && p[2]=='d' && p[3]=='_') {
				if(strtol(&p[4], NULL, 16) == pid) clear--;
			}

			//ok
			if(clear==0)
				return RESULT_OK;
		}
	}

	//failed
	return RESULT_FAILED;
}

// Create device
int OvrvisionDirectShow::CreateDevice(usb_id vid, usb_id pid,
									  int cam_w, int cam_h, int rate, int skip)
{
	//Local var
	HRESULT hr;
	ICreateDevEnum *pDevEnum = NULL;
	IMediaFilter *pMediaFilter = 0;
	
	if(m_devstatus != OV_DEVNONE) {
		//Has already been created
		return RESULT_FAILED;
	}
	m_devstatus = OV_DEVCREATTING;

	// Create the System Device Enumerator.
	hr = CoCreateInstance(CLSID_SystemDeviceEnum, NULL, CLSCTX_INPROC_SERVER,
		IID_ICreateDevEnum, (void **)&pDevEnum);

	if(FAILED(hr)) {
		m_devstatus = OV_DEVNONE;
		return RESULT_FAILED;		//ERROR
	}

	//-------- Create graphs --------

	//Get SrcFilter
	m_pSrcFilter = GetSrcFilterFromID(pDevEnum,vid,pid,skip);
	pDevEnum->Release();

	if(m_pSrcFilter == NULL) {
		DeleteDevice();	//Delete
		return RESULT_FAILED;
	}

	//Get DestFilter
	hr = CoCreateInstance(CLSID_NullRenderer, NULL, CLSCTX_INPROC_SERVER,
		IID_IBaseFilter, (void**)&m_pDestFilter);
	if(FAILED(hr)) {
		DeleteDevice();	//Delete
		return RESULT_FAILED;
	}

	//Create the Sample Grabber.
	hr = CoCreateInstance(CLSID_SampleGrabber, NULL, CLSCTX_INPROC_SERVER,
		IID_IBaseFilter, (void**)&m_pGrabberFilter);
	if (SUCCEEDED(hr)) {
		//One Shot should be false unless you want to capture just one buffer
		m_pGrabberFilter->QueryInterface(IID_ISampleGrabber, (void**)&m_pSGrabber);
		m_pSGrabber->SetOneShot(TRUE);			//OVRVISION only
		m_pSGrabber->SetBufferSamples(FALSE);

		//Create callback class
		m_pSGCallback = new OVSampleGrabberCB();

		//Set callback class
		if(FAILED(m_pSGrabber->SetCallback(m_pSGCallback, 0))) {
			DeleteDevice();	//Delete
			return RESULT_FAILED;
		}
	}

	//-------- Filter graph manager --------

	//Create graph
	hr = CoCreateInstance(CLSID_FilterGraph, NULL, CLSCTX_INPROC_SERVER,
		IID_IGraphBuilder, (void **)&m_pGraph);
	if (SUCCEEDED(hr)) {
		//Media Control
		hr = m_pGraph->QueryInterface(IID_IMediaControl, (void **)&m_pMediaControl);

		//Not synchronized with the clock.
		m_pGraph->QueryInterface(IID_IMediaFilter, (void**)&pMediaFilter);
		pMediaFilter->SetSyncSource(NULL);
		pMediaFilter->Release();
	}

	//Add to graphs
	if(SUCCEEDED(hr) && m_pGraph != NULL)
	{		
		//Add Filter : Camera
		hr = m_pGraph->AddFilter(m_pSrcFilter, L"Ovrvision"); 
		if (FAILED(hr)){
			DeleteDevice();	//Delete
			return RESULT_FAILED;
		}

		//Add Filter : NullRenderer
		m_pGraph->AddFilter(m_pDestFilter, L"NullRenderer");	
		//Add Filter : SampleGrabber
		m_pGraph->AddFilter(m_pGrabberFilter, L"SampleGrabber");
	
		//Connection pin
		/* Form connecting the line.
		 *	[OVRVISION_CAM]->[SampleGrabber]->[NullRenderer]
		 */
		IPin* pOutPin = OV_GetPin(m_pSrcFilter,PINDIR_OUTPUT);
		IPin* pInPin = OV_GetPin(m_pGrabberFilter,PINDIR_INPUT);
		hr = m_pGraph->Connect(pOutPin, pInPin);
		if (FAILED(hr)){
			DeleteDevice();
			return RESULT_FAILED;
		}
		pOutPin = OV_GetPin(m_pGrabberFilter,PINDIR_OUTPUT);
		pInPin = OV_GetPin(m_pDestFilter,PINDIR_INPUT);
		hr = m_pGraph->Connect(pOutPin, pInPin);
		if (FAILED(hr)){
			DeleteDevice();
			return RESULT_FAILED;
		}

		//The acquired in advance the camera control pointer.
		if(FAILED(m_pSrcFilter->QueryInterface(		//VideoProcAmp
			IID_IAMVideoProcAmp, (void**)&m_pAMVideoProcAmp))) {
			DeleteDevice();	//Delete
			return RESULT_FAILED;
		}
		if(FAILED(m_pSrcFilter->QueryInterface(		//CameraControl
			IID_IAMCameraControl, (void**)&m_pIAMCameraControl))) {
			DeleteDevice();	//Delete
			return RESULT_FAILED;
		}
	}

	int iFormatSel = -1;

	//Media setting
	if(SUCCEEDED(hr) && m_pMediaControl != NULL)
	{
		IEnumPins *ppEnum = NULL;
		IPin *pCameraOutPin = NULL;
		IAMStreamConfig *pAMSConfig = NULL;
		VIDEO_STREAM_CONFIG_CAPS scc;
		
		m_pSrcFilter->EnumPins(&ppEnum);
		if(SUCCEEDED(ppEnum->Next(1, &pCameraOutPin, NULL)))
		{
			//Media config
			
			int iCount = 0, iSize = 0;
			pCameraOutPin->QueryInterface(IID_IAMStreamConfig, (void**)&pAMSConfig);

			pAMSConfig->GetNumberOfCapabilities(&iCount, &iSize);
			for(int iFormat = 0; iFormat < iCount; iFormat++)
			{
				AM_MEDIA_TYPE *pmt;
				char mediatype[16] = {0};
				hr = pAMSConfig->GetStreamCaps(iFormat,
						&pmt,reinterpret_cast<BYTE*>(&scc));
				//Get media infomation
				GetMediaSubtypeAsString(pmt->subtype,mediatype);
				VIDEOINFOHEADER *pVih = reinterpret_cast<VIDEOINFOHEADER*>(pmt->pbFormat);
				REFERENCE_TIME framerate = 10000000 / pVih->AvgTimePerFrame;
				//Set infomation
				if(pVih->bmiHeader.biWidth == cam_w && pVih->bmiHeader.biHeight == cam_h
					 && pmt->subtype == MEDIASUBTYPE_YUY2 && framerate == rate){
					hr = pAMSConfig->SetFormat(pmt);
					m_width = pVih->bmiHeader.biWidth;
					m_height = pVih->bmiHeader.biHeight;
					m_rate = (int)framerate;

					iFormatSel = iFormat;	//selected
				}

				//mediatype free
				CoTaskMemFree((PVOID)pmt->pbFormat);
				if(pmt->pUnk)  pmt->pUnk->Release();
				CoTaskMemFree(pmt);
			}
			pAMSConfig->Release();
			pCameraOutPin->Release();
		}
		ppEnum->Release();
	}

	if (iFormatSel == -1) {
		m_devstatus = OV_DEVNONE;
		return RESULT_FAILED;		//ERROR
	}

	//Data area allocation
	m_latestPixelDataSize = m_maxPixelDataSize = m_width*m_height*OV_RGB_COLOR;
	
	//Device running
	m_devstatus = OV_DEVSTOP;
	return RESULT_OK;
}

// Stop device
int OvrvisionDirectShow::DeleteDevice()
{
	if(m_devstatus == OV_DEVNONE) {
		// Can't delete
		return RESULT_FAILED;
	}

	//When camera running, to stop
	StopTransfer();

	//Delete
	SAFE_DELETE(m_pSGCallback);

	//Windows DirectShow Release
	SAFE_RELEASE(&m_pGraph);
	SAFE_RELEASE(&m_pSrcFilter);
	SAFE_RELEASE(&m_pDestFilter);
	SAFE_RELEASE(&m_pGrabberFilter);
	SAFE_RELEASE(&m_pSGrabber);
	SAFE_RELEASE(&m_pMediaControl);

	SAFE_RELEASE(&m_pAMVideoProcAmp);
	SAFE_RELEASE(&m_pIAMCameraControl);

	m_width = 0;
	m_height = 0;
	m_rate = 0;
	m_latestPixelDataSize = 0;
	m_maxPixelDataSize = 0;
	memset(&m_nDeviceName, 0x00, sizeof(m_nDeviceName));

	//None
	m_devstatus = OV_DEVNONE;
	return RESULT_OK;
}


//TransferStatus
int OvrvisionDirectShow::StartTransfer()
{
	if(m_devstatus != OV_DEVSTOP) {
		// Can't delete
		return RESULT_FAILED;
	}

    //Media run
    while(m_pMediaControl->Run()==S_FALSE)
        Sleep(10);

	Sleep(20); //wait 20ms

	m_devstatus = OV_DEVRUNNING;
	return RESULT_OK;
}

int OvrvisionDirectShow::StopTransfer()
{
	if(m_devstatus != OV_DEVRUNNING) {
		// Can't delete
		return RESULT_FAILED;
	}

	DWORD result = WaitForSingleObject(m_pSGCallback->m_hEvent, 1000);
	if( result != WAIT_OBJECT_0)
		return RESULT_FAILED;

	//Media run
	while(m_pMediaControl->Stop()==S_FALSE)
		Sleep(10);

	m_devstatus = OV_DEVSTOP;
	return 0;
}

//Get pixel data
int OvrvisionDirectShow::GetBayer16Image(unsigned char* pImage, bool nonblocking)
{
	int signalwait = OV_BLOCKTIMEOUT;

	if(m_devstatus != OV_DEVRUNNING)
		return RESULT_FAILED;

	if(nonblocking)
		signalwait = 0;	//nonblock

	DWORD result = WaitForSingleObject(m_pSGCallback->m_hEvent, signalwait);
	if( result != WAIT_OBJECT_0)
		return RESULT_FAILED;

	result = RESULT_FAILED;
	if (pImage) {
		m_latestPixelDataSize = m_pSGCallback->m_LatestBufferLength;
		EnterCriticalSection(&m_pSGCallback->m_critSection);
			memcpy(pImage, m_pSGCallback->m_pPixels, m_pSGCallback->m_LatestBufferLength);	//Data copy
		LeaveCriticalSection(&m_pSGCallback->m_critSection);
		result = RESULT_OK;
	}

	ResetEvent(m_pSGCallback->m_hEvent);

	return result;
}

/*
EnterCriticalSection(&m_pSGCallback->m_critSection);
register int i;
for (i = 0; i < m_pSGCallback->m_LatestBufferLength - 2; i += 2) {
	pImage[i] = m_pSGCallback->m_pPixels[i];
	pImage[i + 1] = m_pSGCallback->m_pPixels[i + 3];
}
//memcpy(pImage, m_pSGCallback->m_pPixels, m_pSGCallback->m_LatestBufferLength);	//Data copy
result = RESULT_OK;
LeaveCriticalSection(&m_pSGCallback->m_critSection);
*/

//Set camera setting
int OvrvisionDirectShow::SetCameraSetting(CamSetting proc, int value, bool automode)
{
	if(m_devstatus != OV_DEVRUNNING)
		return RESULT_FAILED;

	//Use auto mode : default : manual
	tagCameraControlFlags autoflag = CameraControl_Flags_Manual;
	if(automode)
		autoflag = CameraControl_Flags_Auto;

	//set
	switch(proc) {
		case OV_CAMSET_EXPOSURE: m_pAMVideoProcAmp->Set(VideoProcAmp_Brightness, value, autoflag);
			break;
		case OV_CAMSET_GAIN: m_pAMVideoProcAmp->Set(VideoProcAmp_Gain, value, autoflag);
			break;
		case OV_CAMSET_WHITEBALANCER: m_pAMVideoProcAmp->Set(VideoProcAmp_Sharpness, value, autoflag);
			break;
		case OV_CAMSET_WHITEBALANCEG: m_pAMVideoProcAmp->Set(VideoProcAmp_Gamma, value, autoflag);
			break;
		case OV_CAMSET_WHITEBALANCEB: m_pAMVideoProcAmp->Set(VideoProcAmp_WhiteBalance, value, autoflag);
			break;
		case OV_CAMSET_BLC: m_pAMVideoProcAmp->Set(VideoProcAmp_BacklightCompensation, value, autoflag);
			break;
		case OV_CAMSET_DATA: m_pAMVideoProcAmp->Set(VideoProcAmp_Contrast, value, false);
			break;
		default:
			return RESULT_FAILED;
			break;
	};

	Sleep(5);	//5ms wait

	return RESULT_OK;
}

//Get camera setting
int OvrvisionDirectShow::GetCameraSetting(CamSetting proc, int* value, bool* automode)
{
	if(m_devstatus != OV_DEVRUNNING)
		return RESULT_FAILED;

	long autoflag;
	(*automode) = false;

	//set
	switch(proc) {
	case OV_CAMSET_EXPOSURE: m_pAMVideoProcAmp->Get(VideoProcAmp_Brightness, (long*)value, &autoflag);
			break;
		case OV_CAMSET_GAIN: m_pAMVideoProcAmp->Get(VideoProcAmp_Gain, (long*)value, &autoflag);
			break;
		case OV_CAMSET_WHITEBALANCER: m_pAMVideoProcAmp->Get(VideoProcAmp_Sharpness, (long*)value, &autoflag);
			break;
		case OV_CAMSET_WHITEBALANCEG: m_pAMVideoProcAmp->Get(VideoProcAmp_Gamma, (long*)value, &autoflag);
			break;
		case OV_CAMSET_WHITEBALANCEB: m_pAMVideoProcAmp->Get(VideoProcAmp_WhiteBalance, (long*)value, &autoflag);
			break;
		case OV_CAMSET_BLC: m_pAMVideoProcAmp->Get(VideoProcAmp_BacklightCompensation, (long*)value, &autoflag);
			break;
		case OV_CAMSET_DATA: m_pAMVideoProcAmp->Get(VideoProcAmp_Contrast, (long*)value, &autoflag);
			break;
		default:
			return RESULT_FAILED;
			break;
	};

	//Auto
	if(autoflag == CameraControl_Flags_Auto)
		(*automode) = true;

	Sleep(5);	//5ms wait

	return RESULT_OK;
}

//Property

//Get status
DevStatus OvrvisionDirectShow::GetDeviceStatus()
{
	return m_devstatus;
}

//Get lastest pixel data size
int OvrvisionDirectShow::GetLatestPixelDataSize()
{
	return m_latestPixelDataSize;
}

//Get pixel data max size
int OvrvisionDirectShow::GetMaxPixelDataSize()
{
	return m_maxPixelDataSize;
}

//Callback
void OvrvisionDirectShow::SetCallback(void(*func)())
{
	m_pSGCallback->m_get_callback = func;
}

};

#endif /*WIN32*/
