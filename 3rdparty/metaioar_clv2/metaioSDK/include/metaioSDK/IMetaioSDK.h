// Copyright 2007-2013 metaio GmbH. All rights reserved.
#ifndef __AS_IMETAIOSDK_H_INCLUDED__
#define __AS_IMETAIOSDK_H_INCLUDED__

#include <metaioSDK/Camera.h>
#include <metaioSDK/IGeometry.h>
#include <metaioSDK/ILight.h>
#include <metaioSDK/IAnnotatedGeometriesGroup.h>
#include <metaioSDK/IBillboardGroup.h>
#include <metaioSDK/IRadar.h>
#include <metaioSDK/IMetaioSDKCallback.h>
#include <metaioSDK/ISensorsComponent.h>
#include <metaioSDK/IVisualSearchCallback.h>
#include <metaioSDK/GeometryHit.h>
#include <metaioSDK/Log.h>
#include <metaioSDK/ScreenRotation.h>
#include <metaioSDK/STLCompatibility.h>

namespace metaio
{

/**
 * Enumerations for different rendering implementations
 */
enum ERENDER_SYSTEM
{
    /// NullRender implementation, if you want to use your own renderer
    ERENDER_SYSTEM_NULL,
    /// OpenGL based rendering (PC only)
    ERENDER_SYSTEM_OPENGL,
    /// OpenGL based rendering (PC only)
    ERENDER_SYSTEM_OPENGL_EXTERNAL,
    /// OpenGL ES 2.0 based rendering
    ERENDER_SYSTEM_OPENGL_ES_2_0
};

/**
 * Enumerations for different Environment Map Format.
 * 6 Cube Side images or 1 LatLong image (only for loading)
 */
enum EENV_MAP_FORMAT 
{
	/// 6 images, each for one cube side
	EEMF_CUBESIDES = 0,
	/// 1 image containing equirectangular projection (LatLong Image)
	EEMF_LATLONG
};

/**
 * Enumeration for camera types when setting camera parameters
 * \sa setCameraParameters, getCameraParameters
 */
enum ECAMERA_TYPE
{
	/// Camera parameters that are used for tracking
	ECT_TRACKING =			1<<0,
	// Camera parameters for the left rendering camera on stereo rendering
	ECT_RENDERING_LEFT =	1<<1,
	// Camera parameters for the right rendering camera on stereo rendering
	ECT_RENDERING_RIGHT =	1<<2,
	/**
	 * Camera parameters used for rendering (in case of stereo rendering: parameters
	 * that apply to both eyes)
	 */
	ECT_RENDERING =			ECT_RENDERING_LEFT | ECT_RENDERING_RIGHT,
	/// Camera parameters that are used for both tracking and rendering
	ECT_ALL =				0xFF
};

/**
 *  The common interface to metaio SDK on all platforms.
 *
 * \par License
 * This code is the property of the metaio GmbH (www.metaio.com).
 * It is absolutely not free to be used, copied or
 * be modified without prior written permission from metaio GmbH.
 * The code is provided "as is" with no expressed or implied warranty.
 * The author accepts no liability if it causes
 * any damage to your computer, or any harm at all.
 */
class METAIO_DLL_API IMetaioSDK
{
public:


	/**
	 * Destructor of the metaio SDK
	 */
	virtual ~IMetaioSDK() {};


	/**
	 * Sets the global log level for Metaio SDK log messages
	 *
	 * This can be used to show additional or fewer messages on console/LogCat.
	 * The default level is ELL_WARNING.
	 *
	 * \sa ELOG_LEVEL
	 */
	static void setLogLevel(metaio::ELOG_LEVEL level);


	/**
	 * Release all memory that was statically allocated by metaio SDK or its dependencies.
	 *
	 * Call this at the end of your application or only if you will not use SDK functions anymore.
	 */
	static void shutdownLibrary();


	/**
	 * Get the SDK version string
	 * \return version string
	 */
	virtual stlcompat::String getVersion() const = 0;

	/**
	 *  Set tracking configuration from an XML file.
	 *
	 *	This function configures the tracking system and the coordinate systems based on an XML file or string input.
	 *	Additionally, some predefined configurations can be loaded by specifying special strings below:
	 *
	 *		"DUMMY" A dummy tracking configuration that delivers null translation and rotation
	 *		"MARKER_ID=<>_SIZE=<>_[ROBUST]" ID Marker tracking configuration with marker ID, size and optional type
	 *		"GPS" default configuration for GPS-Compass tracking, suitable for location based scenarios.
	 *		"ORIENTATION" tracking configuration for device attitude tracking, suitable for 360 degrees scenarios.
	 *		"LLA" tracking configuration for LLA markers, it also uses GPS-Compass tracking in addition to LLA markers reading
	 *		"CODE" configuration for reading bar codes including QR codes
	 *		"QRCODE" configuration for reading QR codes only
	 *		"FACE" configuration for Face Tracking  
	 *
	 * \param trackingConfig Fully qualified path of the XML file that should be loaded. If a ZIP is specified it will first try
	 *		 to load "TrackingData_ML3D.xml" from the ZIP and if that isn't successful it'll try to load any other xml from the ZIP.
	 *		 It can also be one of the special strings to load predefined configurations, or string containing XML configuration.
	 * \param readFromFile if set to false, it will interpret trackingConfig as tracking-configuration XML
	 * \return true if successful, false otherwise.
	 */
	virtual bool setTrackingConfiguration(const metaio::stlcompat::String& trackingConfig, bool readFromFile = true) = 0;


	/**
	 * Start creating instant tracking configuration by specifying a tracking mode.
	 *
	 * It will instantly start creating a tracking configuration based on camera image and available
	 * device sensors if requested. Once the tracking configuration has been created, it will report it
	 * through IMetaioSDKCallback.onInstantTrackingEvent() callback. The following tracking modes are
	 * supported:
	 *
	 * "INSTANT_2D" create instant tracking configuration for 2D planar target.
	 * "INSTANT_2D_GRAVITY" same as INSTANT_2D with additional use of gravity sensor to rectify the pose.
	 * "INSTANT_2D_GRAVITY_EXTRAPOLATED" same as INSTANT_2D_GRAVITY with additional use of attitude sensor to extrapolate the pose when
	 *                                   the target image cannot be tracked visually.
	 * "INSTANT_2D_GRAVITY_SLAM" create instant tracking configuration for 2D objects like INSTANT_2D_GRAVITY, 
	 * additionally uses 3D tracking (SLAM) to continue tracking when the original reference image gets out of sight.
	 * "INSTANT_2D_GRAVITY_SLAM_EXTRAPOLATED" Same as INSTANT_2D_GRAVITY_SLAM, but additionally tries to use
	 * sensors to extrapolate the pose if optical tracking is lost.

	 * "INSTANT_3D" create instant tracking configuration for 3D objects. It is also known as SLAM.
	 *
	 * \param trackingMode one of the supported tracking modes
	 * \param outFile Output file to save the result, if empty, it will save it to a temporary file.
	 * \param enablePreview Enable preview of 2D tracking area or 3D visualization
	 * The saved file path is returned in IMetaioSDKCallback.onInstantTrackingEvent callback.
	 * \sa IMetaioSDKCallback.onInstantTrackingEvent
	 */
	virtual void startInstantTracking(const stlcompat::String& trackingMode,
	                                  const stlcompat::String& outFile = "",
									  bool enablePreview = false ) = 0;


