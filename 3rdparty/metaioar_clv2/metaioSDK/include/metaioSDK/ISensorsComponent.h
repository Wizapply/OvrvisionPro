// Copyright 2007-2013 metaio GmbH. All rights reserved.
#ifndef __AS_ISENSORSCOMPONENT_H__
#define __AS_ISENSORSCOMPONENT_H__

#include <metaioSDK/SensorValues.h>
#include <metaioSDK/STLCompatibility.h>

// TODO use small functions instead of these defines (metaio code guide...)
#define isLocationSensor(sensor)  \
	((sensor & metaio::ISensorsComponent::SENSOR_LOCATION) == metaio::ISensorsComponent::SENSOR_LOCATION)

#define isGravitySensor(sensor) \
	((sensor & metaio::ISensorsComponent::SENSOR_GRAVITY) == metaio::ISensorsComponent::SENSOR_GRAVITY)

#define isHeadingSensor(sensor) \
((sensor & metaio::ISensorsComponent::SENSOR_HEADING) == metaio::ISensorsComponent::SENSOR_HEADING)

#define isAttitudeSensor(sensor) \
((sensor & metaio::ISensorsComponent::SENSOR_ATTITUDE) == metaio::ISensorsComponent::SENSOR_ATTITUDE)

#define isUserAccelerationSensor(sensor) \
((sensor & metaio::ISensorsComponent::SENSOR_USER_ACCELERATION) == metaio::ISensorsComponent::SENSOR_USER_ACCELERATION)

#define isDeviceMovementSensor(sensor) \
((sensor & metaio::ISensorsComponent::SENSOR_DEVICE_MOVEMENT) == metaio::ISensorsComponent::SENSOR_DEVICE_MOVEMENT)

#define isDeviceAccelerationSensor(sensor) \
((sensor & metaio::ISensorsComponent::SENSOR_DEVICE_ACCELEROMETER) == metaio::ISensorsComponent::SENSOR_DEVICE_ACCELEROMETER)

#define isDeviceRotationSensor(sensor) \
((sensor & metaio::ISensorsComponent::SENSOR_DEVICE_GYROSCOPE) == metaio::ISensorsComponent::SENSOR_DEVICE_GYROSCOPE)

#define isDeviceMagnetometerSensor(sensor) \
((sensor & metaio::ISensorsComponent::SENSOR_DEVICE_MAGNETOMETER) == metaio::ISensorsComponent::SENSOR_DEVICE_MAGNETOMETER)


namespace metaio
{

/** Interface for sensors like location, gravity and compass sensors. The return values from
 *	the getter function must be consistent with the coordinate system used in the metaio SDK.
 *	See explicit getter function for more information.
 *
 * \anchor ISensorsComponent
 */
class METAIO_DLL_API ISensorsComponent
{
public:


	static const int SENSOR_NONE =					0 << 0;		///< No sensor
	static const int SENSOR_LOCATION =				1 << 0;		///< Location (or GPS) sensor
	static const int SENSOR_GRAVITY =				1 << 1;		///< Gravity (or accelerometer) sensor
	static const int SENSOR_HEADING =				1 << 2;		///< Orientation (or Compass or Magnetic) sensor
	static const int SENSOR_ATTITUDE =				1 << 3;		///< Device attitude based on different sensors that are running
	static const int SENSOR_USER_ACCELERATION =		1 << 4;		///< Acceleration applied to the device by the user,
																///<    (earth's gravity is missing)
	static const int SENSOR_DEVICE_MOVEMENT	=		1 << 5;		///< Is the device moving at the moment
	static const int SENSOR_DEVICE_ACCELEROMETER =	1 << 6; 	///< Acceleration as measured by the accelerometers,
																///< in [m/s^2] and in coordinate frame of camera pose.
																///< It includes the gravity (9.81m/s).
	static const int SENSOR_DEVICE_GYROSCOPE =		1 << 7; 	///< Gyroscope raw data, in [deg/s] and coordinate frame
																///< of camera pose.
	static const int SENSOR_DEVICE_MAGNETOMETER =	1 << 8; 	///< Magnetometer raw data, in [microTesla/s] and
																///< coordinate frame of camera pose.
	// TODO: Add more sensor types as needed here, e.g. Light, Pressure, Temperature etc..
	static const int SENSOR_ALL =				0xFFFF;		///< All sensors


	/** Default constructor.
	 */
	ISensorsComponent() {};

