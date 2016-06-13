cmake_minimum_required (VERSION 2.8)
project (OvrvisionPro)

set(LINUX 1)
set(CMAKE_CXX_FLAGS "-DLINUX -D_OVRVISION_EXPORTS")

include_directories(../../../3rdparty/OpenCL/amd/include ../../../include)

add_library(Ovrvision 
	ovrvision_pro.cpp
	ovrvision_setting.cpp
	ovrvision_v4l.cpp
	OpenCL.cpp
	)
