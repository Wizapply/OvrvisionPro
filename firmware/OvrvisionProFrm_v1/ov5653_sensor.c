/**************************************************************************
 *
 *              Copyright (c) 2014-2016 by Wizapply.
 *
 *  This software is copyrighted by and is the sole property of Wizapply
 *  All rights, title, ownership, or other interests in the software
 *  remain the property of Wizapply.  This software may only be used
 *  in accordance with the corresponding license agreement.
 *  Any unauthorized use, duplication, transmission, distribution,
 *  or disclosure of this software is expressly forbidden.
 *
 *  This Copyright notice may not be removed or modified without prior
 *  written consent of Wizapply.
 *
 *  Wizapply reserves the right to modify this software without notice.
 *
 *  Wizapply                                info@wizapply.com
 *  5F, KS Building,                        http://wizapply.com
 *  3-7-10 Ichiokamotomachi, Minato-ku,
 *  Osaka, 552-0002, Japan
 *
***************************************************************************/

/**************************************************************************
 *
 *  Ovrvision Pro FirmWare v1.1
 *
 *  Language is 'C' code source
 *  Files : ov5653_sensor.c
 *
***************************************************************************/

#include <cyu3system.h>
#include <cyu3os.h>
#include <cyu3dma.h>
#include <cyu3error.h>
#include <cyu3uart.h>
#include <cyu3i2c.h>
#include <cyu3types.h>
#include <cyu3gpio.h>
#include <cyu3utils.h>

#include "ov5653_sensor.h"

////////////////////// Functions Var & define //////////////////////

//Define
#define FRAMEIDX_MODE_2560X1920AT15FPS	(1)
#define FRAMEIDX_MODE_1920X1080AT30FPS	(2)
#define FRAMEIDX_MODE_1280X960AT45FPS	(3)
#define FRAMEIDX_MODE_1280X800AT60FPS	(4)
#define FRAMEIDX_MODE_960X950AT60FPS	(5)
#define FRAMEIDX_MODE_640X480AT90FPS	(6)
#define FRAMEIDX_MODE_320X240AT120FPS	(7)
#define FRAMEIDX_MODE_1280X960AT15FPS	(11)
#define FRAMEIDX_MODE_640X480AT30FPS	(12)

#define FRAMEIDX_MODE_USB2BORDER		(10)

uint8_t g_frameIdx = 0;

////////////////////// Functions //////////////////////

// I2C functions
CyU3PReturnStatus_t WriteI2C (uint8_t slaveAddr, uint16_t address, uint8_t data)
{
	CyU3PReturnStatus_t apiRetStatus = CY_U3P_SUCCESS;
	CyU3PI2cPreamble_t preamble;

	uint8_t highAddr = address >> 8;
	uint8_t lowAddr = address & 0x00FF;

	/* Validate the I2C slave address. */
	if (slaveAddr != I2C_SENSOR_ADDR_WR) {
		return CY_U3P_ERROR_FAILURE;
	}

	/* Set the parameters for the I2C API access and then call the write API. */
	preamble.buffer[0] = slaveAddr;
	preamble.buffer[1] = highAddr;
	preamble.buffer[2] = lowAddr;
	preamble.length = 3;			/*  Three byte preamble. */
	preamble.ctrlMask = 0x0000; 	/*  No additional start and stop bits. */

	apiRetStatus = CyU3PI2cTransmitBytes(&preamble, &data, 1, 0);
	if(apiRetStatus == CY_U3P_SUCCESS)
		CyU3PBusyWait(10);

	return apiRetStatus;
}

