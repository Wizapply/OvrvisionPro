// Copyright 2007-2013 metaio GmbH. All rights reserved.

#ifndef AS_UnifeyeSDKMobile_ByteBuffer_h
#define AS_UnifeyeSDKMobile_ByteBuffer_h

#include <metaioSDK/Dll.h>

namespace metaio {

/**
 * A byte buffer with its length
 */
struct METAIO_DLL_API ByteBuffer
{
	unsigned char* buffer;		///< pointer to a binary buffer
	int length;					///< length of the buffer
	
	/**
	 * Default constructor for ByteBuffer struct
	 */
	ByteBuffer();
	
	/**
	 * Constructor for ByteBuffer struct
	 *
	 * \param _buffer pointer to the binary data
	 * \param _length length of the buffer
	 */
	ByteBuffer(unsigned char* _buffer, int _length);
	
	/**
	 * Release the memory used by the buffer.
	 * All the members are reset to their default values after this call.
	 */
	void release();
	
};
	
} //namespace metaio

#endif
