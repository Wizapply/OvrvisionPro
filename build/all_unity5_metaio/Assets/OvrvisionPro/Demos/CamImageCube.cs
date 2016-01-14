using UnityEngine;
using System.Collections;

public class CamImageCube : MonoBehaviour {

	private Ovrvision ovrObj = null;

	// Use this for initialization
	void Start () {
		ovrObj = GameObject.Find("OvrvisionProCamera").GetComponent<Ovrvision>();
		this.GetComponent<Renderer>().material.mainTexture = ovrObj.GetCameraTextureLeft();
	}
	
	// Update is called once per frame
	void Update () {
		this.GetComponent<Renderer>().material.mainTexture = ovrObj.GetCameraTextureLeft();
	}
}
