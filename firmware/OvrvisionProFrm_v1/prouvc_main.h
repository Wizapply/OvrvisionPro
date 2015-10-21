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
 *  Files : prouvc_main.h
 *
***************************************************************************/

#ifndef _PROUVC_MAIN_H_
#define _PROUVC_MAIN_H_

#include <cyu3types.h>
#include <cyu3usbconst.h>
#include <cyu3externcstart.h>

/* UVC application thread parameters. */
#define UVC_APP_THREAD_STACK           (0x1000) /* Stack size for the video streaming thread is 4 KB. */
#define UVC_APP_THREAD_PRIORITY        (8)      /* Priority for the video streaming thread is 8. */

#define UVC_APP_EP0_THREAD_STACK       (0x0800) /* Stack size for the UVC control request thread is 2 KB. */
#define UVC_APP_EP0_THREAD_PRIORITY    (8)      /* Priority for the UVC control request thread is 8. */

/* DMA socket selection for UVC data transfer. */
#define CY_FX_EP_VIDEO_CONS_SOCKET      0x03    /* USB Consumer socket 3 is used for video data. */
#define CY_FX_EP_CONTROL_STATUS_SOCKET  0x02    /* USB Consumer socket 2 is used for the status pipe. */

/* Endpoint definition for UVC application */
#define CY_FX_EP_IN_TYPE                0x80    /* USB IN end points have MSB set */
#define CY_FX_EP_BULK_VIDEO             (CY_FX_EP_VIDEO_CONS_SOCKET | CY_FX_EP_IN_TYPE)         /* EP 3 IN */
#define CY_FX_EP_CONTROL_STATUS         (CY_FX_EP_CONTROL_STATUS_SOCKET | CY_FX_EP_IN_TYPE)     /* EP 2 IN */

/* UVC Video Streaming Endpoint Packet Size */
#define CY_FX_EP_BULK_VIDEO_PKT_SIZE    (0x400)         /* 1024 Bytes */

/* UVC Video Streaming Endpoint Packet Count */
#define CY_FX_EP_BULK_VIDEO_PKTS_COUNT  (0x10)          /* 16 packets (burst of 16) per DMA buffer. */

/* DMA buffer size used for video streaming. */
#define CY_FX_UVC_STREAM_BUF_SIZE      (CY_FX_EP_BULK_VIDEO_PKTS_COUNT * CY_FX_EP_BULK_VIDEO_PKT_SIZE)  /* 16 KB */

/* Maximum video data that can be accommodated in one DMA buffer. */
#define CY_FX_UVC_BUF_FULL_SIZE        (CY_FX_UVC_STREAM_BUF_SIZE - 16)

/* Number of DMA buffers per GPIF DMA thread. */
#define CY_FX_UVC_STREAM_BUF_COUNT     (4)

/* Low Byte - UVC Video Streaming Endpoint Packet Size */
#define CY_FX_EP_BULK_VIDEO_PKT_SIZE_L  (uint8_t)(CY_FX_EP_BULK_VIDEO_PKT_SIZE & 0x00FF)

/* High Byte - UVC Video Streaming Endpoint Packet Size and No. of BULK packets */
#define CY_FX_EP_BULK_VIDEO_PKT_SIZE_H  (uint8_t)((CY_FX_EP_BULK_VIDEO_PKT_SIZE & 0xFF00) >> 8)

/*
   The following constants are taken from the USB and USB Video Class (UVC) specifications.
   They are defined here for convenient usage in the rest of the application source code.
 */
#define CY_FX_INTF_ASSN_DSCR_TYPE       (0x0B)          /* Type code for Interface Association Descriptor (IAD) */

#define CY_FX_USB_SETUP_REQ_TYPE_MASK   (uint32_t)(0x000000FF)  /* Mask for bmReqType field from a control request. */
#define CY_FX_USB_SETUP_REQ_MASK        (uint32_t)(0x0000FF00)  /* Mask for bRequest field from a control request. */
#define CY_FX_USB_SETUP_VALUE_MASK      (uint32_t)(0xFFFF0000)  /* Mask for wValue field from a control request. */
#define CY_FX_USB_SETUP_INDEX_MASK      (uint32_t)(0x0000FFFF)  /* Mask for wIndex field from a control request. */
#define CY_FX_USB_SETUP_LENGTH_MASK     (uint32_t)(0xFFFF0000)  /* Mask for wLength field from a control request. */

#define CY_FX_USB_SET_INTF_REQ_TYPE     (uint8_t)(0x01)         /* USB SET_INTERFACE Request Type. */
#define CY_FX_USB_SET_INTERFACE_REQ     (uint8_t)(0x0B)         /* USB SET_INTERFACE Request code. */

#define CY_FX_UVC_MAX_HEADER           (12)             /* Maximum UVC header size, in bytes. */
#define CY_FX_UVC_HEADER_DEFAULT_BFH   (0x8C)           /* Default BFH (Bit Field Header) for the UVC Header */
#define CY_FX_UVC_MAX_PROBE_SETTING    (26)             /* Maximum number of bytes in Probe Control */
#define CY_FX_UVC_MAX_PROBE_SETTING_ALIGNED (32)        /* Probe control data size aligned to 16 bytes. */

/* OvrvisionPro GPIO Pin*/
#define OVRPRO_GPIO0_PIN	(35)
#define OVRPRO_GPIO1_PIN	(36)
#define OVRPRO_GPIO2_PIN	(37)
#define OVRPRO_GPIO3_PIN	(38)

/* Extern definitions of the USB Enumeration constant arrays used for the UVC application.
   These arrays are defined in the cyfxuvcdscr.c file.
 */
extern const uint8_t CyFxUSBDeviceDscrSS[];			/* USB 3.0 Device descriptor. */
extern const uint8_t CyFxUSBDeviceDscrHS[];			/* USB 2.0 device descriptor. */

extern const uint8_t CyFxUSBBOSDscr[];				/* USB 3.0 BOS descriptor. */
extern const uint8_t CyFxUSBDeviceQualDscr[];		/* USB 2.0 Device Qual descriptor. */

extern const uint8_t CyFxUSBStringLangIDDscr[];		/* String 0 descriptor. */
extern const uint8_t CyFxUSBManufactureDscr[];		/* Manufacturer string descriptor. */
extern const uint8_t CyFxUSBProductDscr[];			/* Product string descriptor. */

extern const uint8_t CyFxUSBSSConfigDscr[];			/* USB 3.0 config descriptor. */
extern const uint8_t CyFxUSBHSConfigDscr[];			/* High Speed Config descriptor. */
extern const uint8_t CyFxUSBFSConfigDscr[];			/* Full Speed Config descriptor. */

#include <cyu3externcend.h>

//Define
#ifndef NULL
#define NULL   ((void *) 0)
#endif

#endif /*_PROUVC_MAIN_H_*/
