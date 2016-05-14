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
 *  Ovrvision Pro FirmWare v1.1
 *
 *  Language is 'C' code source
 *  Files : gpio_test_pcd8544.h
 *
***************************************************************************/


#ifndef _GPIO_TEST_PCD8544_
#define _GPIO_TEST_PCD8544_

#include <cyu3types.h>

/* OvrvisionPro GPIO Pin*/
#define OVRPRO_SCE_PIN	(38)
#define OVRPRO_DC_PIN	(37)
#define OVRPRO_SDIN_PIN	(36)
#define OVRPRO_SCLK_PIN	(35)

#define LCD_C  CyFalse
#define LCD_D  CyTrue

#define LCD_X   (84)
#define LCD_Y   (48)

#define LCD_CMD  (0)

void PCD8544_Initialise(void);
void PCD8544_Clear(void);
void PCD8544_Write(uint8_t dc, uint8_t data);
void PCD8544_Character(char character);
void PCD8544_String(char *characters);
void PCD8544_UINT32(int val, int field_length);
void PCD8544_GotoXY(uint8_t x, uint8_t y);
void PCD8544_LogoDraw(void);

#endif /*_GPIO_TEST_PCD8544_*/
