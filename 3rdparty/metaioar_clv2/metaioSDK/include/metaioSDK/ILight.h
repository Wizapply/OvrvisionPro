// Copyright 2007-2013 metaio GmbH. All rights reserved.
#ifndef _METAIOSDK_ILIGHT_H_
#define _METAIOSDK_ILIGHT_H_

#include <metaioSDK/Vector3d.h>

namespace metaio
{

/**
 * Light type
 *
 * Numeric values are passed to fragment shader in the uniform "int metaio_intv_lightTypes[]".
 */
enum ELIGHT_TYPE
{
	/// Infinite directional light (only direction used)
	ELIGHT_TYPE_DIRECTIONAL = 0,

	/// Point light that shines in all directions (position and attenuation are used)
	ELIGHT_TYPE_POINT = 1,

	/**
	 * Spot light defined by a maximum radiated angle and a exponent for the light strength depending
	 * on the angle between normal and light direction (position, direction, attenuation, outer
	 * cone radius used)
	 */
	ELIGHT_TYPE_SPOT = 2
};


/**
 * Interface for dynamic lights
 */
class ILight
{
public:
	virtual ~ILight() {};

	/**
	 * Get ambient color
	 *
	 * \return RGB color in range [0;1]
	 */
	virtual Vector3d getAmbientColor() const = 0;

	/**
	 * Get constant, linear and quadratic attenuation factors
	 */
	virtual Vector3d getAttenuation() const = 0;

	/**
	 * Get the index of the coordinate system (COS) assigned to the light
	 *
	 * \sa setCoordinateSystemID
	 * \return int Coordinate system ID
	 */
	virtual int getCoordinateSystemID() const = 0;

	/**
	 * Get diffuse color
	 *
	 * \return RGB color in range [0;1]
	 */
	virtual Vector3d getDiffuseColor() const = 0;

	/**
	 * Get light direction
	 *
	 * \return Vector describing the light direction (not a target position!)
	 * \sa setDirection
	 */
	virtual Vector3d getDirection() const = 0;

	/**
	 * Get radius.
	 *
	 * Only valid for spot lights.
	 *
	 * \return float Radius in radians
	 */
	virtual float getRadiusDegrees() const = 0;

	/**
	 * Get radius.
	 *
	 * Only valid for spot lights.
	 *
	 * \return float Radius in radians
	 */
	virtual float getRadiusRadians() const = 0;

	/**
	 * Retrieve position relative to light's coordinate system
	 */
	virtual Vector3d getTranslation() const = 0;

	/**
	 * Get light type
	 */
	virtual ELIGHT_TYPE getType() const = 0;

	/**
	 * Check if the light is enabled
	 */
	virtual bool isEnabled() const = 0;

	/**
	 * Set ambient color
	 *
	 * \param color RGB color in range [0;1]
	 */
	virtual void setAmbientColor(const Vector3d& color) = 0;

	/**
	 * Set constant, linear and quadratic attenuation.
	 *
	 * Only valid for point and spot lights, not for directional lights. Note that the SDK uses
	 * millimeters as unit, so the attenuation should be set accordingly. The formula for the
	 * light factor is 1 / (attenuation.X + attenuation.Y*distMM + attenuation.Z*distMM*distMM).
	 *
	 * \param attenuation Constant, linear and quadratic attenuation (stored in XYZ values)
	 */
	virtual void setAttenuation(const Vector3d& attenuation) = 0;

	/**
	 * Assigns light to a coordinate system.
	 *
	 * Just like geometries, lights can be assigned either to the camera's coordinate system (COS 0,
	 * origin is the real camera, -Z axis facing the viewing direction) or a tracked coordinate
	 * system (COS 1 or greater, origin is the middle of the marker or tracked object).
	 *
	 * \param coordinateSystemID Coordinate system ID
	 * \sa getCoordinateSystemID
	 */
	virtual void setCoordinateSystemID(int coordinateSystemID) = 0;

	/**
	 * Set diffuse color
	 *
	 * \param color RGB color in range [0;1]
	 */
	virtual void setDiffuseColor(const Vector3d& color) = 0;

	/**
	 * Set light direction.
	 *
	 * Only valid for spot and directional lights.
	 *
	 * \param direction Vector describing the direction (not a target position!)
	 */
	virtual void setDirection(const Vector3d& direction) = 0;

	/**
	 * Enable/disable the light.
	 *
	 * \param enable Whether the light should be enabled or disabled
	 */
	virtual void setEnabled(bool enable) = 0;

	/**
	 * Set radius.
	 *
	 * Only valid for spot lights.
	 *
	 * \param radius Radius in radians
	 */
	virtual void setRadiusDegrees(float radius) = 0;

	/**
	 * Set radius.
	 *
	 * Only valid for spot lights.
	 *
	 * \param radius Radius in radians
	 */
	virtual void setRadiusRadians(float radius) = 0;

	/**
	 * Set position relative to light's coordinate system (right-handed coordinates: X=right, Y=up,
	 * Z=forward)
	 */
	virtual void setTranslation(const Vector3d& translation, bool concat = false) = 0;

	/**
	 * Set light type
	 */
	virtual void setType(ELIGHT_TYPE type) = 0;
};

} // end of namespace metaio

#endif
