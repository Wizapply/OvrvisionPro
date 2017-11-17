// Copyright 2007-2013 metaio GmbH. All rights reserved.
#ifndef __AS_IGEOMETRY_H_INCLUDED__
#define __AS_IGEOMETRY_H_INCLUDED__

#include <metaioSDK/BoundingBox.h>
#include <metaioSDK/ColorFormat.h>
#include <metaioSDK/ImageStruct.h>
#include <metaioSDK/LLACoordinate.h>
#include <metaioSDK/Rotation.h>
#include <metaioSDK/STLCompatibility.h>

namespace metaio
{

/// Enumeration to encode the type of a geometry
enum EGEOMETRY_TYPE
{
    EGEOMETRY_TYPE_3D,					///< A 3D model
    EGEOMETRY_TYPE_BILLBOARD,			///< Billboard
    EGEOMETRY_TYPE_PLANE,				///< A 3D plane
	EGEOMETRY_TYPE_RADAR,				///< Radar
    EGEOMETRY_TYPE_UNKNOWN				///< Unknown geometry type
};

/**
 * Movie texture playback status
 */
enum EPLAYBACK_STATUS
{
	EPLAYBACK_STATUS_ERROR = 0,			///< not a movie texture or failed to load/play
	EPLAYBACK_STATUS_PLAYING = 1,		///< currently playing
	EPLAYBACK_STATUS_PAUSED = 2,		///< playing, but currently paused
	EPLAYBACK_STATUS_STOPPED = 3		///< playback stopped
};

/**
 * Renderoptions that can be set per geometry
 */
enum ERENDER_OPTION
{
	ERENDEROPTION_BACKFACECULLING,
	ERENDEROPTION_FRONTFACECULLING,
	ERENDEROPTION_ZWRITE,
	ERENDEROPTION_ZTEST,
	ERENDEROPTION_COLORMASK,
	ERENDEROPTION_DEBUGDATA
};

/**
 * Enum values for enabling/disabling color planes for rendering
 * to be used with ERENDEROPTION
 */
enum ECOLOR_MASK
{
	ECM_NONE=0,		///< No color enabled
	ECM_ALPHA=1,	///< Alpha enabled
	ECM_RED=2,		///< Red enabled
	ECM_GREEN=4,	///< Green enabled
	ECM_BLUE=8,		///< Blue enabled
	ECM_RGB=14,		///< All colors, no alpha
	ECM_ALL=15		///< All planes enabled
};

/**
 * Flags determining which debug visualizations are used
 */
enum EDEBUG_VISIBILITY
{
	EDV_OFF = 0,				///< No Debug Data
	EDV_BBOX = 1,				///< Show Bounding Boxes of SceneNode
	EDV_NORMALS = 2,			///< Show Vertex Normals (not working for hardware skinned models)
	EDV_MESH_WIRE_OVERLAY = 8,	///< Overlays Mesh Wireframe (not working for hardware skinned models)
	EDV_BBOX_BUFFERS = 32,		///< Show Bounding Boxes of all MeshBuffers (not working for hardware skinned models)
	EDV_BBOX_ALL = EDV_BBOX | EDV_BBOX_BUFFERS, ///< EDS_BBOX | EDS_BBOX_BUFFERS
	EDV_FULL = EDV_BBOX_ALL | EDV_NORMALS | EDV_MESH_WIRE_OVERLAY 		///<  Show all debug infos
};

/**
 * Movie texture status
 */
struct MovieTextureStatus
{
	EPLAYBACK_STATUS playbackStatus;	///< Playback status
	float currentPosition;				///< Current playback position in seconds
	bool looping;						///< Whether playback should loop

	/**
	 * Constructor
	 */
	MovieTextureStatus(): playbackStatus(EPLAYBACK_STATUS_ERROR), currentPosition(0.f), looping(false) {}
};


/**
 * To be used to set vertex shader and fragment shader constants. An instance of this interface will
 * be passed to your IShaderMaterialOnSetConstantsCallback callback.
 *
 * \sa IShaderMaterialOnSetConstantsCallback
 */
class IShaderMaterialSetConstantsService
{
public:
	virtual ~IShaderMaterialSetConstantsService() {}

#ifndef DOXYGEN_SHOULD_SKIP_THIS
	// Float parameters expected to be 32-bit
	METAIOSDK_CPP11_STATIC_ASSERT(sizeof(float) == 4, "Unexpected sizeof(float)");
#endif

