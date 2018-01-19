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
	private Texture2D CameraTexLeft = null;
	private Texture2D CameraTexRight = null;
	private Vector3 CameraRightGap;

	private System.IntPtr CameraTexLeftPtr = System.IntPtr.Zero;
	private System.IntPtr CameraTexRightPtr = System.IntPtr.Zero;

	//public propaty
	public int cameraMode = COvrvisionUnity.OV_CAMVR_FULL;
	public bool useOvrvisionAR = false;
	public float ARsize = 0.15f;
	public bool useOvrvisionTrack = false;

	public bool overlaySettings = false;
	public int conf_exposure = 12960;
	public int conf_gain = 8;
	public int conf_blc = 32;
	public int conf_wb_r = 1474;
	public int conf_wb_g = 1024;
	public int conf_wb_b = 1738;
	public bool conf_wb_auto = true;

	public int camViewShader = 0;

	public Vector2 chroma_hue = new Vector2(0.9f,0.2f);
	public Vector2 chroma_saturation = new Vector2(1.0f, 0.0f);
	public Vector2 chroma_brightness = new Vector2(1.0f, 0.0f);
	public Vector2 chroma_y = new Vector2(1.0f, 0.0f);
	public Vector2 chroma_cb = new Vector2(1.0f, 0.0f);
	public Vector2 chroma_cr = new Vector2(0.725f, 0.615f);

	//Ar Macro define
	private const int MARKERGET_MAXNUM10 = 100; //max marker is 10
	private const int MARKERGET_ARG10 = 10;
	private const int MARKERGET_RECONFIGURE_NUM = 10;

	// ------ Function ------

	// Use this for initialization
	void Awake() {
		//Open camera
		if (OvrPro.Open(cameraMode, ARsize))
		{
			if (overlaySettings)
			{
				OvrPro.SetExposure(conf_exposure);
				OvrPro.SetGain(conf_gain);
				OvrPro.SetBLC(conf_blc);
				OvrPro.SetWhiteBalanceAutoMode(conf_wb_auto);
				if (!conf_wb_auto)
				{
					OvrPro.SetWhiteBalanceR(conf_wb_r);
					OvrPro.SetWhiteBalanceG(conf_wb_g);
					OvrPro.SetWhiteBalanceB(conf_wb_b);
				}
				Thread.Sleep(100);
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
		CameraLeft = this.transform.Find("LeftCamera").gameObject;
		CameraRight = this.transform.Find("RightCamera").gameObject;
		CameraPlaneLeft = CameraLeft.transform.Find("LeftImagePlane").gameObject;
		CameraPlaneRight = CameraRight.transform.Find("RightImagePlane").gameObject;

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

		CameraTexLeft.Apply();
		CameraTexRight.Apply();

		CameraTexLeftPtr = CameraTexLeft.GetNativeTexturePtr();
		CameraTexRightPtr = CameraTexRight.GetNativeTexturePtr();

		//Mesh
		Mesh m = CreateCameraPlaneMesh();
		CameraPlaneLeft.GetComponent<MeshFilter>().mesh = m;
		CameraPlaneRight.GetComponent<MeshFilter>().mesh = m;

		//SetShader
		SetShader(camViewShader);

		CameraPlaneLeft.GetComponent<Renderer>().materials[0].SetTexture("_MainTex", CameraTexLeft);
		CameraPlaneRight.GetComponent<Renderer>().materials[0].SetTexture("_MainTex", CameraTexRight);
		CameraPlaneLeft.GetComponent<Renderer>().materials[1].SetTexture("_MainTex", CameraTexLeft);
		CameraPlaneRight.GetComponent<Renderer>().materials[1].SetTexture("_MainTex", CameraTexRight);

		CameraRightGap = OvrPro.HMDCameraRightGap();

		//Plane reset
		CameraPlaneLeft.transform.localScale = new Vector3(OvrPro.aspectW, -OvrPro.aspectH, 1.0f);
		CameraPlaneRight.transform.localScale = new Vector3(OvrPro.aspectW, -OvrPro.aspectH, 1.0f);
		CameraPlaneLeft.transform.localPosition = new Vector3(-0.032f, 0.0f, OvrPro.GetFloatPoint());
		float gapx = (CameraRightGap.x - 0.032f) * (282.6231f) / (OvrPro.GetFloatPoint());
		float gapy = CameraRightGap.y * (282.6231f) / (OvrPro.GetFloatPoint());
		CameraPlaneRight.transform.localPosition = new Vector3(gapx * 0.001f, gapy * 0.001f, OvrPro.GetFloatPoint());

		UnityEngine.XR.InputTracking.Recenter();

		if (useOvrvisionTrack)
		{
			OvrPro.useOvrvisionTrack_Calib = true;
			CameraPlaneRight.active = !OvrPro.useOvrvisionTrack_Calib;
		}

		//yield return StartCoroutine("CallPluginAtEndOfFrames");
	}

	private Mesh CreateCameraPlaneMesh()
	{
		Mesh m = new Mesh();
		m.name = "CameraImagePlane";
		Vector3[] vertices = new Vector3[]
		{
			new Vector3(-0.5f, -0.5f, 0.0f),
			new Vector3( 0.5f,  0.5f, 0.0f),
			new Vector3( 0.5f, -0.5f, 0.0f),
			new Vector3(-0.5f,  0.5f, 0.0f)
		};
		int[] triangles = new int[]
		{
			0, 1, 2,
			1, 0, 3
		};
		Vector2[] uv = new Vector2[]
		{
			new Vector2(0.0f, 0.0f),
			new Vector2(1.0f, 1.0f),
			new Vector2(1.0f, 0.0f),
			new Vector2(0.0f, 1.0f)
		};
		m.vertices = vertices;
		m.subMeshCount = 2;
		m.SetTriangles(triangles, 0);
		m.SetTriangles(triangles, 1);
		m.uv = uv;
		m.RecalculateNormals();

		return m;
	}

	void Update()
	{
		//camStatus
		if (!OvrPro.camStatus)
			return;

		//Testing
		if (Input.GetKeyDown(KeyCode.Space))
		{
			OvrPro.OvrvisionTrackReset();
		}

		if (Input.GetKeyDown(KeyCode.G))
		{
			useOvrvisionTrack ^= true;
			if (useOvrvisionTrack)
			{
				OvrPro.useOvrvisionTrack_Calib = true;
				CameraPlaneRight.active = !OvrPro.useOvrvisionTrack_Calib;
			}
		}
		if (useOvrvisionTrack)
		{
			if (Input.GetKeyDown(KeyCode.H))
			{
				OvrPro.useOvrvisionTrack_Calib ^= true;
				CameraPlaneRight.active = !OvrPro.useOvrvisionTrack_Calib;
			}
		}

		//get image data
		OvrPro.useOvrvisionAR = useOvrvisionAR;
		OvrPro.useOvrvisionTrack = useOvrvisionTrack;

		OvrPro.UpdateImage(CameraTexLeftPtr, CameraTexRightPtr);

		if (useOvrvisionAR) OvrvisionARRender();
		else
		{
			OvrvisionTracker[] otobjs = GameObject.FindObjectsOfType(typeof(OvrvisionTracker)) as OvrvisionTracker[];
			foreach (OvrvisionTracker otobj in otobjs)
				otobj.UpdateTransformNone();
		}
		if (useOvrvisionTrack) OvrvisionTrackRender();
	}

	//Ovrvision AR Render to OversitionTracker Objects.
	private int OvrvisionARRender()
	{
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

	//Ovrvision Tracking Render
	private int OvrvisionTrackRender()
	{
		float[] markerGet = new float[3];
		GCHandle marker = GCHandle.Alloc(markerGet, GCHandleType.Pinned);
		//Get marker data
		int ri = OvrPro.OvrvisionGetTrackingVec3(marker.AddrOfPinnedObject());
		if (ri == 0)
			return 0;

		Vector3 fgpos = new Vector3(markerGet[0], markerGet[1], markerGet[2]);

		OvrvisionHandTracker[] otobjs = GameObject.FindObjectsOfType(typeof(OvrvisionHandTracker)) as OvrvisionHandTracker[];
		foreach (OvrvisionHandTracker otobj in otobjs)
		{
			otobj.UpdateTransformNone();

			if (fgpos.z <= 0.0f)
				continue;

			otobj.UpdateTransform(fgpos);
		}

		marker.Free();

		return ri;
	}

	// Quit
	void OnDestroy()
	{
		if (!OvrPro.camStatus)
			return;

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
		if (overlaySettings)
		{
			OvrPro.SetExposure(conf_exposure);
			OvrPro.SetGain(conf_gain);
			OvrPro.SetBLC(conf_blc);
			OvrPro.SetWhiteBalanceR(conf_wb_r);
			OvrPro.SetWhiteBalanceG(conf_wb_g);
			OvrPro.SetWhiteBalanceB(conf_wb_b);
			OvrPro.SetWhiteBalanceAutoMode(conf_wb_auto);
		}

		//SetShader
		SetShader(camViewShader);
	}

	private void SetShader(int viewShader)
	{
		if (viewShader == 0)
		{
			CameraLeft.GetComponent<Camera>().enabled = true;
			CameraRight.GetComponent<Camera>().enabled = true;

			//Normal Shader
			CameraPlaneLeft.GetComponent<Renderer>().material.shader = Shader.Find("Ovrvision/ovTexture");
			CameraPlaneRight.GetComponent<Renderer>().material.shader = Shader.Find("Ovrvision/ovTexture");
		}
		else if (viewShader == 1)
		{
			CameraLeft.GetComponent<Camera>().enabled = true;
			CameraRight.GetComponent<Camera>().enabled = true;

			//Chroma-key Shader
			CameraPlaneLeft.GetComponent<Renderer>().material.shader = Shader.Find("Ovrvision/ovChromaticMask");
			CameraPlaneRight.GetComponent<Renderer>().material.shader = Shader.Find("Ovrvision/ovChromaticMask");

			CameraPlaneLeft.GetComponent<Renderer>().material.SetFloat("_Color_maxh", chroma_hue.x);
			CameraPlaneLeft.GetComponent<Renderer>().material.SetFloat("_Color_minh", chroma_hue.y);
			CameraPlaneLeft.GetComponent<Renderer>().material.SetFloat("_Color_maxs", chroma_saturation.x);
			CameraPlaneLeft.GetComponent<Renderer>().material.SetFloat("_Color_mins", chroma_saturation.y);
			CameraPlaneLeft.GetComponent<Renderer>().material.SetFloat("_Color_maxv", chroma_brightness.x);
			CameraPlaneLeft.GetComponent<Renderer>().material.SetFloat("_Color_minv", chroma_brightness.y);

			CameraPlaneRight.GetComponent<Renderer>().material.SetFloat("_Color_maxh", chroma_hue.x);
			CameraPlaneRight.GetComponent<Renderer>().material.SetFloat("_Color_minh", chroma_hue.y);
			CameraPlaneRight.GetComponent<Renderer>().material.SetFloat("_Color_maxs", chroma_saturation.x);
			CameraPlaneRight.GetComponent<Renderer>().material.SetFloat("_Color_mins", chroma_saturation.y);
			CameraPlaneRight.GetComponent<Renderer>().material.SetFloat("_Color_maxv", chroma_brightness.x);
			CameraPlaneRight.GetComponent<Renderer>().material.SetFloat("_Color_minv", chroma_brightness.y);
		}
		else if (viewShader == 2)
		{
			CameraLeft.GetComponent<Camera>().enabled = true;
			CameraRight.GetComponent<Camera>().enabled = true;

			//Hand Mask Shader
			CameraPlaneLeft.GetComponent<Renderer>().material.shader = Shader.Find("Ovrvision/ovHandMaskRev");
			CameraPlaneRight.GetComponent<Renderer>().material.shader = Shader.Find("Ovrvision/ovHandMaskRev");

			CameraPlaneLeft.GetComponent<Renderer>().material.SetFloat("_Color_maxh", chroma_hue.x);
			CameraPlaneLeft.GetComponent<Renderer>().material.SetFloat("_Color_minh", chroma_hue.y);
			CameraPlaneLeft.GetComponent<Renderer>().material.SetFloat("_Color_maxs", chroma_saturation.x);
			CameraPlaneLeft.GetComponent<Renderer>().material.SetFloat("_Color_mins", chroma_saturation.y);
			CameraPlaneLeft.GetComponent<Renderer>().material.SetFloat("_Color_maxv", chroma_brightness.x);
			CameraPlaneLeft.GetComponent<Renderer>().material.SetFloat("_Color_minv", chroma_brightness.y);

			CameraPlaneRight.GetComponent<Renderer>().material.SetFloat("_Color_maxh", chroma_hue.x);
			CameraPlaneRight.GetComponent<Renderer>().material.SetFloat("_Color_minh", chroma_hue.y);
			CameraPlaneRight.GetComponent<Renderer>().material.SetFloat("_Color_maxs", chroma_saturation.x);
			CameraPlaneRight.GetComponent<Renderer>().material.SetFloat("_Color_mins", chroma_saturation.y);
			CameraPlaneRight.GetComponent<Renderer>().material.SetFloat("_Color_maxv", chroma_brightness.x);
			CameraPlaneRight.GetComponent<Renderer>().material.SetFloat("_Color_minv", chroma_brightness.y);

			CameraPlaneLeft.GetComponent<Renderer>().material.SetFloat("_Color_maxY", chroma_y.x);
			CameraPlaneLeft.GetComponent<Renderer>().material.SetFloat("_Color_minY", chroma_y.y);
			CameraPlaneLeft.GetComponent<Renderer>().material.SetFloat("_Color_maxCB", chroma_cb.x);
			CameraPlaneLeft.GetComponent<Renderer>().material.SetFloat("_Color_minCB", chroma_cb.y);
			CameraPlaneLeft.GetComponent<Renderer>().material.SetFloat("_Color_maxCR", chroma_cr.x);
			CameraPlaneLeft.GetComponent<Renderer>().material.SetFloat("_Color_minCR", chroma_cr.y);

			CameraPlaneRight.GetComponent<Renderer>().material.SetFloat("_Color_maxY", chroma_y.x);
			CameraPlaneRight.GetComponent<Renderer>().material.SetFloat("_Color_minY", chroma_y.y);
			CameraPlaneRight.GetComponent<Renderer>().material.SetFloat("_Color_maxCB", chroma_cb.x);
			CameraPlaneRight.GetComponent<Renderer>().material.SetFloat("_Color_minCB", chroma_cb.y);
			CameraPlaneRight.GetComponent<Renderer>().material.SetFloat("_Color_maxCR", chroma_cr.x);
			CameraPlaneRight.GetComponent<Renderer>().material.SetFloat("_Color_minCR", chroma_cr.y);
		}
		if (viewShader == 3)
		{
			//hide
			CameraLeft.GetComponent<Camera>().enabled = false;
			CameraRight.GetComponent<Camera>().enabled = false;
		}
	}

	// get property
	public Texture2D GetCameraTextureLeft()
	{
		return CameraTexLeft;
	}

	public Texture2D GetCameraTextureRight()
	{
		return CameraTexRight;
	}

}
