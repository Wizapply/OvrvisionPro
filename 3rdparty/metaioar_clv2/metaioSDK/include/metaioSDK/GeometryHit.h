// Copyright 2007-2013 metaio GmbH. All rights reserved.

#ifndef __GEOMETRY_HIT_H__
#define __GEOMETRY_HIT_H__

#include <metaioSDK/Dll.h>
#include <metaioSDK/Vector3d.h>

namespace metaio {

class IGeometry;
	
/// Defines geometry and coordinates of a picked geometry (used e.g. by getAllGeometriesFromViewportCoordinates)
struct METAIO_DLL_API GeometryHit
{
	/// Picked geometry
	IGeometry*				geometry;
	
	/**
	 * Position in coordinates of the geometry's COS where the ray hit the geometry
	 *
	 * Only valid if you set useTriangleTest parameter to true when calling
	 * getAllGeometriesFromViewportCoordinates. Otherwise this value is undefined.
	 */
	Vector3d				cosCoordinates;
	
	/**
	 * Position in object coordinates where the ray hit the geometry
	 *
	 * Only valid if you set useTriangleTest parameter to true when calling
	 * getAllGeometriesFromViewportCoordinates. Otherwise this value is undefined.
	 */
	Vector3d				objectCoordinates;
	
	/// Constructor
	GeometryHit();
};
	
} //namespace metaio

#endif //__GEOMETRY_HIT_H__
