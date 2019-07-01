//
// Define and set to 1 if the target system has POSIX thread support
// and you want IlmBase to use it for multithreaded file I/O.
//

#define HAVE_PTHREAD 0

//
// Define and set to 1 if the target system supports POSIX semaphores
// and you want OpenEXR to use them; otherwise, OpenEXR will use its
// own semaphore implementation.
//

#define HAVE_POSIX_SEMAPHORES 0

#undef HAVE_UCONTEXT_H

//
// Define and set to 1 if the target system has support for large
// stack sizes.
//

#undef ILMBASE_HAVE_LARGE_STACK


//
// Version string for runtime access
//
#define ILMBASE_VERSION_STRING "1.0.3"
#define ILMBASE_PACKAGE_STRING "IlmBase 1.0.3"