	/**
	 * Set camera intrinsic parameters from an XML file or string.
	 *
	 * The provided XML file should be structured as follows:
	 *
	 *	&lt;?xml version="1.0"?&gt;<br/>
	 *	&lt;Camera&gt;&lt;Name&gt;iPhoneCamera&lt;/Name&gt;<br/>
	 *		&lt;CalibrationResolution&gt;&lt;X&gt;480&lt;/X&gt;&lt;Y&gt;360&lt;/Y&gt;&lt;/CalibrationResolution&gt;<br/>
	 *		&lt;FocalLength&gt;&lt;X&gt;500&lt;/X&gt;&lt;Y&gt;500&lt;/Y&gt;&lt;/FocalLength&gt;<br/>
	 *		&lt;PrincipalPoint&gt;&lt;X&gt;240&lt;/X&gt;&lt;Y&gt;180&lt;/Y&gt;&lt;/PrincipalPoint&gt;<br/>
	 *	&lt;/Camera&gt;
	 *
	 * Note: The camera parameters can be automatically loaded for selected Android and iOS devices by passing an empty string.
	 * In case camera parameters for the device are not loaded, the method will return false.
	 *
	 * Hand-eye calibration set with setHandEyeCalibration is not changed by this method.
	 *
	 * \param parameters Fully qualified path to the camera parameters file or complete XML string.
	 * \param cameraType camera type, i.e. tracking, rendering or both
	 * \return true if successful, false otherwise.
	 * \sa getCameraParameters, setCameraParameters
	 * \sa ECAMERA_TYPE
	 * \sa setHandEyeCalibration
	 */
	virtual bool setCameraParameters(const stlcompat::String& parameters, ECAMERA_TYPE cameraType=ECT_ALL) = 0;

	/**
	 * Set custom camera intrinsic parameters.
	 *
	 * Hand-eye calibration set with setHandEyeCalibration is not changed by this method.
	 *
     * \param imageResolution The resolution (width=x and height=y) of the camera image in pixels.
     * \param focalLengths The horizontal (x) and vertical (y) focal lengths of the camera in pixels.
     * \param principalPoint The principal point of the camera in pixels.
	 * \param distortion Distortion coefficients
	 * \param cameraType camera type, i.e. tracking, rendering or both
	 * \sa getCameraParameters
	 * \sa ECAMERA_TYPE
	 * \sa setHandEyeCalibration
	 */
	virtual void setCameraParameters(const metaio::Vector2di& imageResolution, const metaio::Vector2d& focalLengths, 
		const metaio::Vector2d& principalPoint, const metaio::Vector4d& distortion, ECAMERA_TYPE cameraType=ECT_ALL) = 0;

	/**
     * Get the currently used camera intrinsic parameters.
     *
     * \param[out] imageResolution   The resolution (width=x and height=y) of the camera image in pixels.
     * \param[out] focalLengths      The horizontal (x) and vertical (y) focal lengths of the camera in pixels.
     * \param[out] principalPoint    The principal point of the camera in pixels.
	 * \param[out] distortion		 Distortion coefficients
	 * \param cameraType camera type, i.e. tracking or rendering
	 * \sa setCameraParameters
	 * \sa ECAMERA_TYPE
     */
    virtual void getCameraParameters(metaio::Vector2di* const imageResolution, metaio::Vector2d* const focalLengths, 
		metaio::Vector2d* const principalPoint, Vector4d* const distortion, ECAMERA_TYPE cameraType=ECT_TRACKING) const = 0;

	/**
     * Get the currently used camera intrinsic parameters.
	 * \param cameraType camera type, i.e. tracking or rendering
	 * \return Camera parameters as XML
     * \sa setCameraParameters
	 * \sa ECAMERA_TYPE
	 */
	virtual stlcompat::String getCameraParameters(ECAMERA_TYPE cameraType=ECT_TRACKING) const = 0;

	/**
     * Initialize the renderer
     *
     * \param width Width of the renderer's viewport
     * \param height Height of the renderer's viewport
	 * \param screenRotation Screen rotation
     * \param renderSystem Type of render system
	 * \param context Pointer to a custom context
	 * \sa ESCREEN_ROTATION
	 * \sa ERENDER_SYSTEM
     */
	virtual void initializeRenderer(int width, int height, ESCREEN_ROTATION screenRotation = ESCREEN_ROTATION_0,
		const ERENDER_SYSTEM renderSystem=ERENDER_SYSTEM_OPENGL_ES_2_0, void* context=0) = 0;

	/**
	 * Call this to enable a background processing thread.
	 * This is recommended on multi core devices.
	 */
	virtual void enableBackgroundProcessing() = 0;

	/**
	 * Call this to disable background processing thread.
	 */
	virtual void disableBackgroundProcessing() = 0;

	/**
	 * Check if multithreading is turned on
	 * \return True if multi threading is turned on, else false
	 */
	virtual bool isBackgroundProcessingEnabled() const = 0;

	/**
	 *  The main function performing capturing, tracking and rendering.
	 *
	 *	This method is usually called from the application loop. It takes care of capturing, tracking and rendering.
	 *
	 * \sa startCamera
	 * \sa stopCamera
	 * \sa setImage
	 * \sa getTrackingValues
	 */
	virtual	void render() = 0;

	/**
	 * Set an image file as image source.
	 *
	 * This method is used to set the image source from a file for rendering and tracking. It will
	 * automatically stop camera capture if currently running. Call startCamera again to resume
	 * capturing from camera.
	 *
	 * Supported file formats are JPG, PNG, BMP, PPM and PGM.
	 *
	 * If the image does not pertain to the current camera parameters (set with setCameraParameters),
	 * e.g. a widescreen image like 1280x720, you should first set appropriate parameters and only
	 * then call setImage. Else the SDK will try to adjust the current parameters to the image's
	 * resolution.
	 *
	 * \param source A fully qualified path to an image file.
	 * \return Resolution of the image if loaded successfully, else a null vector.
	 * \sa startCamera
	 * \sa setCameraParameters
	 */
	virtual Vector2di setImage(const stlcompat::String& source) = 0;

	/**
	 *  Set an image from memory.
	 *
	 *	This method is used to set the image source for rendering and tracking. Valid color
	 *	formats are ECF_YUV420SP and ECF_A8R8G8B8. On Unity, only ECF_R8G8B8 is supported at the
	 *	moment.
	 *
	 *	Note: On iOS and Android, this function is only available with a signature retrieved using a PRO license.
	 *		  However on Win32 you can use also use it with Free or Basic license.
	 * If the image does not pertain to the current camera parameters (set with setCameraParameters),
	 * e.g. a widescreen image like 1280x720, you should first set appropriate parameters and only
	 * then call setImage. Else the SDK will try to adjust the current parameters to the image's
	 * resolution.
	 *
	 * \param image the image structure containing the image data
	 * \param forceCopyImage If you take care that the image buffer is valid and not destroyed while
	 *                       the SDK uses it (i.e. until the next setImage or startCamera call), set
	 *                       this to false to avoid unnecessary copying. If true, the SDK will copy
	 *                       the image buffer immediately and takes care of destroying it later.
	 */
	virtual void setImage(const ImageStruct& image, bool forceCopyImage = false) = 0;

	/**
	 * Get a list of all available cameras
	 *
	 * \sa metaio::Camera
	 * \sa IMetaioSDK::startCamera
	 * \return Definitions of available cameras
	 */
	virtual metaio::stlcompat::Vector<metaio::Camera> getCameraList() const = 0;

