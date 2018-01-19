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

The camera option supported is shown below. <br />
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
  - ovrvision_app.app/ : OvrvisionPro Camera Viewer for Mac OSX (Mac OSX Only)
  - demo/ : Demonstration
    - <b>ovrvision_figure.exe</b> : The AR demonstration using a product package.
- include/ : include files
- tools/
  - <b>ovrvision_calibration.exe</b> : Calibration Tool
  - <b>ovrvision_clear_eeprom.exe</b> : Calibration Reset Tool (Windows Only)
  - <b>chess4x7x30mm.pdf</b> : The calibration board for printing.
- marker_samples/
- examples/
  - 3rdparty/ : Other libraries which use with examples
  - vs2013/ : VisualStudio 2013 build project files
  - vs2015/ : VisualStudio 2015 build project files
- <b>LICENSE</b> : Ovrvision SDK license
- <b>OculusVR_LICENSE</b> : Oculus Rift license for lib
 
@section conststruct Recommended System Requirements
- CPU : Intel Core i5,i7 (Haswell) 3.0Ghz processor, AMD FX-6300 processor or faster
- GPU GeForce GTX 760, AMD Radeon R9 280 or faster (OpenCL1.2 or more)
- Memory : DDR3-1600 8GB or more
- Interface : USB3.0 Port
- OS 
  - Windows 7, 8.1 and 10<br />
  - Mac OS X 10.10<br />
  - Linux (in the future)
- Development Environment : VS2013, VS2015, Xcode7, Unity5.3.0, UnrealEngine4.10(in the future)

@section install Installation
@subsection gstep1 Step 1: Setup your environment
Before you start developing applications with the Ovrvision Pro, setup the environment of a your computer. 
-# Install latest USB3.0 driver. 
-# Install latest GPU driver. (OpenCL1.2 or more)
-# Install latest Oculus Rift <b>v0.8</b> runtime.(Only when Oculus Rift is used.)
-# Install development environment, VisualStudio and Unity5 and etc...

OvrvisionProを接続する前に、パソコンの環境を設定する。
-# 最新のUSB3.0 driverをインストール
-# 最新のGPUドライバをインストール(OpenCL1.2以上に対応するもの)
-# 最新のOculus Runtime v0.8をインストール(Oculus Riftを使用する場合のみ)
-# VisualStudioやUnityなどの開発環境を予めインストール

@subsection gstep2 Step 2: Run the Ovrvision Pro
Run Ovrvision Pro. 
-# Connect the OvrvisionPro to USB3.0 port. 
-# Standard UVC driver is installed. 
-# Start "ovrvision_app_csharp.exe" in bin folder, and the camera open. 
-# It will complete, if the Ovrvision Pro works satisfactorily. 

Ovrvision Proを動かしてみる
-# OvrvisionProをUSB3.0ポートに接続する
-# 標準のUVCドライバがインストール
-# binフォルダ内の「ovrvision_app_csharp.exe」を起動しオープン
-# カメラ画像が問題なく動作すれば完了

@subsection gstep3 Step 3: Ovrvision Pro calibration.
You should do a calibration, because it connects with environment. <br />
-# How to use a calibration tool is here. ：@ref calib
-# Run the [bin -> x86 or x64 -> <b>ovrvision_app.exe</b>]

環境に合わせるため、キャリブレーションを行う<br />
キャリブレーションはカメラレンズの変更がない限り、初回のみで良い<br />
-# キャリブレーションツールの使い方はこちら：@ref calib
-# bin -> x86 or x64 -> <b>ovrvision_app.exe</b>を起動

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

Introduce how to use the tool attached to OvrvisionPro SDK.  <br />
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
- Aruco Marker Generator
HIRE : <a href="http://terpconnect.umd.edu/~jwelsh12/enes100/markergen.html" target="_blank">http://terpconnect.umd.edu/~jwelsh12/enes100/markergen.html</a>
(C) terpconnect.umd.edu
*/