CyU3PReturnStatus_t ReadI2C (uint8_t slaveAddr, uint16_t address, uint8_t *data)
{
	CyU3PReturnStatus_t apiRetStatus = CY_U3P_SUCCESS;
	CyU3PI2cPreamble_t preamble;

	uint8_t highAddr = address >> 8;
	uint8_t lowAddr = address & 0x00FF;

	if (slaveAddr != I2C_SENSOR_ADDR_RD) {
		return CY_U3P_ERROR_FAILURE;
	}

	preamble.buffer[0] = slaveAddr & I2C_SLAVEADDR_MASK; /*  Mask out the transfer type bit. */
	preamble.buffer[1] = highAddr;
	preamble.buffer[2] = lowAddr;
	preamble.buffer[3] = slaveAddr;
	preamble.length = 4;
	preamble.ctrlMask = 0x0004; /*  Send start bit after third byte of preamble. */

	apiRetStatus = CyU3PI2cReceiveBytes(&preamble, data, 1, 0);
	CyU3PBusyWait(10);

	return apiRetStatus;
}


// Sensor control function

// Initialize sensor
CyU3PReturnStatus_t OV5653SensorInit(void)
{
	if (OV5653SensorBusTest() != CY_U3P_SUCCESS) /* Verify that the sensor is connected. */
		return CY_U3P_ERROR_FAILURE;

	//Reset
	OV5653SensorReset();

	//PLL Reset
	WI2C(0x3102,0x05);
	CyU3PBusyWait (3000);
	WI2C(0x3102,0x00);
	CyU3PBusyWait (3000);

	return CY_U3P_SUCCESS;
}

// Reset sensor
void OV5653SensorReset(void)
{
	//Sensor reset command
	WI2C(0x3008,0x82);
	CyU3PBusyWait (5000);	//5ms wait
	WI2C(0x3000,0xFF);
	WI2C(0x3001,0xFF);
	WI2C(0x3002,0xFF);
	WI2C(0x3003,0xFF);

	//WI2C(0x3008,0x42);
	//CyU3PBusyWait (5000);	//5ms wait
	/* Delay the allow the sensor to power up. */
	CyU3PThreadSleep(20); //20ms
}

// Test sensor
CyU3PReturnStatus_t OV5653SensorBusTest(void)
{
	/* The sensor ID register can be read here to verify sensor connectivity. */
	uint8_t chipid = 0;

	/* Reading sensor ID */
	if (ReadI2C(I2C_SENSOR_ADDR_RD, 0x3100, &chipid) == CY_U3P_SUCCESS) {
		if (chipid == 0x6C) {
			return CY_U3P_SUCCESS;
		}
	}
	return CY_U3P_ERROR_FAILURE;
}

