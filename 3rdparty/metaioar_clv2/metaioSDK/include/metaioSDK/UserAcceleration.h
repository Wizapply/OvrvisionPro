// Copyright 2007-2013 metaio GmbH. All rights reserved.

#ifndef __USER_ACCELERATION_H__
#define __USER_ACCELERATION_H__

#include <metaioSDK/Dll.h>

namespace metaio {
	
/**
 * User-defined acceleration vector with timestamp
 */
struct UserAcceleration
{
	double				timestamp; ///< Timestamp
	
	metaio::Vector3d	acceleration; ///< Acceleration vector
};
	
} //namespace metaio

#endif //__USER_ACCELERATION_H__
