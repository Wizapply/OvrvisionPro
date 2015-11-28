/*!
@mainpage Getting Started

@section features Ovrvision Features and Overview
@image html topimage.jpg

This is a high performance stereo camera where immersive AR and hand tracking are possible by fitting the Ovrvision Pro onto Oculus Rift.
Ovrvision Pro realizes high FPS, high resolution, wide viewing angle, both-eye synchronization, and low delay. It is equipped with EEPROM and GPIO along with an embedding-type extension slot that can be utilized for robot sensors.
It supports game engines such as Unity5 and Unreal Engine and AR software, and when combined with the Ovrvision Pro SDK that comes free of charge, a developmental environment of high versatility is possible.
Ovrvision Pro SDK is provided by MIT LICENSE as a license for open-source software, and it can be used freely regardless of commercial use.

More : http://ovrvision.com/

@section gsstruct Content Structure

Ovrvision SDK
- bin/
- include/
- tools/
- marker_sample/
- examples/d
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
OvrvisionProを接続する前に、パソコンの環境を設定する。
-# 最新のUSB3.0 driverをインストール
-# 最新のGPUドライバをインストール(OpenCL1.2以上に対応するもの)
-# 最新のOculus Runtimeをインストール(Oculus Riftを使用する場合のみ)
-# VisualStudioやUnityなどの開発環境を予めインストール
@subsection gstep2 Step 2: Run the Ovrvision Pro
Ovrvision Proを動かしてみる
-# OvrvisionProをUSB3.0ポートに接続する
-# 標準のUVCドライバがインストール
-# binフォルダ内のOvrvisionViewer.exeを起動しオープン。
-# カメラ画像が問題なく動作すれば完了です。
@subsection gstep3 Step 3: Ovrvision Pro calibration.
-# 貴方の環境に合わせたキャリブレーションを行います。
-# キャリブレーションが完了したらOculus Riftを使ってARをします。

@image html wizapplylogo.png

*/

/*!
@page page1 Using the Tools
@tableofcontents

OvrvisionProに付属するツールの使い方についてご紹介します。

@section calib Calibration tool
This page contains the subsections @ref subsection1 and \@ef subsection2.
For more info see page @ref page2.
@subsection subsection1 The first subsection
Text.
@subsection subsection2 The second subsection
More text.

@section armarker AR Marker make tool

*/

/*! @page page2 Using the Demo examples
  Even more info.
*/

/*! @page page3 How to Rebuild SDK
  Coming Soon
*/

/*! @page page4 Release Notes
@tableofcontents
@section sdk1 Ovrvision SDK v1.0
<b>Notes</b>
- First release.
*/

/*! @page page5 FAQ
  Coming Soon
*/