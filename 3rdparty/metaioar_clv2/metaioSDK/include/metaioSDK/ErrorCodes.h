// Copyright 2007-2013 metaio GmbH. All rights reserved.
#ifndef _AS_ERROR_CODES_H_
#define _AS_ERROR_CODES_H_

/**
 * Low level system (common) error codes such as memory, I/O, network etc..
 */
#define	AS_ERROR_LOW_MEMORY							0x100
#define AS_ERROR_FILE_NOT_FOUND						0x101
#define AS_ERROR_FILE_NOT_READABLE					0x102
#define AS_ERROR_FILE_NOT_WRITEABLE					0x103
#define AS_ERROR_FILE_INVALID						0x104
#define AS_ERROR_INVALID_PARAMETERS					0x105
#define AS_ERROR_UNSUPPORTED_OPERATION				0x106

/**
 * Capture component error codes
 */
#define AS_ERROR_CAPTURE_NOT_INITIALIZED			0x200
#define AS_ERROR_CAPTURE_START_FAILED				0x201

/**
 * Tracking error codes
 */
#define AS_ERROR_TRACKING_CONFIGURATION_FAILED		0x300
#define AS_ERROR_TRACKING_SENSORS_FAILED			0x301


/**
 * Rendering error codes
 */
#define AS_ERROR_RENDERER_NOT_INITIALIZED			0x400
#define AS_ERROR_RENDERER_WRONG_THREAD				0x401
#define AS_ERROR_RENDERER_UNSUPPORTED_OPERATION		0x402


/**
 * SDK Error codes
 */
#define AS_ERROR_SDK_INVALID_LICENSE				0x500
#define AS_ERROR_SDK_UNSUPPORTED_PLATFORM			0x501
#define AS_ERROR_SDK_UNSUPPORTED_OPERATION			0x502


/**
 * Cloud plugin error codes
 */
#define AS_ERROR_CLOUD_INVALID_LICENSE				0x600

#endif // _AS_ERROR_CODES_H_