/*! @page page3 How to Play Demons
@tableofcontents
@section htdemo_ardemo AR Demonstration
The demonstration which does AR.<br />
ＡＲ機能を使います。<br />

- デモンストレーションプログラムを<a href="https://www.dropbox.com/s/8yy7isjnsrfkl08/ar_demo.zip?dl=0" target="_new">ここから</a>ダウンロードします。
- Please download a demonstration program from <a href="https://www.dropbox.com/s/8yy7isjnsrfkl08/ar_demo.zip?dl=0" target="_new">HERE</a>. 

If program is started, please look the package of OvrvisionPro.<br />
It is completion when a character appears.<br />
プログラムを起動したら、OvrvisionProのパッケージを見ます。<br />
キャラクターが出現したら完了です。<br />

@image html ar_1.png

@section htdemo_handtrack Hand Tracking Demonstration
The demonstration which does Tracking of the finger.<br />
指をトラッキングする機能を使います。<br />

- デモンストレーションプログラムを<a href="https://www.dropbox.com/s/563xs2a017lnk5t/handtracking_demo.zip?dl=0" target="_new">ここから</a>ダウンロードします。
- Please download a demonstration program from <a href="https://www.dropbox.com/s/563xs2a017lnk5t/handtracking_demo.zip?dl=0" target="_new">HERE</a>. 

If program is started, please start the calibration for Tracking by the "H" key. <br />
プログラムを起動したら「H」キーでトラッキング用キャリブレーションを開始します。
@image html tracking_1.jpg

Like an image, you combine with the cap of the Tracking color, and red beige blue. <br />
画像のように、青色にトラッキング色のキャップ、赤色に肌色に合わせます。
@image html tracking_2.jpg
Please press and set the "SPACE" key. <br />
When it cannot do well, you press and reset a key repeatedly. 
「SPACE」キーを押してセットします。<br />
上手くいかなかった場合は、何度もキーを押してリセットします。
@image html tracking_3.jpg

It is completion when a red marker appears in the finger. 
指に赤いマーカーが表示されたら完了です。
*/

/*! @page page4 Use in VisualStudio
@image html into_vs1.jpg
Explain the usage in the case of using OvrvisionPro in VisualStudio.<br />
VisualStudioでOvrvisionProを使用する場合の使い方を説明します。<br />
@image html into_vs2.jpg
First, in order to compile Program for Oculus Rift, please install the DirectX SDK. <br />
Download: <a href="https://www.microsoft.com/en-us/download/details.aspx?id=68120" target="_new">https://www.microsoft.com/en-us/download/details.aspx?id=6812</a><br />
まずは、Oculus Rift用プログラムをコンパイルするために「DirectX SDK」をインストールします。<br />
ここからダウンロード：<a href="https://www.microsoft.com/en-us/download/details.aspx?id=68120" target="_new">https://www.microsoft.com/en-us/download/details.aspx?id=6812</a><br />
@image html into_vs3.jpg
Open the solution of Examples folder -> vs2015 or vs2013 by VisualStudio.<br />
And it will be completion, if it builds and finishes normally.<br />
Examplesフォルダ→vs2015又はvs2013のソリューションをVisualStudioで開きます。<br />
そしてビルドを行い、正常に終われば完了です。<br />
*/

/*! @page page5 Use in Unity5
Unity Editor should use Version 5.3 or more. <br />
Unity Editorは必ずVersion 5.3以上をご利用ください。
@image html into_unity1.jpg
Explain the usage in the case of using OvrvisionPro in Unity5.3. <br />
Unity5でOvrvisionProを使用する場合の使い方を説明します。
@image html into_unity2.jpg
First, please import UnityPackage of OvrvisionSDK.  <br />
まずは、ダウンロードしたOvrvisionSDKのUnityPackageをインポートします。
@image html into_unity3.jpg
"OvrvisionPro" is added to the menubar of Unity5. Click top "Add OvrvisionProCamera" and put the ovrvision system on this scene.  <br />
Unity5のメニューバーに「OvrvisionPro」が追加されます。一番上の「Add OvrvisionProCamera」をクリックし、Ovrvision用のシステムをシーンに追加します。
@image html into_unity4.jpg
It is completion when it can add like this image. Please push PLAY of Unity5 and confirm run. If using AR Function and a hand tracking Function, Click "Add OvrvisionARTracker" of a menu bar, and "Add OvrvisionHandTracker", and put on this scene.  <br />
このように追加できたら完了です。Unity5の再生を押して起動を確認してください。もし、ＡＲ機能やハンドトラッキング機能を利用する場合はメニューバーの「Add OvrvisionARTracker」や「Add OvrvisionHandTracker」をクリックしてシーンに追加します。
@image html into_unity5.jpg
If required, can change setting by "OvrvisionProCamera" Object. AR Marker size is metric system. : 0.15 = 15cm<br />
必要に応じて、「OvrvisionProCamera」の設定を変更できます。AR Marker sizeはメートル法です。 : 0.15 = 15cm

*/

/*! @page page6 How to remove lens dust
How to remove when dust has adhered to the image sensor.<br />
イメージセンサーにゴミが付着している場合の除去方法<br />
@image html lens_sow1.jpg
@image html lens_sow2.jpg
@image html lens_sow3.jpg
@image html lens_sow4.jpg
@image html lens_sow5.jpg
@image html lens_sow6.jpg
*/

