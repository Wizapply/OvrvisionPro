// Copyright 2007-2014 metaio GmbH. All rights reserved.

#ifndef AS_UnifeyeSDKMobile_ImageStruct_h
#define AS_UnifeyeSDKMobile_ImageStruct_h

#include <metaioSDK/ByteBuffer.h>
#include <metaioSDK/ColorFormat.h>
#include <metaioSDK/ScreenRotation.h>

namespace metaio {

/**
 * Image structure used by metaio SDK
 */
struct METAIO_DLL_API ImageStruct
{
	unsigned char* buffer;				///< Pointer to the pixels' buffer
	int width;							///< Image width
	int height; 						///< Image height
	common::ECOLOR_FORMAT colorFormat;	///< Image color format
	bool originIsUpperLeft;				///< true if the origin is in the
										///< upper left corner (default);
										///< false, if lower left
	double timestamp;					///< timestamp when the image was created

	int  roiLeft; ///< left  border of region of interest
	int roiUpper; ///< upper border of region of interest
	int roiRight; ///< right border of region of interest
	int roiLower; ///< lower border of region of interest
	bool hasRegionOfInterest;			///< Defines whether regionOfInterest is set

	/**
	 * On iOS and especially iPhone5 captured YUV420SP-images may have an 
	 * offset between Y and UV plane. To not omit this information after 
	 * capturing the frame it should be stored here. On iOS this information 
	 * can be retrieved using CVPixelBufferGetBaseAddressOfPlane()
	 */
	unsigned int planePaddingOffset;
	
    /**
	 * Platform-specific capturing context object.
	 *
	 * On iOS and OSX, this is a CVImageBufferRef
	 * (https://developer.apple.com/library/ios/documentation/QuartzCore/Reference/CVImageBufferRef/Reference/reference.html)
	 * which you can optionally use for faster texture upload of the camera
	 * image, for example. If you store this object yourself, don't forget to
	 * use CFRetain/CFRelease for reference counting.
	 *
	 * On other platforms, this is NULL at the moment.
	 */
	void* capturingContext;
	
	/**
	 * Stride of the image in bytes.
	 *
	 * This defines the number of bytes between the first and second row in the
	 * image. Use this in case an image has extra padding bytes at the end of 
	 * each row. If this field is zero, a packed alignment will be assumed - 
	 * for example, a 12 pixels wide RGB image has a stride of 36 bytes if it's
	 * packed, i.e. without any padding.
	 */
	unsigned int stride;
	
	/**
	 * Create an empty ImageStruct
	 */
	ImageStruct();
	
	/**
	 * Create ImageStruct with the given data.
	 *
	 * Note: you need to provide a timestamp>0.0 so the image gets processed.
	 *
	 * \param _buffer			 pointer to the image data
	 * \param _width			 width of the image
	 * \param _height			 height of the image
	 * \param _colorFormat       the color format
	 * \param _originIsUpperLeft true if the origin is upper left corner, 
	 *							 false if lower left
	 * \param _timestamp		 timestamp in seconds when the image was created
	 * \param _capturingContext  platform-specific capturing context object
	 * \param _stride			 stride of the image
	 */
	ImageStruct(unsigned char* _buffer, 
				int _width, 
				int _height,
				metaio::common::ECOLOR_FORMAT _colorFormat, 
				bool _originIsUpperLeft, 
				double _timestamp,
				void* _capturingContext = 0, 
				unsigned int _stride = 0);
	
	/**
	 * Get buffer size that is based on image dimensions and color format
	 * \return Image buffer size
	 */
	unsigned int getBufferSize() const;
	
	/**
	 * Compress the image contents into a new buffer.
	 * This function currently supports JPEG compression only.
	 * It is the responsibility of the caller to delete returned ByteBuffer 
	 * structure and its contents.
	 *
	 *	\param	quality JPEG quality (1-100, 0 will pick the default quality)
	 *
	 *	\return	ByteBuffer containing compressed data on success, NULL on failure.
	 */
	ByteBuffer* compress(unsigned int quality=0) const;
	
	/**
	 * Release the memory used by the buffer.
	 * All the members are reset to their default values after this call.
	 */
	void release();

	/**
	* Set region of interest
	*
	* \param x1 upper left  rectangle corner
	* \param y1 upper left  rectangle corner
	* \param x2 lower right rectangle corner
	* \param y2 lower right rectangle corner
	*/
	void setRegionOfInterest(int x1, int y1, int x2, int y2);
	
};
	
} //namespace metaio

#endif
