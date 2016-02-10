################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../CUDA.cpp \
../main.cpp \
../ovrvision_v4l.cpp 

OBJS += \
./CUDA.o \
./main.o \
./ovrvision_v4l.o 

CPP_DEPS += \
./CUDA.d \
./main.d \
./ovrvision_v4l.d 


# Each subdirectory must supply rules for building sources it contributes
%.o: ../%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -DLINUX -D_OVRVISION_EXPORTS -O3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


