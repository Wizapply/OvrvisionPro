// Copyright 2007-2013 metaio GmbH. All rights reserved.

#ifndef __VISUAL_SEARCH_RESPONSE_H__
#define __VISUAL_SEARCH_RESPONSE_H__

#include <metaioSDK/Dll.h>
#include <metaioSDK/STLCompatibility.h>

namespace metaio {
	
/**
 * The Visual Search response from the server.
 */
struct METAIO_DLL_API VisualSearchResponse
{
	stlcompat::String trackingConfigurationName;	///< The name of the tracking configuration that is found
	stlcompat::String trackingConfiguration;		///< The tracking configuration of the found target that can be directly loaded into metaioSDK
	float visualSearchScore;						///< Visual search score
	stlcompat::String metadata;						///< metadata (in JSON format)
	/**
	 * Default constructor of VisualSearchResponse
	 */
	VisualSearchResponse();
	
	/**
	 * Copy operator
	 *
	 * \param[in] from VisualSearchResponse to copy from
	 * \return copied VisualSearchResponse
	 */
	inline VisualSearchResponse& operator=(const VisualSearchResponse& from) {
		trackingConfigurationName = from.trackingConfigurationName;
		trackingConfiguration = from.trackingConfiguration;
		visualSearchScore = from.visualSearchScore;
		metadata = from.metadata;
		return *this;
	}
};
	
} //namespace metaio

#endif //__VISUAL_SEARCH_RESPONSE_H__
