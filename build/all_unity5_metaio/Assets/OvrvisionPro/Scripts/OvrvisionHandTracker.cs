using UnityEngine;
using System.Collections;

public class OvrvisionHandTracker : MonoBehaviour {

	private GameObject OvrvisionProCameraObj = null;
	private Vector3 offsetPos = new Vector3(-0.032f, 0.0f, 0.0f);

	// Use this for initialization
	void Start () {
		if (GameObject.Find("OvrvisionProCamera"))
			OvrvisionProCameraObj = GameObject.Find("OvrvisionProCamera");

		if (GameObject.Find("LeftCamera"))
			this.transform.parent = GameObject.Find("LeftCamera").transform;

		this.transform.localScale = new Vector3(1.0f, 1.0f, 1.0f);
	}

	// UpdateTracker
	public void UpdateTransform (Vector3 trakingGet) {
		this.transform.localPosition = trakingGet + offsetPos;
	}

	public void UpdateTransformNone()
	{
		this.transform.localPosition = new Vector3(-10000.0f, -10000.0f, -10000.0f);
	}
}