/*! @page page7 Release Notes
@tableofcontents
@section sdk13 Ovrvision SDK v1.9
Date : 19/Jan/2018<br />
<b>Notes</b>
- Fixed the bug of laptop PC with built-in Intel GPU. 
- The calculation way of the focal length point was changed(Re-calibration necessity).
- Supported ubuntu-64bit. 

@section sdk12 Ovrvision SDK v1.8
Date : 12/Oct/2016<br />
<b>Notes</b>
- Oculus SDK 1.8 was supported. Work is possible at the release version Oculus Rift(CV1). 
- Fixed the bug of Calibration Tool of Mac OS. 

<b>Unimplementeds and issue</b>
- Unreal Engine 4
- A defect of a document.
@section sdk11 Ovrvision SDK v1.7
Date : 31/May/2016<br />
<b>Notes</b>
- OvrvisionPro new firmware was released.
- The callback function was added.
- Oculus SDK 1.3.2 was supported. Work is possible at the release version Oculus Rift(CV1). 

<b>Unimplementeds and issue</b>
- Unreal Engine 4
- A defect of a document.
@section sdk10 Ovrvision SDK v1.61
Date : 8/Mar/2016<br />
<b>Notes</b>
- The fault about GPU choice of OpenCL was corrected.
- Improve performance of Unity5.
- CameraSettings Button was added to the calibration tool.

<b>Unimplementeds and issue</b>
- Unreal Engine 4
- A defect of a document.
@section sdk9 Ovrvision SDK v1.6
Date : 15/Feb/2016<br />
<b>Notes</b>
- Linux OS beta support (Ubuntu 15.10 x64 only)
- Arranged exsample projects. 
- The bug displayed not to support although GPU is stacked was fixed.

<b>Unimplementeds and issue</b>
- Unreal Engine 4
- A defect of a document.

@tableofcontents
@section sdk8 Ovrvision SDK v1.5
Date : 2/Feb/2016<br />
<b>Notes</b>
- Fixed the bug of the shader read error. 
- Fixed the bug which is not drawn by OpenGL of Unity.
- Improve AR system performance. 
- Improve OpenCL system performance.

<b>Unimplementeds and issue</b>
- Linux OS support
- Unreal Engine 4
- A defect of a document.

@section sdk7 Ovrvision SDK v1.4
Date : 16/Jan/2016<br />
<b>Notes</b>
- OvrvisionPro new firmware was released.
- Dissolve the memory leak of OpenCL. 
- Become easy to introduce OvrvisionSDK(Add in MenuBar) in Unity5. 
- Fixed bugs of the Calibration Tool. 
- SetCameraExposurePerSec() was added in order to simplify Exposure setting.
- Improve system performance. 

<b>Unimplementeds and issue</b>
- Linux OS support
- Unreal Engine 4
- A defect of a document.

@section sdk6 Ovrvision SDK v1.31
Date : 08/Jan/2016<br />
<b>Notes</b>
- Fixed bugs.
- Improved accuracy of the hand tracking system. 
- Add an AR sample and hand tracking.

<b>Unimplementeds and issue</b>
- Linux OS support
- Unreal Engine 4
- The memory leak of OpenCL. (NVIDIA Driver)
- The phenomenon in which transfer stops on the way.
- A defect of a document.

@section sdk5 Ovrvision SDK v1.3
Date : 29/Dec/2015<br />
<b>Notes</b>
- Add the function of errors display. 
- Mac OSX support (Beta:Mac Pro)
- Fixed bugs.
- Stabilized system. 
- Add  the EEPROM elimination tool. 

<b>Unimplementeds and issue</b>
- Linux OS support
- Unreal Engine 4
- The memory leak of OpenCL. (NVIDIA Driver)
- The phenomenon in which transfer stops on the way.

@section sdk4 Ovrvision SDK v1.2
Date : 10/Dec/2015<br />
<b>Notes</b>
- Add the function of errors display. 
- Intensified AR and Tracking function. 
- Add mask functions in Unity. 
- Bug of the calibration tools was fixed. 

<b>Unimplementeds and issue</b>
- Mac OSX support (in a few days) 
- Linux OS support
- Unreal Engine 4
- The memory leak of OpenCL. (NVIDIA Driver)
@section sdk3 Ovrvision SDK v1.1
Date : 07/Dec/2015<br />
<b>Notes</b>
- The memory leak was resolved.
- OvrvisionTracking was released.
- The fault which OvrvisionPro does not start was corrected. 

<b>Unimplementeds and issue</b>
- Mac OSX support (in a few days) 
- Linux OS support
- Unreal Engine 4
- The memory leak of OpenCL. (NVIDIA Driver)

@section sdk2 Ovrvision SDK v1.01
Date : 02/Dec/2015<br />
<b>Notes</b>
- Fixed bugs.
- OpenCL system is choose suitable GPU. 

<b>Unimplementeds and issue</b>
- OvrvisionTracking class : Hand tracking (in a few days) 
- Mac OSX support (in a few days) 
- Linux OS support
- Unreal Engine 4

@section sdk1 Ovrvision SDK v1.0
Date : 01/Dec/2015<br />
<b>Notes</b>
- First release.

<b>Unimplementeds and issue</b>
- OvrvisionTracking class : Hand tracking (in a few days) 
- Mac OSX support (in a few days) 
- Linux OS support
- Unreal Engine 4
*/

/*! @page pag8 FAQ
  Coming Soon
*/