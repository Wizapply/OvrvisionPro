/************************************************************************************
Filename    :   Win32_RoomTiny_Main.cpp
Content     :   First-person view test application for Oculus Rift
Created     :   11th May 2015
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
/// This samples allows you to load the application with a GPU
/// intensive object, and increase or decrease that loading with 
/// the '1' and '2' keys until it can't handle the framerate.
/// Then allow queue ahead to occur by holding '3' and you 
/// should see the frame rate return to smooth.
/// You can also adjust the CPU loading before rendering begins
/// which is a benefit of queue-ahead, to have GPU rendering 
/// continue during these times

/// An interesting test case :
/// 1) Hold '4' until CPU use is zero milliseconds.
/// 2) Adjust render load with '1' and '2' until frame-rate is JUST OK.
/// 3) Increase CPU use by holding '5', until that CPU overwhelms the 
///    framerate and juddering starts.
/// 4) Hold '3' to see queue-ahead return the framerate to smooth.

#define   OVR_D3D_VERSION 11
#include "../Common/Win32_DirectXAppUtil.h" // DirectX
#include "../Common/Win32_BasicVR.h"        // Basic VR

struct QueueAhead : BasicVR
{
    QueueAhead(HINSTANCE hinst) : BasicVR(hinst, L"Queue Ahead") {}

    void MainLoop()
    {
	    Layer[0] = new VRLayer(HMD);

	    // Make a new room model, with the more intensive GPU object
	    // Note, you can decide to have this, or not, by 
	    // editting the code below, switching to false if you wish.
        Scene BigRoomScene(true); //<=================================================MODIFY DEFAULT?

	    while (HandleMessages())
	    {
		    // Here we allow a variable amount of CPU usage
		    // before the graphics, as this is a good example 
		    // of queue ahead increasing performance
		    // Vary by '4' and '5'
		    static float msOfCPUBeforeRender = 3.0f; //<=================================================MODIFY DEFAULT?
		    if ((DIRECTX.Key['4']) && (msOfCPUBeforeRender > 0.01f))
		    {
			    msOfCPUBeforeRender -= 0.01f;
			    Util.Output("Ms of CPU use before render = %0.2f\n", msOfCPUBeforeRender);
		    }
		    if (DIRECTX.Key['5'])
		    {
			    msOfCPUBeforeRender += 0.01f;
			    Util.Output("Ms of CPU use before render = %0.2f\n", msOfCPUBeforeRender);
		    }

		    // Now the actual, simulated CPU usage
		    double startTime = ovr_GetTimeInSeconds();
		    double currTime = ovr_GetTimeInSeconds();

		    while (currTime < (startTime + 0.001f * msOfCPUBeforeRender))
		    {
			    int total = 0;
			    for (int i = 0; i < 1000; ++i) total += i;
			    currTime = ovr_GetTimeInSeconds();
		    }

		    // Adjust loading on the app, by varying the times the scene is drawn
		    // until it can't hold framerate, then hold 3 to let the 
		    // queue ahead bring it back into framerate, albeit with an extra few
		    // milliseconds of latency.
		    // The current amount is output to the Output window in Visual Studio.
		    static int timesToRenderRoom = 50; // <==================================================MODIFY DEFAULT?
		    if ((DIRECTX.Key['1']) && (timesToRenderRoom > 1))
		    {
			    timesToRenderRoom -= 1;
			    Util.Output("Times to render room = %d\n", timesToRenderRoom);
		    }
		    if (DIRECTX.Key['2'])
		    {
			    timesToRenderRoom += 1;
			    Util.Output("Times to render room = %d\n", timesToRenderRoom);
		    }

		    // Hold 3 to turn basic queue ahead on
		    if (DIRECTX.Key['3']) ovr_SetBool(HMD, "QueueAheadEnabled", true);
		    else                  ovr_SetBool(HMD, "QueueAheadEnabled", false);

            ActionFromInput();
            Layer[0]->GetEyePoses();

            for (int eye = 0; eye < 2; ++eye)
            {
			    Layer[0]->RenderSceneToEyeBuffer(MainCam, &BigRoomScene, eye, 0, 0, timesToRenderRoom);
            }

            Layer[0]->PrepareLayerHeader();
            DistortAndPresent(1);
	    }
    }
};

//-------------------------------------------------------------------------------------
int WINAPI WinMain(HINSTANCE hinst, HINSTANCE, LPSTR, int)
{
	QueueAhead app(hinst);
    return app.Run();
}
