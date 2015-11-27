// Copyright 2007-2013 metaio GmbH. All rights reserved.

#ifndef __SCREEN_ROTATION_H__
#define __SCREEN_ROTATION_H__

#include <metaioSDK/Dll.h>

namespace metaio {

/**
 * Screen rotations.
 *
 * This enumeration is used to inform Mobile SDK about
 * camera image rotation needed to compensate for current screen
 * rotation w.r.t. it's natural rotation.
 *
 * For example if the screen is naturally set to Landscape orientation,
 * and device is rotated to Portrait inverted orientation, then an angle
 * of 90 degrees is required to compensate this.
 */
enum ESCREEN_ROTATION
{
	/// No rotation, natural screen orientation (Landscape (Left) by default)
	ESCREEN_ROTATION_0,
	
	/// 90 degrees, by default Portrait Inverted orientation
	ESCREEN_ROTATION_90,
	
	/// 180 degrees, by default Landscape Inverted (Right) orientation
	ESCREEN_ROTATION_180,
	
	/// 270 degrees, by default Portrait orientation
	ESCREEN_ROTATION_270,
};

	
} //namespace metaio

#endif //__SCREEN_ROTATION_H__
