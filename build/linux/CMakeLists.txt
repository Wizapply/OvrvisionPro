cmake_minimum_required (VERSION 2.8)
project (OvrvisionPro)

set(LINUX 1)
set(CMAKE_CXX_FLAGS "-O2 -DLINUX -D_OVRVISION_EXPORTS")

include_directories(../../3rdparty/OpenCL/amd/include ../../include ../../src/lib_src)

add_library(Ovrvision 
	../../src/lib_src/ovrvision_pro.cpp
	../../src/lib_src/ovrvision_setting.cpp
	../../src/lib_src/ovrvision_v4l.cpp
	../../src/lib_src/OpenCL.cpp
	)
