//CMetaio.h
//Copyright(C)2014 wizapply.com

/////////// includes ///////////

#include "CMetaio.h"

/////////// var and def ///////////


/////////// funcation ///////////

CMetaio::CMetaio(int w, int h, float fp) :IMetaioSDKCallback()
{
	// Create the SDK
	m_pMetaioSDK = metaio::CreateMetaioSDKWin32();
	m_pMetaioSDK->initializeRenderer(0, 0, metaio::ESCREEN_ROTATION_0, metaio::ERENDER_SYSTEM_NULL);

	m_pSensors = metaio::CreateSensorsComponent();
	m_pMetaioSDK->registerSensorsComponent(m_pSensors);

	// Set the callback to this class
	m_pMetaioSDK->registerCallback(this);

	m_stamp = 0.0;
	//m_founds.clear();

	metaio::Vector2di resolute(w,h);
	metaio::Vector2d focas(-fp,-fp);
	metaio::Vector2d pricibals(w/2,h/2);
	metaio::Vector4d dec(0.0,0.0,0.0,0.0);
	m_pMetaioSDK->setCameraParameters(resolute,focas,pricibals,dec);

	NotInstantTracking();

	printf("---------------------------------------------------------\n");
}

CMetaio::~CMetaio()
{
	delete m_pMetaioSDK;
	delete m_pSensors;
}

int CMetaio::StartTracking(const metaio::stlcompat::String& trackingMode)
{
	printf("Start instant tracking!\n");

	m_pMetaioSDK->startInstantTracking(trackingMode);
	m_sdkReady = true;

	return 0;
}

void CMetaio::NotInstantTracking()
{
	printf("Load xml config file!\n");

	if(!m_pMetaioSDK->setTrackingConfiguration(".\\arcl\\TrackingConfig.xml")) {
		printf("Load zip config file!\n");
		if(!m_pMetaioSDK->setTrackingConfiguration(".\\arcl\\TrackingData.zip")) {
			printf("Failed to set tracking configuration.\n");
			printf("3D instant tracking mode.\n");
			m_sdkReady = false;
		} else {
			printf("Successfully set tracking configuration!\n");
			m_sdkReady = true;
		}
	} else {
		printf("Successfully set tracking configuration!\n");
		m_sdkReady = true;
	}
}

int CMetaio::UpdateAR(volatile byte* mem, int w, int h)
{
	int result = 0;
	if(!m_sdkReady)
		return (-1);

	unsigned char* buf2 = new unsigned char[w*h*4];

	//BGRAToARGB
	for(register int ih = 0; ih < h; ih++) {
		for(register int iw = 0; iw < w; iw++) {
			register int dw = (ih*w*4)+(iw*4);
			buf2[dw+0] = mem[dw+3];
			buf2[dw+1] = mem[dw+2];
			buf2[dw+2] = mem[dw+1];
			buf2[dw+3] = mem[dw+0];
		}
	}

	metaio::ImageStruct img((unsigned char*)buf2,w,h,metaio::common::ECF_A8R8G8B8,true,m_stamp+=1.0);
	m_pMetaioSDK->setImage(img);
	m_pMetaioSDK->render();	//calc
	delete buf2;

	//tracking data
	metaio::stlcompat::Vector<metaio::TrackingValues> trackingValues = m_pMetaioSDK->getTrackingValues(false);
	for(int i=0; i < (int)trackingValues.size(); i++)
	{
		if(trackingValues[i].quality > 0.4)
		{
			int offset = (result * 8 * 4) + 3;
			float* mat = (float*)&mem[offset];	//allinment
			//pos
			mat[0] = trackingValues[i].translation.x * 0.1f;
			mat[1] = trackingValues[i].translation.y * 0.1f;
			mat[2] = trackingValues[i].translation.z * 0.1f;
			//rot
			metaio::Vector4d qout = trackingValues[i].rotation.getQuaternion();
			mat[3] = qout.x;
			mat[4] = qout.y;
			mat[5] = qout.z;
			mat[6] = qout.w;
			//quo
			mat[7] = static_cast<float>(trackingValues[i].coordinateSystemID);

			result++;
		}
	}

	mem[0] = (byte)result;

	return result != 0;
}

void CMetaio::onTrackingEvent(const metaio::stlcompat::Vector<metaio::TrackingValues>& values)
{
	for(int i=0; i < (int)values.size(); i++) {
		switch(values[i].state) {
			case metaio::ETS_INITIALIZED:
				printf("Tracking state changed: INITIALIZED: COS %s\n",values[i].cosName);
				break;
			case metaio::ETS_LOST:
				printf("Tracking state changed: LOST: COS %d\n",values[i].coordinateSystemID);
				break;
			case metaio::ETS_FOUND:
				printf("Tracking state changed: FOUND: COS %d\n",values[i].coordinateSystemID);
				break;
			default:
				break;
		}
	}
}

void CMetaio::onInstantTrackingEvent(bool success, const metaio::stlcompat::String& file)
{
	if (success){
		m_pMetaioSDK->setTrackingConfiguration(file);
	} else {
		m_sdkReady = false;
	}
}

void CMetaio::onNewCameraFrame(metaio::ImageStruct* cameraFrame)
{

}
