// Copyright 2007-2013 metaio GmbH. All rights reserved.

#if !defined(METAIO_DLL_API)
	#if !defined(AS_USE_METAIOSDKDLL)
		#define METAIO_DLL_API	// we don't have a dll file
	#else
		#ifdef AS_METAIOSDKDLL_EXPORTS
			#ifdef AS_ANDROID
				#define METAIO_DLL_API __attribute__ ((visibility("default")))
			#else
				#define METAIO_DLL_API __declspec(dllexport)
			#endif
		#else
			#define METAIO_DLL_API __declspec(dllimport)
		#endif
	#endif
#endif