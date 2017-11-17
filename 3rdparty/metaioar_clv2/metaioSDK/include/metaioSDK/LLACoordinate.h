// Copyright 2007-2013 metaio GmbH. All rights reserved.

#ifndef __LLA_COORDINATE_H__
#define __LLA_COORDINATE_H__

#include <metaioSDK/Dll.h>

namespace metaio {

/**
 * Structure that defines a GPS coordinate.
 */
struct METAIO_DLL_API LLACoordinate
{
	double latitude;	///< Latitude in degrees
	double longitude;	///< Longitude in degrees
	double altitude;	///< Altitude in meters
	double accuracy;	///< Accuracy of the GPS position in meters
	double timestamp;	///< Timestamp when the coordinates were valid (in seconds since system boot)
	
	/**
	 * Default constructor
	 */
	LLACoordinate();
	
	/**
	 * Create and initialize LLACoordinate to the given values
	 * \param _lat	latitude component
	 * \param _long	longitude component
	 * \param _alt	altitude component
	 * \param _acc	accuracy component
	 */
	LLACoordinate(double _lat, double _long, double _alt, double _acc);
	
	/**
	 * Create and initialize LLACoordinate to the given values
	 * \param _lat	latitude component
	 * \param _long	longitude component
	 * \param _alt	altitude component
	 * \param _acc	accuracy component
	 * \param _tms	timestamp
	 */
	LLACoordinate(double _lat, double _long, double _alt, double _acc, double _tms);
	
	/**
	 * Determine if location is invalid (null)
	 * \return true if invalid, else false
	 * \sa setNull
	 */
	bool isNull() const;
	
	/**
	 * Set location to invalid, i.e. all fields to zero
	 * \sa isNull
	 */
	void setNull();
	
	/**
	 * Get approximate distance between this and the target coordinate in meters
	 * \param target Target LLACoordinate
	 *
	 * \return Approximate distance in meters between two locations
	 * \sa bearingTo
	 */
	double distanceTo(const LLACoordinate& target) const;
	
	/**
	 * Get approximate bearing (in degrees East of North) between this and the target coordinate
	 * when travelled along the shortest path.
	 *
	 * \param target Target LLACoordinate
	 * \return Approximate bearing in degrees East of North between two locations
	 * \sa distanceTo
	 */
	float bearingTo(const LLACoordinate& target) const;
	
	/**
	 * Add offset to the location. The offset is specified by the bearing and distance of the
	 * shortest path to the target location.
	 *
	 * Note that altitude of the resultant location is not updated, while timestamp and accuracy is
	 * copied from source location.
	 *
	 * \param bearing Bearing in degrees East of North
	 * \param distance Distance in meters
	 * \return LLACoordinate representing new location.
	 */
	LLACoordinate addOffset(const double bearing, const double distance) const;
	
	/**
	 * Determine if the two LLACoordinates are equal, this does not compare
	 * timestamps
	 *
	 * \param rhs LLACoordinates to compare with
	 * \return true if they are equal
	 */
	bool operator==(const LLACoordinate& rhs) const;
	
	/**
	 * Determine if the two LLACoordinates are not equal, this does not compare
	 * timestamps
	 *
	 * \param rhs LLACoordinates to compare with
	 * \return true if they are not equal
	 */
	bool operator!=(const LLACoordinate& rhs) const;
};

} //namespace metaio

#endif //__LLA_COORDINATE_H__