	/**
	 * Start capturing on a camera.
	 *
	 * Start the specified camera with the given capture resolution (optional).
	 * The captured image can be optionally downsampled for tracking to allow rendering at higher resolution.
	 * This is always valid on Android, while on other platforms, it is only valid if YUV pipeline
	 * is enabled.
	 * The YUV pipeline can only be enabled on Android or iOS. It is enabled by default on these
	 * platforms.

	 * \deprecated This method is deprecated and will be removed in the future version. Please use startCamera
	 *             with Camera object containing full parameters.
	 *
	 * \param index The index of the camera to start (zero-based).
	 * \param width The desired width of the camera frame (default=320).
	 * \param height The desired height of the camera frame (default=240).
	 * \param downsample downsampling factor for the tracking image(default=1 means no downsampling), e.g. 2 or 3.
	 * \param enableYUVpipeline Enable/disable processing camera frames in YUV color space (default=true).
	 *	This is ignored on Windows and OSX because YUV pipeline can only be enabled on Android or iOS.
	 * \return Actual camera frame resolution (x = width, y = height) on success, else a null vector.
	 * \sa stopCamera
	 */
	virtual Vector2di startCamera(int index, unsigned int width = 320, unsigned int height = 240,
		int downsample = 1, bool enableYUVpipeline = true) = 0;

	/**
	 * Start capturing on a camera.
	 * Start the specified camera (index) with the given capture parameters (resolution, FPS, image format etc.)
	 * The captured image can be optionally downsampled for tracking to allow rendering at higher resolution.
	 * This is always valid on Android, while on other platforms, it is only valid if YUV pipeline
	 * is enabled. The YUV pipeline can only be enabled on Android or iOS.
     * On success, the input camera object will be updated with actual parameters that are used by
	 * the system.
	 * To get a list of available cameras that can be used see getCameraList
	 * 
	 * \param[in,out] camera A camera object containing all the requested parameters. On success,
	 *						 it will be updated with actual supported parameters.
	 * \return true on success
	 * \sa getCameraList
	 * \sa getCamera
	 * \sa stopCamera
	 */
	virtual bool startCamera(Camera& camera) = 0;

	/**
	 *  Stop capturing on a camera.
	 *
	 *	Use this to stop capturing on the current camera.
	 *
	 * \sa startCamera
	 */
	virtual void stopCamera() = 0;

	/**
	 * Get currently running camera
	 * \sa startCamera
	 */
	virtual Camera getCamera() = 0;

	/**
	 * Pause all processing and rendering.
	 *
	 * Use this to pause the processing whenever application
	 * switches to another view or goes to the background
	 *
	 * \sa resume
	 */
	virtual void pause() = 0;

	/**
	 * Resume all processing and rendering.
	 *
	 * Use this to resume the processing that was previously paused
	 *
	 * \sa pause
	 */
	virtual void resume() = 0;

	/**
	 * Pause tracking.
	 *
	 * Use this to pause tracking while continuing rendering
	 *
	 * \param keepTrackingValues true to keep last tracking values, false to clear it (default)
	 * \sa resumeTracking
	 */
	virtual void pauseTracking(bool keepTrackingValues=false) = 0;

	/**
	 * Resume tracking.
	 *
	 * Use this to resume tracking that is paused before
	 *
	 * \sa pauseTracking
	 */
	virtual void resumeTracking() = 0;

	/**
	 * Resize renderer view port
	 *
	 * \param width width of the view port in pixels
	 * \param height width of the view port in pixels
	 * \sa getRenderSize
	 */
	virtual void resizeRenderer(int width, int height) = 0;

	/**
	 * Get renderer viewport size in pixels.
	 * \return A vector containing viewport size (x=width, y=height)
	 * \sa resizeRenderer
	 */
	virtual Vector2di getRenderSize() const = 0;

	/** Get the current renderer type
	* \return the enumeration of of the renderer
	*/
	virtual ERENDER_SYSTEM getRendererType() const = 0;

	/**
	 * Inform screen rotation w.r.t. natural orientation.
	 *
	 * This should be called on Android if the Activity should support orientations other
	 * than Landscape
	 *
	 * \sa getScreenRotation
	 * \sa ESCREEN_ROTATION
	 *
	 * \param rotation screen rotation
	 * \return true if the rotation has been changed, false otherwise
	 */
	virtual bool setScreenRotation(const ESCREEN_ROTATION rotation) = 0;

	/**
	 * Get screen rotation
	 *
	 * \sa setScreenRotation
	 * \sa ESCREEN_ROTATION
	 *
	 * \return Screen rotation
	 */
	virtual ESCREEN_ROTATION getScreenRotation() const = 0;

	/**
	 * Request a callback that delivers the camera image.
	 *
	 * The image will have the dimensions of the current capture resolution.
	 * It will be delivered through the IMetaioSDKCallback.onNewCameraFrame
	 *
	 * Note: you need to copy the ImageStuct::buffer, if you need it for later.
	 *
	 * \sa registerCallback to register a callback.
	 */
	virtual void requestCameraImage() = 0;

	/**
	 * Request a high resolution camera image that will be saved as file.
	 *
	 * The result is notified in IMetaioSDKCallback.onCameraImageSaved. In case of failure,
	 * an empty string will be returned, else the string will have full path
	 * of the file. 
	 * 
	 * Note: On iOS devices the resolution depends on the actual device. An appropriate resolution
	 * is chosen automatically depending on the specified width (e.g. width=9999 will choose the
	 * highest resolution).
	 * Use width/height=0 if you want to use the resulting image with setImage(), this will choose
	 * the current capturing resolution.
	 *
	 * \param filepath file path to write file, currently only JPEG is supported
	 * \param width Desired width of the camera image (if 0, it will be the current capturing width)
	 * \param height Desired height of the camera image (if 0, it will be the current capturing height)
	 *
	 * \sa registerCallback to register a callback.
	  * \sa IMetaioSDKCallback::onCameraImageSaved
	 */
	virtual void requestCameraImage(const stlcompat::String& filepath, int width = 0, int height = 0) = 0;

	/**
	 * Request screen shot in memory.
	 * The screenshot will be returned in IMetaioSDKCallback::onScreenshot
	 * as a new ImageStruct object in the next render cycle.
	 * Note that it is responsibility of the caller to delete the ImageStruct in the
	 * callback.
     * \param frameBuffer Frame Buffer (iOS only)
     * \param renderBuffer Render Buffer (iOS only)
	 * \sa IMetaioSDKCallback::onScreenshot
	 * \sa setRendererFrameBuffers
	 */
	virtual void requestScreenshot(unsigned int frameBuffer = 0, unsigned int renderBuffer = 0) = 0;

	/**
	 * Request screen shot to be saved to a file.
	 * Currently JPG and PNG  file formats are supported. If an empty string is
	 * passed, it will save JPEG at a temporary path.
	 *
	 * The result will be notified in IMetaioSDKCallback::onScreenshot. In case
	 * of success, the full path to the file will be passed, else an empty string.
	 * \param filepath Filepath where screenshot should be saved, or empty string to use
	 *                 temporary directory
     * \param frameBuffer Frame Buffer (iOS only)
     * \param renderBuffer Render Buffer (iOS only)
	 * \sa IMetaioSDKCallback::onScreenshotSaved
	 * \sa setRendererFrameBuffers
	 */
	virtual void requestScreenshot(const stlcompat::String& filepath, unsigned int frameBuffer = 0, unsigned int renderBuffer = 0) = 0;

