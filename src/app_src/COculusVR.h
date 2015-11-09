// COculusVR.h
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

#ifndef __COCULUSVR_H__
#define __COCULUSVR_H__

/////////// INCLUDE //////////

// Include the Wizapply
#include "wizapply.h"				//!<Common Header
// Include the OculusVR SDK
#include "OVR.h"
using namespace OVR;	//namespace

/////////// CLASS ///////////

class COculusVR
{
public:
	COculusVR(bool latency = false);
	~COculusVR();

	//Method

	//Pre-Renderer
	void BeginDrawRender();
	void EndDrawRender();
	//SetViewPort
	void SetViewport(int eye);

	//Draw
	void DrawScreen();
	void EndFrameTiming();

	//Propatry
	bool isReady();
	ovrHmdType GetHMDType();	//Hmd type
	float GetHMDFov(int eyeidx);
	float GetHMDAspect();


private:

	//Structures for the oculus application
    ovrHmd              Hmd;
    ovrEyeRenderDesc    EyeRenderDesc[2];
	ovrRecti			EyeRenderViewport[2];
    Sizei               EyeRenderTargetSize;

	ovrVector2f         UVScaleOffset[2][2];
	wzMesh				MeshBuffer[2];
	wzShaderProg		LensShader;

	Sizei               WindowSize;

	//Render target
	wzRenderTarget	m_screenRender;
	wzRenderBuffer	m_screenBuffer;
	//Render texture
	wzTexture		m_screenTex;

	bool m_isReady;

};

#endif /*__OCULUSVR_H__*/
