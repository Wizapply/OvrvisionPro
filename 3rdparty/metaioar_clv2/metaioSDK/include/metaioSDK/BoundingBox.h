// Copyright 2007-2013 metaio GmbH. All rights reserved.

#ifndef __BOUNDING_BOX_H__
#define __BOUNDING_BOX_H__

#include <metaioSDK/Dll.h>
#include <metaioSDK/Vector3d.h>

namespace metaio {
	
/**
 * BoundingBox of the geometry.
 */
struct METAIO_DLL_API BoundingBox
{
	Vector3d min;	///< Vector containing the minimum x,y,z values
	Vector3d max;	///< Vector containing the maximum x,y,z values
};
	
} //namespace metaio

#endif //__BOUNDING_BOX_H__
