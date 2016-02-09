################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../OpenCL.cpp \
../ovrvision_linux.cpp \
../ovrvision_pro.cpp \
../ovrvision_setting.cpp \
../ovrvision_v4l.cpp 

OBJS += \
./OpenCL.o \
./ovrvision_linux.o \
./ovrvision_pro.o \
./ovrvision_setting.o \
./ovrvision_v4l.o 

CPP_DEPS += \
./OpenCL.d \
./ovrvision_linux.d \
./ovrvision_pro.d \
./ovrvision_setting.d \
./ovrvision_v4l.d 


# Each subdirectory must supply rules for building sources it contributes
%.o: ../%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -DLINUX -D_OVRVISION_EXPORTS -I../../../../include -I"/home/mao/OvrvisionPro/build/linux/ovrvision" -I/home/mao/src/opencv-3.0.0/include -I/home/mao/src/opencv-3.0.0/3rdparty/include/opencl/1.2 -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