	/**
	 * Sets a vertex/fragment shader uniform from one or more float values
	 *
	 * \param uniformName Name of the constant as declared in your fragment shader
	 * \param floatArray Floating-point value(s)
	 * \param count Number of values in floatArray (e.g. 1 for a float variable, 4 for vec4, 16 for mat4)
	 */
	virtual void setShaderUniformF(const stlcompat::String& uniformName, const float* floatArray,
		unsigned int count) = 0;
};


/**
 * Callback interface used to set own shader constants (uniforms)
 */
class IShaderMaterialOnSetConstantsCallback
{
public:
	virtual ~IShaderMaterialOnSetConstantsCallback() {}

	/**
	 * Called before rendering. Use this to set your own shader constants.
	 *
	 * \param shaderMaterialName Name of the shader material in use 
	 * \param extra In case you've attached this callback interface to an IGeometry instance, this
	 *              points to the IGeometry
	 * \param constantsService Use this instance to set shader constants
	 */
	virtual void onSetShaderMaterialConstants(const stlcompat::String& shaderMaterialName, void* extra,
		IShaderMaterialSetConstantsService* constantsService) = 0;
};


/**
 * General interface for a geometry that can be loaded within the system
 *
 */
class IGeometry
{

public:

	static const int ANCHOR_NONE =			0<<0;			///< No anchor, i.e. not relative-to-screen (0)
	static const int ANCHOR_LEFT =			1<<0;			///< Anchor to the left edge (1)
	static const int ANCHOR_RIGHT =			1<<1;			///< Anchor to the right edge (2)
	static const int ANCHOR_BOTTOM =		1<<2;			///< Anchor to the bottom edge (4)
	static const int ANCHOR_TOP =			1<<3;			///< Anchor to the top edge (8)
	static const int ANCHOR_CENTER_H =		1<<4;			///< Anchor to the horizontal center (16)
	static const int ANCHOR_CENTER_V =		1<<5;			///< Anchor to the vertical center (32)

	static const int ANCHOR_TL = ANCHOR_LEFT|ANCHOR_TOP;				///< Anchor to the Top-Left (9)
    static const int ANCHOR_TC = ANCHOR_TOP|ANCHOR_CENTER_H;			///< Anchor to the Top-Center (24)
    static const int ANCHOR_TR = ANCHOR_TOP|ANCHOR_RIGHT;				///< Anchor to the Top-Right (10)
    static const int ANCHOR_CL = ANCHOR_CENTER_V|ANCHOR_LEFT;			///< Anchor to the Center-Left (33)
    static const int ANCHOR_CC = ANCHOR_CENTER_H|ANCHOR_CENTER_V;		///< Anchor to the Center (48)
    static const int ANCHOR_CR = ANCHOR_CENTER_V|ANCHOR_RIGHT;			///< Anchor to the Center-Right (34)
    static const int ANCHOR_BL = ANCHOR_BOTTOM|ANCHOR_LEFT;				///< Anchor to the Bottom-Left (5)
    static const int ANCHOR_BC = ANCHOR_BOTTOM|ANCHOR_CENTER_H;			///< Anchor to the Bottom-Center (20)
    static const int ANCHOR_BR = ANCHOR_BOTTOM|ANCHOR_RIGHT;			///< Anchor to the Bottom-Right (6)

