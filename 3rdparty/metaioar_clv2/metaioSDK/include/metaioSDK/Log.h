// Copyright 2007-2014 metaio GmbH. All rights reserved.

#ifndef __METAIOSDK_LOG_H_INCLUDED__
#define __METAIOSDK_LOG_H_INCLUDED__

namespace metaio
{

/// Log level, defines which messages are logged by the SDK
enum ELOG_LEVEL
{
	/// Informational messages, warnings and errors are logged
	ELL_INFO = 0,

	/// Warnings and errors are logged
	ELL_WARNING = 1
};

} //namespace metaio

#endif //__METAIOSDK_LOG_H_INCLUDED__
