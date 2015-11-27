// Copyright 2007-2013 metaio GmbH. All rights reserved.

//compatibility to old MobileStructs
//has to be outside the guard because these files might still include MobileStructs.h
#include <metaioSDK/ByteBuffer.h>
#include <metaioSDK/Camera.h>
#include <metaioSDK/ImageStruct.h>
#include <metaioSDK/ScreenRotation.h>
#include <metaioSDK/RenderEvent.h>
#include <metaioSDK/Vector2d.h>
#include <metaioSDK/Vector3d.h>
#include <metaioSDK/Vector4d.h>
#include <metaioSDK/Correspondence2D3D.h>
#include <metaioSDK/LLACoordinate.h>
#include <metaioSDK/BoundingBox.h>
#include <metaioSDK/UserAcceleration.h>
#include <metaioSDK/VisualSearchResponse.h>
#include <metaioSDK/GeometryHit.h>

#pragma message( "MobileStructs.h is deprecated. Please use ByteBuffer.h, Camera.h, ImageStruct.h, ScreenRotation.h, RenderEvent.h, Vector2d.h, \
Vector3d.h, Vector4d.h, Correspondence2D3D.h, LLACoordinate.h, BoundingBox.h, UserAcceleration.h, VisualSearchResponse.h or GeometryHit.h instead." )