	static const int FLAG_NONE =						0<<0;		///< No flag, all geometric transforms are considered
	static const int FLAG_IGNORE_ROTATION =				1<<0;		///< ignore rotation of the geometry
	static const int FLAG_IGNORE_ANIMATIONS =			1<<1;		///< ignore animations of the geometry
	/**
	 * The geometry will be scaled automatically to match the physical display, regardless of its pixel density
	 * and resolution. This means that geometry will have same physical size on every display. 
	 * The scaling is relative to the baseline density which is 160ppi.
	 * If this flag is not defined, the one unit of the geometry will exactly match 1 pixel
	 * on the screen. It will also match 1 pixel on a display with 160ppi.
	 */
	static const int FLAG_MATCH_DISPLAY =				1<<2;

	/**
	 * Autoscale geometries according to the screen resolution and/or display density.
	 * if flag FLAG_MATCH_DISPLAY is also defined, the baseline will be 4-inch
	 * display, other wise it will be screen with width = 640 pixels.
	 */
	static const int FLAG_AUTOSCALE =					1<<3;


	virtual ~IGeometry() {};

	/**
	 * Determine whether dynamic lighting affects this geometry
	 *
	 * \return True if lighting enabled for this geometry, else false
	 * \sa setDynamicLightingEnabled
	 */
	virtual bool isDynamicLightingEnabled() const = 0;

	/**
	 * Set whether this geometry is affected by dynamic lights.
	 *
	 * If lighting is disabled for a geometry, it will be rendered with 0 lights, i.e. lights will
	 * not affect the geometry color.
	 *
	 * Default is to use lighting.
	 *
	 * \param enable Whether to enable or disable lighting
	 * \sa IMetaioSDK::createLight
	 */
	virtual void setDynamicLightingEnabled(bool enable) = 0;

	/**
	 * Set geometry relative to an anchor point on screen.
	 *
	 * \param anchor one or combination of screen anchors (use ANCHOR_NONE to stop rendering geometry as relative to screen)
	 * \param flags additional flags to ignore some geometric transforms.
	 * Can be combination of FLAG_IGNORE_ROTATION, FLAG_IGNORE_ANIMATIONS, FLAG_MATCH_DISPLAY or FLAG_AUTOSCALE.
	 * Default is FLAG_NONE.
	 *
	 * \sa ANCHOR_NONE
	 * \sa ANCHOR_LEFT, ANCHOR_RIGHT, ANCHOR_BOTTOM, ANCHOR_TOP, ANCHOR_CENTER_H, ANCHOR_CENTER_V
	 * \sa ANCHOR_TL, ANCHOR_TC, ANCHOR_TR, ANCHOR_CL, ANCHOR_CC, ANCHOR_CR, ANCHOR_BL, ANCHOR_BC, ANCHOR_BR
	 * \sa FLAG_NONE
	 * \sa FLAG_IGNORE_ROTATION, FLAG_IGNORE_ANIMATIONS
	 * \sa FLAG_MATCH_DISPLAY, FLAG_AUTOSCALE
	 * \sa getRelativeToScreen
	 */
	virtual void setRelativeToScreen(int anchor, int flags=FLAG_NONE) = 0;

	/**
	 * Get relative-to-screen anchor.
	 * \return One or combination of screen anchors.
	 * \sa setRelativeToScreen
	 * \sa isRelativeToScreen
	 */
	virtual int getRelativeToScreen() const = 0;

	/**
	 * Determine if the geometry is relative-to-screen
	 * \return true if relative-to-screen, else false
	 * \sa setRelativeToScreen
	 */
	virtual bool isRelativeToScreen() const = 0;

	/**
	 * Set the translation of the geometry.
	 * The unit of translation is always in millimeters. However for relative-to-screen geometry without any additional
	 * flags, it can be interpreted as pixels.
	 * \param translation The 3D translation vector.
	 * \param concat If true, the new translation is added to the existing one, otherwise it is overwritten.
	 * \sa getTranslation
	 */
	virtual void setTranslation(const Vector3d& translation, bool concat = false) = 0;


	/**
	 * Get the current translation of the geometry.
	 * The unit of translation is always in millimeters, however for relative-to-screen geometry without any additional
	 * flags, it can be interpreted as pixels.
	 * \return A 3D vector containing the translation.
	 * \sa setTranslation
	 */
	virtual Vector3d getTranslation() const = 0;


