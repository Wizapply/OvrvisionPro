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
 *  Files : eeprom_data.h
 *
***************************************************************************/

#ifndef _EEPROME_DATA_H_
#define _EEPROM_DATA_H_

#include <cyu3types.h>

// Define

/* I2C Slave address for the image sensor. */
#define I2C_MEMORY_ADDR_WR 0xA0         /* I2C slave address used to write to an EEPROM. */
#define I2C_MEMORY_ADDR_RD 0xA1         /* I2C slave address used to read from an EEPROM. */

#define I2C_MEMORY_SLAVEADDR_MASK 0xF0    /* Mask to get Actual I2C slave address value without direction bit. */

// User data
#define USER_DATA_BUFFERSIZE			(512)
#define USER_DATA_CHECKSUM_ADDR			(511)
#define USER_DATA_NOCHECKSUM_BUFSIZE	(511)

// EEPROM Status
#define USER_DATA_STATUS_LOCK		(0)
#define USER_DATA_STATUS_UNLOCK_P1	(1)
#define USER_DATA_STATUS_UNLOCK_P2	(2)
#define USER_DATA_STATUS_UNLOCK		(3)
#define USER_DATA_STATUS_RUNNING	(4)

// EEPROM Command
#define USER_DATA_CMD_LOCK			(0)
#define USER_DATA_CMD_SELADDR		(1)
#define USER_DATA_CMD_SETDATA		(2)
#define USER_DATA_CMD_SAVEDATA		(3)
#define USER_DATA_CMD_CHKSUMADDR	(5)
#define USER_DATA_CMD_UNLOCK1		(6)
#define USER_DATA_CMD_UNLOCK2		(7)

// I2C functions
extern CyU3PReturnStatus_t EEPROMWriteI2C(uint8_t slaveAddr, uint32_t address, uint32_t count, uint8_t *data);
extern CyU3PReturnStatus_t EEPROMReadI2C(uint8_t slaveAddr, uint32_t address, uint32_t count, uint8_t *data);

// EEPROM control function
extern void UserDataProcessor(uint16_t system);
extern void LockUserData();

extern void LoadInitUserData_EEPROMtoRAM();	//Init only
extern void SaveUserData_RAMtoEEPROM();
extern unsigned char CraeteCheckSumRAM();

extern void SelectUserDataAddress(uint32_t address);
extern unsigned char GetUserData();
extern void SetUserData(unsigned char value);

#endif /*_EEPROM_DATA_H_*/
