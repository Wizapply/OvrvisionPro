#pragma strict
//part of Car Paint Shader PRO

var cubemapSize = 128;
var cubemapFarClip = 50;
var oneFacePerFrame = false;
var cameraOffset : Vector3;
var alsoOnChilds : boolean = false;
private var cam : Camera;
private var rtex : RenderTexture;

function Start () {
	if (!SystemInfo.supportsRenderTextures) Debug.LogError("Real Time Reflections only works with Unity PRO!");
	if (!enabled) return;
    UpdateCubemap( 63 );
}

function LateUpdate () {
    if (oneFacePerFrame) {
        var faceToRender = Time.frameCount % 6;
        var faceMask = 1 << faceToRender;
        UpdateCubemap (faceMask);
    } else {
        UpdateCubemap (63);
    }
}

function UpdateCubemap (faceMask : int) {

	if( transform.gameObject.layer == 0 ) {
			Debug.LogWarning("Target object should use a separate layer!");
	}

    if (!cam) {
        var go = new GameObject ("CubemapCamera", Camera);
        go.hideFlags = HideFlags.HideAndDontSave;
        go.transform.position = transform.position + cameraOffset;
        go.transform.rotation = Quaternion.identity;
        
        cam = go.GetComponent.<Camera>();
        cam.cullingMask = ~((1<<transform.gameObject.layer));
        cam.farClipPlane = cubemapFarClip; 
        cam.clearFlags = Camera.main.clearFlags;
        cam.backgroundColor = Camera.main.backgroundColor;
        cam.enabled = false;
    }
    
    if (!rtex) {    
        rtex = new RenderTexture (cubemapSize, cubemapSize, 16);
        
        rtex.isPowerOfTwo = true;
        rtex.isCubemap = true;
        rtex.hideFlags = HideFlags.HideAndDontSave;
        rtex.useMipMap = true;
        
        if (alsoOnChilds) {
        	for (mat in GetComponent.<Renderer>().materials) mat.SetTexture ("_Cube", rtex);
        
        	for (var trans : Transform in transform) {
        		if (!trans.GetComponent.<Renderer>()) continue;
        		for (mat in trans.GetComponent.<Renderer>().materials) mat.SetTexture ("_Cube", rtex);
        	}
        
        
        } else {
        
        	for (mat in GetComponent.<Renderer>().materials) mat.SetTexture ("_Cube", rtex);
        
        }
        
    }
    
    cam.transform.position = transform.position + cameraOffset;
    cam.RenderToCubemap (rtex, faceMask);
}

function OnDisable () {
    DestroyImmediate (cam);
    DestroyImmediate (rtex);
}