	/**
	 * Set the translation of the geometry to an LLA coordinate.
	 *	The system will then adjust its Cartesian offset in the renderer accordingly.
	 *	Note: The altitude is ignored, if you want adjust the height use setTranslation
	 *
	 * \param llaCoorindate The LLA (latitude, longitude, altitude) to set as translation.
	 * \sa setTranslation and getTranslation
	 * \sa getTranslationLLA
	 * \sa getTranslationLLACartesian
	 */
	virtual void setTranslationLLA(LLACoordinate llaCoorindate)  = 0;


	/**
	 * Get the translation of the geometry as LLA coordinate.
	 * \return The LLA (latitude, longitude, altitude) coordinate of the geometry.
	 * \sa setTranslation and getTranslation
	 * \sa setTranslationLLA
	 * \sa getTranslationLLACartesian
	 */
	virtual LLACoordinate getTranslationLLA() const = 0;


	/**
	 * Get the Cartesian translation of the geometry with an LLA coordinate.
	 * It returns absolute translation of the geometry relative to current LLA coordinates
	 * provided by the sensors' component. 
	 *
	 * \return A 3D vector containing the translation in millimeters
	 * \sa setTranslation and getTranslation
	 * \sa setTranslationLLA and getTranslationLLA
	 */
	virtual Vector3d getTranslationLLACartesian() const = 0;


	/**
	 * Set the scale of the geometry.
	 * \param scale Scaling vector (x,y,z).
	 * \param concat If true, the new scale is multiplied with existing scale.
	 * \sa getScale
	 */
	virtual void setScale(const Vector3d& scale, bool concat = false)  = 0;

	/**
	 * Set the scale of the geometry.
	 * \param scale scale factor for all dimensions
	 * \param concat If true, the new scale is multiplied with existing scale.
	 * \sa getScale
	 */
	virtual void setScale(const float scale, bool concat = false) = 0;

	/**
	 * Get the current scale of the geometry.
	 * \return The scaling vector (x,y,z).
	 * \sa setScale
	 */
	virtual Vector3d getScale() const = 0;


	/**
	 * Set the rotation of the geometry in axis angle representation.
	 *
	 * \param rotation The rotation object specifying the rotation.
	 * \param concat If true, the new rotation is concatenated with an existing rotation.
	 * \sa getRotation
	 */
	virtual void setRotation(const metaio::Rotation& rotation, bool concat = false)  = 0;


	/**
	 * Get the current rotation of the geometry in axis angle representation.
	 * \return The current rotation as Rotation object.
	 * \sa setRotation
	 */
	virtual metaio::Rotation getRotation() const = 0;

	/**
	 * Attach this IGeometry to another IGeometry to e.g. share it's transformation.
	 * \param parent the IGeometry that this one should be attached to.
	 * \sa getParentGeometry
	 */
	virtual void setParentGeometry(const metaio::IGeometry* parent) = 0;

	/**
	 * Get the parent IGeometry that this IGeometry is attached to.
	 * \return pointer to parent IGeometry object (null if there is none)
	 * \sa setParentGeometry
	 */
	virtual const metaio::IGeometry* getParentGeometry() const = 0;

	/**
	 * Gets the currently assigned shader material
	 *
	 * \return Assigned shader material name, or an empty string if not using a custom shader
	 */
	virtual stlcompat::String getShaderMaterial() const = 0;

	/**
	 * Assigns a shader material defined by the given name to this geometry
	 *
	 * \param shaderMaterialName Shader material name as previously loaded through
	 *                           IMetaioSDK::loadShaderMaterials
	 * \sa getShaderMaterial
	 * \sa IMetaioSDK::loadShaderMaterials
	 * \return bool True on success, false on error
	 */
	virtual bool setShaderMaterial(const stlcompat::String& shaderMaterialName) = 0;


	/**
	 * Sets the callback handler that will be triggered every time before this geometry is rendered.
	 *
	 * This callback is optional - the SDK will automatically pass a set of default constants to the
	 * shaders. Use this if you want to provide own constants to vertex or fragment shader.
	 *
	 * \param callback Callback implementation or NULL to remove the handler
	 */
	virtual void setShaderMaterialOnSetConstantsCallback(IShaderMaterialOnSetConstantsCallback* callback) = 0;


