#  Copyright Cypress Semiconductor Corporation, 2010-2012,
#  All Rights Reserved
#  UNPUBLISHED, LICENSED SOFTWARE.
#
#  CONFIDENTIAL AND PROPRIETARY INFORMATION
#  WHICH IS THE PROPERTY OF CYPRESS.
#
#  Use of this file is governed
#  by the license agreement included in the file
#
#     <install>/license/license.txt
#
#  where <install> is the Cypress software
#  installation root directory path.
#

# Cypress FX3 Firmware Startup code. The actual firmware entry point is
# provided by the FX3 API library and sets up the stacks and vectors.
# The CyU3PToolChainInit only needs to perform application specific initialization.

# This file is taken from the FX3 SDK version 1.2.2. When upgrading to a later
# SDK version, please ensure that the corresponding startup file is used as the
# base version.

.section .text
.code 32

# Jump function implementation.
.global jump
jump:
    bx  R0

.global CyU3PToolChainInit
CyU3PToolChainInit:

# Clear the BSS segment and then jump to main.
__main:
	mov	R0, #0
	ldr	R1, =_bss_start
	ldr	R2, =_bss_end
1:	cmp	R1, R2
	strlo	R0, [R1], #4
	blo	1b

	b	main

# Stacks are setup in the FX3 API library. We currently do not use a heap
# in this application. Therefore, no stack or heap initialization is required.
.global __user_initial_stackheap
__user_initial_stackheap:

.if  INTER == TRUE
    bx      lr                 
.else
    mov     pc, lr             
.endif

.end

# []
