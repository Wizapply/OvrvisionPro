// Copyright 2007-2013 metaio GmbH. All rights reserved.

#ifndef __CORRESPONDENCE_2D_3D_H__
#define __CORRESPONDENCE_2D_3D_H__

#include <metaioSDK/Dll.h>
#include <metaioSDK/Vector2d.h>
#include <metaioSDK/Vector3d.h>

namespace metaio {

/**
 * Struct for corresponding 2D and 3D points
 */
struct METAIO_DLL_API Correspondence2D3D
{
	Vector2d observedPoint;		///< observed 2D point (e.g. on the image screen)
	Vector3d referencePoint;	///< reference 3D point (e.g. point in world coordinates)
	
	Correspondence2D3D();
	
	/**
	 * Sets the initial coordinates of the correspondence
	 *
	 * \param[in] observed_x Coordinate in x of the 2D point
	 * \param[in] observed_y Coordinate in y of the 2D point
	 * \param[in] reference_x Coordinate in x of the 3D point
	 * \param[in] reference_y Coordinate in y of the 3D point
	 * \param[in] reference_z Coordinate in z of the 3D point
	 */
	Correspondence2D3D(float observed_x, float observed_y, float reference_x, float reference_y, float reference_z);
	
	/**
	 * Sets the initial coordinates of the correspondence
	 *
	 * \param[in] observed Observed point in 2D
	 * \param[in] reference Reference point in 3D
	 */
	Correspondence2D3D(const Vector2d& observed, const Vector3d& reference);
	
};

} //namespace metaio

#endif //__CORRESPONDENCE_2D_3D_H__
