using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;
using System.Threading;
using UnityEngine.VR;

/// <summary>
/// This class provides main interface to the Ovrvision
/// </summary>
public class Ovrvision : MonoBehaviour
{
	//Ovrvision Pro class
	private COvrvisionUnity OvrPro = new COvrvisionUnity();

	//Camera GameObject
	private GameObject CameraLeft;
	private GameObject CameraRight;
	private GameObject CameraPlaneLeft;
	private GameObject CameraPlaneRight;
	//Camera texture
	private Texture2D CameraTexLeft;
	private Texture2D CameraTexRight;
	private Vector3 CameraRightGap;

	//public propaty
	public bool useOvrvisionAR = false;
	public float ARsize = 0.15f;

	public bool overlaySettings = false;
	public int conf_exposure = 12960;
	public int conf_gain = 8;
	public int conf_blc = 32;
	public int conf_wb_r = 1474;
	public int conf_wb_g = 1024;
	public int conf_wb_b = 1738;
	public bool conf_wb_auto = true;

	public int camViewShader = 0;

	//Ar Macro define
	private const int MARKERGET_MAXNUM10 = 100; //max marker is 10
	private const int MARKERGET_ARG10 = 10;
	private const int MARKERGET_RECONFIGURE_NUM = 10;

	// ------ Function ------

	// Use this for initialization
	void Awake() {
		//Open camera
		if (OvrPro.Open(COvrvisionUnity.OV_CAMVR_FULL, ARsize))
		{
			if (overlaySettings) {
				OvrPro.SetExposure(conf_exposure);
				OvrPro.SetGain(conf_gain);
				OvrPro.SetBLC(conf_blc);
				OvrPro.SetWhiteBalanceR(conf_wb_r);
				OvrPro.SetWhiteBalanceG(conf_wb_g);
				OvrPro.SetWhiteBalanceB(conf_wb_b);
				OvrPro.SetWhiteBalanceAutoMode(conf_wb_auto);
			}
		} else {
			Debug.LogError ("Ovrvision open error!!");
		}
	}

	// Use this for initialization
	void Start()
	{
		if (!OvrPro.camStatus)
			return;

		// Initialize camera plane object(Left)
		CameraLeft = this.transform.FindChild("LeftCamera").gameObject;
		CameraRight = this.transform.FindChild("RightCamera").gameObject;
		CameraPlaneLeft = CameraLeft.transform.FindChild("LeftImagePlane").gameObject;
		CameraPlaneRight = CameraRight.transform.FindChild("RightImagePlane").gameObject;

		CameraLeft.transform.localPosition = Vector3.zero;
		CameraRight.transform.localPosition = Vector3.zero;
		CameraLeft.transform.localRotation = Quaternion.identity;
		CameraRight.transform.localRotation = Quaternion.identity;

		//Create cam texture
		CameraTexLeft = new Texture2D(OvrPro.imageSizeW, OvrPro.imageSizeH, TextureFormat.BGRA32, false);
		CameraTexRight = new Texture2D(OvrPro.imageSizeW, OvrPro.imageSizeH, TextureFormat.BGRA32, false);
		//Cam setting
		CameraTexLeft.wrapMode = TextureWrapMode.Clamp;
		CameraTexRight.wrapMode = TextureWrapMode.Clamp;

		//SetShader
		CameraPlaneLeft.GetComponent<Renderer>().material.shader = Shader.Find("Ovrvision/ovTexture");
		CameraPlaneRight.GetComponent<Renderer>().material.shader = Shader.Find("Ovrvision/ovTexture");

		CameraPlaneLeft.GetComponent<Renderer>().material.SetTexture("_MainTex", CameraTexLeft);
		CameraPlaneRight.GetComponent<Renderer>().material.SetTexture("_MainTex", CameraTexRight);

		CameraRightGap = OvrPro.HMDCameraRightGap();

		CameraPlaneLeft.transform.localPosition = new Vector3(0.0f, 0.0f, OvrPro.GetFloatPoint());
		CameraPlaneRight.transform.localPosition = new Vector3(CameraRightGap.x, CameraRightGap.y, OvrPro.GetFloatPoint());
	}

	// Update is called once per frame
	void Update ()
	{
		//camStatus
		if (!OvrPro.camStatus)
			return;

		//get image data
		OvrPro.useOvrvisionAR = useOvrvisionAR;
		OvrPro.UpdateImage(CameraTexLeft.GetNativeTexturePtr(), CameraTexRight.GetNativeTexturePtr());

		if (useOvrvisionAR) OvrvisionARRender();
	}

	//Ovrvision AR Render to OversitionTracker Objects.
	int OvrvisionARRender()
	{
		OvrPro.OvrvisionARRender();

		float[] markerGet = new float[MARKERGET_MAXNUM10];
		GCHandle marker = GCHandle.Alloc(markerGet, GCHandleType.Pinned);

		//Get marker data
		int ri = OvrPro.OvrvisionGetAR(marker.AddrOfPinnedObject(), MARKERGET_MAXNUM10);

		OvrvisionTracker[] otobjs = GameObject.FindObjectsOfType(typeof(OvrvisionTracker)) as OvrvisionTracker[];
		foreach (OvrvisionTracker otobj in otobjs)
		{
			otobj.UpdateTransformNone();
			for (int i = 0; i < ri; i++)
			{
				if (otobj.markerID == (int)markerGet[i * MARKERGET_ARG10])
				{
					otobj.UpdateTransform(markerGet, i);
					break;
				}
			}
		}

		marker.Free();

		return ri;
	}

	// Quit
	void OnDestroy()
	{
		//Close camera
		if(!OvrPro.Close())
			Debug.LogError ("Ovrvision close error!!");
	}

	//proparty
	public bool CameraStatus()
	{
		return OvrPro.camStatus;
	}

	public void UpdateOvrvisionSetting()
	{
		if (!OvrPro.camStatus)
			return;

		//set config
		OvrPro.SetExposure(conf_exposure);
		OvrPro.SetGain(conf_gain);
		OvrPro.SetBLC(conf_blc);
		OvrPro.SetWhiteBalanceR(conf_wb_r);
		OvrPro.SetWhiteBalanceG(conf_wb_g);
		OvrPro.SetWhiteBalanceB(conf_wb_b);
		OvrPro.SetWhiteBalanceAutoMode(conf_wb_auto);

		if (camViewShader == 0)
		{

		}
	}
}
