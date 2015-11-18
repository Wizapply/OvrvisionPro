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
 *  Files : eeprom_data.c
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

#include "eeprom_data.h"

////////////////////// Functions Var & define //////////////////////

static uint8_t g_userDataBuffer[USER_DATA_BUFFERSIZE];
static uint8_t g_userDataStatus = USER_DATA_STATUS_LOCK;	//0:lock 1:unlock_proc 2:unlock_proc 4:unlock_ok 5:running
static uint32_t g_userDataCurAddr = 0;

////////////////////// Functions //////////////////////

// I2C functions
CyU3PReturnStatus_t EEPROMWriteI2C(uint8_t slaveAddr, uint32_t address, uint32_t count, uint8_t *data)
{
	CyU3PReturnStatus_t apiRetStatus = CY_U3P_SUCCESS;
	CyU3PI2cPreamble_t preamble;

	uint8_t hiHighAddr = (address >> 16) & 0x00000003;
	uint8_t highAddr = (address >> 8) & 0x000000FF;
	uint8_t lowAddr = address & 0x000000FF;

	/* Validate the I2C slave address. */
	if (slaveAddr != I2C_MEMORY_ADDR_WR) {
		return CY_U3P_ERROR_FAILURE;
	}

	/* Set the parameters for the I2C API access and then call the write API. */
	preamble.buffer[0] = slaveAddr & I2C_MEMORY_SLAVEADDR_MASK;
	preamble.buffer[0] |= (hiHighAddr << 1);
	preamble.buffer[1] = highAddr;
	preamble.buffer[2] = lowAddr;
	preamble.length = 3;			/*  Three byte preamble. */
	preamble.ctrlMask = 0x0000; 	/*  No additional start and stop bits. */

	apiRetStatus = CyU3PI2cTransmitBytes(&preamble, data, count, 0);
	if(apiRetStatus == CY_U3P_SUCCESS)
		CyU3PBusyWait(10);

	return apiRetStatus;
}

CyU3PReturnStatus_t EEPROMReadI2C(uint8_t slaveAddr, uint32_t address, uint32_t count, uint8_t *data)
{
	CyU3PReturnStatus_t apiRetStatus = CY_U3P_SUCCESS;
	CyU3PI2cPreamble_t preamble;

	uint8_t hiHighAddr = (address >> 16) & 0x00000003;
	uint8_t highAddr = (address >> 8) & 0x000000FF;
	uint8_t lowAddr = address & 0x000000FF;

	if (slaveAddr != I2C_MEMORY_ADDR_RD) {
		return CY_U3P_ERROR_FAILURE;
	}

	preamble.buffer[0] = slaveAddr & I2C_MEMORY_SLAVEADDR_MASK; /*  Mask out the transfer type bit. */
	preamble.buffer[0] |= (hiHighAddr << 1);
	preamble.buffer[1] = highAddr;
	preamble.buffer[2] = lowAddr;
	preamble.buffer[3] = slaveAddr;
	preamble.length = 4;
	preamble.ctrlMask = 0x0004; /*  Send start bit after third byte of preamble. */

	apiRetStatus = CyU3PI2cReceiveBytes(&preamble, data, count, 0);
	CyU3PBusyWait(10);

	return apiRetStatus;
}

