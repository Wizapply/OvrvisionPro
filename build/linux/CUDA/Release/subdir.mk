################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../CUDA.cpp \
../main.cpp \
../ovrvision_v4l.cpp 

CU_SRCS += \
../Bayer2RGB.cu \
../Remap.cu 

CU_DEPS += \
./Bayer2RGB.d \
./Remap.d 

OBJS += \
./Bayer2RGB.o \
./CUDA.o \
./Remap.o \
./main.o \
./ovrvision_v4l.o 

CPP_DEPS += \
./CUDA.d \
./main.d \
./ovrvision_v4l.d 


# Each subdirectory must supply rules for building sources it contributes
%.o: ../%.cu
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	nvcc -DLINUX -DOPENCV_VERSION_2_4 -DJETSON_TK1 -D_OVRVISION_EXPORTS -I/home/mao/OvrvisionPro/src/lib_src -I"/home/mao/OvrvisionPro/build/linux/CUDA" -O3  -odir "" -M -o "$(@:%.o=%.d)" "$<"
	nvcc --compile -DLINUX -DOPENCV_VERSION_2_4 -DJETSON_TK1 -D_OVRVISION_EXPORTS -I/home/mao/OvrvisionPro/src/lib_src -I"/home/mao/OvrvisionPro/build/linux/CUDA" -O3  -x cu -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

%.o: ../%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	nvcc -DLINUX -DOPENCV_VERSION_2_4 -DJETSON_TK1 -D_OVRVISION_EXPORTS -I/home/mao/OvrvisionPro/src/lib_src -I"/home/mao/OvrvisionPro/build/linux/CUDA" -O3  -odir "" -M -o "$(@:%.o=%.d)" "$<"
	nvcc -DLINUX -DOPENCV_VERSION_2_4 -DJETSON_TK1 -D_OVRVISION_EXPORTS -I/home/mao/OvrvisionPro/src/lib_src -I"/home/mao/OvrvisionPro/build/linux/CUDA" -O3 --compile  -x c++ -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


