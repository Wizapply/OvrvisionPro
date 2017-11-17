// Copyright 2007-2013 metaio GmbH. All rights reserved.
#ifndef _AS_SENSORVALUES_H_
#define _AS_SENSORVALUES_H_

#include <metaioSDK/LLACoordinate.h>
#include <metaioSDK/Rotation.h>
#include <metaioSDK/STLCompatibility.h>
#include <metaioSDK/Vector3d.h>

namespace metaio
{

/** Sensor reading with timestamp */
struct SensorReading
{ 
	double timestamp;	///< timestamp (in seconds since system boot)
	int accuracy;		///< accuracy - not yet really used (3 seems "good"...)
	Vector3d values;	///< Three floating point numbers from a sensor.
	                    ///< The interpretation depends on the sensor used.

	/** Default constructor */
	SensorReading(): timestamp(0.0), accuracy(0)
	{
	}

	// Sensor readings should be sorted by timestamp
	bool operator<(SensorReading const& rhs)
	{
		return timestamp < rhs.timestamp;
	}
};

/** An encapsulation of all the sensors' readings with corresponding time stamps */
struct SensorValues
{
	LLACoordinate location; ///< Device location. Needed: SENSOR_LOCATION
	
	Vector3d gravity; ///< Normalized gravity vector. Needed: SENSOR_GRAVITY
	double gravityTimestamp; ///< timestamp (in seconds since system boot)
	bool hasGravity() const { return gravityTimestamp > 0; }

	float heading; ///< Heading in degrees, 0=North, 90=East, 180=South. Needed: SENSOR_HEADING
	double headingTimestamp; ///< timestamp (in seconds since system boot)
	bool hasHeading() const { return headingTimestamp > 0; }

	metaio::Rotation attitude; ///< device attitude based on running sensors. Needed: SENSOR_ATTITUDE
	double attitudeTimestamp; ///< timestamp (in seconds since system boot)
	bool hasAttitude() const { return attitudeTimestamp > 0; }

	bool	deviceIsMoving; ///< Indicates if device is moving. Needed: SENSOR_DEVICE_MOVEMENT

	stlcompat::Vector<SensorReading> historicalGyroscopeVector;	///< Historical raw gyroscope values [rad/s] with timestamps in [s] Needed: SENSOR_DEVICE_GYROSCOPE
	stlcompat::Vector<SensorReading> historicalAccelerometerVector; ///< Historical raw accelerometer values [m/s^2] with timestamps in [s] Needed: SENSOR_DEVICE_ACCELEROMETER
	stlcompat::Vector<SensorReading> historicalMagnetometerVector; ///< Historical raw magnetometer values [microTesla] with timestamps [s] Needed: SENSOR_DEVICE_MAGNETOMETER

	/** Default constructor */
	SensorValues(): gravityTimestamp(0.0), heading(-1.0), headingTimestamp(0.0), attitudeTimestamp(0), deviceIsMoving(false)
	{
	}

	/** Copy constructor */
	SensorValues(const SensorValues& other);

	/** Assignment operator */
	SensorValues& operator=(const SensorValues& other);
};
}


#endif // _AS_SENSORVALUES_H_