	/** 
	 * Set the renderbuffers for iOS screenshot functionality.
	 * If you pass in the valid framebuffers here, it's not necessary anymore to specify them
	 * in the requestScreenshot functions.
	 *
	 * \param frameBuffer the default framebuffer
	 * \param renderBuffer the default renderBuffer
	 *
	 */
	virtual void setRendererFrameBuffers( unsigned int frameBuffer, unsigned int renderBuffer ) = 0;

	/**
	 * Enable or disable the advanced rendering features. If this option is
	 * enabled the advanced rendering effects are run on every device. This
	 * should not be enabled on older devices. These effects are extremely
	 * performance intensive and require an iPhone 5, similar or newer device
	 * to run at a decent speed.
	 *
	 * \param enable If set to true the features are enabled, default is false
	 *
	 * \sa autoEnableAdvancedRenderingFeatures
	 */
	virtual void setAdvancedRenderingFeatures(const bool enable) = 0;
	
	/**
	 * This is a convenience method for setAdvancedRenderingFeatures.
	 * It checks if isAdvancedRenderingSupported()
	 * returns true or false and enables advanced rendering accordingly.
	 *
	 * \return true if advanced rendering was enabled, false if not
	 *
	 * \sa setAdvancedRenderingFeatures
	 */
	virtual bool autoEnableAdvancedRenderingFeatures() = 0;
	
	/**
	 * Check if advanced rendering is supported on the current device or not.
	 *
	 * This is just a suggestion for where to use advanced rendering. Advanced 
	 * rendering can be enabled on every device with setAdvancedRenderingFeatures(true).
	 * 
	 * \return true if advanced rendering is supported, false otherwise
	 */
	virtual bool isAdvancedRenderingSupported() = 0;
	
	/**
	 * Sets the parameters for the Depth of Field (DoF) effect
	 *
	 * \param focalLength The focal length
	 * \param focalDistance The focal distance, the distance where the object is 
	 * focused. This is in range [0,1] where 1 is at the far clipping plane
	 * and 0 at the near clipping plane. Keep in mind that DoF currently is only
	 * rendered in between the focal plane and the near clipping plane.
	 * \param aperture Size of the aperture
	 */
	virtual void setDepthOfFieldParameters(const float focalLength = 0.1f,
										   const float focalDistance = 0.6f,
										   const float aperture = 0.2f) = 0;
	
	/**
	 * Sets the intensity of the motion blur applied to the rendering.
	 * Default value is 1.0. The length of the motion vector is multiplied
	 * by this value.
	 * \param intensity The intensity of the motion blur
	 */
	virtual void setMotionBlurIntensity(const float intensity) = 0;
	
	/**
	 * Enable or disable the constant blur that is applied to the entire scene (camera image & rendering)
	 *
	 * \param enable IF set to true the final output is blurred, otherwise it will remain untouched
	 * \sa setConstantBlurIntensity
	 */
	virtual void setConstantBlur(const bool enable) = 0;
	
	/**
	 * Setting the intensity of blur that should be used for the constant blur. The quality of the blur scales inverse
	 * to it's intensity. So more blur means less blur quality
	 *
	 * \param intensity The amount of blur to be used
	 * \sa setConstantBlur
	 */
	virtual void setConstantBlurIntensity(const float intensity) = 0;
	
	/**
	 * Take a screenshot and put it into an ImageStruct.
	 *
	 * The returned ImageStruct and its' buffer must be released by the
	 * caller.
	 *
	 * \deprecated Use requestScreenshot
	 * \return Returns a new ImageStruct containing the screenshot.
	 * \sa requestScreenshot
	 */
	virtual ImageStruct* getScreenshot() = 0;

	/**
	 * Get the duration in milliseconds per frame it took to render the 3D geometry, UI and camera image.
	 *
	 * \return The duration in seconds for rendering the last frame.
	 */
	virtual unsigned int getRenderingDuration() const = 0;

	/**
	 * Get the duration in milliseconds per frame it took to perform tracking.
	 *
	 * \return The duration in seconds for tracking the last frame.
	 */
	virtual unsigned int getTrackingDuration() const = 0;

	/**
	 * Get the current rendering frame rate.
	 *
	 * The methods returns the rendering performance as number of frames per second.
	 *
	 * \return The mean rendering performance in frames per second over the last 25 frames.
	 */
	virtual float getRenderingFrameRate() const = 0;

	/**
	 * Get the current tracking frame rate.
	 *
	 * The methods returns the image processing performance as number of frames per second.
	 *
	 * \return The mean image processing performance in frames per second over the last 25 frames.
	*/
	virtual float getTrackingFrameRate() const = 0;

	/**
	 * Get current camera capture rate
	 * \return Camera capture rate as frames per second
	 */
	virtual float getCameraFrameRate() const = 0;

	/**
	 * Allows to get the state of the tracking system for a given coordinate system.
	 *
	 * The provided matrix is compatible with the OpenGL ModelView matrix (if you specify
	 * rightHanded=true) such that rendered geometry will e.g. be placed on a marker or marker-less
	 * tracking target. The matrix is always returned in column-major order as expected by OpenGL.
	 * The screen rotation is also used for computing the matrix.
	 *
	 * \param coordinateSystemID The (one-based) index of the coordinate system, the values should be retrieved for.
	 * \param[out] matrix An array that will carry 16 float values forming a (4x4) ModelView matrix after execution.
	 * \param preMultiplyWithStandardViewMatrix A boolean parameter specifying if the matrix should be
	 *	pre-multiplied with metaio's standard ViewMatrix to finally form a ModelView matrix for OpenGL.
	 * \param rightHanded True to get a matrix for a right-handed coordinate system,
	 *    false for a left-handed coordinate system.
	 */
	virtual void getTrackingValues(int coordinateSystemID, float* matrix,
	                               bool preMultiplyWithStandardViewMatrix = true,
								   bool rightHanded = false) = 0;

	/**
	 * Allows to get the state of the tracking system for a given coordinate system.
	 *
	 * Returned tracking values may have any tracking state, see ETRACKING_STATE.
	 *
	 * Depending on the configuration of the tracking system, the provided values may include
	 * a 6DoF camera pose with 3D translation and 3D rotation, an LLA coordinate (latitude, longitude, altitude)
	 * and a value indicating the quality/certainty of the above.
	 *
	 * \param rotate if the tracking values should be rotated according to screen rotation
	 * \sa metaio::TrackingValues
	 * \sa metaio::IMetaioSDKCallback.onTrackingEvent
	 * \param coordinateSystemID The (one-based) index of the coordinate system, the values should be retrieved for.
	 * \return A TrackingValues object containing the tracking values for the desired coordinate system.
	 */
	virtual metaio::TrackingValues getTrackingValues(int coordinateSystemID, bool rotate = false) = 0;

	/**
	 * Get the TrackingValues of all tracked coordinate systems.
	 *
	 * Returned tracking values may have a state Initialized, Found, Tracking or Lost. 
	 * Use TrackingValues::isTrackingState to determine if the target is being tracked or not.
	 *
	 * \param rotate if the tracking values should be rotated according to screen rotation
	 * \note In order to get informed about tracking changes, use the onTrackingEvent callback.
	 * \sa metaio::TrackingValues
	 * \sa metaio::IMetaioSDKCallback.onTrackingEvent
	 * \return A vector containing the TrackingValues.
	 */
	virtual metaio::stlcompat::Vector<metaio::TrackingValues> getTrackingValues(bool rotate = false) = 0;