	/**
	 * Unassigns custom shader material so that in the next frame, the geometry is rendered with
	 * the default technique of the SDK
	 */
	virtual void unsetShaderMaterial() = 0;


	/**
	 * Determine if the geometry is currently being rendered based on camera frustum, tracking of
	 * the assigned COS, and geometry visibility.
	 *
	 * For the moment, always returns true for RTS geometries.
	 *
	 * \return True if the geometry is being rendered, false otherwise.
	 */
	virtual bool getIsRendered() const = 0;


	/**
	 * Determine the visibility of the geometry.
	 * \return True if the geometry is set visible, false otherwise.
	 * \sa setVisible
	 */
	virtual bool isVisible() const = 0;

	/**
	 * Triggers application pause actions.
	 *
	 * You don't need to call this directly, use IMetaioSDK::pause() instead!
	 */
	virtual void onApplicationPause() {};

	/**
	 * Triggers application resume actions.
	 *
	 * You don't need to call this directly, use IMetaioSDK::resume() instead!
	 */
	virtual void onApplicationResume() {};

	/**
	 * Set the visibility of the geometry.
	 * \param visible True if the geometry should be visible, false if it should be hidden.
	 * \sa isVisible
	 * \sa setOcclusionMode
	 * \sa setTransparency
	 * \sa setRenderOption
	 * \sa setPickingEnabled
	 */
	virtual void setVisible(bool visible) = 0;

	/**
	 * Set special render options of a geometry. This can be used: 
	 * - to turn front-/backface culling on/off
	 * - to turn writing to z-buffer on/off
	 * - to turn z-test on/off
	 * - to set certain colormask					(see ECOLOR_MASK)
	 * - to set certain combination of debugdata	(see EDEBUG_VISIBILITY)
	 * \param option ERENDER_OPTION
	 * \param value value to set for this option (either of type bool or respective enum for debug data or colormask)
	 * \sa getRenderOption
	 * \sa setDebugDataVisibility
	 * \sa getDebugDataVisibility
	 */
	virtual void setRenderOption(ERENDER_OPTION option, int value) = 0;

	/**
	 * Get special render options of a geometry.
	 * \param option ERENDER_OPTION
	 * \return currently set value for this option (either of type bool or respective enum EDEBUG_VISIBILITY or ECOLOR_MASK)
	 * \sa setRenderOption
	 * \sa setDebugDataVisibility
	 * \sa getDebugDataVisibility
	 */
	virtual int getRenderOption(ERENDER_OPTION option) const = 0;

	/**
	 * Get triangle count of this model.
	 *
	 *	\return the number of triangles within this model
	 */
	virtual unsigned int getTriangleCount() const = 0;

	/**
	 * Set the rendering order of the geometry.
	 *
	 * This method should be used for compositing, e.g. if a geometry should be drawn before or after other geometries.
	 * The ordering depends on the value of the level that is passed, the lower levels are drawn before higher levels,
	 * which means that a geometry with higher level will be on top of a geometry with lower level.
	 *
	 * The z-buffer (depth) check can be optionaly disabled so that geometrys are rendered independant of their
	 * real distance from the camera. This is usefull when more than one geometries are positioned at same depth (z), or
	 * a geometry with greater depth needs to be rendered in front of a geometry with less depth. Note that it works only
	 * for simple geometries, e.g a plane or sphere.
	 *
	 * For complex geometries, clear depth (z-buffer) can be enabled instead of disabling z-buffer check. This would ensure
	 * that geometries are rendered in correct order, however, it is an expensive operation and can significantly reduce
	 * rendering performance.
	 * 
	 * Note that geometry picking is always based on real distance from the camera. It means that even though a geometry
	 * is forced to rendered on top of another geometry (i.e. by disabling z-buffer check and/or enabling clear depth), the
	 * background geometry may be picked because it is closer to the camera in reality.
	 *
	 * \param level render order, the higher value means front, default is 0
	 * \param disableDepth true to disable depth test, false to enable (default)
	 * \param clearDepth true to clear depth before rendering, false to disable this (default)
	 * \sa getRenderOrder
	 */
	virtual void setRenderOrder(int level, bool disableDepth=false, bool clearDepth=false) = 0;

