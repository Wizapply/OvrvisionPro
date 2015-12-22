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
 * EntryPoint.h
 */

#ifndef _WZ_ENTRYPOINT_H_
#define _WZ_ENTRYPOINT_H_

/*---- インクルードファイル ----*/

#include "wizapply.h"				//!<共通ヘッダー

/*---- プロトタイプ宣言 ----*/

#ifdef __cplusplus
extern "C" {
#endif

/*
 *	int Initialize()
 *
 *	＜引数＞
 *　　なし
 *	＜戻り値＞
 *　　なし
 *	＜説明＞
 *　　プログラムのエントリーポイントとして扱われます。
 *　　※定義のみ行われているのでユーザー側で実装する必要がある関数です。
 */
int Initialize();

/*
 *	int Terminate()
 *
 *	＜引数＞
 *　　なし
 *	＜戻り値＞
 *　　なし
 *	＜説明＞
 *　　プログラムの終了処理として扱われます。
 *　　※定義のみ行われているのでユーザー側で実装する必要がある関数です。
 */
int Terminate();

/*
 *	void DrawLoop()
 *
 *	＜引数＞
 *　　なし
 *	＜戻り値＞
 *　　なし
 *	＜説明＞
 *　　プログラムのループ処理として扱われます。
 *　　※定義のみ行われているのでユーザー側で実装する必要がある関数です。
 */
void DrawLoop();

//for the Oculus
void OculusEndFrame();
    
#ifndef WIN32
    int __argc;
    const char** __argv;
#endif

/*---- 関数 ----*/

// エントリポイント
#if defined(WIN32) || defined(WIN64)
#ifdef DEVELOPBUILD
int main(int argc, const char **argv)
#else
int WINAPI WinMain( HINSTANCE hInstance, HINSTANCE hPrevInstance,
					 char* szCmdLine, int nCmdShow )
#endif
#endif
#ifdef IOS
int main(int argc, const char **argv)
#endif
#ifdef MACOSX
int main(int argc, const char **argv)
#endif
#ifdef X11
int main(int argc, const char **argv)
#endif
#ifdef ANDROID9
void android_main(struct android_app* state)
#endif
#ifndef ANDROID
{
	#ifdef ANDROID9
		wzSetAndroidState((void*)state);
	#endif
    
#ifndef WIN32
    __argc = argc;
    __argv = argv;
#endif
    
	// 関数ポインタ
	wzSetITFuncOculusVR(Initialize, Terminate, DrawLoop, OculusEndFrame);

	// メイン:RUN
	wzMainWizapply();
}
#endif

#ifdef __cplusplus
}
#endif

#endif	/*_WZ_ENTRYPOINT_H_*/
