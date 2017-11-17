//CMetaio.h
//Copyright(C)2014 wizapply.com

#define __C_METAIO__
#ifdef __C_METAIO__

/////////// includes ///////////

#include <MetaioSDK/IMetaioSDKWin32.h>

//byte
typedef unsigned char byte;

/////////// class ///////////

class CMetaio : public metaio::IMetaioSDKCallback
{
private:
	//AR
	metaio::IMetaioSDKWin32*	m_pMetaioSDK;
	metaio::ISensorsComponent*	m_pSensors;
	bool						m_sdkReady;


	double						m_stamp;

public:
	//コンストラクタ
	CMetaio(int w, int h, float fp);
	//デストラクタ
	~CMetaio();

	//メソッド

	//処理する
	int StartTracking(const metaio::stlcompat::String& trackingMode);
	void NotInstantTracking();
	int UpdateAR(volatile byte* mem, int w, int h);

	//オーバーライド
	virtual void onTrackingEvent(const metaio::stlcompat::Vector<metaio::TrackingValues>& values) override;
	virtual void CMetaio::onInstantTrackingEvent(bool success, const metaio::stlcompat::String& file) override;
	virtual void onNewCameraFrame(metaio::ImageStruct* cameraFrame) override;
};

typedef CMetaio *LPCMetaio;

#endif /*__C_METAIO__*/
