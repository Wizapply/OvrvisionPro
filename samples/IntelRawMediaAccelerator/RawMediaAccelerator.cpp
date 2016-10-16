#include "stdafx.h"
#include "RawMediaAccelerator.h"

#include <memory.h>
#include <mfxvideo.h> /* The SDK include file */
#include <mfxvideo++.h> /* Optional for C++ development */
#include <mfxplugin.h> /* Plugin development */
#include <mfxcamera.h> /* The Raw Accelerator include file */

#pragma comment(lib, "libmfx.lib") /* The SDK static dispatcher library */


RawMediaAccelerator::RawMediaAccelerator()
{
}


RawMediaAccelerator::~RawMediaAccelerator()
{
}

void RawMediaAccelerator::configure()
{
	/* enable image stabilization filter with default settings */
	mfxExtVPPDoUse du;
	mfxU32 alg_list[3] = { MFX_EXTBUF_CAM_PIPECONTROL,
		MFX_EXTBUF_CAM_GAMMA_CORRECTION };
	du.Header.BufferId = MFX_EXTBUFF_VPP_DOUSE;
	du.Header.BufferSz = sizeof(mfxExtVPPDoUse);
	du.NumAlg = 2;
	du.AlgList = alg_list;
	/* configure the mfxVideoParam structure */
	mfxVideoParam conf;
	mfxExtBuffer *eb = &du;
	memset(&conf, 0, sizeof(conf));
	conf.IOPattern = MFX_IOPATTERN_IN_SYSTEM_MEMORY |
		MFX_IOPATTERN_OUT_VIDEO_MEMORY;
	conf.NumExtParam = 2;
	conf.ExtParam = &eb;
	conf.vpp.In.FourCC = MFX_FOURCC_R16;
	conf.vpp.In.ChromaFormat = MFX_CHROMAFORMAT_YUV400;
	conf.vpp.Out.FourCC = MFX_FOURCC_RGB4;
	conf.vpp.Out.ChromaFormat = MFX_CHROMAFORMAT_YUV444;
	conf.vpp.In.Width = conf.vpp.Out.Width = 4096;
	conf.vpp.In.Height = conf.vpp.Out.Height = 2160;
	/* video processing initialization */
	MFXVideoVPP_Init(session, &conf);
}