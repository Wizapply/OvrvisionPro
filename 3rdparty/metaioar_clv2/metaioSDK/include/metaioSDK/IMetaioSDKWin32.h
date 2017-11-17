// Copyright 2007-2013 metaio GmbH. All rights reserved.
#ifndef ___AS_IMETAIOSDKWIN32_H_INCLUDED___
#define ___AS_IMETAIOSDKWIN32_H_INCLUDED___

#include "IMetaioSDK.h"

#include <windows.h>
#include <WinDef.h>


namespace metaio
{
/** \brief The interface to metaioSDK on Win32
*
* \ingroup UnifeyeMobile
*
* \date 15-Mar-2011
*
* \par License
* This code is the property of the metaio GmbH (www.metaio.com).
* It is absolutely not free to be used, copied or
* be modified without prior written permission from metaio GmbH.
* The code is provided "as is" with no expressed or implied warranty.
* The author accepts no liability if it causes
* any damage to your computer, or any harm at all.
*/
class METAIO_DLL_API IMetaioSDKWin32 : public virtual IMetaioSDK
{

};




/**
 * Create MetaioSDKWin32 instance
 *
 * \param width width of the renderer
 * \param height height of the renderer
 * \param screenRotation Screen rotation
 * \param renderSystem To use a specify OpenGL version or the NullRenderer
 * \param windowHandle depending on platform, this may be an instance
 *	to a window. See the example of each platform for best usage.
 * \return a pointer to MetaioSDKWin32 instance
 */
METAIO_DLL_API IMetaioSDKWin32* CreateMetaioSDKWin32(int width, int height, 
	ESCREEN_ROTATION screenRotation=ESCREEN_ROTATION_0, 
	const ERENDER_SYSTEM renderSystem = ERENDER_SYSTEM_OPENGL_ES_2_0, HWND windowHandle = 0);

/**
 * Create MetaioSDKWin32 instance.
 *
 * new interface, old is deprecated
 * \return a pointer to MetaioSDKWin32 instance
 */
METAIO_DLL_API IMetaioSDKWin32* CreateMetaioSDKWin32();

} //namespace metaio


#endif //___AS_IMETAIOSDKWIN32_H_INCLUDED___
