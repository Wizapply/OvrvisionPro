/**************************************************************************
 *
 *              Copyright (c) 2014-2015 by Wizapply.
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
 *  Wizpply reserves the right to modify this software without notice.
 *
 *  Wizapply                                info@wizapply.com
 *  5F, KS Building,                        http://wizapply.com
 *  3-7-10 Ichiokamotomachi, Minato-ku,
 *  Osaka, 552-0002, Japan
 *
***************************************************************************/

/**************************************************************************
 *
 *  Ovrvision Pro FirmWare v1.0
 *
 *  Language is 'C' code source
 *  Files : ov5653_sensor.h
 *
***************************************************************************/

#ifndef _OV5653_SENSOR_H_
#define _OV5653_SENSOR_H_

#include <cyu3types.h>

// Define

/* I2C Slave address for the image sensor. */
#define I2C_SENSOR_ADDR_WR 0x6C         /* Slave address used to write sensor registers.*/
#define I2C_SENSOR_ADDR_RD 0x6D         /* Slave address used to read from sensor registers. */

#define I2C_SLAVEADDR_MASK 0xFE         /* Mask to get actual I2C slave address value without direction bit. */

// I2C functions
extern CyU3PReturnStatus_t WriteI2C (uint8_t slaveAddr, uint16_t address, uint8_t data);
extern CyU3PReturnStatus_t ReadI2C (uint8_t slaveAddr, uint16_t address, uint8_t *data);

#define WI2C(x,y) WriteI2C(I2C_SENSOR_ADDR_WR,x,y)

// Sensor system control function
extern void OV5653SensorInit(void);			// Initialize sensor
extern void OV5653SensorReset(void);		// Reset sensor
extern uint8_t OV5653SensorBusTest(void);	// Test sensor

// Sensor setup

//Frame Index : frameIdx
// 1 = 2560 x 1920 @ 15fps	X 2
// 2 = 1920 x 1080 @ 30fps	X 2
// 3 = 1280 x 960 @ 45fps	X 2
// 4 = 1280 x 800 @ 60fps	X 2 Oculus Rift
// 5 = 640 x 480 @ 90fps    X 2
// 6 = 320 x 240 @ 120fps	X 2
//11 = 1280 x 800 @ 10fps	X 2 Oculus Rift, For USB2.0
//12 = 640 x 480 @ 60fps	X 2 For USB2.0
extern void OV5653SensorControl(unsigned char frameIdx);

//Processing Unit specific UVC control function
extern uint16_t OV5653SensorGetExp();
extern void OV5653SensorSetExp(uint16_t v);
extern unsigned char OV5653SensorGetGain();
extern void OV5653SensorSetGain(unsigned char v);

extern uint16_t OV5653SensorGetRGainWB();
extern void OV5653SensorSetRGainWB(uint16_t v);
extern uint16_t OV5653SensorGetGGainWB();
extern void OV5653SensorSetGGainWB(uint16_t v);
extern uint16_t OV5653SensorGetBGainWB();
extern void OV5653SensorSetBGainWB(uint16_t v);
extern unsigned char OV5653SensorGetWBTAuto();
extern void OV5653SensorSetWBTAuto(unsigned char v);
extern uint16_t OV5653SensorGetBLC();
extern void OV5653SensorSetBLC(uint16_t v);

//Camera Terminal specific UVC control function
extern unsigned char OV5653SensorGetCurRoll();
extern void OV5653SensorSetModRoll(unsigned char v);

#endif /*_OV5653_SENSOR_H_*/