	/**
	 * Set whether IMetaioSDKCallback::onTrackingEvent should always receive all tracking values and
	 * not only those with tracking state changes.
	 *
	 * Use this to receive all tracking value changes, i.e. also changes to the pose even if the
	 * tracking state has not changed.
	 *
	 * Default is to only pass tracking values which indicate a state change (ETS_INITIALIZED,
	 * ETS_FOUND, ETS_LOST, ETS_REGISTERED, but e.g. not ETS_TRACKING).
	 *
	 * \param enable Whether to propagate all tracking values
	 */
	virtual void setTrackingEventCallbackReceivesAllChanges(bool enable) = 0;

	/**
	 * Computes the spatial relationship, which is a rigid model transformation, between two coordinate systems.
	 *
	 *	This function computes the spatial relationship between the two given coordinate systems.
	 *
	 * \param baseCos The (one-based) index of the coordinate system to measure from.
	 * \param relativeCos The (one-based) index of the coordinate system to measure to.
	 * \param[out] relation Relation (i.e. transformation) between the given baseCOS and the relativeCOS
	 * \return True if the relation could be computed, false otherwise (e.g. if one coordinate system has no pose).
	 */
	virtual bool getCosRelation(int baseCos, int relativeCos, metaio::TrackingValues& relation) = 0;

	/**
	* Set an offset for a particular coordinate system.
	*
	* \param coordinateSystemID The (one-based) index of the desired coordinate system.
	* \param pose A pose consisting of a 3D translation and a 3D rotation which should act as offset.
	*/
	virtual void setCosOffset(int coordinateSystemID, const TrackingValues& pose) = 0;

	/**
	 * Get the offset for a particular coordinate system.
	 *
	 * \param coordinateSystemID The (one-based) index of the desired coordinate system.
	 * \sa metaio::TrackingValues
	 * \return a pose consisting of a 3D translation and a 3D rotation which should act as offset.
	 */
	virtual metaio::TrackingValues getCosOffset(int coordinateSystemID) = 0;

	/**
	 * Invert the pose in the given TrackingValues.
	 * This can be interpreted as swapping the roles of the coordinate systems of the camera and the tracking target.
	 *
	 * \param inPose TrackingValues containing pose to invert.
	 * \return TrackingValues with inverted pose.
	 */
	virtual metaio::TrackingValues invertPose(const metaio::TrackingValues& inPose) = 0;

	/**
	 * Allows to get the OpenGL projection matrix retrieved from camera calibration.
	 *
	 * The values can be used to set the OpenGL projection matrix according to the
	 * camera parameters of the current camera (e.g. for custom rendering scenarios).
	 *
	 * \param	matrix		An array that will carry 16 float values forming a (4x4) projection
	 *						matrix after execution. The matrix is stored as column major.
	 * \param	rightHanded	True to get a projection matrix for a right handed coordinate system
	 *						false for a left handed coordinate system.
	 * \param	cameraType	Camera type for which to retrieve the matrix (defaults to ECT_TRACKING)
	 * \sa setCameraParameters
	 * \return True on success, false on invalid parameter
	 */
	virtual bool getProjectionMatrix(float* matrix, bool rightHanded, ECAMERA_TYPE cameraType=ECT_TRACKING) const = 0;

	/**
	 * Get the number of currently tracked coordinate systems.
	 *
	 *	This function returns the number of coordinate systems that are currently tracked, i.e. have a valid pose.
	 *
	 * \return The number of tracked coordinate systems.
	 */
	virtual int getNumberOfValidCoordinateSystems() const = 0;

	/**
	 * Get the number of currently defined coordinate systems.
	 *
	 * This function returns the number of coordinate systems that are currently defined.
	 *
	 * \return The number of defined coordinate systems.
	 */
	virtual int getNumberOfDefinedCoordinateSystems() const = 0;

	/**
	 * Check if see-through is enabled
	 * \return True if enabled
	 */
	virtual bool isSeeThrough() const = 0;

	/**
	 * Toggle see-through state of the renderer.
	 *
	 * This function can be used to turn off the rendering of the camera image.
	 * It is useful e.g. when overlaying the metaio SDK view on top of another 
	 * view that renders the camera image.
	 *
	 * \param seeThrough If true, the camera image is not displayed, otherwise 
	 * it is drawn as by default.
	 *
	 * \sa setSeeThroughColor
	 */
	virtual void setSeeThrough(bool seeThrough) = 0;
	
	/**
	 * Set the background color for see-through mode.
	 * The specified color is rendered instead of the camera image if
	 * the see-through mode is enabled.
	 *
	 * \param red Red value of see through color in range [0,255]
	 * \param green Green value of see through color in range [0,255]
	 * \param blue Blue value of see through color in range [0,255]
	 * \param alpha Alpha value of see through color in range [0,255]
	 * \sa setSeeThrough
	 */
	virtual void setSeeThroughColor(unsigned int red,
									unsigned int green,
									unsigned int blue,
									unsigned int alpha) = 0;

    
	/**
	 * Set hand-eye calibration
	 *
	 * \param translation	Translation component of the transform
	 * \param rotation		Rotation component of the transform
	 * \param cameraType	Camera type for which to set the hand-eye calibration - one of
	 *						ECT_RENDERING, ECT_RENDERING_LEFT or ECT_RENDERING_RIGHT (defaults to
	 *						ECT_RENDERING)
	 */
	virtual void setHandEyeCalibration(const Vector3d& translation, const Rotation& rotation, ECAMERA_TYPE cameraType=ECT_RENDERING) = 0;

	/**
	 * Get hand-eye calibration
	 * \param[out] translation	Translation component of the transform
	 * \param[out] rotation		Rotation component of the transform
	 * \param cameraType		Camera type for which to return the hand-eye calibration
	 *							(ECT_RENDERING, ECT_RENDERING_LEFT or ECT_RENDERING_RIGHT)
	 */
	virtual void getHandEyeCalibration(Vector3d* const translation, Rotation* const rotation, ECAMERA_TYPE cameraType=ECT_RENDERING) = 0;

	/**
	 * Check if stereo rendering is enabled
	 * \return True if enabled, else false
	 */
	virtual bool isStereoRenderingEnabled() const = 0;

    /**
     * Toggle stereo rendering for 3D capable devices
     * 
     * The rendering is performed once for the left eye and once for the right eye. You should set
	 * a hand-eye calibration to get exact results. For known devices, the call to
	 * setStereoRendering overwrites the hand-eye calibration with built-in values. If you want to
	 * override them, make sure you call setHandEyeCalibration after setStereoRendering(true).
     *
	 * By default stereo rendering is turned off.
     *
     * \param stereoRendering If true, the rendering is performed in stereo mode, otherwise normal
     * rendering is performed.
	 *
	 * \sa setHandEyeCalibration
     */
    virtual void setStereoRendering(bool stereoRendering) = 0;
    
	/**
     * Freeze tracking.
	 *
	 * Freezes or un-freezes the current tracking. While frozen, the CPU load is reduced.
	 * The tracking values of the last frame before freezing will be returned by the metaio SDK.
	 *
	 * \param freeze True to freeze the tracking, false to un-freeze it.
	 */
	virtual void setFreezeTracking(bool freeze) = 0;

