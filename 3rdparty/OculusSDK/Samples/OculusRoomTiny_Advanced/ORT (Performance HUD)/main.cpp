/************************************************************************************
Filename    :   Win32_RoomTiny_Main.cpp
Content     :   First-person view test application for Oculus Rift
Created     :   18th Dec 2014
Authors     :   Tom Heath
Copyright   :   Copyright 2012 Oculus, Inc. All Rights reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*************************************************************************************/
/// This sample shows the built in performance data 
/// available from the SDK.
/// Press '1' to see latency timing.
/// Press '2' to see render timing.
/// Press '3' to see performance headroom info.
/// Press '4' to see version info.

#include "OVR_Version.h"

/// Press '0' to dismiss again.

/// Latency Timing Pane :
///
///     App Tracking to Mid - Photon
///         Latency from when the app called ovr_GetTrackingState() to when that frame
///         eventually was shown(i.e.illuminated) on the HMD display - averaged mid - point illumination
///        
///     Timewarp to Mid - Photon
///         Latency from when the last predictied tracking info is fed to the GPU for timewarp execution
///         to the point when the middle scanline of that frame is illuminated on the HMD display
///        
///     Flip to Photon - Start
///         From the point the back buffer is presented to the HMD to the point that frame's
///         first scanline is illuminated on the HMD display
///        
///     Left-side graph:    Plots "App to Mid - Photon"
///     Right-side graph:   Plots "Timewarp to Mid - Photon" time
///     
/// Render Timing Pane :
///
///     Compositor Missed V-Sync Count
///         Increments each time the compositor fails to present a new rendered frame at V-Sync (Vertical Synchronization).
///        
///     Compositor Frame - rate
///         The rate at which final composition is happening outside the client application rendering.
///         It will never go above the native HMD refresh rate (since compositor is always locked to V - Sync,
///         but if the compositor (due to various reasons) fails to finish a new frame on time,
///         it can go below HMD the native refresh rate.
///        
///     Compositor GPU Time
///         The amount of time the GPU spends executing the compositor renderer
///         This includes timewarp and distortion of all the layers submitted by the client application.
///        
///     App Render GPU Time
///         The total GPU time spent on rendering by the client application. This includes the work done
///         after ovr_SubmitFrame() using the mirror texture if applicable. It also includes GPU command-buffer
///         "bubbles" that might be injected due to the client application's CPU thread not pushing data fast enough
///         to the GPU command buffer to keep it occupied.
///        
///     App Render CPU Time
///         The time difference from when the app starting executing on CPU after ovr_SubmitFrame() returned
///         to when timewarp draw call was executed on the CPU. Will show "N/A" if latency tester is not functioning
///         as expected. Includes IPC call overhead to compositor after ovr_SubmitFrame() is called by client application.
///
///     Left-side graph:    Plots frame rate of the compositor
///     Right-side graph:   Plots the total time spend by the GPU rendering both the client app and the compositor
///                         Plots the compositor GPU time in cyan under the total time graph
///
/// Performance HUD (aka Performance Headroom) :
///     
///     Motion - to - Photon Latency
///         Latency from when the last predictied tracking info is fed to the GPU for timewarp execution
///         to the point when the middle scanline of that frame is illuminated on the HMD display.
///         This is the same info presented in "Latency Timing" section, presented here for consumer - friendliness.
///
///     Unused performance
///         The percentage of PC performance that has not been utilized by the client application and compositor.
///         This is essentially the total CPU & GPU time tracked in the "Render Timing Pane" section divided by the
///         native frame time (inverse of refresh rate) of the HMD. If queue-ahead is enabled by the application, then
///         that is also taken into account. It is meant to be a simple guide for the consumer to verify that their
///         PC has enough CPU & GPU performance buffer to avoid dropping frames and leading to unwanted judder.
///
///     Total Frames Dropped
///         This is the same value provided in the "Render Timing Pane". It is provided in a centralized location
///         for easier viewing by the consumer to know if the PC is instantly running into performance issues.
///
///     Left-side graph:    Plots frame rate of the compositor
///     Right-side graph:   Plots the "Unused GPU performance" provided in the same section
///
///Version Info :
///     
///     OVR SDK Runtime Ver
///         Version of the runtime currently installed on the PC. Every VR application that uses the OVR SDK
///         since 0.5.0 will be using this installed runtime.
///
///     OVR SDK Client DLL Ver
///         The SDK version the client app was compiled against.


#define   OVR_D3D_VERSION 11
#include "../Common/Win32_DirectXAppUtil.h" // DirectX
#include "../Common/Win32_BasicVR.h"        // Basic VR

struct PerformanceHUD : BasicVR
{
    PerformanceHUD(HINSTANCE hinst) : BasicVR(hinst, L"Performance HUD") {}

    void MainLoop()
    {
	    Layer[0] = new VRLayer(HMD);

	    while (HandleMessages())
	    {
            // Handle Perf HUD Toggle
            if (DIRECTX.Key['0']) ovr_SetInt(HMD, OVR_PERF_HUD_MODE, int(ovrPerfHud_Off));
            if (DIRECTX.Key['1']) ovr_SetInt(HMD, OVR_PERF_HUD_MODE, int(ovrPerfHud_LatencyTiming));
            if (DIRECTX.Key['2']) ovr_SetInt(HMD, OVR_PERF_HUD_MODE, int(ovrPerfHud_RenderTiming));
            if (DIRECTX.Key['3']) ovr_SetInt(HMD, OVR_PERF_HUD_MODE, int(ovrPerfHud_PerfHeadroom));
            if (DIRECTX.Key['4']) ovr_SetInt(HMD, OVR_PERF_HUD_MODE, int(ovrPerfHud_VersionInfo));

		    ActionFromInput();
		    Layer[0]->GetEyePoses();

		    for (int eye = 0; eye < 2; ++eye)
		    {
			    Layer[0]->RenderSceneToEyeBuffer(MainCam, RoomScene, eye);
		    }

		    Layer[0]->PrepareLayerHeader();
		    DistortAndPresent(1);
	    }
    }
};

//-------------------------------------------------------------------------------------
int WINAPI WinMain(HINSTANCE hinst, HINSTANCE, LPSTR, int)
{
	PerformanceHUD app(hinst);
    return app.Run();
}
