// Copyright 2007-2013 metaio GmbH. All rights reserved.
#ifndef _AS_WARNING_CODES_H_
#define _AS_WARNING_CODES_H_

/**
 * Low level system (common) warning codes such as memory, I/O, network etc..
 */
#define	AS_WARN_LOW_MEMORY							0x100
#define AS_WARN_FILE_NOT_FOUND						0x101
#define AS_WARN_FILE_NOT_READABLE					0x102
#define AS_WARN_FILE_NOT_WRITEABLE					0x103
#define AS_WARN_FILE_INVALID						0x104
#define AS_WARN_INVALID_PARAMETERS					0x105
#define AS_WARN_UNSUPPORTED_OPERATION				0x106

/**
 * SDK warning codes
 */
#define AS_WARN_SDK_INVALID_LICENSE					0x500
#define AS_WARN_SDK_UNSUPPORTED_PLATFORM			0x501
#define AS_WARN_SDK_UNSUPPORTED_OPERATION			0x502


#endif // _AS_WARNING_CODES_H_