	/**
     * Get the Freeze-Tracking state.
	 *
	 * This function will return the state set by setFreezeTracking();
	 *
	 * \return true if the tracking currently frozen.
	 */
	virtual bool getFreezeTracking() const = 0;

	/**
	 * Retrieve the tracking sensor type according to loaded tracking configuration.
	 *
	 * \return The type of the currently loaded tracking sensor.
	 */
	virtual stlcompat::String getSensorType() = 0;

	/**
	 * Set the near and far clipping planes of the renderer.
	 *
	 * The clipping plane limits must be greater than 0 and far clipping plane
	 * limit must be greater than near clipping plane limit.
	 * 
	 * Note: This should be called after initializeRenderer() on Android.
	 *
	 * \param nearCP The distance of the near clipping plane in millimeters.
	 * \param farCP The distance of the far clipping plane in millimeters.
	 */
	virtual void setRendererClippingPlaneLimits(const float nearCP, const float farCP) = 0;

	/**
	 * Load a 3D geometry from a given file.
	 *
	 * This function loads a 3D geometry from the given file. The file format can be OBJ, MD2 or
	 * converted FBX. ZIP archive containing 3D geometry is also supported.
	 *
	 * The geometry can be deleted by calling unloadGeometry.
	 *
	 * \sa createGeometryFromMovie to create a 3D plane to play a movie file
	 * \sa createGeometryFromImage to create a 3D plane showing an image
	 * \sa unloadGeometry to unload the geometry.
	 *
	 * \param filepath Path to the geometry file to load.
	 * \return Pointer to the geometry. Null pointer if not successful.
	 */
	virtual IGeometry* createGeometry(const stlcompat::String& filepath) = 0;

	/**
	 * Loads an image from a given file and places it on a generated 3D-plane.
	 *
	 * This function loads an image from a given file and places it on a generated 3D-plane.
	 * You can unload the geometry again with unloadGeometry().
	 * Supported image formats are PNG, JPG and BMP.
	 *
	 * \sa unloadGeometry to unload the geometry.
	 * \sa createGeometry
	 * \sa createGeometryFromMovie
	 *
	 * \param filepath Path to the image file.
	 * \param displayAsBillboard true if the plane should be rendered as a billboard (always facing camera)
	 * \param autoScale true if the plane size should be assigned a height of 100, and width of
	 *        100*{image width}/{image height}. false if the size should be the image width and height
	 *        (e.g. 640 by 480 units for a 640x480 image)
	 * \return Pointer to the geometry. Null pointer if not successful.
	 */
	virtual IGeometry* createGeometryFromImage(const stlcompat::String& filepath,
	        const bool displayAsBillboard = false,
			const bool autoScale = true) = 0;

	/**
	 * Loads an image from given ImageStruct and places it on a generated 3D-plane.
	 *
	 * This function loads an image from a given file and places it on a generated 3D-plane.
	 * You can unload the geometry again with unloadGeometry().
	 * Supported image formats are PNG, JPG and BMP.
	 *
	 * \sa unloadGeometry to unload the geometry.
	 * \sa createGeometry
	 * \sa createGeometryFromMovie
	 *
	 * \param textureName Assign a unique identifier to the texture.
	 * \param image The new image in memory.
	 * \param displayAsBillboard true if the plane should be rendered as a billboard (always facing camera)
	 * \param autoScale true if the plane size should be assigned a height of 100, and width of
	 *        100*{image width}/{image height}. false if the size should be the image width and height
	 *        (e.g. 640 by 480 units for a 640x480 image)
	 * \return Pointer to the geometry. Null pointer if not successful.
	 */
	virtual IGeometry* createGeometryFromImage(const stlcompat::String& textureName,
	        const ImageStruct& image,
			const bool displayAsBillboard = false,
			const bool autoScale = true) = 0;

	/**
	 * Loads a movie from a given file and places it on a generated 3D-plane.
	 *
	 * This function loads a movie from a given file and places it on a generated 3d-plane.
	 * You can unload the geometry again with unloadGeometry().
	 * Supported movie file format is "3g2" (for details see movietexture documentation).
	 *
	 * \sa createGeometryFromMovie to create a 3D plane to play a movie file
	 * \sa createGeometryFromImage to create a 3D plane showing an image
	 * \sa unloadGeometry to unload the geometry.
	 *
	 * \param filepath Path to the movie file.
	 * \param transparentMovie true if the movie contains an alpha-plane next to the movie itself. default is false.
	 * \param displayAsBillboard true if the plane should be rendered as a billboard (always facing camera). default is false.
	 * \return Pointer to the geometry. Null pointer if not successful.
	 */
	virtual IGeometry* createGeometryFromMovie(const stlcompat::String& filepath,
	        const bool transparentMovie = false,
	        const bool displayAsBillboard = false) = 0;

	/**
	 * Creates and adds a new light.
	 *
	 * Defaults to an enabled point light. Change the light properties using the ILight interface.
	 *
	 * Not applicable for custom renderer.
	 *
	 * \return ILight instance, owned by SDK
	 * \sa ILight
	 */
	virtual ILight* createLight() = 0;

	/**
	 * Gets global ambient illumination value
	 *
	 * \return RGB color in range [0;1]
	 */
	virtual metaio::Vector3d getAmbientLight() const = 0;

	/**
	 * Remove a light from the scene and delete it.
	 *
	 * ILight instance becomes invalid after calling this method.
	 *
	 * \param light The light to remove
	 */
	virtual void removeLight(ILight* light) = 0;

	/**
	 * Sets the global ambient color
	 *
	 * Defaults to black. Not applicable for custom renderer.
	 *
	 * \param globalAmbientColor Global ambient illumination value added to all lighting
	 *                           calculations (RGB color in range [0;1])
	 */
	virtual void setAmbientLight(const metaio::Vector3d& globalAmbientColor) = 0;

	/**
	 * Unload the given geometry.
	 *
	 * This function unloads a geometry. If you do not want to unload the geometry but hide it,
	 * use setVisible() instead.
	 *
	 * \param geometry Pointer to the geometry that is returned by one of the createGeometry functions.
	 * \return true on success, false on failure
	 * \sa createGeometry
	 * \sa setVisible
	 */
	virtual bool unloadGeometry(metaio::IGeometry* geometry) = 0;

	/**
	 * Get a vector containing all loaded geometries.
	 *
	 * This function returns a vector containing pointers to all loaded 3D geometries.
	 *
	 * \sa createGeometry
	 * \return A vector containing pointers to all the created geometries.
	 */
	virtual stlcompat::Vector<metaio::IGeometry*> getLoadedGeometries() = 0;

	/**
	 * Determines all geometries that are touched by the ray defined by a given viewport coordinate
	 *
	 * \param x						The x-component of the viewport coordinate
	 * \param y						The y-component of the viewport coordinate
	 * \param useTriangleTest		If true, all triangles are tested which is more accurate but slower.
	 *								If set to false, bounding boxes are used instead.
	 * \param maxGeometriesToReturn Maximum number of geometries to find. If you know that many
	 *								geometries could be positioned along the ray, but you only want
	 *								the front-most N geometries, set this value to N. The default
	 *								value of 0 means to return all matching geometries.
	 * \param geometriesToConsider	List of geometries that should be considered for picking.
	 *								The default (NULL) is to test against all loaded geometries.
	 * \sa getGeometryFromViewportCoordinates
	 * \return Vector containing all matching geometries in front-to-back order. The vector may be
	 *         empty if no geometry was hit by the ray.
	 */
	virtual stlcompat::Vector<metaio::GeometryHit> getAllGeometriesFromViewportCoordinates(int x, int y,
	    bool useTriangleTest = false, unsigned long maxGeometriesToReturn = 0,
		const stlcompat::Vector<metaio::IGeometry*>* geometriesToConsider = 0) const = 0;