// EEPROM control function
extern void UserDataProcessor(uint16_t system)
{
	uint8_t ctrl = system >> 12;
	uint32_t data = system & 0x03FF;	//0-1023

	//locked
	if(ctrl == USER_DATA_CMD_LOCK) {
		LockUserData();
		return;
	}

	switch(g_userDataStatus) {
		case USER_DATA_STATUS_LOCK:
			//LOCK -> 0x7000 -> 0x6000 -> 0x7000 -> UNLOCK
			if(ctrl == USER_DATA_CMD_UNLOCK2 && data == 0) g_userDataStatus = USER_DATA_STATUS_UNLOCK_P1;
			break;
		case USER_DATA_STATUS_UNLOCK_P1:
			if(ctrl == USER_DATA_CMD_UNLOCK1 && data == 0) g_userDataStatus = USER_DATA_STATUS_UNLOCK_P2;
			else g_userDataStatus = USER_DATA_STATUS_LOCK;
			break;
		case USER_DATA_STATUS_UNLOCK_P2:
			if(ctrl == USER_DATA_CMD_UNLOCK2 && data == 0) g_userDataStatus = USER_DATA_STATUS_UNLOCK;
			else g_userDataStatus = USER_DATA_STATUS_LOCK;
			break;
		case USER_DATA_STATUS_UNLOCK:
			if(ctrl == USER_DATA_CMD_SELADDR) {
				SelectUserDataAddress(data);
			} else if(ctrl == USER_DATA_CMD_SETDATA) {
				SetUserData(data);	//set
			} else if(ctrl == USER_DATA_CMD_SAVEDATA) {
				SaveUserData_RAMtoEEPROM();	//Save
			} else if(ctrl == 0x04) {
				//Reserved
			} else if(ctrl == USER_DATA_CMD_CHKSUMADDR) {
				SelectUserDataAddress(USER_DATA_CHECKSUM_ADDR);	//checksum
			}

			break;
		case USER_DATA_STATUS_RUNNING:
		default:
			break;
	}
}

extern void LockUserData() {
	g_userDataStatus = USER_DATA_STATUS_LOCK;	//lock
	g_userDataCurAddr = 0;
}

extern void LoadInitUserData_EEPROMtoRAM() {

	//Clear
	CyU3PMemSet(&g_userDataBuffer[0x0000],0x00,0xFF);
	CyU3PMemSet(&g_userDataBuffer[0x0100],0x00,0xFF);

	//load
	EEPROMReadI2C(I2C_MEMORY_ADDR_RD,0x00038000,256,&g_userDataBuffer[0x0000]);
	CyU3PThreadSleep(15); //15ms
	EEPROMReadI2C(I2C_MEMORY_ADDR_RD,0x00038100,256,&g_userDataBuffer[0x0100]);
	CyU3PThreadSleep(15); //15ms

	g_userDataCurAddr = 0;
	g_userDataStatus = USER_DATA_STATUS_LOCK;
}

extern void SaveUserData_RAMtoEEPROM() {

	if(g_userDataStatus != USER_DATA_STATUS_UNLOCK)
		 return;

	g_userDataStatus = USER_DATA_STATUS_RUNNING;//running

	//create checksum
	g_userDataBuffer[USER_DATA_CHECKSUM_ADDR] = CraeteCheckSumRAM();

	//Save eeprom
	EEPROMWriteI2C(I2C_MEMORY_ADDR_WR,0x00038000,256,&g_userDataBuffer[0x0000]);
	CyU3PThreadSleep(15); //15ms
	EEPROMWriteI2C(I2C_MEMORY_ADDR_WR,0x00038100,256,&g_userDataBuffer[0x0100]);
	CyU3PThreadSleep(15); //15ms

	g_userDataCurAddr = 0;
	g_userDataStatus = USER_DATA_STATUS_UNLOCK;//unlock

	CyU3PThreadSleep(20); //20ms
}

extern unsigned char CraeteCheckSumRAM() {
	uint32_t i;
	uint8_t chsum = 0;

	for (i=0; i < USER_DATA_NOCHECKSUM_BUFSIZE; i++)
		chsum = chsum^g_userDataBuffer[i];

	return chsum;
}

extern void SelectUserDataAddress(uint32_t address) {
	if(address < USER_DATA_BUFFERSIZE)
		g_userDataCurAddr = address;
}

extern unsigned char GetUserData() {
	uint8_t data = 0x00;
	if(g_userDataStatus != USER_DATA_STATUS_UNLOCK)
		 return 0x00;

	data = g_userDataBuffer[g_userDataCurAddr];

	if(g_userDataCurAddr < USER_DATA_NOCHECKSUM_BUFSIZE)
		++g_userDataCurAddr;

	return data;
}

extern void SetUserData(unsigned char value) {
	g_userDataBuffer[g_userDataCurAddr] = value;

	if(g_userDataCurAddr < USER_DATA_NOCHECKSUM_BUFSIZE)
		++g_userDataCurAddr;
}