// Sensor setup
void OV5653SensorControl(unsigned char frameIdx)
{
	//Frame Index : frameIdx
	// 1 = 2560 x 1920 @ 15fps	X 2
	// 2 = 1920 x 1080 @ 30fps	X 2
	// 3 = 1280 x 960 @ 45fps	X 2
	// 4 = 1080 x 800 @ 60fps	X 2 Oculus Rift
	// 5 = 640 x 480 @ 90fps    X 2
	// 6 = 320 x 240 @ 120fps	X 2
	//11 = 1280 x 800 @ 10fps	X 2 Oculus Rift, For USB2.0
	//12 = 640 x 480 @ 60fps	X 2 For USB2.0

	//Copy index
	g_frameIdx = frameIdx;

	//Sensor reset command
	WI2C(0x3103,0x93);		//PLL
	CyU3PBusyWait (200);	//200us wait
	WI2C(0x3017,0xff);
	WI2C(0x3018,0xf0);
	CyU3PBusyWait (100);	//100us wait

	if(frameIdx >= FRAMEIDX_MODE_USB2BORDER) {	//USB2.0
		WI2C(0x3012,0x05);	//PLL
	}

	//System control
	WI2C(0x3000,0x03);	//Timing & Array Reset
	WI2C(0x3001,0x00);
	WI2C(0x3002,0x08);
	WI2C(0x3003,0x00);
	WI2C(0x3004,0xff);
	WI2C(0x3005,0xff);
	WI2C(0x3006,0x41);
	WI2C(0x3007,0x27);

	//PLL control (do not use)
	WI2C(0x3815,0x80);
	//WI2C(0x3010,0x00);
	//WI2C(0x3011,0x05);
	//WI2C(0x3012,0x00);

	WI2C(0x3600, 0x50);
	WI2C(0x3601, 0x0d);
	WI2C(0x3604, 0x50);
	WI2C(0x3605, 0x04);
	WI2C(0x3606, 0x3f);
	WI2C(0x3612, 0x1a);
	WI2C(0x3630, 0x22);
	WI2C(0x3631, 0x22);
	WI2C(0x3702, 0x3c);	//pos
	WI2C(0x3704, 0x18);
	WI2C(0x3705, 0xda);
	WI2C(0x3706, 0x41);
	WI2C(0x370a, 0x80);
	WI2C(0x370b, 0x40);
	WI2C(0x370e, 0x00);
	WI2C(0x3710, 0x28);
	WI2C(0x3712, 0x13);
	WI2C(0x3830, 0x50);
	WI2C(0x3a18, 0x00);
	WI2C(0x3a19, 0xf8);
	//WI2C(0x3603, 0xa7);
    WI2C(0x3615, 0x50);
    WI2C(0x3620, 0x56);
	WI2C(0x3810, 0x00);
	WI2C(0x3836, 0x00);
	WI2C(0x3a1a, 0x06);

	//Frex control = no
	WI2C(0x302C,0x02);

	//Image timing control
	switch(frameIdx) {
		case FRAMEIDX_MODE_2560X1920AT15FPS:
			WI2C(0x3800,0x01);
			WI2C(0x3801,0x94);
			WI2C(0x3802,0x00);
			WI2C(0x3803,0x0a);
			WI2C(0x3804,0x0a);
			WI2C(0x3805,0x00);
			WI2C(0x3806,0x07);
			WI2C(0x3807,0x80);

			WI2C(0x3808,0x0A);
			WI2C(0x3809,0x00);
			WI2C(0x380A,0x07);
			WI2C(0x380B,0x80);

			WI2C(0x380C,0x0c);
			WI2C(0x380D,0x80);
			WI2C(0x380E,0x07);
			WI2C(0x380F,0xd0);
			break;
		case FRAMEIDX_MODE_1920X1080AT30FPS:
			WI2C(0x3800,0x01);
			WI2C(0x3801,0x94);
			WI2C(0x3802,0x00);
			WI2C(0x3803,0x0a);
			WI2C(0x3804,0x07);
			WI2C(0x3805,0x80);
			WI2C(0x3806,0x04);
			WI2C(0x3807,0x38);

			WI2C(0x3808,0x07);
			WI2C(0x3809,0x80);
			WI2C(0x380A,0x04);
			WI2C(0x380B,0x38);

			WI2C(0x380C,0x0a);
			WI2C(0x380D,0x84);
			WI2C(0x380E,0x04);
			WI2C(0x380F,0xa5);

			WI2C(0x381c,0x31);	//cropping
			WI2C(0x381d,0xa4);
			WI2C(0x381e,0x04);
			WI2C(0x381f,0x60);
			WI2C(0x3820,0x04);
			//WI2C(0x3821,0x1a);
			break;
		case FRAMEIDX_MODE_1280X960AT45FPS:
			WI2C(0x3800,0x02);
			WI2C(0x3801,0xa0);
			WI2C(0x3802,0x00);
			WI2C(0x3803,0x0a);
			WI2C(0x3804,0x05);
			WI2C(0x3805,0x00);
			WI2C(0x3806,0x03);
			WI2C(0x3807,0xc0);

			WI2C(0x3808,0x05);
			WI2C(0x3809,0x00);
			WI2C(0x380A,0x03);
			WI2C(0x380B,0xc0);

			WI2C(0x380C,0x08);	//45fps
			WI2C(0x380D,0x55);
			WI2C(0x380E,0x03);
			WI2C(0x380F,0xe8);
			break;
		case FRAMEIDX_MODE_1280X800AT60FPS:
			WI2C(0x3800,0x02);
			WI2C(0x3801,0xa0);
			WI2C(0x3802,0x00);
			WI2C(0x3803,0x0a);
			WI2C(0x3804,0x05);
			WI2C(0x3805,0x00);
			WI2C(0x3806,0x03);
			WI2C(0x3807,0x20);

			WI2C(0x3808,0x05);
			WI2C(0x3809,0x00);
			WI2C(0x380A,0x03);
			WI2C(0x380B,0x20);

			WI2C(0x380C,0x07);	//60fps
			WI2C(0x380D,0xa9);
			WI2C(0x380E,0x03);
			WI2C(0x380F,0x30);

			WI2C(0x381c,0x30);	//cropping
			WI2C(0x381d,0x8a);
			WI2C(0x381e,0x06);
			WI2C(0x381f,0x50);
			WI2C(0x3820,0x00);
			break;
		case FRAMEIDX_MODE_960X950AT60FPS:
			WI2C(0x3800,0x02);
			WI2C(0x3801,0xa0);
			WI2C(0x3802,0x00);
			WI2C(0x3803,0x0a);
			WI2C(0x3804,0x03);
			WI2C(0x3805,0xc0);
			WI2C(0x3806,0x03);
			WI2C(0x3807,0xb6);

			WI2C(0x3808,0x03);
			WI2C(0x3809,0xc0);
			WI2C(0x380A,0x03);
			WI2C(0x380B,0xb6);

			WI2C(0x380C,0x06);	//60fps
			WI2C(0x380D,0x67);
			WI2C(0x380E,0x03);
			WI2C(0x380F,0xd0);

			WI2C(0x381c,0x30);	//cropping
			WI2C(0x381d,0x0a);
			WI2C(0x381e,0x07);
			WI2C(0x381f,0x90);
			WI2C(0x3820,0x04);
			break;
		case FRAMEIDX_MODE_640X480AT90FPS:
			WI2C(0x3800,0x02);
			WI2C(0x3801,0xa0);
			WI2C(0x3802,0x00);
			WI2C(0x3803,0x0a);
			WI2C(0x3804,0x05);
			WI2C(0x3805,0x00);
			WI2C(0x3806,0x01);
			WI2C(0x3807,0xe0);

			WI2C(0x3808,0x02);
			WI2C(0x3809,0x80);
			WI2C(0x380A,0x01);
			WI2C(0x380B,0xe0);

			WI2C(0x380C,0x08);
			WI2C(0x380D,0x55);
			WI2C(0x380E,0x01);
			WI2C(0x380F,0xf4);
			break;
		case FRAMEIDX_MODE_320X240AT120FPS:
			WI2C(0x3800,0x02);
			WI2C(0x3801,0xa0);
			WI2C(0x3802,0x00);
			WI2C(0x3803,0x0a);
			WI2C(0x3804,0x05);
			WI2C(0x3805,0x00);
			WI2C(0x3806,0x00);
			WI2C(0x3807,0xf0);

			WI2C(0x3808,0x01);
			WI2C(0x3809,0x40);
			WI2C(0x380A,0x00);
			WI2C(0x380B,0xf0);

			WI2C(0x380C,0x0c);
			WI2C(0x380D,0x35);
			WI2C(0x380E,0x01);
			WI2C(0x380F,0x00);
			break;
		//USB2.0
		case FRAMEIDX_MODE_1280X960AT15FPS:
			WI2C(0x3800,0x02);
			WI2C(0x3801,0xa0);
			WI2C(0x3802,0x00);
			WI2C(0x3803,0x0a);
			WI2C(0x3804,0x05);
			WI2C(0x3805,0x00);
			WI2C(0x3806,0x03);
			WI2C(0x3807,0xc0);

			WI2C(0x3808,0x05);
			WI2C(0x3809,0x00);
			WI2C(0x380A,0x03);
			WI2C(0x380B,0xc0);

			WI2C(0x380C,0x0c);	//15fps
			WI2C(0x380D,0x80);
			WI2C(0x380E,0x03);
			WI2C(0x380F,0xe8);
			break;
		case FRAMEIDX_MODE_640X480AT30FPS:
			WI2C(0x3800,0x02);
			WI2C(0x3801,0xa0);
			WI2C(0x3802,0x00);
			WI2C(0x3803,0x0a);
			WI2C(0x3804,0x05);
			WI2C(0x3805,0x00);
			WI2C(0x3806,0x01);
			WI2C(0x3807,0xe0);

			WI2C(0x3808,0x02);
			WI2C(0x3809,0x80);
			WI2C(0x380A,0x01);
			WI2C(0x380B,0xe0);

			WI2C(0x380C,0x0c);	//30fps
			WI2C(0x380D,0x80);
			WI2C(0x380E,0x01);
			WI2C(0x380F,0xf4);
			break;
		default: break;
	}

	//5060Hz control
	WI2C(0x3A0D, 0x08); /* b60 max pg 113 */
	WI2C(0x3A0D, 0x06); /* b50 max pg 113 */
    WI2C(0x3C01, 0x00); /* 5060HZ_CTRL01 ON */

	//AEC AGC
	WI2C(0x3503,0x03);	//manual

	//Exposure Gain control
	if(frameIdx >= FRAMEIDX_MODE_USB2BORDER) {	//USB2.0
		WI2C(0x3500,0x00);	// long exp 1/3 in unit of 1/16 line
	    WI2C(0x3501,0x09);	// long exp 2/3 in unit of 1/16 line
	    WI2C(0x3502,0x58); 	// long exp 3/3 in unit of 1/16 line
		WI2C(0x350A,0x00);	// long gain
		WI2C(0x350B,0x08);
	} else {				//USB3.0
		WI2C(0x3500,0x00);	// long exp 1/3 in unit of 1/16 line
	    WI2C(0x3501,0x30);	// long exp 2/3 in unit of 1/16 line
	    WI2C(0x3502,0x28); 	// long exp 3/3 in unit of 1/16 line
		WI2C(0x350A,0x00);	// long gain
		WI2C(0x350B,0x08);
	}

	//AWB control
	WI2C(0x3406,0x00);	//auto
	WI2C(0x5192,0x00);	//simple
	WI2C(0x5191,0x00);
	WI2C(0x5183,0x80);

	WI2C(0x3400,0x07);	//WB
	WI2C(0x3401,0x88);
	WI2C(0x3402,0x04);
	WI2C(0x3403,0x00);
	WI2C(0x3404,0x05);
	WI2C(0x3405,0x00);

	//ISP control
	WI2C(0x5046,0x09);
	WI2C(0x5000,0x86);
	WI2C(0x5001,0x01);
	WI2C(0x5002,0x00);
	//Test control
	WI2C(0x503D,0x00);	//test=0x80
	WI2C(0x503E,0x02);

	//BLC control
	WI2C(0x4000,0x09);	//enable
	WI2C(0x4006,0x00);
	WI2C(0x4007,0x20);

	//Binning / Sub-sampling
	switch(frameIdx) {
		case FRAMEIDX_MODE_2560X1920AT15FPS:
		case FRAMEIDX_MODE_1920X1080AT30FPS:
			WI2C(0x370D,0x04);
			WI2C(0x3621,0x2f);
			WI2C(0x3818,0xa0);
			WI2C(0x381A,0x3c);
			WI2C(0x381B,0x00);
			break;
		case FRAMEIDX_MODE_1280X960AT45FPS:
		case FRAMEIDX_MODE_1280X800AT60FPS:
		case FRAMEIDX_MODE_1280X960AT15FPS:
		case FRAMEIDX_MODE_960X950AT60FPS:
			WI2C(0x370D,0x42);
			WI2C(0x3621,0xaf);
			WI2C(0x3818,0xa1);
			WI2C(0x381A,0x00);
			WI2C(0x381B,0x00);
			break;
		case FRAMEIDX_MODE_640X480AT30FPS:
		case FRAMEIDX_MODE_640X480AT90FPS:
			WI2C(0x370D,0x42);
			WI2C(0x3621,0xaf);
			WI2C(0x3818,0xa2);
			WI2C(0x381A,0x00);
			WI2C(0x381B,0x00);
			WI2C(0x5002,0x02);
			WI2C(0x5901,0x04);
			break;
		case FRAMEIDX_MODE_320X240AT120FPS:
			WI2C(0x370D,0x42);
			WI2C(0x3621,0xaf);
			WI2C(0x3818,0xa3);
			WI2C(0x381A,0x00);
			WI2C(0x381B,0x00);
			WI2C(0x5002,0x02);
			WI2C(0x5901,0x08);
			break;
		default: break;
	}

	//DVP signal control
	WI2C(0x300E,0x00);	//Select DVP
	WI2C(0x4700,0x04);
	WI2C(0x4704,0x02);
	WI2C(0x4706,0x08);
	WI2C(0x4708,0x03);

	CyU3PBusyWait (100);	//100us wait
	WI2C(0x3000,0x00);		//Start
	WI2C(0x3002,0x00);
	CyU3PBusyWait (10); 	//10us
}

