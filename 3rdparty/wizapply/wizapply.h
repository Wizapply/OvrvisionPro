/*
 * アプリ開発用フレームワーク「Wizapply」
 * Copyright (C) 2010-2012 Wizapply Project. All rights reserved.
 * 
 * >> The MIT Licence
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation 
 * the rights to use, copy, modify, merge, publish, distribute, sublicense, 
 * and/or sell copies of the Software, and to permit persons to whom the Software is furnished
 * to do so, subject to the following conditions:
 * The above copyright notice and this permission notice shall be included in all copies
 * or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS 
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS 
 * OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * wizapply.h
 */

#ifndef _WZ_WIZAPPLY_H_
#define _WZ_WIZAPPLY_H_

//警告なし
#define _CRT_SECURE_NO_DEPRECATE
#define _CRT_SECURE_NO_WARNINGS

//特殊オプション：サウンドなし
//#define __WIZAPPLY_NO_PATRICIA_

#ifdef __cplusplus
extern "C" {
#endif

/*---- インクルードファイル ----*/

//標準
#include <stdio.h>		//!<標準ライブラリ
#include <math.h>		//!<数学関連標準ライブラリ
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include <stdarg.h>

#if defined(WIN32) || defined(WIN64)
#include <windows.h>	//!<WindowsAPI
#include <process.h>	//!<Process(マルチスレッドを使用)
#include <gl/glew.h>	//!<OpenGL API Ex
#include <gl/wglew.h>
#include <al/al.h>		//!<OpenAL
#include <al/alc.h>
#define WZOPENGL_3
#endif

#ifdef IOS
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include <pthread.h>
#include <sys/time.h>
#include <OpenAL/al.h>
#include <OpenAL/alc.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#define WZOPENGL_ES2
#endif

#ifdef MACOSX
#include <OpenGL/OpenGL.h>
#include <OpenGL/gl.h>
#include <pthread.h>
#include <sys/time.h>
#include <OpenAL/al.h>
#include <OpenAL/alc.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#define WZOPENGL_3
#endif

#ifdef ANDROID
#include <jni.h>
#include <pthread.h>
#include <unistd.h>
#include <GLES2/gl2.h>
#include <GLES2/gl2ext.h>
#include <sys/time.h>
#include <al/al.h>
#include <al/alc.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#define WZOPENGL_ES2
#endif

#ifdef X11
#include <pthread.h>
#include <unistd.h>
#include <X11/Xlib.h>
#include <X11/Xatom.h>
#ifndef X11ES
#include <GL/gl.h>
#include <GL/glx.h>
#define WZOPENGL_ES2
#else
#include <EGL/egl.h>
#include <GLES2/gl2.h>
#include <GLES2/gl2ext.h>
#define WZOPENGL_3
#endif
#include <sys/time.h>
#include <al/al.h>
#include <al/alc.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <linux/input.h>
#endif

typedef unsigned int GLenum;
typedef unsigned int GLbitfield;
typedef unsigned int GLuint;
typedef int GLint;
typedef int GLsizei;
typedef unsigned char GLboolean;
typedef signed char GLbyte;
typedef short GLshort;
typedef unsigned char GLubyte;
typedef unsigned short GLushort;
typedef unsigned long GLulong;
typedef float GLfloat;
typedef float GLclampf;
typedef double GLdouble;
typedef double GLclampd;
typedef void GLvoid;
typedef char GLchar;

/*
//直接インクルード
#include "expat.h"
*/

/*---- 数学定義 ----*/

#define PI			(3.141592653589793f)		//!<円周率
#define HALF_PI		(1.570796326794897f)		//!<半円周率

//変換
#define TO_DEGREE(Radian)		((float)(Radian) * (180.0f / PI))
#define TO_RADIAN(Degree)		((float)(Degree) * (PI/180.0f))

// 初期化系
// Ex) shVector2 = VEC2_INIT(1.0f,5.0f);
#define VEC2_INIT(x, y)			{x, y}
#define VEC3_INIT(x, y, z)		{x, y, z}
#define VEC4_INIT(x, y, z, w)	{x, y, z, w}
#define RECT_INIT(t, b, l, r)	{t, b, l, r}

//絶対値へ変換
#undef wzAbs
#define wzAbs(x)		((x) < 0 ? -(x) : (x))
//最大を取得
#undef wzMax
#define wzMax(a,b)	(((a) > (b)) ? (a) : (b))
//最小を取得
#undef wzMin
#define wzMin(a,b)	(((a) < (b)) ? (a) : (b))
//0.0f-1.0fの範囲にクランプ
#undef wzClamp
#define wzClamp(x)	(((x) > 1.0f) ? 1.0f : ((x) < 0.0f) ? 0.0f : (x))

/*---- マクロ定義 ----*/

#ifndef TRUE
#define TRUE	1
#endif

#ifndef FALSE
#define FALSE	0
#endif

#ifndef NULL
#define NULL	(0)
#endif


#define MAX_DEVICENAME		(256)	//!<デバイス名最大文字数

//起動モードのフラグ一覧
#define WZ_CM_FULLSCREEN	(0x0001)	//!<フルスクリーン（Windows,MacOSX,Linuxのみ）
#define WZ_CM_FS_DEVICE		(0x0002)	//!<デバイス解像度変更フルスクリーン（Windowsのみ）：WZ_CM_FULLSCREENと併用すること
#define WZ_CM_NOVSYNC		(0x0004)	//!<垂直同期を使用しない（Windows,MacOSX,Linuxのみ）
#define WZ_CM_NOWINDOW		(0x0008)	//!<ウィンドウ機能を表示しない（Windowsのみ）
#define WZ_CM_USE_GVTY		(0x0010)	//!<重力加速度センサーを使用する（iOS、Androidのみ）
#define WZ_CM_USE_GROS		(0x0020)	//!<ジャイロスコープセンサーを使用する（iOS、Androidのみ）
#define WZ_CM_USE_OREN		(0x0040)	//!<角速度センサーを使用する（iOS、Androidのみ）
#define WZ_CM_USE_GPS		(0x0080)	//!<ＧＰＳセンサーを使用する（iOS、Androidのみ）

#define WZ_CM_NOCOMINIT		(0x2000)	//!<コンポーネントの自動初期化＆解放しない
#define WZ_CM_NODEPTHBUF	(0x4000)	//!<デブスバッファを無効化（未実装）
#define WZ_CM_FULLDRAW		(0x8000)	//!<描画関数のみを使用する

// ブレンド方法指定フラグ
#define WZ_BLD_ALPHA			0x00000000	//!<α合成（デフォルト）
#define WZ_BLD_ADD				0x00000001	//!<加算合成
#define WZ_BLD_SUB				0x00000002	//!<減算合成（未実装）
#define WZ_BLD_MULA				0x00000003	//!<乗算合成
#define WZ_BLD_INVSRC			0x00000004	//!<反転合成
#define WZ_BLD_NONE				0x00000010	//!<使わない
// カリング方法指定フラグ
#define WZ_CLF_CW				0x00000000	//!<背面を右回りでカリング
#define WZ_CLF_CCW				0x00000001	//!<背面を左回りでカリング
#define WZ_CLF_NONE				0x00000002	//!<カリングなし
// ステンシル設定（未実装・下記関数を使うこと）
//glStencilFunc
//glStencilFuncSeparate
//glStencilMask
//glStencilMaskSeparate
//glStencilOp
//glStencilOpSeparate
// スイッチフラグ
#define WZ_TRUE					0x00000001	//!<TRUE
#define WZ_FALSE				0x00000000	//!<FALSE

// テクスチャ
#define WZ_FORMATTYPE_RGBA			0x00000000		//!<R8G8B8A8
#define WZ_FORMATTYPE_RGB			0x00000001		//!<R8G8B8
#define WZ_FORMATTYPE_RGB_RGBA		0x00000002		//!<R8G8B8->R8G8B8A8
#define WZ_FORMATTYPE_RGBA_RGB		0x00000003		//!<R8G8B8A8->R8G8B8
#define WZ_FORMATTYPE_LUMINANCE		0x00000004		//!<LUMINANCE8
#define WZ_FORMATTYPE_LUMINANCEA	0x00000005		//!<LUMINANCE8ALPHA8
#define WZ_FORMATTYPE_R				0x00000006		//!<RED8
#define WZ_FORMATTYPE_BGR_RGB		0x00000007		//!<B8G8R8->B8G8R8(ES不可)
#define WZ_FORMATTYPE_BGR_RGBA		0x00000008		//!<B8G8R8->B8G8R8A8(ES不可)
#define WZ_FORMATTYPE_BGRA_RGB		0x00000009		//!<B8G8R8A8->B8G8R8(ES不可)
#define WZ_FORMATTYPE_BGRA_RGBA		0x0000000A		//!<B8G8R8A8->B8G8R8A8(ES不可)
#define WZ_FORMATTYPE_RGB16F		0x0000000B		//!<float16 RGB(ES不可)
#define WZ_FORMATTYPE_RGB32F		0x0000000C		//!<float32 RGB(ES不可)
#define WZ_FORMATTYPE_RGBA16F		0x0000000D		//!<float32 RGBA(ES不可)
#define WZ_FORMATTYPE_RGBA32F		0x0000000E		//!<float32 RGBA(ES不可)
#define WZ_FORMATTYPE_R16F			0x0000000F		//!<float16 RED(ES不可)
#define WZ_FORMATTYPE_R32F			0x00000010		//!<float32 RED(ES不可)
#define WZ_FORMATTYPE_DEPTH			0x00000011		//!<float16or32 DEPTH（32bit、ESの場合:16bit）

#define WZ_FORMATTYPE_C_BGRA		0x00000100		//!<B8G8R8A8 Changeのみ(ES不可)
#define WZ_FORMATTYPE_C_BGR			0x00000101		//!<B8G8R8 Changeのみ(ES不可)

#define WZ_TP_MIRRORED_REPEAT		(0)
#define WZ_TP_REPEAT				(1)
#define WZ_TP_CLAMP_EDGE			(2)

#define WZ_TP_LINEAR				(0)
#define WZ_TP_NEAREST				(1)

// 描画モード
#define WZ_MESH_DF_TRIANGLELIST		0x00000000	//!<三角形モード(デフォルト)
#define WZ_MESH_DF_TRIANGLESTRIP	0x00000001	//!<三角形ストリップモード
#define WZ_MESH_DF_TRIANGLEFAN		0x00000002	//!<三角形ファンモード
#define WZ_MESH_DF_LINELIST			0x00000003	//!<線モード
#define WZ_MESH_DF_LINESTRIP		0x00000004	//!<線ストリップモード
#define WZ_MESH_DF_POINTS			0x00000005	//!<頂点モード

typedef unsigned int texparam;		//テクスチャパラメータフラグ型
typedef struct _wztexture {
	GLuint	texture;	//テクスチャ番号
	GLenum	target;		//テクスチャ種類
	unsigned int flag;	//フラグ
} wzTexture;						//テクスチャ
typedef GLuint		 wzShaderProg;	//シェーダプログラム

//キューブマップ
#define WZ_TEXTURE_CUBE_MAP_POSITIVE_X GL_TEXTURE_CUBE_MAP_POSITIVE_X
#define WZ_TEXTURE_CUBE_MAP_NEGATIVE_X GL_TEXTURE_CUBE_MAP_NEGATIVE_X
#define WZ_TEXTURE_CUBE_MAP_POSITIVE_Y GL_TEXTURE_CUBE_MAP_POSITIVE_Y
#define WZ_TEXTURE_CUBE_MAP_NEGATIVE_Y GL_TEXTURE_CUBE_MAP_NEGATIVE_Y
#define WZ_TEXTURE_CUBE_MAP_POSITIVE_Z GL_TEXTURE_CUBE_MAP_POSITIVE_Z
#define WZ_TEXTURE_CUBE_MAP_NEGATIVE_Z GL_TEXTURE_CUBE_MAP_NEGATIVE_Z

// VertexElements タイプ
typedef enum _enum_shvetype
{
    WZVETYPE_FLOAT1    =  0,  // 1D float expanded to (value, 0., 0., 1.)
    WZVETYPE_FLOAT2    =  1,  // 2D float expanded to (value, value, 0., 1.)
    WZVETYPE_FLOAT3    =  2,  // 3D float expanded to (value, value, value, 1.)
    WZVETYPE_FLOAT4    =  3,  // 4D float

    WZVETYPE_BYTE4     =  5,  // 4D signed byte
    WZVETYPE_UBYTE4    =  6,  // 4D unsigned byte
    WZVETYPE_SHORT2    =  7,  // 2D signed short
    WZVETYPE_USHORT2   =  8,  // 2D unsigned short

    WZVETYPE_UNUSED    = 17,  // When the type field in a decl is unused.
} WZ_VETYPE;

// shVertexElementsのターミネータ
#define WZVE_TMT() {WZVETYPE_UNUSED,""}
#define WZ_GLSL_VALUENAMENUM 128

#ifdef WIN32
typedef void* wzThdHandle;			//!<スレッド用ハンドル
#else
typedef pthread_t wzThdHandle;		//!<スレッド用ハンドル
#endif

#ifdef WIN32
typedef void* wzThdMutex;				//!<スレッド用ミューテクス
#else
typedef pthread_mutex_t wzThdMutex;		//!<スレッド用ミューテクス
#endif

//フォント描画タイプ
#define WZ_FONTDRAWTYPE_MONO	(0)		//モノクロビットマップ
#define WZ_FONTDRAWTYPE_AA		(1)		//アンチエイリアスビットマップ
//使用する文字コード
#define WZ_FONTCHARCODE_SJIS	(0)		//SJIS文字コード（デフォルト）
#define WZ_FONTCHARCODE_UTF8	(1)		//UTF-8文字コード
#define WZ_FONTCHARCODE_UTF16LE	(2)		//UTF-16LE文字コード

// レンダーバッファ種類フラグ
#define WZ_RENDERBUFFER_COLOR		0x00000001	//!<カラーバッファ
#define WZ_RENDERBUFFER_DEPTH		0x00000002	//!<デプスバッファ
#define WZ_RENDERBUFFER_STENCIL		0x00000003	//!<ステンシルバッファ

// サウンド関連
// 音声フォーマット[fmtflag]
#define WZ_AUDIOFORMAT_MONO8		0x00000000	//!<モノラル8bit
#define WZ_AUDIOFORMAT_MONO16		0x00000001	//!<モノラル16bit
#define WZ_AUDIOFORMAT_STEREO8		0x00000002	//!<ステレオ8bit
#define WZ_AUDIOFORMAT_STEREO16		0x00000003	//!<ステレオ16bit

// 音声データタイプ
#define WZ_AUDIOTYPE_LUMP			0x00000000	//!<一括読み込み
#define WZ_AUDIOTYPE_STREAMING		0x00000001	//!<ストリーミング
#define WZ_AUDIOTYPE_STREAMING_NOW	0x00000002	//!<ストリーミング中

// 通信関連
//ファイルダウンロード準備
#define WZ_FD_DOWNLOAD_ERRORSTOP (-1)		//!<エラー停止中
#define WZ_FD_DOWNLOAD_STOP		 (0)		//!<停止中
#define WZ_FD_DOWNLOAD_READY	 (1)		//!<準備中
#define WZ_FD_DOWNLOAD_LOADING	 (2)		//!<ダウンロード中

/*---- 構造体定義 ----*/

/*
 *	Vector2　：　２次元ベクトル
 */
typedef struct _wzvector2
{
	union {
		float v[2];
		struct {
			float x;
			float y;
		};
	};
} wzVector2;

/*
 *	Vector3　：　３次元ベクトル
 */
typedef struct _wzvector3
{
	union {
		float v[3];
		struct {
			float x;
			float y;
			float z;
		};
	};
} wzVector3;

/*
 *	Vector4　：　４次元ベクトル
 */
typedef struct _wzvector4
{
	union {
		float v[4];
		struct {
			float x;
			float y;
			float z;
			float w;
		};
	};
} wzVector4;

/*
 *	Matrix　：　４×４行列
 */
typedef struct _wzmatrix
{
	union {
		float ms[16];
		float m[4][4];
		struct {
			float _11, _12, _13, _14;
			float _21, _22, _23, _24;
			float _31, _32, _33, _34;
			float _41, _42, _43, _44;
		};
	};
} wzMatrix;

/*
 *	Quaternion　：　四元数
 */
typedef struct _wzquaternion
{
	union {
		float v[4];
		struct {
			float x;
			float y;
			float z;
			float w;
		};
	};
} wzQuaternion;

/*
 *	Rect　：　矩形
 */
typedef struct _wzrect
{
	union {
		float v[4];
		struct {
			float top;
			float bottom;
			float left;
			float right;
		};
	};
} wzRect;

/*
 * struct _tag_vertexElements
 * 頂点要素
 */
typedef struct _tag_vertexElements {
	unsigned char	type;								//!<type
	unsigned char	valuename[WZ_GLSL_VALUENAMENUM];	//!<value name
} wzVertexElements;

/*
 *	typedef struct _wzRenderBuffer wzRenderBuffer
 *
 *	　レンダーバッファ構造体
 */
typedef struct _wzRenderBuffer {
	unsigned int flag;			//!<データの種類フラグ
	int width;					//!<データ幅
	int height;					//!<データ高さ
	GLuint glrb[2];				//!<OpenGL向けレンダーバッファ(配列 0:デプス用1:ステンシル)
} wzRenderBuffer;

/*
 *	typedef struct _wzRenderTarget wzRenderTarget
 *	　レンダーターゲットの構造体
 */
typedef struct _wzRenderTarget {
	unsigned int flag;		//!<レンダーフラグ
	GLuint glrt;			//!<OpenGL向けレンダーターゲット
} wzRenderTarget;

/*
 *	３Ｄモデルメッシュ
 */
typedef struct _wzmesh
{
	struct {
		GLuint* vertex;		//!<頂点情報（複数）
		GLuint index;		//!<結線
	} mesh_gl;
	int vertex_size;		//!<頂点数
	int face_size;			//!<ポリゴン数
	unsigned int draw_flag;	//!<描画モードのフラグ

	int startp;				//!<スタート頂点
	int endp;				//!<エンド頂点

	wzVertexElements ve[10];	//!<頂点属性[最大10]
} wzMesh;


// サウンド関連
/*
 *　typedef struct _pa_audiosrc paAudioSource
 *　音源構造体
 */
typedef struct _wz_audiosrc {
	int				audioType;	//!<音声データタイプ

	unsigned int	alSource;	//!<音の発生源
	unsigned int	alBuffer;	//!<音のバッファ
	unsigned int	bufsize;	//!<バッファサイズ
	int				loopflag;	//!<ループさせるかどうか

	//ストリーミング用データ
	int				seek_cmd;	//!<ファイルシークコマンド
	unsigned long	seek_pos;	//!<ファイルシーク（サンプル数）
	int				playing;	//!<再生中かどうか（ストリーミング用）
	int				streamNo;	//!<ストリーム中の番号
} wzAudioSrc;

/*
 * typedef struct _tag_waveform paWaveform;
 * 波形データ構造体
 */
typedef struct _tag_waveform {
    unsigned int	channels;			//!<チャンネル数
	unsigned int	samplesPerSec;		//!<１秒間のサンプルレート
	unsigned int	avgBytesPerSec;		//!<１秒間のバイト数
	unsigned int	blockAlign;			//!<データブロックサイズ
    unsigned int	bitsPerSample;		//!<1サンプル当たりのビット数
	char*			waveData;			//!<波形データ（動的）
    unsigned long	dataSize;			//!<データサイズ
} wzWaveform;

// 通信関連
/*
 * typedef struct _tag_jf_socket jfSocket;
 *  ソケット構造体
 */
typedef struct _tag_jf_socket {
#ifdef WIN32
	SOCKET				sock;		//!<ソケット識別子を格納
#else
	int					sock;
#endif
	struct sockaddr_in	address;	//!<アドレス情報
	enum {
		WZ_SocketNone = 0,
		WZ_SocketTCPServer,
		WZ_SocketTCPClient,
		WZ_SocketUDP,
	} kindsocket;					//!<ソケットの種類
} wzSocket;

/*
 * typedef struct sockaddr_in jfSender;
 *  送信相手構造体
 */
typedef struct sockaddr_in wzSender;

/*---- 共用体定義 ----*/


/*---- 関数定義 ----*/

//Sherry
// Application
void wzSetITFunc(int(*init)(), int(*tmt)(), void(*loop)());
void wzSetITFuncOculusVR(int(*init)(), int(*tmt)(), void(*loop)(), void(*sdef)());
int wzInitCreateWizapply(const char* title, int width, int height, unsigned short flags);
int wzExitWizapply();
void wzMainWizapply();
void wzSetUpdateThread(int framerate, void(*thd)());
char* wzDCP(const char* filePath);
char* wzDSP(const char* filePath);
void wzSetMenuFunc(void(*func)(int));	// Androidのみ
// Device
void wzClear();
void wzSetViewport(int x, int y, int width, int height);
void wzSetClearColor(float r, float g, float b, float a);
void wzSetBlend(unsigned int flag);
void wzSetCullFace(unsigned int flag);
void wzSetDepthTest(unsigned int flag);
void wzSetDepthWrite(unsigned int flag);
void wzSetStencilTest(unsigned int flag);
void wzSetLineWidth(float width);
void wzGetPixelColorByte(int x, int y, int w, int h, unsigned char* pdata);
void wzGetPixelColorFloat(int x, int y, int w, int h, float* pdata);
int wzGetProcessorsNum();
char* wzGetAudioDeviceName();
char* wzGetOpenGLVender();
char* wzGetOpenGLRenderer();
char* wzGetOpenGLVersion();
char* wzGetOpenGLExtensions();
// System
void wzSetCursorScSize(float w, float h);
int wzGetCursorSrPos(int idx, float* x, float* y);
int wzGetCursorPos(int idx, float* x, float* y);
int wzGetTouch(int idx);
int wzGetAccelerometerGravity(float* x, float* y, float* z);
int wzGetAccelerometer(float* x, float* y, float* z);
int wzGetRotationRate(float* y, float* p, float* r);
int wzGetArrowKey(float* arrow_x, float* arrow_y);
int wzGetKeyState(unsigned char keycode);
int wzGetKeyStateTrigger(unsigned char keycode);
int wzGetWindowWidth();
int wzGetWindowHeight();
float wzGetUpdateFPS();
float wzGetDrawFPS();
void wzUpdateSignalCatchWait();
void wzDrawSignalCatchWait();
unsigned int wzGetTime();
void wzSleep(unsigned long msec);
void wzIntervalSleep(unsigned long msec);
void wzOpenWebBrowser(const char* url);
//int wzOpenInputTextDialog(char* inbuf, int inbufsize, const char* title, const char* inputText); 未実装
// Math
wzVector2 wzVec2Create(float x, float y);
void wzVec2Set(wzVector2* pOut, float x, float y);
wzVector2 wzVec2Multiply(wzVector2* pV1, wzVector2* pV2);
wzVector2 wzVec2Division(wzVector2* pV1, wzVector2* pV2);
wzVector2 wzVec2Add(wzVector2* pV1, wzVector2* pV2);
wzVector2 wzVec2Sub(wzVector2* pV1, wzVector2* pV2);
float wzVec2Dot(wzVector2* pV1, wzVector2* pV2);
float wzVec2Cross(wzVector2* pV1, wzVector2* pV2);
float wzVec2Length(wzVector2* pV);
wzVector2 wzVec2Normalize(wzVector2* pV);
wzVector2 wzVec2Linear(wzVector2* pV1, wzVector2* pV2, float t);
wzVector3 wzVec3Create(float x, float y, float z);
void wzVec3Set(wzVector3* pOut, float x, float y, float z);
wzVector3 wzVec3Multiply(wzVector3* pV1, wzVector3* pV2);
wzVector3 wzVec3Division(wzVector3* pV1, wzVector3* pV2);
wzVector3 wzVec3Add(wzVector3* pV1, wzVector3* pV2);
wzVector3 wzVec3Sub(wzVector3* pV1, wzVector3* pV2);
float wzVec3Dot(wzVector3* pV1, wzVector3* pV2);
wzVector3 wzVec3Cross(wzVector3* pV1, wzVector3* pV2);
float wzVec3Length(wzVector3* pV);
wzVector3 wzVec3Normalize(wzVector3* pV);
wzVector3 wzVec3Linear(wzVector3* pV1, wzVector3* pV2, float t);
wzVector4 wzVec4Create(float x, float y, float z, float w);
void wzVec4Set(wzVector4* pOut, float x, float y, float z, float w);
wzVector4 wzVec4Multiply(wzVector4* pV1, wzVector4* pV2);
wzVector4 wzVec4Division(wzVector4* pV1, wzVector4* pV2);
wzVector4 wzVec4Add(wzVector4* pV1, wzVector4* pV2);
wzVector4 wzVec4Sub(wzVector4* pV1, wzVector4* pV2);
float wzVec4Dot(wzVector4* pV1, wzVector4* pV2);
wzVector4 wzVec4Cross(wzVector4* pV1, wzVector4* pV2, wzVector4* pV3);
float wzVec4Length(wzVector4* pV);
wzVector4 wzVec4Normalize(wzVector4* pV);
wzVector4 wzVec4Linear(wzVector4* pV1, wzVector4* pV2, float t);
void wzMatrixIdentity(wzMatrix* pOut);
wzMatrix* wzMatrixMultiply(wzMatrix* pOut, wzMatrix* pM1, wzMatrix* pM2);
wzVector4* wzVec3Transform(wzVector4* pOut, wzVector3* pV, wzMatrix* pM);
wzVector3* wzVec3TransformCoord(wzVector3* pOut, wzVector3* pV, wzMatrix* pM);
wzVector4* wzVec4Transform(wzVector4* pOut, wzVector4* pV, wzMatrix* pM);
wzMatrix* wzMatrixScaling(wzMatrix* pOut, float fScaleX, float fScaleY, float fScaleZ);
wzMatrix* wzMatrixRotationX(wzMatrix* pOut, float Degree);
wzMatrix* wzMatrixRotationY(wzMatrix* pOut, float Degree);
wzMatrix* wzMatrixRotationZ(wzMatrix* pOut, float Degree);
wzMatrix* wzMatrixRotationYawPitchRoll(wzMatrix* pOut, float Yaw, float Pitch, float Roll);
wzMatrix* wzMatrixRotationEuler(wzMatrix* pOut, float x, float y, float z);
wzMatrix* wzMatrixTranslation(wzMatrix* pOut, float fTransX, float fTransY, float fTransZ);
wzMatrix* wzMatrixTranspose(wzMatrix* pOut, wzMatrix* pIn);
wzMatrix* wzMatrixInverse(wzMatrix* pOut, wzMatrix* pIn);
wzMatrix* wzLookAtMatrixLH(wzMatrix* pOut, wzVector3* pEye, wzVector3* pAt, wzVector3* pUp);
wzMatrix* wzLookAtMatrixRH(wzMatrix* pOut, wzVector3* pEye, wzVector3* pAt, wzVector3* pUp);
wzMatrix* wzMatrixPerspectiveFovLH(wzMatrix* pOut, float fovY, float Aspect, float zn, float zf);
wzMatrix* wzMatrixPerspectiveFovRH(wzMatrix* pOut, float fovY, float Aspect, float zn, float zf);
wzMatrix* wzMatrixOrthoLH(wzMatrix* pOut, float left, float right, float bottom, float top, float zn, float zf);
wzMatrix* wzMatrixOrthoRH(wzMatrix* pOut, float left, float right, float bottom, float top, float zn, float zf);
void wzMatrixLerp(wzMatrix* pOut, const wzMatrix* m1, const wzMatrix* m2, float rate);
void wzMatrixToRowOrder(wzMatrix* pOut, double* m_array);
void wzMatrixToRowOrderf(wzMatrix* pOut, float* m_array);
wzQuaternion wzQuaternionCreate(float ax, float ay, float az);
void wzQuaternionAdd(wzQuaternion* pOut, wzQuaternion* pIn0, wzQuaternion* pIn1);
void wzQuaternionMul(wzQuaternion* pOut, wzQuaternion* pIn0, wzQuaternion* pIn1);
void wzQuaternionRotation(wzQuaternion* pOut, float rad, float ax, float ay, float az);
void wzQuaternionToMatrix(wzMatrix *pOut, wzQuaternion *pIn);
void wzRotMatrixToQuaternion(wzQuaternion* pOut, const wzMatrix* pMat);
void wzQuaternionSlerp(wzQuaternion* pOut, wzQuaternion* q1, wzQuaternion* q2, float rate);
wzRect wzRectCreate(float top, float bottom, float left, float right);
void wzRectSet(wzRect* pOut, float top, float bottom, float left, float right);
wzVector3* wzCalculateNormal(wzVector3* pOut, wzVector3* p1, wzVector3* p2, wzVector3* p3);
void CalculateTangentAndBinormal(wzVector3* pOutTangent, wzVector3* pOutBinormal,
								 wzVector3* p0, wzVector2* uv0,wzVector3* p1, wzVector2* uv1,wzVector3* p2, wzVector2* uv2);
// Texture
int wzCreateTextureFromColor(wzTexture* stex, int size, unsigned char r, unsigned char g, unsigned char b);
int wzCreateTextureFromPNG(wzTexture* stex, const char* filepath);
int wzCreateTextureCubeFromPNG(wzTexture* stex, const char* filepath);
int wzCreateTextureMipmapFromPNG(wzTexture* stex, int mipmap, const char* filepath);
int wzCreateTextureCubeMipmapFromPNG(wzTexture* stex, int mipmap, const char* filepath);
int wzCreateTextureMipmapFromMemPNG(wzTexture* stex, int mipmap, void* data, int datalen);
int wzCreateTexture(wzTexture* stex, int w, int h, int colortype, char* texbuf);
int wzCreateTextureCube(wzTexture* stex, int w, int h, int colortype, char* texbuf);
int wzCreateTextureMipmap(wzTexture* stex, int w, int h, int mipmap, int colortype, char* texbuf);
int wzCreateTextureCubeMipmap(wzTexture* stex, int w, int h, int mipmap, int colortype, char* texbuf);
int wzCreateTextureBuffer(wzTexture* stex, int w, int h, int colortype);
int wzCreateTextureMemoryFromPNG(char** pTexbuf, unsigned int* pLen, const char* filepath);
int wzChangeTextureBuffer(wzTexture* stex, int x, int y, int w, int h, int colortype, char* texbuf, int mipmap);
int wzGetTextureBuffer(wzTexture* stex, int colortype, char* texbuf);
int wzDeleteTexture(wzTexture* stex);
void wzSetTextureWarp(wzTexture* stex, texparam u, texparam v);
void wzSetTextureFilter(wzTexture* stex, texparam min, texparam mag);
void wzSetTextureMipMapFilter(wzTexture* stex, texparam min, texparam mag, float anisotropy);
void wzSetTextureWarpBorderColor(wzTexture* stex, float r, float g, float b, float a);	//OpenGL 3.0のみ
// Shader
int wzCreateShader_GLSL(wzShaderProg* spg, const char* vsbuf, const char* fsbuf, wzVertexElements* ve);
#define wzCreateShader wzCreateShader_GLSL	//定義
int wzCreateShaderFromFile(wzShaderProg* spg, const char* shaderfile, wzVertexElements* ve);
void wzDeleteShader(wzShaderProg* spg);
int wzUseShader(wzShaderProg* spg);
void wzSetTexture(const char* param, wzTexture* texture, unsigned int stage);
void wzUniformMatrix(const char* param, wzMatrix* value);
void wzUniformMatrixArray(const char* param, wzMatrix* v_array, int array_size);
void wzUniformInteger(const char* param, int value);
void wzUniformIntegerArray(const char* param, int* v_array, int array_size);
void wzUniformFloat(const char* param, float value);
void wzUniformFloatArray(const char* param, float* v_value, int array_size);
void wzUniformVector2(const char* param, wzVector2* value);
void wzUniformVector3(const char* param, wzVector3* value);
void wzUniformVector4(const char* param, wzVector4* value);
char* wzGetShaderVersion();
// Sprite
int wzInitSprite();
int wzExitSprite();
void wzSetSpriteVertexSetting(wzVector2* p1, wzVector2* p2, wzVector2* p3, wzVector2* p4, float depth);
void wzSetSpritePosition(float x, float y, float z);
void wzSetSpriteSize(float w, float h);
void wzSetSpriteSizeLeftUp(float w, float h);
void wzSetSpriteSizeLeftDown(float w, float h);
void wzSetSpriteSizeRightUp(float w, float h);
void wzSetSpriteSizeRightDown(float w, float h);
void wzSetSpriteTexCoord(float u, float v, float uw, float vh);
void wzSetSpriteTexCoordYRef(float u, float v, float uw, float vh);
void wzSetSpriteRotate(float angdeg);
void wzSetSpriteScSize(float w, float h);
void wzSetSpriteColor(float r, float g, float b, float a);
void wzSetSpriteTexture(wzTexture* texture);
void wzSpriteDraw();
// Debug
int wzInitDebug();
void wzExitDebug();
int wzPrintf(int _x, int _y, char * fmt, ...);
void wzFontSize(int size);
void wzFontDepth(float z);
void wzPrintString(int _x, int _y, char* str);
void wzPrintChar(int _x, int _y, char inChar);
int wzCreateDebugButton(int id, int w, int h, char *text, char* fontpath);
int wzDeleteDebugButton(int id);
int wzDrawDebugButton(int id, float x, float y, float z);
int wzGetPushDebugButton(int id);
// Thread
wzThdHandle wzCreateThread(void(*startaddr)(void *), void* arg);
int wzWaitEndThread(wzThdHandle thdHandle);
int wzInternalEndThread(void);
wzThdMutex wzCreateMutex();
void wzDeleteMutex(wzThdMutex* mutex);
void wzMutexLock(wzThdMutex* mutex);
void wzMutexUnLock(wzThdMutex* mutex);
// Line
int wzInitLine();
int wzExitLine();
void wzSetLinePosition(float start_x, float start_y, float end_x, float end_y, float depth);
void wzSetLineScSize(float w, float h);
void wzSetLineColor(float r, float g, float b, float a);
void wzLineDraw();
// 3DLine
int wzInitLine3D();
int wzExitLine3D();
void wzSetLine3DPosition(float sx, float sy, float sz, float ex, float ey, float ez);
void wzSetLine3DColor(float r, float g, float b, float a);
void wzSetCameraL3Position(float x, float y, float z);
void wzSetCameraL3LookAt(float x, float y, float z);
void wzSetCameraL3Up(float x, float y, float z);
void wzSetCameraL3ScSize(float w, float h, float n, float f, float fovY);
void wzLine3DDrawLH();
void wzLine3DDrawRH();
// Font
int wzInitFont();
int wzExitFont();
int wzCreateFontScBuffer(int w, int h);
int wzCreateFontTexBuffer(wzTexture* ptex, int texsize);
int wzSetFontFile(const char* filepath);
int wzSetFontMemory(void* data, long datasize);
void wzSetCharcode(int code);
void wzSetFontDrawPosition(int x, int y);
void wzSetFontDrawSize(int size);
void wzSetFontDrawColor(float r, float g, float b, float a);
void wzSetFontDrawType(int type);
int wzGetFontStringWidth(const char* str);
int wzGetFontVerticalStringHeight(const char* str);
int wzGetCharSize(char* charcode);
void wzFontDrawClear();
void wzFontDrawChar(char* charcode);
void wzFontDrawString(const char* str);
void wzFontDrawStringLineFeed(const char* str, const int w, const int h);
void wzFontDrawVerticalString(const char* str);
int wzFontDrawPrintf(const char* fmt, ...);
void wzFontDraw(float depth);
// RenderBuffer
int wzCreateRenderBufferDepth(wzRenderBuffer* pRb, int w, int h);
int wzCreateRenderBufferStencil(wzRenderBuffer* pRb, int w, int h);
int wzCreateRenderBufferDepthStencil(wzRenderBuffer* pRb, int w, int h);
int wzDeleteRenderBuffer(wzRenderBuffer* pRb);
// RenderTarget
int wzCreateRenderTarget(wzRenderTarget* pRt);
int wzDeleteRenderTarget(wzRenderTarget* pRt);
void wzUseRenderTarget(wzRenderTarget* pRt);
void wzClearBufferRenderTarget(wzRenderTarget* pRt);
void wzSetRenderTexture(wzRenderTarget* pRt, wzTexture* texture);
void wzSetRenderBuffer(wzRenderTarget* pRt, wzRenderBuffer* renderbuf);
unsigned int wzGetClearFlag(wzRenderTarget* pRt);
// Mesh
int wzCreateMesh(wzMesh* pMesh, void* vertex_array[], wzVertexElements* ve,
				 unsigned short* idx, int vsize, int fsize);
void wzChangeDrawMode(wzMesh* pMesh, unsigned int flag);
void wzChangeDrawRange(wzMesh* pMesh, int start, int end);
int wzDrawMesh(wzMesh* pMesh);
int wzDeleteMesh(wzMesh* pMesh);
// MeshCOLLADA
int wzMeshLoadCOLLADA(wzMesh* pMesh, int* pMeshNum, const char* daefile);
// MeshModelDraw
int wzInitModelDraw();
int wzExitModelDraw();
void wzSetModelPosition(float x, float y, float z);
void wzSetModelLocalPosition(float x, float y, float z);
void wzSetModelScale(float x, float y, float z);
void wzSetModelRotation(float y, float p, float r);
void wzSetModelColor(float r, float g, float b, float a);
void wzSetCameraPosition(float x, float y, float z);
void wzSetCameraLookAt(float x, float y, float z);
void wzSetCameraUp(float x, float y, float z);
void wzSetCameraScSize(float w, float h, float n, float f, float fovY);
void wzSetMeshTexture(wzMesh* pMesh, wzTexture* pTex);
void wzModelDrawLH();
void wzModelDrawRH();
// Collision2D
float wzDistance2Point(wzVector2* p1, wzVector2* p2);
int wzPointInRect(wzVector2* point, wzRect* rect);
int wzPointInRectCenter(wzVector2* point, wzVector2* center, wzVector2* size);
int wzPointInCircle(wzVector2* point, wzVector2* circle_c, float circle_r);
int wzPointInTriangle(wzVector2* point, wzVector2* tg_p1, wzVector2* tg_p2, wzVector2* tg_p3);
int wzOrthogonal(wzVector2* a1, wzVector2* a2, wzVector2* b1, wzVector2* b2);
int wzRectOnRect(wzRect* rect1, wzRect* rect2);
int wzCircleOnCircle(wzVector2* circle1_c, float circle1_r, wzVector2* circle2_c, float circle2_r);
int wzRectOnCircle(wzRect* rect, wzVector2* circle_c, float circle_r);
int wzIntersected(wzVector2* a1, wzVector2* a2, wzVector2* b1, wzVector2* b2);
wzVector2 wzIntersection(wzVector2* a1, wzVector2* a2, wzVector2* b1, wzVector2* b2);
// Collision3D
int wzBoundingSphere(wzVector3* sphere1_c, float sphere1_r, wzVector3* sphere2_c, float sphere2_r);
int wzAxisAlignedBoundingBox(wzVector3* box1_pos, wzVector3* box1_min, wzVector3* box1_max,
							 wzVector3* box2_pos, wzVector3* box2_min, wzVector3* box2_max);
int wzOrientedBoundingBox(wzVector3* box1_c, wzVector3* box1_size, wzMatrix* box1_rotMat,
						  wzVector3* box2_c, wzVector3* box2_size, wzMatrix* box2_rotMat);
int wzIntersectPolygon(wzVector3* ray_a, wzVector3* ray_b, wzVector3 vertex3[]);
//FXAA3
int wzInitFXAA3();
void wzExitFXAA3();
void wzFXAADrawBegin();
void wzFXAADrawEnd();

#ifndef __WIZAPPLY_NO_PATRICIA_
//Patricia
// Audio
int wzCreateAudio(wzAudioSrc* pAudio, void* data, int size, unsigned int fmtflag, int frequency);
int wzCreateAudioStreaming(wzAudioSrc* pAudio, void* data, int size, unsigned int fmtflag, int frequency);
int wzDeleteAudio(wzAudioSrc* pAudio);
void wzAudioPlay(wzAudioSrc* pAudio);
void wzAudioStop(wzAudioSrc* pAudio);
void wzSetAudioLoop(wzAudioSrc* pAudio, int loop);
void wzSetAudioInfluence(wzAudioSrc* pAudio, float influence);
void wzSetSourcePosition(wzAudioSrc* pAudio, float x, float y, float z);
void wzSetSourceVelocity(wzAudioSrc* pAudio, float vx, float vy, float vz);
void wzSetSourceOffset(wzAudioSrc* pAudio, unsigned long pos);
unsigned long wzGetSourceOffset(wzAudioSrc* pAudio);
void wzSetRolloffFactor(wzAudioSrc* pAudio, float value);
void wzSetMaxDistance(wzAudioSrc* pAudio, float value);
void wzSetReferenceDistance(wzAudioSrc* pAudio, float value);
void wzSetGainRange(wzAudioSrc* pAudio, float range);
void wzSetGain(wzAudioSrc* pAudio, float volume);
void wzSetPitch(wzAudioSrc* pAudio, float pitch);
void wzSetListenPosition(float x, float y, float z);
void wzSetListenVelocity(float vx, float vy, float vz);
void wzSetListenVecDirection(float x, float y, float z, float upx, float upy, float upz);
void wzSetListenRadDirection(float radian, float upx, float upy, float upz);
//WaveformOgg
int wzCreateWaveformFromOGG(wzWaveform* pWf, const char* filePath);
int wzCreateAudioFromOGG(wzAudioSrc* pAudio, const char* filePath);
int wzCreateStreamingAudioFromOGG(wzAudioSrc* pAudio, const char* filePath);
int wzDeleteWaveform(wzWaveform* pWf);
#endif /*__WIZAPPLY_NO_PATRICIA_*/

//Jennifer
// Network
int wzCreateSocketTCPServer(wzSocket* pSocket, unsigned short s_port, int blocking, int max_connect);
int wzCreateSocketTCPClient(wzSocket* pSocket, const char* s_iphost, unsigned short s_port, int blocking);
int wzCreateSocketUDP(wzSocket* pSocket, unsigned short s_port, int blocking);
int wzCreateSenderUDP(wzSender* pSender, const char* s_iphost, unsigned short s_port);
int wzCreateBroadcastUDP(wzSender* pSender, unsigned short s_port);
void wzDeleteSocket(wzSocket* pSocket);
int wzAccept(wzSocket* pSocketCl, wzSocket* pSocket);
int wzSendData(wzSocket* pSocket, const char* buffer, int bufsize, wzSender* sender);
int wzRecvData(wzSocket* pSocket, char* bufpool, int bufsize, wzSender* sender);
// NetworkHelper
char* wzGetSelfIP(int index);
char* wzGetConnectedSelfIP(wzSocket* pSocket);
char* wzGetHostToIP(int index, const char* host);
// HTTPConnection
int wzHTTPToMessage(const char* uri, char* bufmes, int messize, unsigned short timeout);
int wzHTTPToPost(const char* uri, char* bufmes, int messize, char* strpost, unsigned short timeout);
int wzHTTPFileDownLoad(const char* uri, const char* savefile, unsigned short timeout);
int wzHTTPFileDownLoadProgress(int* getfilesize, int* getdlsize);
int wzHTTPFileDownLoadBlocking();
void wzHTTPFileDownLoadStop();

//キーコードマクロ
//WINDOWS用キーコード一覧
#if defined(WIN32) || defined(WIN64)
//COMMAND
#define WZ_KEY_BACK		VK_BACK
#define WZ_KEY_TAB		VK_TAB
#define WZ_KEY_RETURN	VK_RETURNs
#define WZ_KEY_LSHIFT	VK_LSHIFT
#define WZ_KEY_RSHIFT	VK_RSHIFT
#define WZ_KEY_LCTRL	VK_LCONTROL
#define WZ_KEY_RCTRL	VK_RCONTROL
#define WZ_KEY_MENU		VK_MENU
#define WZ_KEY_PAUSE	VK_PAUSE
#define WZ_KEY_ESCAPE	VK_ESCAPE
#define WZ_KEY_SPACE	VK_SPACE
#define WZ_KEY_PAGEUP	VK_PRIOR
#define WZ_KEY_PAGEDOWN	VK_NEXT
#define WZ_KEY_END		VK_END
#define WZ_KEY_HOME		VK_HOME
#define WZ_KEY_LEFT		VK_LEFT
#define WZ_KEY_UP		VK_UP
#define WZ_KEY_RIGHT	VK_RIGHT
#define WZ_KEY_DOWN		VK_DOWN
#define WZ_KEY_INSERT	VK_INSERT
#define WZ_KEY_DELETE	VK_DELETE
//0-9A-Z
#define WZ_KEY_0		'0'
#define WZ_KEY_1		'1'
#define WZ_KEY_2		'2'
#define WZ_KEY_3		'3'
#define WZ_KEY_4		'4'
#define WZ_KEY_5		'5'
#define WZ_KEY_6		'6'
#define WZ_KEY_7		'7'
#define WZ_KEY_8		'8'
#define WZ_KEY_9		'9'
#define WZ_KEY_A		'A'
#define WZ_KEY_B		'B'
#define WZ_KEY_C		'C'
#define WZ_KEY_D		'D'
#define WZ_KEY_E		'E'
#define WZ_KEY_F		'F'
#define WZ_KEY_G		'G'
#define WZ_KEY_H		'H'
#define WZ_KEY_I		'I'
#define WZ_KEY_J		'J'
#define WZ_KEY_K		'K'
#define WZ_KEY_L		'L'
#define WZ_KEY_M		'M'
#define WZ_KEY_N		'N'
#define WZ_KEY_O		'O'
#define WZ_KEY_P		'P'
#define WZ_KEY_Q		'Q'
#define WZ_KEY_R		'R'
#define WZ_KEY_S		'S'
#define WZ_KEY_T		'T'
#define WZ_KEY_U		'U'
#define WZ_KEY_V		'V'
#define WZ_KEY_W		'W'
#define WZ_KEY_X		'X'
#define WZ_KEY_Y		'Y'
#define WZ_KEY_Z		'Z'
//SPECIAL
#define WZ_KEY_COLON	VK_OEM_1
#define WZ_KEY_SMCOLON	VK_OEM_PLUS
#define WZ_KEY_COMMA	VK_SEPARATOR
#define WZ_KEY_MINUS	VK_OEM_MINUS
#define WZ_KEY_DOT		VK_OEM_PERIOD
#define WZ_KEY_SLASH	VK_OEM_2
#define WZ_KEY_ATMARK	VK_OEM_3
#define WZ_KEY_LBRACE	VK_OEM_4
#define WZ_KEY_YEN		VK_OEM_5
#define WZ_KEY_RBRACE	VK_OEM_6
#define WZ_KEY_CARET	VK_OEM_7
//FUNCTION
#define WZ_KEY_F1		VK_F1
#define WZ_KEY_F2		VK_F2
#define WZ_KEY_F3		VK_F3
#define WZ_KEY_F4		VK_F4
#define WZ_KEY_F5		VK_F5
#define WZ_KEY_F6		VK_F6
#define WZ_KEY_F7		VK_F7
#define WZ_KEY_F8		VK_F8
#define WZ_KEY_F9		VK_F9
#define WZ_KEY_F10		VK_F10
#define WZ_KEY_F11		VK_F11
#define WZ_KEY_F12		VK_F12
//NUMPAD
#define WZ_KEY_NUMPAD0	VK_NUMPAD0
#define WZ_KEY_NUMPAD1	VK_NUMPAD1
#define WZ_KEY_NUMPAD2	VK_NUMPAD2
#define WZ_KEY_NUMPAD3	VK_NUMPAD3
#define WZ_KEY_NUMPAD4	VK_NUMPAD4
#define WZ_KEY_NUMPAD5	VK_NUMPAD5
#define WZ_KEY_NUMPAD6	VK_NUMPAD6
#define WZ_KEY_NUMPAD7	VK_NUMPAD7
#define WZ_KEY_NUMPAD8	VK_NUMPAD8
#define WZ_KEY_NUMPAD9	VK_NUMPAD9
#define WZ_KEY_MULTIPLY	VK_MULTIPLY
#define WZ_KEY_ADD		VK_ADD
#define WZ_KEY_SUBTRACT	VK_SUBTRACT
#define WZ_KEY_DECIMAL	VK_DECIMAL
#define WZ_KEY_DIVIDE	VK_DIVIDE
#endif

//MACOSX用キーコード一覧
#if defined(MACOSX)
//COMMAND
#define WZ_KEY_BACK		0x33
#define WZ_KEY_TAB		0x30
#define WZ_KEY_RETURN	0x24
#define WZ_KEY_LSHIFT	0x38
#define WZ_KEY_RSHIFT	0x3C
#define WZ_KEY_LCTRL	kVK_Control
#define WZ_KEY_RCTRL	kVK_RightControl
#define WZ_KEY_MENU		0	//非対応
#define WZ_KEY_PAUSE	0	//非対応
#define WZ_KEY_ESCAPE	0x35
#define WZ_KEY_SPACE	0x31
#define WZ_KEY_PAGEUP	kVK_PageUp
#define WZ_KEY_PAGEDOWN	kVK_PageDown
#define WZ_KEY_END		kVK_End
#define WZ_KEY_HOME		kVK_Home
#define WZ_KEY_LEFT		0x7B
#define WZ_KEY_UP		0x7E
#define WZ_KEY_RIGHT	0x7C
#define WZ_KEY_DOWN		0x7D
#define WZ_KEY_INSERT	0	//非対応
#define WZ_KEY_DELETE	0x33
//0-9A-Z
#define WZ_KEY_0		0x1D
#define WZ_KEY_1		0x12
#define WZ_KEY_2		0x13
#define WZ_KEY_3		0x14
#define WZ_KEY_4		0x15
#define WZ_KEY_5		0x17
#define WZ_KEY_6		0x16
#define WZ_KEY_7		0x1A
#define WZ_KEY_8		0x1C
#define WZ_KEY_9		0x19
#define WZ_KEY_A		0x00
#define WZ_KEY_B		0x0B
#define WZ_KEY_C		0x08
#define WZ_KEY_D		0x02
#define WZ_KEY_E		0x0E
#define WZ_KEY_F		0x03
#define WZ_KEY_G		0x05
#define WZ_KEY_H		0x04
#define WZ_KEY_I		0x22
#define WZ_KEY_J		0x26
#define WZ_KEY_K		0x28
#define WZ_KEY_L		0x25
#define WZ_KEY_M		0x2E
#define WZ_KEY_N		0x2D
#define WZ_KEY_O		0x1F
#define WZ_KEY_P		0x23
#define WZ_KEY_Q		0x0C
#define WZ_KEY_R		0x0F
#define WZ_KEY_S		0x01
#define WZ_KEY_T		0x11
#define WZ_KEY_U		0x20
#define WZ_KEY_V		0x09
#define WZ_KEY_W		0x0D
#define WZ_KEY_X		0x07
#define WZ_KEY_Y		0x10
#define WZ_KEY_Z		0x06
//SPECIAL
#define WZ_KEY_COLON	kVK_ANSI_Quote
#define WZ_KEY_SMCOLON	kVK_ANSI_Semicolon
#define WZ_KEY_COMMA	kVK_ANSI_Comma
#define WZ_KEY_MINUS	kVK_ANSI_Minus
#define WZ_KEY_DOT		kVK_ANSI_Period
#define WZ_KEY_SLASH	kVK_ANSI_Slash
#define WZ_KEY_ATMARK	kVK_ANSI_Grave
#define WZ_KEY_LBRACE	kVK_ANSI_LeftBracket
#define WZ_KEY_YEN		kVK_JIS_Yen
#define WZ_KEY_RBRACE	kVK_ANSI_RightBracket
#define WZ_KEY_CARET	kVK_ANSI_Equal
//FUNCTION
#define WZ_KEY_F1		kVK_F1
#define WZ_KEY_F2		kVK_F2
#define WZ_KEY_F3		kVK_F3
#define WZ_KEY_F4		kVK_F4
#define WZ_KEY_F5		kVK_F5
#define WZ_KEY_F6		kVK_F6
#define WZ_KEY_F7		kVK_F7
#define WZ_KEY_F8		kVK_F8
#define WZ_KEY_F9		kVK_F9
#define WZ_KEY_F10		kVK_F10
#define WZ_KEY_F11		kVK_F11
#define WZ_KEY_F12		kVK_F12
//NUMPAD
#define WZ_KEY_NUMPAD0	kVK_ANSI_Keypad0
#define WZ_KEY_NUMPAD1	kVK_ANSI_Keypad1
#define WZ_KEY_NUMPAD2	kVK_ANSI_Keypad2
#define WZ_KEY_NUMPAD3	kVK_ANSI_Keypad3
#define WZ_KEY_NUMPAD4	kVK_ANSI_Keypad4
#define WZ_KEY_NUMPAD5	kVK_ANSI_Keypad5
#define WZ_KEY_NUMPAD6	kVK_ANSI_Keypad6
#define WZ_KEY_NUMPAD7	kVK_ANSI_Keypad7
#define WZ_KEY_NUMPAD8	kVK_ANSI_Keypad8
#define WZ_KEY_NUMPAD9	kVK_ANSI_Keypad9
#define WZ_KEY_MULTIPLY	kVK_ANSI_KeypadMultiply
#define WZ_KEY_ADD		kVK_ANSI_KeypadPlus
#define WZ_KEY_SUBTRACT	kVK_ANSI_KeypadMinus
#define WZ_KEY_DECIMAL	kVK_ANSI_KeypadDecimal
#define WZ_KEY_DIVIDE	kVK_ANSI_KeypadDivide
#endif

//X11用キーコード一覧
#if defined(X11)
//COMMAND
#define WZ_KEY_BACK		KEY_BACKSPACE
#define WZ_KEY_TAB		KEY_TAB
#define WZ_KEY_RETURN	KEY_ENTER
#define WZ_KEY_LSHIFT	KEY_LEFTSHIFT
#define WZ_KEY_RSHIFT	KEY_RIGHTSHIFT
#define WZ_KEY_LCTRL	KEY_LEFTCTRL
#define WZ_KEY_RCTRL	KEY_RIGHTCTRL
#define WZ_KEY_MENU		KEY_MENU
#define WZ_KEY_PAUSE	KEY_PAUSE
#define WZ_KEY_ESCAPE	KEY_ESC
#define WZ_KEY_SPACE	KEY_SPACE
#define WZ_KEY_PAGEUP	KEY_PAGEUP
#define WZ_KEY_PAGEDOWN	KEY_PAGEDOWN
#define WZ_KEY_END		KEY_END
#define WZ_KEY_HOME		KEY_HOME
#define WZ_KEY_LEFT		KEY_LEFT
#define WZ_KEY_UP		KEY_UP
#define WZ_KEY_RIGHT	KEY_RIGHT
#define WZ_KEY_DOWN		KEY_DOWN
#define WZ_KEY_INSERT	KEY_INSERT
#define WZ_KEY_DELETE	KEY_DELETE
//0-9A-Z
#define WZ_KEY_0		KEY_0
#define WZ_KEY_1		KEY_1
#define WZ_KEY_2		KEY_2
#define WZ_KEY_3		KEY_3
#define WZ_KEY_4		KEY_4
#define WZ_KEY_5		KEY_5
#define WZ_KEY_6		KEY_6
#define WZ_KEY_7		KEY_7
#define WZ_KEY_8		KEY_8
#define WZ_KEY_9		KEY_9
#define WZ_KEY_A		KEY_A
#define WZ_KEY_B		KEY_B
#define WZ_KEY_C		KEY_C
#define WZ_KEY_D		KEY_D
#define WZ_KEY_E		KEY_E
#define WZ_KEY_F		KEY_F
#define WZ_KEY_G		KEY_G
#define WZ_KEY_H		KEY_H
#define WZ_KEY_I		KEY_I
#define WZ_KEY_J		KEY_J
#define WZ_KEY_K		KEY_K
#define WZ_KEY_L		KEY_L
#define WZ_KEY_M		KEY_M
#define WZ_KEY_N		KEY_N
#define WZ_KEY_O		KEY_O
#define WZ_KEY_P		KEY_P
#define WZ_KEY_Q		KEY_Q
#define WZ_KEY_R		KEY_R
#define WZ_KEY_S		KEY_S
#define WZ_KEY_T		KEY_T
#define WZ_KEY_U		KEY_U
#define WZ_KEY_V		KEY_V
#define WZ_KEY_W		KEY_W
#define WZ_KEY_X		KEY_X
#define WZ_KEY_Y		KEY_Y
#define WZ_KEY_Z		KEY_Z
//SPECIAL
#define WZ_KEY_COLON	KEY_APOSTROPHE
#define WZ_KEY_SMCOLON	KEY_SEMICOLON
#define WZ_KEY_COMMA	KEY_COMMA
#define WZ_KEY_MINUS	KEY_MINUS
#define WZ_KEY_DOT		KEY_DOT
#define WZ_KEY_SLASH	KEY_SLASH
#define WZ_KEY_ATMARK	KEY_GRAVE
#define WZ_KEY_LBRACE	KEY_LEFTBRACE
#define WZ_KEY_YEN		KEY_YEN
#define WZ_KEY_RBRACE	KEY_RIGHTBRACE
#define WZ_KEY_CARET	KEY_EQUAL
//FUNCTION
#define WZ_KEY_F1		KEY_F1
#define WZ_KEY_F2		KEY_F2
#define WZ_KEY_F3		KEY_F3
#define WZ_KEY_F4		KEY_F4
#define WZ_KEY_F5		KEY_F5
#define WZ_KEY_F6		KEY_F6
#define WZ_KEY_F7		KEY_F7
#define WZ_KEY_F8		KEY_F8
#define WZ_KEY_F9		KEY_F9
#define WZ_KEY_F10		KEY_F10
#define WZ_KEY_F11		KEY_F11
#define WZ_KEY_F12		KEY_F12
//NUMPAD
#define WZ_KEY_NUMPAD0	KEY_KP0
#define WZ_KEY_NUMPAD1	KEY_KP1
#define WZ_KEY_NUMPAD2	KEY_KP2
#define WZ_KEY_NUMPAD3	KEY_KP3
#define WZ_KEY_NUMPAD4	KEY_KP4
#define WZ_KEY_NUMPAD5	KEY_KP5
#define WZ_KEY_NUMPAD6	KEY_KP6
#define WZ_KEY_NUMPAD7	KEY_KP7
#define WZ_KEY_NUMPAD8	KEY_KP8
#define WZ_KEY_NUMPAD9	KEY_KP9
#define WZ_KEY_MULTIPLY	KEY_KPASTERISK
#define WZ_KEY_ADD		KEY_KPPLUS
#define WZ_KEY_SUBTRACT	KEY_KPMINUS
#define WZ_KEY_DECIMAL	KEY_KPDOT
#define WZ_KEY_DIVIDE	KEY_KPSLASH
#endif

//専用関数（クロスプラットフォームではない）
//Windowsプロシージャー
#if defined(WIN32) || defined(WIN64)
HWND wzGetWindowHandle();
void wzSetWindowProcedureFunc(void(*profnc)(UINT uMsg, WPARAM wParam, LPARAM lParam));
void wzSetWindowIcon(HICON icon);	//★
#endif
    
#if defined(MACOSX)
void* wzGetWindowHandle();
#endif

//Androidのみ
#ifdef ANDROID
char* wzGetSDPath();
int wzWizapplySleep_Android(void(*func)(void));
#else
//それ以外
#define wzWizapplySleep_Android(x) (0)
#endif

#ifdef __cplusplus
}
#endif

#endif /*_WZ_WIZAPPLY_H_*/
