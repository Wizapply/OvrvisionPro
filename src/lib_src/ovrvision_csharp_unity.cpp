// ovrvision_csharp.cpp
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

/////////// INCLUDE ///////////

// Which graphics device APIs we possibly support?
#if WIN32
#define SUPPORT_D3D9 1
#define SUPPORT_D3D11 1 // comment this out if you don't have D3D11 header/library files
#define SUPPORT_OPENGL 1
#endif

#if MACOSX
#define SUPPORT_OPENGL 1
#endif

#if SUPPORT_D3D9
#include <d3d9.h>
#endif
#if SUPPORT_D3D11
#include <d3d11.h>
#endif
#if SUPPORT_OPENGL
#if WIN32
#include <gl/GL.h>
#else
#include <OpenGL/gl.h>
#endif
#endif

/////////// VARS AND DEFS ///////////

//Exporter
#ifdef WIN32
#define CSHARP_EXPORT __declspec(dllexport)
#elif MACOSX
#define CSHARP_EXPORT 
#endif

// Graphics device identifiers in Unity
enum GfxDeviceRenderer
{
	kGfxRendererOpenGL = 0,		// Desktop OpenGL
	kGfxRendererD3D9 = 1,		// Direct3D 9
	kGfxRendererD3D11 = 2,		// Direct3D 11
	kGfxRendererGCM = 3,		// PlayStation 3
	kGfxRendererNull = 4,		// "null" device (used in batch mode)
	kGfxRendererXenon = 6,		// Xbox 360
	kGfxRendererOpenGLES20 = 8, // OpenGL ES 2.0
	kGfxRendererOpenGLES30 = 11, // OpenGL ES 3.0
	kGfxRendererGXM = 12,		// PlayStation Vita
	kGfxRendererPS4 = 13,		// PlayStation 4
	kGfxRendererXboxOne = 14,	// Xbox One        
	kGfxRendererMetal = 16,		// iOS Metal
	kGfxRendererD3D12 = 18,		// Direct3D 12
};

// Event types for UnitySetGraphicsDevice
enum GfxDeviceEventType {
	kGfxDeviceEventInitialize = 0,
	kGfxDeviceEventShutdown,
	kGfxDeviceEventBeforeReset,
	kGfxDeviceEventAfterReset,
};

/////////// EXPORT FUNCTION ///////////

//C language
#ifdef __cplusplus
extern "C" {
#endif

float g_Time;
int g_DeviceType = -1;
ID3D11Device* g_D3D11Device = NULL;
IDirect3DDevice9* g_D3D9Device = NULL;

void CSHARP_EXPORT SetTimeFromUnity(float t)
{
	g_Time = t;
}

void CSHARP_EXPORT UnitySetGraphicsDevice(void* device, int deviceType, int eventType)
{
	// Set device type to -1, i.e. "not recognized by our plugin"
	g_DeviceType = -1;

#if SUPPORT_D3D9
	// D3D9 device, remember device pointer and device type.
	// The pointer we get is IDirect3DDevice9.
	if (deviceType == kGfxRendererD3D9)
	{
		g_DeviceType = deviceType;
		g_D3D9Device = (IDirect3DDevice9*)device;
	}
#endif

#if SUPPORT_D3D11
	// D3D11 device, remember device pointer and device type.
	// The pointer we get is ID3D11Device.
	if (deviceType == kGfxRendererD3D11)
	{
		g_DeviceType = deviceType;
		g_D3D11Device = (ID3D11Device*)device;
	}
#endif

#if SUPPORT_OPENGL
	// If we've got an OpenGL device, remember device type. There's no OpenGL
	// "device pointer" to remember since OpenGL always operates on a currently set
	// global context.
	if (deviceType == kGfxRendererOpenGL)
	{
		g_DeviceType = deviceType;
	}
#endif
}

#ifdef __cplusplus
}
#endif