cmake_minimum_required (VERSION 2.8)
project (OpenGL)

set(LINUX 1)
set(CMAKE_CXX_FLAGS "-DLINUX -D_OVRVISION_EXPORTS -lglut -lGLU -lGL")

include_directories(../../3rdparty/OpenCL/amd/include ../../include ../../src/lib_src/)
link_directories(../../build/linux /usr/local/cuda-7.5/lib64)

add_executable(GLUT 
	glut.cpp
	OpenGL.cpp
	)

target_link_libraries(GLUT 
	glut GLU GL Ovrvision 
	OpenCL cudart 
	opencv_calib3d
	opencv_core
	opencv_imgcodecs
	opencv_imgproc 
	opencv_highgui 
	opencv_video
	opencv_videoio
	)