	/**
	 * Retrieve the rendering order of the geometry.
	 *
	 * \return the level
	 * \sa setRenderOrder
	 */
	virtual int getRenderOrder() const = 0;

	/**
	 * Set the occlusion mode of the geometry.
	 *
	 * \param occlude If true, the geometry is not displayed but only used to occlude other geometrys,
	 * otherwise it will be displayed normally.
	 * \sa setVisible and isVisible
	 * \sa setTransparency
	 * \sa setRenderOption
	 * \sa setPickingEnabled
	 */
	virtual void setOcclusionMode(bool occlude) = 0;


    /**
	 * Get the occlusion mode of the geometry.
	 * \return boolean If true geometry is occluded, otherwise false
	 * \sa isVisible
	 */
	virtual bool isOccluded() const = 0;
    
	/**
	 * Set the transparency of the geometry.
	 *
	 * \param transparency The transparency value, where 0 corresponds to a non-transparent model, 1 to a fully transparent model.
	 * \sa getTransparency
	 * \sa setVisible and isVisible
	 * \sa setOcclusionMode
	 * \sa setRenderOption
	 * \sa setPickingEnabled
	 */
	virtual void setTransparency(float transparency) = 0;

	/**
	 * Get the transparency of the geometry.
	 *
	 * \return transparency The transparency value, where 0 corresponds to a non-transparent model, 1 to a fully transparent model.
	 * \sa setTransparency
	 */
	virtual float getTransparency() const = 0;


	/**
	 * Set the fade in transparency effect for the geometry when assigned COS is tracked
	 *
	 * \param duration Time in ms specifying the duration of the fade in effect from full transparency to final transparency of the model.
	 * Specify duration <= 0.0f to have no fade in effect
	 * \sa getFadeInTime
	 * \sa setTransparency
	 */
	virtual void setFadeInTime(float duration) = 0;

	/**
	 * Get the time of the fade in transparency effect for the geometry when assigned COS is tracked
	 *
	 * \return time in ms specifying the duration of the fade in effect from full transparency to final transparency of the model.
	 * \sa setFadeInTime
	 */
	virtual float getFadeInTime() const = 0;


	/**
	 * Start a specific animation of the geometry.
	 * \param animationName Identifier of the animation.
	 * \param loop If true, the animation is looped, otherwise it is only played once.
	 * \sa setAnimationSpeed
	 */
	virtual void startAnimation(const stlcompat::String& animationName = "", const bool loop = false) = 0;

	/**
	 * Start an animation (frame range) of the geometry. OnAnimationEndCallback will receive animationName like "frameXX-YY" if not playing looped.
	 * \param startFrame frame number of animation start.
	 * \param stopFrame frame number of animation stop.
	 * \param loop If true, the animation is looped, otherwise it is only played once.
	 * \sa setAnimationSpeed
	 */
	virtual void startAnimation(const unsigned int startFrame, const unsigned int stopFrame, const bool loop = false) = 0;

	/**
	 * Stops the current animation of the geometry.
	 * \sa startAnimation
	 */
	virtual void stopAnimation() = 0;

	/**
	 * Set the animation speed of the model.
	 * \param fps Desired animation speed in frames per second.
	 */
	virtual void setAnimationSpeed(float fps) = 0;

	/**
	 * Pause the currently started animation
	 */
	virtual void pauseAnimation() = 0;

	/**
	 * Returns all possible animation names.
	 * \return all animation names.
	 * \sa startAnimation
	 */
	virtual stlcompat::Vector<stlcompat::String> getAnimationNames() const = 0;

