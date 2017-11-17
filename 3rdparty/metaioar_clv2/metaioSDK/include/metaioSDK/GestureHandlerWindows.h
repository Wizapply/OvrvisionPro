// Copyright 2007-2013 metaio GmbH. All rights reserved.
#ifndef __GESTUREHANDLER_WINDOWS_H__
#define __GESTUREHANDLER_WINDOWS_H__

#include <afxwin.h>  

#include <metaioSDK/GestureHandler.h>



namespace metaio
{
/**
 * GestureHandler for Windows tablets that are equipped with a touch screen
 */
class METAIO_DLL_API GestureHandlerWindows : public metaio::GestureHandler
{
public:

    /**
     * Create new gesture handler by specifying gestures to enable.
	 *
     * \param metaioSDK metaio SDK instance
     * \param gestureMask Gesture mask to enable gestures
	 * \sa GESTURE_DRAG
     * \sa GESTURE_ROTATE
     * \sa GESTURE_PINCH
     * \sa GESTURE_ALL
     */
	GestureHandlerWindows(metaio::IMetaioSDK* metaioSDK, int gesture_mask);


    /**
     * Destructor for the class.
     */
	virtual ~GestureHandlerWindows();


    /**
     * Register GestureHandler to the CFrameWnd window.
	 *
     * \param pFrameWnd The CFrameWnd instance for registration
     */
	void registerGestureHandler(CFrameWnd* pFrameWnd);


    /**
     * The touch event interface that handles all gestures.
	 *
     * \param pt Touch point coordinate
     * \param nInputNumber Number of touch point
	 * \param nInputsCount Total number of touch points
     * \param pInput A pointer that points to TOUCHINPUT structure (Please consult Windows)
     */
	void OnTouchInput(CPoint pt, int nInputNumber, int nInputsCount, PTOUCHINPUT pInput);

private:
	// Indicate if the secondary touch point is activated
	bool m_pointerDown;

	// Indicate if touchesBegan has already been called
	bool m_beganCalled;

	// The x axis of the primary touch point
	LONG m_px;

	// The y axis of the primary touch point
	LONG m_py;

	// The x axis of the secondary touch point
	LONG m_sx;

	// The y axis of the secondary touch point
	LONG m_sy;

	// The original distance between the two touch points
	float m_distance;

	// The original angle between the two touch points
	float m_rotation;

	// Indicate the current gesture type
	int m_gestureMode;
};

} // namespace metaio

#endif // defined(__GESTUREHANDLER_WINDOWS_H__)
