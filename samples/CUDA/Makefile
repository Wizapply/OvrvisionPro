#
#
#

CUDA_PATH       ?= /usr/local/cuda-7.5
TARGET_SIZE	:= 64
HIGHEST_SM	:= 20

HOST_COMPILER ?= g++
NVCC          := $(CUDA_PATH)/bin/nvcc -ccbin $(HOST_COMPILER)
NVCCFLAGS   := -m${TARGET_SIZE}
INCLUDES    := -I../../src/lib_src
LIBRARIES   := -lm -lopencv_core -lopencv_highgui -lopencv_cudalegacy
CCFLAGS     := -DLINUX
LDFLAGS     := -L /usr/local/lib
GENCODE_FLAGS += -gencode arch=compute_$(HIGHEST_SM),code=compute_$(HIGHEST_SM)

all: Ovrvision

Ovrvision: OvrvisionCUDA.o  ovrvision_cuda.o ovrvision_v4l.o Windows.o
	$(NVCC) $(LDFLAGS) $(GENCODE_FLAGS) -o $@ $+ $(LIBRARIES)

OvrvisionCUDA.o: OvrvisionCUDA.cu OvrvisionCUDA.h
	$(NVCC) $(INCLUDES) $(CCFLAGS) $(GENCODE_FLAGS) -o $@ -c $<

ovrvision_cuda.o: ovrvision_cuda.cpp OvrvisionCUDA.h
	$(NVCC) $(INCLUDES) $(CCFLAGS) $(GENCODE_FLAGS) -o $@ -c $<

ovrvision_v4l.o: ../../src/lib_src/ovrvision_v4l.cpp
	$(NVCC) $(INCLUDES) $(CCFLAGS) $(GENCODE_FLAGS) -o $@ -c $<

Windows.o: Windows.cpp OvrvisionCUDA.h
	$(NVCC) $(INCLUDES) $(CCFLAGS) $(GENCODE_FLAGS) -o $@ -c $<
