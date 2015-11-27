// Copyright 2007-2013 metaio GmbH. All rights reserved.

#ifndef __CAMERA_H__
#define __CAMERA_H__

#include <metaioSDK/Dll.h>
#include <metaioSDK/STLCompatibility.h>
#include <metaioSDK/Vector2d.h>

namespace metaio {

/**
 * Definition of a camera available on the system
 */
struct METAIO_DLL_API Camera
{
	/// No information about camera facing direction
	static const int FACE_UNDEFINED =		0;
	
	/// Camera facing back (rear) direction
	static const int FACE_BACK =			1;
	
	/// Camera facing front direction
	static const int FACE_FRONT =			1<<1;
	
	/// No flip
	static const int FLIP_NONE =			0;
	
	/// Vertical flip
	static const int FLIP_VERTICAL =		1;
	
	/// Horizontal flip
	static const int FLIP_HORIZONTAL =		1<<1;
	
	/// Both vertical and horizontal flip (= 180 degrees rotation)
	static const int FLIP_BOTH =			FLIP_VERTICAL|FLIP_HORIZONTAL;
	
	
	/// Unique camera index
	int	index;
	
	/// base index for OpenNI based devices
	static const int BASE_INDEX_OPENNI = 5000;

	/// base index for Tango 
	static const int BASE_INDEX_TANGOPGM = 6000;
	
	/// base index for OptrisPI based devices
	static const int BASE_INDEX_OPTRISPI = 10000;
	
	/// Name of the camera (not necessarily unique if the system has multiple cameras of the same model!)
	stlcompat::String friendlyName;
	
	/**
	 * Camera image resolution (x=width, y=height).
	 * This is used as requested resolution in the IMetaioSDK::startCamera call,
	 * and is updated with actual resolution after a successful call
	 * \sa IMetaioSDK::startCamera
	 */
	metaio::Vector2di resolution;
	
	/**
	 * Camera FPS, if 0, the maximum available fps will be chosen.
	 * On Android and iOS, both x (min) and y (max) values are used,
	 * while on Windows only x is used as maximum FPS.
	 * This is used as requested FPS in the IMetaioSDK::startCamera call,
	 * and is updated with actual FPS after a successful call
	 * \sa IMetaioSDK::startCamera
	 */
	metaio::Vector2d fps;
	
	/**
	 * Downsample image for tracking, must be greater than 0.
	 * 1 meaning no downsampling / use original resolution
	 * This is only used as input for startCamera call.
	 * \sa IMetaioSDK::startCamera
	 */
	int downsample;
	
	/**
	 * YUV pipeline, only used as input for startCamera call.
	 * This is ignored on Windows and OSX because YUV pipeline can only be enabled on Android or iOS.
	 * \sa IMetaioSDK::startCamera
	 */
	bool yuvPipeline;
	
	/// Camera facing direction, FACE_BACK, FACE_FRONT or FACE_UNDEFINED.
	int facing;
	
	
	/// Flip camera image. This is only used as input for startCamera call.
	int flip;
	
	/// Create camera with default parameters
	Camera();
	
	/// Copy constructor
	Camera(const Camera& other);
	
	/// Assignment operator
	Camera& operator=(const Camera& other);
	
	stlcompat::String toString() const;
	
	/**
	 * Validate camera parameters
	 * \return true if parameters are valid
	 */
	bool validateParameters() const;
	
	/**
	 * Check if two camera parameters are equal
	 *
	 * \param other Camera to compare with
	 * \return true if both camera parameters are equal
	 */
	bool operator ==(const Camera& other) const;
};
	
} //namespace metaio

#endif //__AS_UNIFEYESDKMOBILE_CAMERA_H__