	/**
	 * Determines the front-most 3D geometry that is located at a given viewport coordinate.
	 *
	 * \deprecated	This method is deprecated and will be removed in a future version. Please use
	 *				getGeometryFromViewportCoordinates instead.
	 * \param x The x-component of the viewport coordinate.
	 * \param y The y-component of the viewport coordinate.
	 * \param useTriangleTest If true, all triangles are tested which is more accurate but slower. If set to false, bounding boxes are used instead.
	 * \sa getAllGeometriesFromViewportCoordinates
	 * \return A pointer to the geometry. If no 3D geometry is located at the given coordinate, it's a null pointer.
	 */
	virtual metaio::IGeometry* getGeometryFromScreenCoordinates(int x, int y,
		bool useTriangleTest = false) const = 0;

	/**
	 * Determines the front-most 3D geometry that is located at a given viewport coordinate.
	 *
	 * \param x The x-component of the viewport coordinate.
	 * \param y The y-component of the viewport coordinate.
	 * \param useTriangleTest If true, all triangles are tested which is more accurate but slower. If set to false, bounding boxes are used instead.
	 * \sa getAllGeometriesFromViewportCoordinates
	 * \return A pointer to the geometry. If no 3D geometry is located at the given coordinate, it's a null pointer.
	 */
	virtual metaio::IGeometry* getGeometryFromViewportCoordinates(int x, int y,
	        bool useTriangleTest = false) const = 0;

	/**
	 * Converts the given 3D point to viewport coordinates.
	 *
	 * The returned coordinates are only valid if the specified coordinate system is currently
	 * being tracked.
	 *
	 * \deprecated	This method is deprecated and will be removed in a future version. Please use
	 *				getViewportCoordinatesFrom3DPosition instead.
	 * \param coordinateSystemID The (one-based) index of the coordinate system in which the 3D point is defined.
	 * \param point A 3D point on the specified coordinate system.
	 * \param forRelativeToScreenGeometry Set this to true to find correct viewport coordinates for RTS geometries
	 * \return A 2D vector containing the viewport coordinates. The origin is at Top-Left that is consistent with
	 *	the touch coordinates.
	 */
	virtual Vector2d getScreenCoordinatesFrom3DPosition(int coordinateSystemID, const Vector3d& point, bool forRelativeToScreenGeometry = false) const = 0;

	/**
	 * Converts the given 3D point to viewport coordinates.
	 *
	 * The returned coordinates are only valid if the specified coordinate system is currently
	 * being tracked.
	 *
	 * \param coordinateSystemID The (one-based) index of the coordinate system in which the 3D point is defined.
	 * \param point A 3D point on the specified coordinate system.
	 * \param forRelativeToScreenGeometry Set this to true to find correct viewport coordinates for RTS geometries
	 * \return A 2D vector containing the viewport coordinates. The origin is at Top-Left that is consistent with
	 *	the touch coordinates.
	 */
	virtual Vector2d getViewportCoordinatesFrom3DPosition(int coordinateSystemID, const Vector3d& point, bool forRelativeToScreenGeometry = false) const = 0;

	/**
	 * Converts viewport coordinates to the corresponding 3D point on the plane of the tracked target.
	 *
	 * The function will only return (0,0,0) if the COS ID is invalid. The z value is always 0
	 * because the point lies on the plane defined by the tracked target.
	 *
	 * \deprecated	This method is deprecated and will be removed in a future version. Please use
	 *				get3DPositionFromViewportCoordinates instead.
	 * \param coordinateSystemID The coordinate system in which the 3D point is defined
	 * \param point The 2D viewport coordinates to use
	 * \param distance the distance vector that specifies the distance of the plane from the origin
	 * \param normal the normal factor that specifies the direction and size of the plane
	 * \return A 3D vector containing the coordinates of the resulting 3D point.
	 */
	virtual Vector3d get3DPositionFromScreenCoordinates(int coordinateSystemID, const Vector2d& point, const Vector3d& distance = Vector3d(0.0f, 0.0f, 0.0f), const Vector3d& normal = Vector3d(0.0f, 0.0f, 1.0f)) const = 0;

	/**
	 * Converts viewport coordinates to the corresponding 3D point on the plane of the tracked target.
	 *
	 * The function will only return (0,0,0) if the COS ID is invalid. The z value is always 0
	 * because the point lies on the plane defined by the tracked target.
	 *
	 * \param coordinateSystemID The coordinate system in which the 3D point is defined
	 * \param point The 2D viewport coordinates to use
	 * \param distance the distance vector that specifies the distance of the plane from the origin
	 * \param normal the normal factor that specifies the direction and size of the plane
	 * \return A 3D vector containing the coordinates of the resulting 3D point.
	 */
	virtual Vector3d get3DPositionFromViewportCoordinates(int coordinateSystemID, const Vector2d& point, const Vector3d& distance = Vector3d(0.0f, 0.0f, 0.0f), const Vector3d& normal = Vector3d(0.0f, 0.0f, 1.0f)) const = 0;

	/**
	 * Converts screen coordinates to the corresponding 3D point on surface of the touched model.
	 *
	 * The function will only return (0,0,0) if there's no model at the given screen position
	 *
	 * \deprecated	This method is deprecated and will be removed in a future version. Please use
	 *				getAllGeometriesFromViewportCoordinates and GeometryHit::objectCoordinates instead.
	 * \param point The 2D screen coordinate to use.
	 * \param useTriangleTest If true, all triangles are tested which is more accurate but slower. If set to false, bounding boxes are used instead.
	 * \return A 3D vector containing the coordinates of the resulting 3D point.
	 */
	virtual Vector3d get3DLocalPositionFromScreenCoordinates(const Vector2d& point, const bool useTriangleTest = false) const = 0;

	/**
	 * Set the rendering limits for geometries with LLA coordinates.
	 *
	 * The near limit will ensure that all geometries closer than this limit are pushed back to the near limit.
	 * The far limit will ensure that all geometries farther away than this limit are pulled forward to the far limit.
	 * Set both limits to 0 to disable this feature.
	 *
	 * This is especially helpful for billboards.
	 *
	 * \param nearLimit The near limit in meters
	 * \param farLimit The far limit in meters
	 * \sa IGeometry::setLLALimitsEnabled
	 * \sa getLLAObjectRenderingLimits
	 */
	virtual void setLLAObjectRenderingLimits(const int nearLimit, const int farLimit) = 0;


	/**
	 * Get the rendering limits for geometries with LLA coordinates.
	 * \return Rendering limits, x=near limit, y=far limit in meters
	 * \sa setLLAObjectRenderingLimits
	 */
	virtual Vector2di getLLAObjectRenderingLimits() const = 0;

	/**
	 * Creates a group for annotated geometries or returns the existing one
	 *
	 * \return New or existing group
	 */
	virtual metaio::IAnnotatedGeometriesGroup* createAnnotatedGeometriesGroup() = 0;

