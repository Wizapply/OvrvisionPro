//metaioar_cl.cpp
//Copyright(C)2014 wizapply.com

/////////// includes ///////////
#include <windows.h>
#include "CMetaio.h"

 /////////// var and def ///////////



//global data
volatile HANDLE g_hMapping;
volatile byte* g_pMappingView;

CMetaio* g_metaio;

//[ctrl:1byte][data:2560*1920*4byte]
#define DATASIZE_SHARD	(19660800+1)

//ctrl : unsigned int
#define CT_NON		(0x00)
#define CT_PSSTART	(0x01)
#define CT_PSNCOMP	(0x02)
#define CT_PSCOMP	(0x03)
#define CT_ERR1		(0x04)
#define CT_ERR2		(0x05)

#define CT_ITSTART	(0x10)
#define CT_ITRECVOK	(0x11)

#define CT_NITSTART		(0x20)
#define CT_NITRECVOK	(0x21)

#define CT_ENDCODE	(0xFF)

#define MEMORYMAPNAME	L"OvrvisionARShareMem"

 /////////// funcation ///////////

//main function
int main(int argc, char *argv[])
{
	printf("Ovrvision Program for Metaio SDK 5.3\n");
	printf("Copyright(C)2014 Wizapply.com All rights reserved.\n\n");

	if(argc < 4) {
		printf("%s [width] [height] [focalpoint]\n",argv[0]);
		return 1;
	}

	int width = atoi(argv[1]);
	int height = atoi(argv[2]);
	float fp = (float)atof(argv[3]);

	printf("set width=%d height=%d focalpoint=%.3f\n",width,height,fp);

	g_metaio = new CMetaio(width,height,fp);

	g_hMapping = ::CreateFileMapping(
			(HANDLE)0xffffffff,     // 共有メモリの場合は0xffffffffを指定
			NULL,                   // セキュリティ属性。NULLでよい
			PAGE_READWRITE,         // プロテクト属性を読み書き可能に指定
			0,                      // ファイルサイズの上位32ビット
			DATASIZE_SHARD,          // ファイルサイズの下位32ビット
			MEMORYMAPNAME );       // メモリマップドファイルの名前

	// プロセス内のアドレス空間にファイルのビューをマップ
	g_pMappingView = (byte*)::MapViewOfFile(g_hMapping, FILE_MAP_ALL_ACCESS, 0, 0, 0);
	if(g_pMappingView == NULL) {
		printf("Memory Error!!");
		return 1;
	}

	memset((void*)g_pMappingView,0x00,DATASIZE_SHARD);	//clear

	volatile byte* ctrlcode = &g_pMappingView[0];
	while((*ctrlcode) != CT_ENDCODE) {
		//ループ
		if((*ctrlcode) == CT_PSSTART) {
			//renderer
			int stat = g_metaio->UpdateAR(&g_pMappingView[1],width,height);

			switch(stat) {
				case (-1): (*ctrlcode) = CT_ERR1;
					break;
				case 0: (*ctrlcode) = CT_PSNCOMP;
					break;
				case 1: (*ctrlcode) = CT_PSCOMP;
					break;
				default: (*ctrlcode) = CT_ERR2;
					break;
			};
		}
		else if((*ctrlcode) == CT_ITSTART) {	//Instanto
			g_metaio->StartTracking("INSTANT_3D");
			(*ctrlcode) = CT_ITRECVOK;
		}
		else if((*ctrlcode) == CT_NITSTART) {
			g_metaio->NotInstantTracking();
			(*ctrlcode) = CT_NITRECVOK;
		}
	}
	
	//解放
	::UnmapViewOfFile((void*)g_pMappingView);
	::CloseHandle(g_hMapping);

	delete g_metaio;

	return 0;
}