//Processing Unit specific UVC control function
uint16_t OV5653SensorGetExp() {
	uint8_t highBuf = 0;
	uint8_t lowBuf = 0;
	uint16_t buffer = 0;

	ReadI2C(I2C_SENSOR_ADDR_RD, 0x3501, &highBuf);
	ReadI2C(I2C_SENSOR_ADDR_RD, 0x3502, &lowBuf);

	buffer |= lowBuf;
	buffer |= (uint16_t)highBuf << 8;
	return buffer;
}
void OV5653SensorSetExp(uint16_t v) {
	uint8_t highBit = v >> 8;
	uint8_t lowBit = v & 0x00FF;

	switch(g_frameIdx) {
		case FRAMEIDX_MODE_2560X1920AT15FPS:
			if(v >= 32000 - 200)
				v = 32000 - 200;
			break;
		case FRAMEIDX_MODE_1920X1080AT30FPS:
			if(v >= 19019 - 200)
				v = 19019 - 200;
			break;
		case FRAMEIDX_MODE_1280X960AT45FPS:
			if(v >= 16002 - 200)
				v = 16002 - 200;
			break;
		case FRAMEIDX_MODE_1280X800AT60FPS:
			if(v >= 13054 - 200)
				v = 13054 - 200;
			break;
		case FRAMEIDX_MODE_960X950AT60FPS:
			if(v >= 15619 - 160)
				v = 15619 - 160;
			break;
		case FRAMEIDX_MODE_640X480AT90FPS:
			if(v >= 8002 - 120)
				v = 8002 - 120;
			break;
		case FRAMEIDX_MODE_320X240AT120FPS:
			if(v >= 4096 - 100)
				v = 4096 - 100;
			break;
		//USB2.0
		case FRAMEIDX_MODE_1280X960AT15FPS:
			if(v >= 16000 - 200)
				v = 16000 - 200;
			break;
		case FRAMEIDX_MODE_640X480AT30FPS:
			if(v >= 8000 - 120)
				v = 8000 - 120;
			break;
		default: break;
	}

	highBit = v >> 8;
	lowBit = v & 0x00FF;

	WI2C(0x3501,highBit);
	WI2C(0x3502,lowBit);
}
unsigned char OV5653SensorGetGain() {
	uint8_t buf = 0;
	ReadI2C(I2C_SENSOR_ADDR_RD, 0x350B, &buf);

	if(buf > 0x1F) {
		buf &= 0x2F;
	}
	return buf;
}
void OV5653SensorSetGain(unsigned char v) {
	if(v > 0x1F)
		v |= 0x10;

	WI2C(0x350B,v);
}

