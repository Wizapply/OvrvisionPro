// Copyright 2007-2013 metaio GmbH. All rights reserved.
#ifndef _DEVICEINFOIOS_H_
#define _DEVICEINFOIOS_H_

namespace metaio {

/**
 * Enumeration of iOS Devices
 */
enum E_IOS_DEVICETYPE
{
	EID_IPHONEOLD__UNSUPPORTED, // pre-3GS, not supported anymore
	EID_IPHONE3GS,
	EID_IPHONE4,
	EID_IPHONE4S,
	EID_IPHONE5,
	EID_IPHONE5C,
	EID_IPHONE5S,
	EID_IPAD__UNSUPPORTED, // unsupported, no camera
	EID_IPAD2,
	EID_IPAD3,
	EID_IPAD4,
	EID_IPADMINI,
	EID_IPADAIR,
	EID_IPADMINIRETINA,
	EID_IPODOLD__UNSUPPORTED, // unsupported, no camera
	EID_IPOD4,
	EID_IPOD5,
	EID_UNKNOWNIPHONE,
	EID_UNKNOWNIPAD,
	EID_UNKNOWNIPOD,
    EID_SIMULATOR   // simulator
};

/** 
 * Retrieve the current iOS device type
 * \return the device type of the current device. EID_UNKNOWN if its a new/unknown device
 */
E_IOS_DEVICETYPE getDeviceType();
	
/**
 * Returns true if the GPU of the device is capable of rendering
 * with advanced rendering features.
 * \return true if capable of performing advanced rendering, false otherwise
 * \sa isAdvancedRenderingSupported in com.metaio.tools.SystemInfo for Android
 */
bool isAdvancedRenderingSupported();

}

#endif