	/** Destructor.
	 */
	virtual ~ISensorsComponent() {};

	/** Start the given sensors
	 *
	 * \param sensors Sensors to start (see ESENSOR)
	 * \return sensors that are actually started
	 * \sa stop
	 */
	virtual int start(int sensors) = 0;

	/** Stop the given sensors
	 *
	 * \param sensors Sensors to stop (default is all sensors, i.e. SENSOR_ALL)
	 * \return sensors that are actually stopped
	 * \sa start
	 */
	virtual int stop(int sensors = SENSOR_ALL) = 0;

	/**
	* Set manual LLA location, all updates from location service will
	* be ignore after this call
	*
	* \param location Manual location
	* \sa resetManualLocation
	*/
	virtual void setManualLocation(const metaio::LLACoordinate& location) {};

	/**
	 * Reset the manual LLA location again.
	 *
	 * \sa setManualLocation
	 */
	virtual void resetManualLocation() {};

	/** Get location provided by the location sensor
	 *
	 * \return location as LLA coordinates
	 */
	virtual LLACoordinate getLocation() const = 0;

	/** Gets the gravity values provided in the metaio camera coordinate system used by metaioSDK.
	 *	The metaio camera-COS is defined as follows: if the device is hold in landscape mode
	 *	with button to the right and the touch screen facing you, then the positive X-axis points
	 *	right, the positive Y-axis points up and the positive Z-axis points to you
	 *	 ________________________________________
	 *	|  ________________________________      |
	 *	| |								   |     |
	 *	| |				^ Y				   |     |
	 *	| |			    |				   |     |
	 *	| |			   \|				   |     |
	 *	| |			   -|-----> X		   | O   |
	 *	| |				 \				   |     |
	 *	| |				  \				   |     |
	 *	| |				   v Z			   |     |
	 *	| |________________________________|     |
	 *	|________________________________________|
	 *
	 *  This means:
	 *	If device is hold:							=>		then the gravity vector is:
	 *		landscape button right					=>		 0 -1  0
	 *		landscape button left					=>		 0 +1  0
	 *		portrait button down					=>		+1  0  0
	 *		portrait button up						=>		-1  0  0
	 *		lying horizontal with screen facing up	=>		 0  0 -1
	 *		lying horizontal with screen facing down=>		 0  0 +1
	 *
	 * \return Vector containing the last reading
	 */
	virtual Vector3d getGravity() const = 0;


	/** Get the device heading (or compass)
	 *
	 * \return Heading in degrees
	 */
	virtual float getHeading() const = 0;

	/**
	 * Read all sensor values.
	 * The sensor values are returned in the metaio camera coordinate system used by metaio SDK.
	 *	The metaio camera-COS is defined as follows: if the device is hold in landscape mode
	 *	with button to the right and the touch screen facing you, then the positive X-axis points
	 *	right, the positive Y-axis points up and the positive Z-axis points to you
	 *	 ________________________________________
	 *	|  ________________________________      |
	 *	| |								   |     |
	 *	| |				^ Y				   |     |
	 *	| |			    |				   |     |
	 *	| |			   \|				   |     |
	 *	| |			   -|-----> X		   | O   |
	 *	| |				 \				   |     |
	 *	| |				  \				   |     |
	 *	| |				   v Z			   |     |
	 *	| |________________________________|     |
	 *	|________________________________________|
	 *
	 *  This means:
	 *	If device is hold:							=>		then the gravity vector is:
	 *		landscape button right					=>		 0 -1  0
	 *		landscape button left					=>		 0 +1  0
	 *		portrait button down					=>		+1  0  0
	 *		portrait button up						=>		-1  0  0
	 *		lying horizontal with screen facing up	=>		 0  0 -1
	 *		lying horizontal with screen facing down=>		 0  0 +1
	 *
	 * The values may be invalid if the required sensors are not
	 * running or started
	 *
	 * \return sensor values
	 */
	virtual SensorValues getSensorValues() = 0;
	
	
	/** Returns the last sensor values (i.e. belonging to the last camera image captured);
	 * \return The last sensor values.
	 * \sa getSensorValues for semantics.
	 */
	virtual SensorValues getLastSensorValues() const {return SensorValues();};
	


};


/** The factory will create a device independent ISensorsComponent
*/
METAIO_DLL_API ISensorsComponent* CreateSensorsComponent();
}

#endif