uint16_t OV5653SensorGetRGainWB() {
	uint8_t highBuf = 0;
	uint8_t lowBuf = 0;
	uint16_t buffer = 0;

	ReadI2C(I2C_SENSOR_ADDR_RD, 0x3400, &highBuf);
	ReadI2C(I2C_SENSOR_ADDR_RD, 0x3401, &lowBuf);

	buffer |= lowBuf;
	buffer |= (uint16_t)highBuf << 8;
	return buffer;
}
void OV5653SensorSetRGainWB(uint16_t v){
	uint8_t highBit = v >> 8;
	uint8_t lowBit = v & 0x00FF;
	WI2C(0x3400,highBit);
	WI2C(0x3401,lowBit);
}
uint16_t OV5653SensorGetGGainWB(){
	uint8_t highBuf = 0;
	uint8_t lowBuf = 0;
	uint16_t buffer = 0;

	ReadI2C(I2C_SENSOR_ADDR_RD, 0x3402, &highBuf);
	ReadI2C(I2C_SENSOR_ADDR_RD, 0x3403, &lowBuf);

	buffer |= lowBuf;
	buffer |= (uint16_t)highBuf << 8;
	return buffer;
}
void OV5653SensorSetGGainWB(uint16_t v){
	uint8_t highBit = v >> 8;
	uint8_t lowBit = v & 0x00FF;
	WI2C(0x3402,highBit);
	WI2C(0x3403,lowBit);
}
uint16_t OV5653SensorGetBGainWB(){
	uint8_t highBuf = 0;
	uint8_t lowBuf = 0;
	uint16_t buffer = 0;

	ReadI2C(I2C_SENSOR_ADDR_RD, 0x3404, &highBuf);	//32 no more
	ReadI2C(I2C_SENSOR_ADDR_RD, 0x3405, &lowBuf);

	buffer |= lowBuf;
	buffer |= (uint16_t)highBuf << 8;
	return buffer;
}
void OV5653SensorSetBGainWB(uint16_t v) {
	uint8_t highBit = v >> 8;
	uint8_t lowBit = v & 0x00FF;
	WI2C(0x3404,highBit);
	WI2C(0x3405,lowBit);
}

