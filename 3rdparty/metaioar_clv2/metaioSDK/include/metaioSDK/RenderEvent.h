// Copyright 2007-2013 metaio GmbH. All rights reserved.

#ifndef __RENDER_EVENT_H__
#define __RENDER_EVENT_H__

#include <metaioSDK/Dll.h>

namespace metaio {
	
class IGeometry;
	
/// Render event type
enum ERENDER_EVENT_TYPE
{
	/**
	 * Geometry became visible.
	 *
	 * Note that a geometry's bounding box may be used to check visibility, so "visible" means that
	 * the object will be rendered and may or may not occupy pixels on the screen, depending on its
	 * shape, position and transparency.
	 */
	ERENDER_EVENT_TYPE_VISIBLE,
	
	/// Geometry became invisible
	ERENDER_EVENT_TYPE_INVISIBLE,
};


/// Defines a rendering event
struct METAIO_DLL_API RenderEvent
{
	/// Geometry pertaining to the event
	IGeometry*				geometry;
	
	/// Type of the event
	ERENDER_EVENT_TYPE		type;
	
	RenderEvent();
};

	
} //namespace metaio

#endif //__RENDER_EVENT_H__
