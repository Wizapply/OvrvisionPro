cmake_minimum_required(VERSION 3.0)

project(OvrvisionPro CXX)

add_executable(OvrvisionPro CUDA.cpp ovrvision_v4l.cpp ovrvision_v4l.h OvrvisionProCUDA.h main.cpp)

find_package(OpenCV REQUIRED)

if(OpenCV_FOUND)
	target_include_directories(OvrvisionPro
		PRIVATE
		$(OpenCV_INCLUDE_DIRS)
		)
	target_link_libraries(OvrvisionPro
		$(OpenCV_LIBS)
		)
endif(OpenCV_FOUND)