unsigned char OV5653SensorGetWBTAuto() {
	uint8_t buffer = 0;
	ReadI2C(I2C_SENSOR_ADDR_RD, 0x3406, &buffer);
	buffer ^= 1;	//Reversal
	return buffer;
}
void OV5653SensorSetWBTAuto(unsigned char v) {
	v = v & 0x01;
	v ^= 1;	//Reversal
	WI2C(0x3406,v);
}

extern uint16_t OV5653SensorGetBLC(){
	uint8_t highBuf = 0;
	uint8_t lowBuf = 0;
	uint16_t buffer = 0;

	ReadI2C(I2C_SENSOR_ADDR_RD, 0x4006, &highBuf);	//32 no more
	ReadI2C(I2C_SENSOR_ADDR_RD, 0x4007, &lowBuf);

	buffer |= lowBuf;
	buffer |= (uint16_t)highBuf << 8;
	return buffer;
}
extern void OV5653SensorSetBLC(uint16_t v){
	uint8_t highBit = v >> 8;
	uint8_t lowBit = v & 0x00FF;
	WI2C(0x4006,highBit);
	WI2C(0x4007,lowBit);
}

//Camera Terminal specific UVC control function
unsigned char OV5653SensorGetCurRoll() {
	return 0;
}
void OV5653SensorSetModRoll(unsigned char v) {

}

//Camera Timing control
void OV5653SensorSetRelativeTimingHTS(uint16_t v){
	uint8_t highBit = 0;
	uint8_t lowBit = 0;
	uint16_t buffer = 0;

	ReadI2C(I2C_SENSOR_ADDR_RD, 0x380D, &highBit);	//32 no more
	ReadI2C(I2C_SENSOR_ADDR_RD, 0x380E, &lowBit);

	buffer |= lowBit;
	buffer |= (uint16_t)highBit << 8;

	buffer += v;

	highBit = buffer >> 8;
	lowBit = buffer & 0x00FF;
	WI2C(0x380D,highBit);
	WI2C(0x380E,lowBit);
}

