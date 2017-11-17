// Copyright 2007-2014 metaio GmbH. All rights reserved.
#ifndef _AS_IANNOTATEDGEOMETRIESGROUP_H_
#define _AS_IANNOTATEDGEOMETRIESGROUP_H_

#include <metaioSDK/SensorValues.h>
#include <metaioSDK/Vector2d.h>

namespace metaio
{
class IGeometry;

enum EGEOMETRY_FOCUS_STATE
{
	/// Out of the focus area
	EGFS_UNFOCUSED = 0,
	/// In the focus area
	EGFS_FOCUSED,
	/// Tapped by user, does not get reset to the other states automatically
	EGFS_SELECTED
};


/// Interface for IAnnotatedGeometriesGroup events and callbacks
class IAnnotatedGeometriesGroupCallback
{
public:
	virtual ~IAnnotatedGeometriesGroupCallback() {}

	/**
	 * Callback should load an annotation or update an existing one.
	 *
	 * If a different pointer than existingAnnotation is returned, the callback implementation is
	 * responsible for destroying the old annotation geometry (just as with
	 * IAnnotatedGeometriesGroup::removeGeometry).
	 *
	 * If NULL is returned, the current annotation is removed from the geometry and won't be
	 * displayed any longer.
	 *
	 * Always called in renderer thread.
	 *
	 * \param geometry Geometry as passed to IAnnotatedGeometriesGroup::addGeometry
	 * \param userData Parameter as passed to IAnnotatedGeometriesGroup::addGeometry
	 * \param existingAnnotation Instance of a previously created annotation, if any (in case of
	 *                           update operation)
	 * \return Annotation instance, or NULL if application doesn't want to load one or on error
	 */
	virtual IGeometry* loadUpdatedAnnotation(IGeometry* geometry, void* userData, IGeometry* existingAnnotation) = 0;

	/**
	 * Focus state of a geometry changed (and thus its annotation's visibility).
	 *
	 * Always called in renderer thread.
	 *
	 * \param geometry Geometry as passed to IAnnotatedGeometriesGroup::addGeometry
	 * \param userData Parameter as passed to IAnnotatedGeometriesGroup::addGeometry
	 * \param oldState Previous state
	 * \param newState New state
	 */
	virtual void onFocusStateChanged(IGeometry* geometry, void* userData,
		EGEOMETRY_FOCUS_STATE oldState, EGEOMETRY_FOCUS_STATE newState) {}

	/**
	 * Distance of the geometry updated. Can be used to update geometry attributes like
	 * scale/rotation or trigger other actions.
	 *
	 * Translation updates are only recognized in the next frame.
	 *
	 * Always called in renderer thread.
	 *
	 * \param geometry Geometry as passed to IAnnotatedGeometriesGroup::addGeometry
	 * \param userData Parameter as passed to IAnnotatedGeometriesGroup::addGeometry
	 * \param distance Distance in meters
	 * \param sensorValues Current sensor values
	 * \param geoPosInViewport Viewport pixel coordinate of the origin of geometry
	 */
	virtual void onGeometryDistanceUpdated(IGeometry* geometry, void* userData, float distance,
		const SensorValues& sensorValues, const Vector2d& geoPosInViewport) {};
};


/**
 * Replacement for IBillboardGroup which places geometries at their real location. Additionally
 * manages their selection via focusing the most central geometries in the camera image.
 * Furthermore, annotations are managed for each geometry.
 *
 * Note the difference between the terms "geometry" and "annotation" throughout the method names.
 * "Geometries" are the geometries placed in 3D space (e.g. at a POI's LLA coordinates), while
 * annotations' positions are determined by the implementation and aligned in 2D screen space.
 */
class IAnnotatedGeometriesGroup
{
public:
	virtual ~IAnnotatedGeometriesGroup() {}

	/**
	 * Adds geometry to the group
	 *
	 * \param geometry Geometry to add. A geometry pointer may not be added twice (leads to error).
	 *                 Caller is responsible for removing the geometry and destroying it.
	 * \param userData Will be passed to callback along with the geometry pointer
	 * \return True on success, false if geometry could not be added
	 */
	virtual bool addGeometry(IGeometry* geometry, void* userData) = 0;

	/**
	 * Get annotation currently associated with a geometry
	 *
	 * Not thread-safe. It is recommended to not call this while other SDK functions are called
	 * (such as rendering).
	 *
	 * \param geometry	Geometry for which to retrieve the associated annotation
	 * \return			Associated annotation, or NULL if none associated or if geometry not
	 *					contained in the group
	 */
	virtual IGeometry* getAnnotationForGeometry(IGeometry* geometry) = 0;

	/**
	 * Sets or unsets the callback
	 *
	 * \param callback Callback implementation or NULL to unset it
	 */
	virtual void registerCallback(IAnnotatedGeometriesGroupCallback* callback) = 0;

	/**
	 * Removes geometry from the group.
	 *
	 * Caller is responsible for destroying both the geometry and its annotation (which is not used
	 * anymore by this class after this call) after calling this method!
	 *
	 * \param geometry Geometry to remove
	 */
	virtual void removeGeometry(IGeometry* geometry) = 0;

	/**
	 * Sets padding to add between bottom of viewport and bottom row of annotations
	 *
	 * This is helpful if you want to add user interface elements to the bottom of the viewport.
	 *
	 * \param value Absolute padding in pixels
	 */
	virtual void setBottomPadding(unsigned int value) = 0;

	/**
	 * Sets the selected geometry
	 *
	 * There can only be one selected geometry - or none.
	 *
	 * This call will immediately trigger IAnnotatedGeometriesGroupCallback::onFocusStateChanged.
	 * If there was a selected geometry, its state changes from EGFS_SELECTED to either EGFS_FOCUSED
	 * or EGFS_UNFOCUSED. The newly assigned selected geometry (if any) will change its state to
	 * EGFS_SELECTED.
	 *
	 * If the geometry is already selected, this method does nothing at all (no callback
	 * triggered).
	 *
	 * \param geometry Geometry that should be the selected one, or NULL to deselect any existing
	 *                 selection. This must be the same geometry pointer as passed into addGeometry
	 *                 (not the annotation instance!).
	 */
	virtual void setSelectedGeometry(IGeometry* geometry) = 0;

	/**
	 * Triggers an update of the annotation of the specified geometry (e.g. if location changed and
	 * annotation text or information needs to be changed)
	 *
	 * May be implemented asychronously, i.e. the annotation update callback will only be called
	 * from the next update() call instead of immediately. (But: Method is not thread-safe.)
	 *
	 * \param geometry Geometry whose associated annotation should be updated
	 */
	virtual void triggerAnnotationUpdate(IGeometry* geometry) = 0;
};

}

#endif