	/**
	 * Get the (axis-aligned) bounding box of the geometry.
	 * \param inObjectCoordinates If true (default behaviour) the bounding box
	          will be returned in the coordinate system of the object, if false
			  it will be returned in the geometry's coordinate system
	 * \return The bounding box of the geometry.
	 */
	virtual BoundingBox getBoundingBox(bool inObjectCoordinates = true) const = 0;


    /**
	 * Get the bounding box of the geometry in screen coordinates.
	 * \return The bounding box of the geometry.
	 */
  	virtual BoundingBox getBoundingBox2D() = 0;

    
	/**
	 * Assign the geometry to a specific coordinate system (COS).
	 * \param coordinateSystemID The (one based) index of the coordinate system.
	 * \sa getCoordinateSystemID
	 */
	virtual void setCoordinateSystemID(int coordinateSystemID) = 0;


	/**
	 * Get the index of the coordinate system (COS) the geometry is assigned.
	 * \return The (one based) index of the coordinate system.
	 * \sa setCoordinateSystemID
	 */
	virtual int getCoordinateSystemID() const = 0;


	/**
	 * Set a name of the geometry
	 * \param name Name of the geometry
	 * \sa getName
	 */
	virtual void setName(const stlcompat::String& name) = 0;

	/**
	 * Get the name of the geometry previously set by calling setName.
	 * \return Name of the geometry
	 * \sa setName
	 */
	virtual stlcompat::String getName() const = 0;


	/**
	 * Get the type of the geometry.
	 * \return EGEOMETRY_TYPE value
	 * \sa EGEOMETRY_TYPE
	 */
	virtual EGEOMETRY_TYPE getType() const = 0;


	/**
	 * Activate or deactivate the usage of LLA rendering limits.
	 *
	 * If disabled, the geometry will ignore the near and far LLA limit
	 * and always render the object the the real location. The default
	 * is always enabled.
	 *
	 * \param enabled True to enable, false to disable.
	 * \sa IMetaioSDK::setLLAObjectRenderingLimits
	 */
	virtual void setLLALimitsEnabled(bool enabled) = 0;


	/**
	 * Enable or disable picking for the geometry.
	 *
	 * \param enabled True to enable picking of this geometry, false to disable it.
	 * \sa isPickingEnabled
	 * \sa setVisible and isVisible
	 * \sa setOcclusionMode
	 * \sa setTransparency
	 * \sa setPickingEnabled
	 * \sa setRenderOption
	 */
	virtual void setPickingEnabled(bool enabled)  = 0;


	/** 
	 * Determine if picking is enabled or disabled for the geometry
	 * \return true, if enabled, false otherwise
	 * \sa setPickingEnabled
	 */
	virtual bool isPickingEnabled() const = 0;


	/**
	 * Set image from given file path as texture for the geometry.
	 *
	 * Supported formats are PNG and JPG.
	 *
	 * \param texturePath Path to the texture image file.
	 * \return true on success
	 */
	virtual bool setTexture(const stlcompat::String& texturePath) = 0;

	/**
	 * Set image from memory as texture for the geometry.
	 *
	 * \param textureName A name that should be assigned to the texture (for reuse).
	 * \param image The actual image.
	 * \param updateable Flag to signal, that this image will be frequently updated.
	 * \return true on success
	 */
	virtual bool setTexture(const stlcompat::String& textureName, const ImageStruct& image, const bool updateable = false) = 0;

	/**
	 * Set movie texture for the geometry.
	 *
	 * If the movie texture is transparent, the left side should have colored part,
	 * and right side should have alpha transparency (red channel).
	 *
	 * \param filename Filename of the movie.
	 * \param transparent If true, the movie file will be rendererd as transparent texture.
	 * \sa removeMovieTexture
	 * \return true if successful, false otherwise (e.g. file not found or not loadable).
	 */
	virtual bool setMovieTexture(const stlcompat::String& filename,
	                             const bool transparent = false) = 0;

	/**
	 * Remove the movie texture of the geometry.
	 * \sa setMovieTexture
	 */
	virtual void removeMovieTexture() = 0;

