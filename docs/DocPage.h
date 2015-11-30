/*!
@mainpage Getting Started

@section features Ovrvision Features and Overview
@image html topimage.jpg

This is a high performance stereo camera where immersive AR and hand tracking are possible by fitting the Ovrvision Pro onto Oculus Rift.
Ovrvision Pro realizes high FPS, high resolution, wide viewing angle, both-eye synchronization, and low delay. It is equipped with EEPROM and GPIO along with an embedding-type extension slot that can be utilized for robot sensors.
It supports game engines such as Unity5 and Unreal Engine and AR software, and when combined with the Ovrvision Pro SDK that comes free of charge, a developmental environment of high versatility is possible.
Ovrvision Pro SDK is provided by MIT LICENSE as a license for open-source software, and it can be used freely regardless of commercial use.

Ovrvision ProはOculus Riftに装着する事で没入型ARやハンドトラッキングが行える高性能ステレオカメラです。
高FPS、高解像度、広視野角、両眼同期、低遅延を実現しています。EEPROMやGPIOを搭載し組み込み系の拡張スロットを備えているため、ロボセンサーなどにも活用可能です。
Unity5、Unreal EngineなどのゲームエンジンやARソフトウェアをサポートして無償提供されるOvrvision Pro SDKと合わせて汎用性の高い開発環境が整っています。
Ovrvision Pro SDKはオープンソースソフトウェアのライセンスであるMIT LICENSEで提供され、商用利用問わず自由にご利用頂けます。

More : http://ovrvision.com/

@subsection gscamdata About Camera Data

The camera option supported is shown below. 
対応しているカメラオプションは下記に示します。

@image html camparam_table.jpg

@subsection gscamprop About OvrvisionSDK Processing

@image html processing.jpg

The image upper 8bit is a left eye and lower 8bit is right eye, 16-bit data is transmitted.<br />
Although that is using the UVC standard, In the case of usual camera software, become such an image. <br />

1ピクセルで、上位8ビットが左目、下位8ビットが右目の16bitデータとして送信されています。<br />
UVC規格を使用しておりますが、通常のカメラソフトの場合は、このような画像となります。<br />

@image html noprocimage.jpg

Demosaic and undistortion are processed using GPU by OvrvisionSDK, the normal image is outputted. <br />
OvrvisionSDK側で、デモザイク処理、歪み補正処理をGPUにて行い正常な画像データを作り出しています。<br />

@image html procimage.jpg
* ovrvision_app_csharp.exe

@section gsstruct Content Structure

Ovrvision SDK
- bin/
  - x86/ : Program files for x86 CPU (Windows Only)
    - <b>ovrvision_app_csharp.exe</b> : Ovrvision Pro Camera C# Viewer
    - <b>ovrvision_app.exe</b> : Ovrvision Pro Camera C++ Viewer
    - <b>ovrvision_oculus_app.exe</b> : When looking by Oculus Rift
  - x64/ : Program files for x86_64 CPU (Windows Only)
    - <b>ovrvision_app.exe</b> : Ovrvision Pro Camera C++ Viewer
    - <b>ovrvision_oculus_app.exe</b> : When looking by Oculus Rift
  - mac/ : Program files for Mac OSX (Mac OSX Only)
  - demo/ : Demonstration
    - <b>ovrvision_figure.exe</b> : The AR demonstration using a product package.
- include/ : include files
- tools/
  - <b>calibration.exe</b> : Calibration Tool
- marker_samples/
- examples/
  - vs2013/ : VisualStudio 2013 build project files
  - vs2015/ : VisualStudio 2015 build project files
- <b>LICENSE</b> : Ovrvision SDK license
- <b>OculusVR_LICENSE</b> : Oculus Rift license for lib
- <b>VERSION</b> : Ovrvision SDK version infomation
 
@section conststruct Recommended System Requirements
- CPU : Intel Core i5,i7 (Haswell) 3.0Ghz processor, AMD FX-6300 processor or faster
- GPU GeForce GTX 760, AMD Radeon R9 280 or faster (OpenCL1.2 or more)
- Memory : DDR3-1600 4GB or more
- Interface : USB3.0 Port
- OS 
  - Windows 7, 8.1 and 10<br />
  - Mac OS X 10.10<br />
  - Linux (in the future)
- Development Environment : VS2013, VS2015, Xcode7, Unity5.2.3, UnrealEngine4.10(in the future)

@section install Installation
@subsection gstep1 Step 1: Setup your environment
Before you start developing applications with the Ovrvision Pro, setup the environment of a your computer. 
-# Install latest USB3.0 driver. 
-# Install latest GPU driver. (OpenCL1.2 or more)
-# Install latest Oculus Rift runtime.(Only when Oculus Rift is used.)
-# Install development environment, VisualStudio and Unity5 and etc...

OvrvisionProを接続する前に、パソコンの環境を設定する。
-# 最新のUSB3.0 driverをインストール
-# 最新のGPUドライバをインストール(OpenCL1.2以上に対応するもの)
-# 最新のOculus Runtimeをインストール(Oculus Riftを使用する場合のみ)
-# VisualStudioやUnityなどの開発環境を予めインストール

@subsection gstep2 Step 2: Run the Ovrvision Pro
Run Ovrvision Pro. 
-# Connect the OvrvisionPro to USB3.0 port. 
-# Standard UVC driver is installed. 
-# Start OvrvisionViewer.exe in bin folder. 
-# It will complete, if the Ovrvision Pro works satisfactorily. 

Ovrvision Proを動かしてみる
-# OvrvisionProをUSB3.0ポートに接続する
-# 標準のUVCドライバがインストール
-# binフォルダ内のOvrvisionViewer.exeを起動しオープン。
-# カメラ画像が問題なく動作すれば完了。

@subsection gstep3 Step 3: Ovrvision Pro calibration.
You should do a calibration, because it connects with environment. <br />
-# How to use a calibration tool is here. ：@ref calib
-# Run bin -> demo -> <b>ovrvision_figure.exe</b>

環境に合わせるため、キャリブレーションを行う。<br />
キャリブレーションはカメラレンズの変更がない限り、初回のみで良い。<br />
-# キャリブレーションツールの使い方はこちら：@ref calib
-# bin -> demo -> <b>ovrvision_figure.exe</b>を起動

@section license SDK License
Copyright(C) 2013-2016 Wizapply<br />
<br />
MIT License<br />
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR<br />
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,<br />
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE<br />
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER<br />
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,<br />
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN<br />
THE SOFTWARE.<br />
*/

/*!
@page page1 Using the Tools
@tableofcontents

Introduce how to use the tool attached to OvrvisionPro SDK. 
OvrvisionProに付属するツールの使い方についてご紹介します。

@section calib Calibration tool
@image html ovrvision2_sm_calib.jpg

Program path : 
- tools -> calibration.exe(Windows)
- tools -> calibration.app(Mac OSX)

@subsection calibsec1 How to Use
@image html calib_start.jpg

The usage should confirm the following video. <br />
使い方は、下記のビデオをご確認してください。<br />
<b style="font-size:22px">URL : <a href="https://www.youtube.com/watch?v=wSjqImFmxDY">https://www.youtube.com/watch?v=wSjqImFmxDY</a></b>

@section armarker AR Marker make tool
- Coming Soon
*/

/*! @page page3 How to Rebuild SDK
- Coming Soon
*/

/*! @page page4 Release Notes
@tableofcontents
@section sdk1 Ovrvision SDK v1.0
<b>Notes</b>
- First release.

<b>Unimplementeds and issue</b>
- OvrvisionTracking class : Hand tracking (in a few days) 
- Mac OSX support (in a few days) 
- Linux OS support
- Unreal Engine 4
*/

/*! @page page5 FAQ
  Coming Soon
*/