	/**
	 * Creates or gets the billboard group object.
	 *
	 * Calling this function the first time will create a billboard group. Calling it again, will return the
	 * previously created object.
	 *
	 * A billboard group takes a set of billboards and reorders them in space. All billboards within the set are
	 * placed in space relative to each other. First the billboard distance to the global origin (3d camera position)
	 * is adjusted (in the range [nearValue, farValue] see parameters) and then the billboards are arranged in
	 * clip space that they don't overlap anymore.
	 *
	 * \param nearValue The minimum billboard-to-camera distance in meters a billboard can have (default 0.5m).
	 * \param farValue The maximum billboard-to-camera distance in meters a billboard can have (default 3.0m).
	 * \return Pointer to the billboard group.
	 */
	virtual metaio::IBillboardGroup* createBillboardGroup(const float nearValue=0.5f, const float farValue=3.f) = 0;

	/**
	 * Loads shader materials from XML (file or buffer)
	 *
	 * \param filenameOrXmlContent Path to shader materials XML file, or the XML content itself
	 *                             as string
	 * \param isFile Whether filenameOrXmlContent specifies a file path
	 * \return bool True on success, false on error
	 */
	virtual bool loadShaderMaterials(const stlcompat::String& filenameOrXmlContent, bool isFile = true) = 0;

	/**
	 * Create and add radar object. The radar object is destroyed with the
	 * metaio SDK destructor.
	 *
	 * \param size size of the radar (default=100.0)
	 * \return Pointer to the new radar object
	 * \sa IRadar
	 */
	virtual metaio::IRadar* createRadar(float size = 100.f) = 0;

	/**
	 * Register a callback interface to receive visual search events
	 *
	 * \param callback A pointer to the object that implements metaio::IVisualSearchCallback
	 */
	virtual void registerVisualSearchCallback(metaio::IVisualSearchCallback* callback) = 0;

	/**
	 * Requests the execution of a new visual search.
	 *
	 * Visual search will send the current capture image to metaio's VisualSearch-Server
	 * to find matching patterns which are stored on the server. Then the found patterns are
	 * processed on the client side and the final result is forwarded to your application
	 * through the visual search callback (see IMetaioSDKCallback::onVisualSearchResult()).
	 * You will need an active internet connection in order to work.
	 * You can do only one visual search at a time.
	 * \param databaseID The id of the database which is searched
	 * \param returnFullTrackingConfig true if you want a ready-made tracking configuration in the result callback
	 * \param visualSearchServer the URL to the visual search server (e.g. cvs.junaio.com/vs)
	 * \sa IMetaioSDKCallback::onVisualSearchResult
	 */
	virtual void requestVisualSearch(const stlcompat::String& databaseID, 
		bool returnFullTrackingConfig = false,
		const stlcompat::String& visualSearchServer = "cvs.junaio.com/vs") = 0;

	/**
	 * Determine the current state of the visual search engine.
	 *
	 * You can use this method to determine if a request is already running or
	 * the engine can process a new request.
	 * \return the current state of the engine
	 * \sa EVISUAL_SEARCH_STATE
	 */
	virtual metaio::EVISUAL_SEARCH_STATE getVisualSearchState() = 0;

	/**
	 * Register a callback interface to the metaio SDK.
	 *
	 * \param callback A pointer to the object that implements metaio::IMetaioSDKCallback
	 * \sa metaio::IMetaioSDKCallback
	 * \sa getRegisteredCallback()
	 */
	virtual void registerCallback(metaio::IMetaioSDKCallback* callback) = 0;

	/**
	 * Get a pointer to the registered callback
	 *
	 * \sa metaio::ISensorsComponent
	 * \sa registerSensorsComponent
	 * \return Pointer to the callback or NULL
	 */
	virtual metaio::IMetaioSDKCallback* getRegisteredCallback() const = 0;

	/**
	 * Creates an environment map, which can be seen as a reflection on 3D geometries.
	 *
	 * This feature can be used to attach a reflection map to an object.
	 * 
	 * When envMapFormat is set to EEMF_CUBESIDES, six image files have to be supplied
	 *
	 * The six image files contained in the provided folder need to have the following names:
	 * "positive_x.png", "positive_y.png", "positive_z.png",
	 * "negative_x.png", "negative_y.png",	"negative_z.png".
	 *
	 * \param folder In case of envMapFormat = EEMF_CUBESIDES, the path of a folder that 
	 *				 should contain six PNG image files containing the textures for the six faces of 
	 *				 the cube. In case of envMapFormat = EEMF_LATLONG, folder must be set to the file 
	 *				 URI of the lat-long-image.
	 * \param envMapFormat format of given environment map
	 * \return Returns true, if the environment map was successfully loaded.
	 * \sa metaio::EENV_MAP_FORMAT
	 */
	virtual bool loadEnvironmentMap(const stlcompat::String& folder, EENV_MAP_FORMAT envMapFormat = EEMF_CUBESIDES) = 0;

	/**
	 * This function will pause all currently running movie textures.
	 */
	virtual void pauseAllMovieTextures() = 0;

	/**
	 * Register (or de-register) sensors component.
	 * Pass NULL to de-register sensors component. This should be done before deleting
	 * the sensors component.
	 *
	 * \param sensors An implementation of metaio::ISensorsComponent interface
	 * \sa metaio::ISensorsComponent
	 * \sa getRegisteredSensorsComponent()
	 */
	virtual void registerSensorsComponent(metaio::ISensorsComponent* sensors) = 0;


	/**
	 * Get a pointer to the registered sensors component
	 * \return pointer to the sensors component or NULL
	 * \sa metaio::ISensorsComponent
	 * \sa registerSensorsComponent
	 */
	virtual metaio::ISensorsComponent* getRegisteredSensorsComponent() const = 0;



	/**
	 * Stop all sensors that have been started by the SDK.
	 * Call resumeSensors to start the required sensors again.
	 *
	 * \sa resumeSensors
	 */
	virtual void pauseSensors() = 0;


	/**
	 * Restart all the necessary sensors that the current Tracking-System requires
	 *
	 * \sa pauseSensors
	 * \sa getRunningSensors
	 */
	virtual void resumeSensors() = 0;

	/**
	 * Get currently running sensors that have been started by the SDK.
	 * \sa metaio::ISensorsComponent
	 */
	virtual int getRunningSensors() const = 0;


	/**
	 * Send a command to the Sensor, depending on the input command.
	 *
	 * Some times a sensor need a more fine grained control, e.g. for Stereo-SLAM initialization it
	 * is helpful to specify an output file, without needing to re-generate XML file.
	 *
	 * \param command the command to send to the sensor
	 * \param parameter the parameters for the sensor
	 * \return result of the command
	 */
	virtual stlcompat::String sensorCommand(const stlcompat::String& command, const stlcompat::String& parameter = "") = 0 ;


	/**
	 * Get the name of a coordinate system if it has one (can be set via tracking data XML file).
	 *
	 * Use this to find out the given name of a coordinate system according to it's ID.
	 *
	 * \param coordinateSystemID ID of the according coordinate system.
	 * \return The name of a coordinate system. The return value is an empty string if no ID is found.
	 */
	virtual stlcompat::String getCoordinateSystemName(int coordinateSystemID) = 0;

	/**
	 * Get the ID of a coordinate system by its name.
	 *
	 *	In the XML configuration each coordinate system can have a name tag, the &lt;SensorCosID&gt;.
	 *
	 * \param name the name specified in the xml
	 * \return the id, 0 if coordinate system name is not found
	 */
	virtual int getCoordinateSystemID(const stlcompat::String& name) = 0;

};


} // namespace metaio

#endif //__AS_IMETAIOSDK_H_INCLUDED__
