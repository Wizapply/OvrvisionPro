// Copyright 2007-2013 metaio GmbH. All rights reserved.
#ifndef _AS_TRACKINGVALUES_H_
#define _AS_TRACKINGVALUES_H_

#include <metaioSDK/LLACoordinate.h>
#include <metaioSDK/Rotation.h>
#include <metaioSDK/STLCompatibility.h>
#include <metaioSDK/Vector3d.h>

namespace metaio
{
/**
 * The tracking states of a target.
 *
 * The state of a target usually starts with ETS_NOT_TRACKING.
 * When it is found in the current camera image, the state change to
 * ETS_FOUND for one image, the following images where the location of the
 * target is successfully determined will have the state ETS_TRACKING.
 *
 * Once the tracking is lost, there will be one single frame ETS_LOST, then
 * the state will be ETS_NOT_TRACKING again. In case there is extrapolation 
 * of the pose requested, the transition may be from ETS_TRACKING to ETS_EXTRAPOLATED.
 *
 * To sum up, these are the state transitions to be expected:
 *  ETS_NOT_TRACKING -> ETS_FOUND 
 *  ETS_FOUND        -> ETS_TRACKING
 *  ETS_TRACKING     -> ETS_LOST
 *  ETS_LOST         -> ETS_NOT_TRACKING
 *
 * With additional extrapolation, these transitions can occur as well:
 *  ETS_TRACKING     -> ETS_EXTRAPOLATED
 *  ETS_EXTRAPOLATED -> ETS_LOST
 *
 * "Event-States" do not necessarily correspond to a complete frame but can be used to 
 * flag individual tracking events or replace tracking states to clarify their context:
 *  ETS_NOT_TRACKING -> ETS_REGISTERED -> ETS_FOUND for edge based initialization
 *
 * The methods like SLAM need an initialization phase (e.g. requiring the user to do a special
 * movement). This phase can also go wrong, and then the user of the SDK can re-start the 
 * initialization phase completely.
 *  ETS_NOT_TRACKING -> ETS_INITIALIZATION_FAILED
 *  ETS_TRACKING -> ETS_INITIALIZATION_FAILED
 */
enum ETRACKING_STATE
{
	ETS_UNKNOWN		 = 0,	///< Tracking state is unknown
    ETS_NOT_TRACKING = 1,	///< Not tracking
	ETS_TRACKING	 = 2,	///< Tracking
	ETS_LOST		 = 3,	///< Target lost
	ETS_FOUND		 = 4,	///< Target found
	ETS_EXTRAPOLATED = 5,	///< Tracking by extrapolating
	ETS_INITIALIZED	 = 6,	///< The tracking configuration has just been loaded.

 	ETS_REGISTERED	 = 7,	///< Event-State: Pose was just registered for tracking
    ETS_INITIALIZATION_FAILED = 8 ///< e.g. SLAM initialization failed
};

/** Static helper class for conversion to/from ETRACKING_STATE.
*
* \note Needs to be updated when \a ETRACKING_STATE is modified!
*/
class TrackingState
{
  public: 

	/** Converts an int value to an \a ETRACKING_STATE by checked type casting.
	*
	* \param state the index of the state enum value
	* \param outValidState optional output flag that is set true if the index is valid and false if it is out of bounds
	* \return the converted state, or ETS_UNKNOWN if state index is out of bounds
	*/
	static ETRACKING_STATE intToTrackingState(int state, bool* outValidState = 0);

	/** Converts a string value to an \a ETRACKING_STATE.
	*
	* \param state the state as upper-case string of the enum value name (e.g. "ETS_FOUND")
	* \param outValidState optional output flag that is set true if the string is valid (corresponds to an enum value), false if not
	* \return  converted state, or "ETS_UNKNOWN" if the string is invalid 
	*/
	static ETRACKING_STATE stringToTrackingState(const std::string& state, bool* outValidState = 0);
	/** Converts an \a ETRACKING_STATE to a string.
	*
	* \param state the tracking state to convert
	* \return upper-case string of the enum value name (e.g. "ETS_FOUND")
	*/
	static std::string trackingStateToString(ETRACKING_STATE state);
};

/** 
 * This class encapsulates complete tracking state of the system.
 */
class METAIO_DLL_API TrackingValues
{
public:

	/**
	 * Create with default values
	 */
	TrackingValues();

	/**
	 * Destructor
	 */
	~TrackingValues();

	/** 
	 * Create TrackingValues with given translation, rotation, quality,
	 * coordinate system ID and name.
	 *
	 * \param tx Translation in x direction
	 * \param ty Translation in y direction
	 * \param tz Translation in z direction
	 * \param q1 First component of the rotation quaternion
	 * \param q2 Second component of the rotation quaternion
	 * \param q3 Third component of the rotation quaternion
	 * \param q4 Fourth component of the rotation quaternion
	 * \param quality Value between 0 and 1 defining the tracking
	 *	quality. (1=tracking, 0=not tracking)
	 * \param cosID the coordinate system ID
	 * \param cosName Name of the coordinate system.
	 */
	TrackingValues(float tx, float ty, float tz, float q1, float q2,
	               float q3, float q4, float quality, int cosID, const stlcompat::String& cosName);

	/// Copy constructor
	TrackingValues(const TrackingValues& other);

	/// Assignment operator
	TrackingValues& operator= (const TrackingValues& other);

	ETRACKING_STATE			state;			///< The state of the tracking values

	Vector3d                translation;	///< Translation component of the pose
	Rotation                rotation;		///< Rotation component of the pose
	LLACoordinate           llaCoordinate;	///< Set if the sensors provides a geo position

	/** 
	 * Quality of the tracking values.
	 * Value between 0 and 1 defining the tracking quality.
	 * A higher value means better tracking results. More specifically:
	 * - 1 means the system is tracking perfectly.
	 * - 0 means that we are not tracking at all.
	 *
	 * In the case of marker-based tracking, the quality values behave a bit
	 * different:
	 * - If tracking is unsuccessful, the quality will be 0.
	 * - If tracking results are coming from a fuser, the quality will be 0.5.
	 * - If the system is tracking successfully, the quality will be between
	 *   0.5 and 1.
	 */
	float				quality;

	double				timeElapsed;				///< Time elapsed (in ms) since last state change of the tracking system
	double				trackingTimeMs;				///< Time (in milliseconds) used for tracking the respective frame
	int					coordinateSystemID;			///< The ID of the coordinate system
	stlcompat::String	cosName;                    ///< The name of the coordinate system (configured via Connection/COS/Name)
	stlcompat::String	additionalValues;           ///< Extra space for information provided by a sensor that cannot be expressed with translation and rotation properly.
	stlcompat::String	sensor;                     ///< The sensor that provided the values

	/** 
	 * Determine if a state means that its tracking or not
	 * \return true, if the current state represents a state, that is tracking
	 */
	bool isTrackingState() const;

	/**
	 * Get inverse translation based on current pose
	 * \return Inverse translation vector
	 */
	metaio::Vector3d getInverseTranslation() const;

	/** 
	 * Determine if a state means that its tracking or not
	 *
	 * \param state the state to check for
	 * \return true, if the state represents a state, that is tracking
	 */
	static inline bool isTrackingState(ETRACKING_STATE state)
	{
		return (state == ETS_FOUND || state == ETS_TRACKING || state == ETS_EXTRAPOLATED);
	}
};
}


#endif
