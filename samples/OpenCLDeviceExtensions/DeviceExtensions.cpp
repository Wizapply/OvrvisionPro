//
//
#include <string.h>
#include "ovrvision_pro.h"

using namespace OVR;

static 	OvrvisionPro ovrvision;

int callback(void *pItem, const char *extensions)
{
	if (extensions != NULL)
	{
		puts("Device Extensions:");
		puts(extensions);
	}
	return 0;
}

int main()
{
	if (ovrvision.Open(0, Camprop::OV_CAMHD_FULL))
	{
		ovrvision.OpenCLExtensions(callback, NULL);
	}
}