	/**
	 * Stop the playback of a movie texture.
	 * \sa startMovieTexture
	 * \sa pauseMovieTexture
	 */
	virtual void stopMovieTexture() = 0;

	/**
	 * Start the playback of a movie texture.
	 * If the movie texture was stopped, it will start from begining. If it was paused,
	 * it will resume playback from same frame.
	 * \param loop If true, the movie will play in a loop, otherwise it is played only once.
 	 * \sa pauseMovieTexture
	 * \sa stopMovieTexture
	 */
	virtual void startMovieTexture(const bool loop = false) = 0;


	/**
	 * Pause the playback of a movie texture. Call startMovieTexture to
	 * resume again.
	 * \sa startMovieTexture
	 * \sa stopMovieTexture
	 */
	virtual void pauseMovieTexture() = 0;

	/**
	 * Retrieves the current playback status and position of the movie texture.
	 *
	 * Note that the timestamp does not immediately get reset to zero when stopMovieTexture is
	 * called, so you should take playbackStatus into account.
	 *
	 
	 * \return Current playback status of the movie texture
	 * \sa metaio::MovieTextureStatus
	 */
	virtual metaio::MovieTextureStatus getMovieTextureStatus() const = 0;
	
	/** 
	 * Determine if the geometry should be displayed on the radar
	 * \return true, if it should be displayed on the radar, false otherwise
	 * \sa setRadarVisibility to set the visibility on radar
	 */
	virtual bool getRadarVisibility() const = 0;
	
	
	/** 
	 * Define if a geometry should be displayed on the radar
	 * \param visible if false, the geometry is never displayed on
	 * the radar, else it may be displayed depending on its visibility.
	 */
	virtual void setRadarVisibility(bool visible) = 0;

	/** Gets the state of which debug data is displayed 
	 * \return BitField with bitwise-OR'ed EDEBUG_VISIBILITY flags
	 * \sa metaio::EDEBUG_VISIBILITY
	 * \sa setDebugDataVisibility to set visibility of debug data
	 */
	virtual EDEBUG_VISIBILITY getDebugDataVisibility() const = 0;

	/** Sets which debug data shall be displayed 
	 * \param debugVisibilityFlags BitField with bitwise-OR'ed EDEBUG_VISIBILITY flags
	 * \return none
	 * \sa metaio::EDEBUG_VISIBILITY
	 * \sa getDebugDataVisibility to retrieve visibility of debug data
	 */
	virtual void setDebugDataVisibility(EDEBUG_VISIBILITY debugVisibilityFlags) = 0;

	/** Determine if a selection box shall be displayed around the geometry
	 * \return true, if it should be displayed, false otherwise
	 * \sa setSelectionBoxVisibility to set visibility of selection box
	 */
	virtual bool getSelectionBoxVisibility() const = 0;

	/** Define if a selection box shall be displayed around the geometry
	 * \param visible if true, selection Box is displayed
	 * \return none
	 * \sa getSelectionBoxVisibility to retrieve visibility of selection box
	 */
	virtual void setSelectionBoxVisibility(bool visible) = 0;

	/**
	* Returns whether hardware skinning for this geometry has been enabled.
	* Hardware skinning can only be enabled for 3D geometry with joint animation
	* \return true if hardware skinning for this geometry has been enabled, false otherwise
	* \sa setHardwareSkinning to enable/disable hardware skinning
	*/
	virtual bool isHardwareSkinning() const = 0;

	/**
	* Enable/Disable Hardware Skinning for this geometry.
	* Hardware skinning can only be enabled for 3D geometry with joint animation
	* Hardware skinning currently only works on devices featuring 256+ vertex uniform vectors
	* On other devices, enabling hardware skinning may lead to undefined behavior.
	* \param hardwareSkinning if true, hardware skinning shall be enabled, 
	* if false hardware skinning shall be disabled
	* \return true if hardware skinning for this geometry has been enabled, false otherwise
	*/
	virtual bool setHardwareSkinning(bool hardwareSkinning) = 0;
};
}
#endif //__AS_IGEOMETRY_H_INCLUDED__

