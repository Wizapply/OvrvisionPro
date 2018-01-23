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
 *  Files : cyfxuvcdscr.c
 *
***************************************************************************/

#include "prouvc_main.h"

/* Device Descriptor for USB3.0(SS) */
const uint8_t CyFxUSBDeviceDscrSS[] =
{
	0x12,                           /* Descriptor Size */
	CY_U3P_USB_DEVICE_DESCR,        /* Device Descriptor Type */
	0x00,0x03,                      /* USB 3.0 */
	0xEF,                           /* Device Class */
	0x02,                           /* Device Sub-class */
	0x01,                           /* Device protocol */
	0x06,                           /* Maxpacket size for EP0 : 2^6 Bytes */
	0x33,0x2C,                      /* Vendor ID*/
	0x01,0x00,                      /* Product ID*/
	0x05,0x01,                      /* Device release number */
	0x01,                           /* Manufacture string index */
	0x02,                           /* Product string index */
	0x00,                           /* Serial number string index */
	0x01                            /* Number of configurations */
};

/* Device Descriptor for USB2.0(HS) */
const uint8_t CyFxUSBDeviceDscrHS[] =
{
	0x12,                           /* Descriptor Size */
	CY_U3P_USB_DEVICE_DESCR,        /* Device Descriptor Type */
	0x00,0x02,                      /* USB 2.0 */
	0xEF,                           /* Device Class */
	0x02,                           /* Device Sub-class */
	0x01,                           /* Device protocol */
	0x40,                           /* Maxpacket size for EP0 : 64 bytes */
	0x33,0x2C,                      /* Vendor ID*/
	0x01,0x00,                      /* Product ID*/
	0x05,0x01,                      /* Device release number */
	0x01,                           /* Manufacture string index */
	0x02,                           /* Product string index */
	0x00,                           /* Serial number string index */
	0x01                            /* Number of configurations */
};

/* Binary Device Object Store (BOS) Descriptor */
const uint8_t CyFxUSBBOSDscr[] =
{
    0x05,                               /* Descriptor size */
    CY_U3P_BOS_DESCR,                   /* Device descriptor type */
    0x16, 0x00,                         /* Length of this descriptor and all sub descriptors */
    0x02,                               /* Number of device capability descriptors */

    /* USB 2.0 Extension */
    0x07,                               /* Descriptor size */
    CY_U3P_DEVICE_CAPB_DESCR,           /* Device capability type descriptor */
    CY_U3P_USB2_EXTN_CAPB_TYPE,         /* USB 2.1 extension capability type */
    0x02, 0x00, 0x00, 0x00,             /* Supported device level features - LPM support */

    /* SuperSpeed Device Capability */
    0x0A,                               /* Descriptor size */
    CY_U3P_DEVICE_CAPB_DESCR,           /* Device capability type descriptor */
    CY_U3P_SS_USB_CAPB_TYPE,            /* SuperSpeed device capability type */
    0x00,                               /* Supported device level features  */
    0x0E, 0x00,                         /* Speeds supported by the device : SS, HS and FS */
    0x03,                               /* Functionality support */
    0x00,                               /* U1 device exit latency */
    0x00, 0x00                          /* U2 device exit latency */
};

/* Standard Device Qualifier Descriptor */
const uint8_t CyFxUSBDeviceQualDscr[] =
{
    0x0A,                               /* descriptor size */
    CY_U3P_USB_DEVQUAL_DESCR,           /* Device qualifier descriptor type */
    0x00, 0x02,                         /* USB 2.0 */
    0xEF,                               /* Device class */
    0x02,                               /* Device sub-class */
    0x01,                               /* Device protocol */
    0x40,                               /* Maxpacket size for EP0 : 64 bytes */
    0x01,                               /* Number of configurations */
    0x00                                /* Reserved */
};

/* Standard Language ID String Descriptor */
const uint8_t CyFxUSBStringLangIDDscr[] =
{
	0x04,                           /* Descriptor Size */
	CY_U3P_USB_STRING_DESCR,        /* Device Descriptor Type */
	0x09,0x04                       /* Language ID supported */
};

/* Standard Manufacturer String Descriptor */
const uint8_t CyFxUSBManufactureDscr[] =
{
	0x12,                           /* Descriptor Size */
	CY_U3P_USB_STRING_DESCR,        /* Device Descriptor Type */
	'W',0x00,
	'i',0x00,
	'z',0x00,
	'a',0x00,
	'p',0x00,
	'p',0x00,
	'l',0x00,
	'y',0x00
};

/* Standard Product String Descriptor */
const uint8_t CyFxUSBProductDscr[] =
{
	0x1A,                           /* Descriptor Size */
	CY_U3P_USB_STRING_DESCR,        /* Device Descriptor Type */
	'O',0x00,
	'v',0x00,
	'r',0x00,
	'v',0x00,
	'i',0x00,
	's',0x00,
	'i',0x00,
	'o',0x00,
	'n',0x00,
	'P',0x00,
	'r',0x00,
	'o',0x00
};


///////////////////// Descriptor /////////////////////
/* Super Speed Configuration Descriptor (USB3.0) */
const uint8_t CyFxUSBSSConfigDscr[] =
{
	/* Configuration Descriptor Type */
	0x09,                           /* Descriptor Size */
	CY_U3P_USB_CONFIG_DESCR,        /* Configuration Descriptor Type */
	0x8D,0x01,                      /* Length of this descriptor and all sub descriptors */
	0x02,                           /* Number of interfaces */
	0x01,                           /* Configuration number */
	0x00,                           /* Configuration string index */
	0x80,                           /* Config characteristics - Bus powered */
	0x2D,                           /* Max power consumption of device (in 8mA unit) : 360mA */

	/* Interface Association Descriptor */
	0x08,                           /* Descriptor Size */
	CY_FX_INTF_ASSN_DSCR_TYPE,      /* Interface Association Descr Type: 11 */
	0x00,                           /* I/f number of first VideoControl i/f */
	0x02,                           /* Number of Video i/f */
	0x0E,                           /* CC_VIDEO : Video i/f class code */
	0x03,                           /* SC_VIDEO_INTERFACE_COLLECTION : Subclass code */
	0x00,                           /* Protocol : Not used */
	0x00,                           /* String desc index for interface */

	/* Standard Video Control Interface Descriptor */
	0x09,                           /* Descriptor size */
	CY_U3P_USB_INTRFC_DESCR,        /* Interface Descriptor type */
	0x00,                           /* Interface number */
	0x00,                           /* Alternate setting number */
	0x01,                           /* Number of end points */
	0x0E,                           /* CC_VIDEO : Interface class */
	0x01,                           /* CC_VIDEOCONTROL : Interface sub class */
	0x00,                           /* Interface protocol code */
	0x00,                           /* Interface descriptor string index */

	/* Class specific VC Interface Header Descriptor */
	0x0D,                           /* Descriptor size */
	0x24,                           /* Class Specific I/f Header Descriptor type */
	0x01,                           /* Descriptor Sub type : VC_HEADER */
	0x00,0x01,                      /* Revision of class spec : 1.0 */
	0x50,0x00,                      /* Total Size of class specific descriptors (till Output terminal) */
	0x00,0xD8,0xB8,0x05,            /* Clock frequency : 96MHz(Deprecated) */
	0x01,                           /* Number of streaming interfaces */
	0x01,                           /* Video streaming I/f 1 belongs to VC i/f */

	/* Input (Camera) Terminal Descriptor */
	0x12,                           /* Descriptor size */
	0x24,                           /* Class specific interface desc type */
	0x02,                           /* Input Terminal Descriptor type */
	0x01,                           /* ID of this terminal */
	0x01,0x02,                      /* Camera terminal type */

	0x00,                           /* No association terminal */
	0x00,                           /* String desc index : Not used */
	0x00,0x00,                      /* No optical zoom supported */
	0x00,0x00,                      /* No optical zoom supported */
	0x00,0x00,                      /* No optical zoom supported */
	0x03,                           /* Size of controls field for this terminal : 3 bytes */
									/* A bit set to 1 in the bmControls field indicates that
									 * the mentioned Control is supported for the video stream.
									 * D0: Scanning Mode
									 * D1: Auto-Exposure Mode
									 * D2: Auto-Exposure Priority
									 * D3: Exposure Time (Absolute)
									 * D4: Exposure Time (Relative)
									 * D5: Focus (Absolute)
									 * D6: Focus (Relative)
									 * D7: Iris (Absolute)
									 * D8: Iris (Relative)
									 * D9: Zoom (Absolute)
									 * D10: Zoom (Relative)
									 * D11: PanTilt (Absolute)
									 * D12: PanTilt (Relative)
									 * D13: Roll (Absolute)
									 * D14: Roll (Relative)
									 * D15: Reserved
									 * D16: Reserved
									 * D17: Focus, Auto
									 * D18: Privacy
									 * D19: Focus, Simple
									 * D20: Window
									 * D21: Region of Interest
									 * D22&D23: Reserved, set to zero
									 */
	0x00,0x00,0x00,                 /* bmControls field of camera terminal: No controls supported */

	/* Processing Unit Descriptor */
	0x0C,                           /* Descriptor size */
	0x24,                           /* Class specific interface desc type */
	0x05,                           /* Processing Unit Descriptor type */
	0x02,                           /* ID of this terminal */
	0x01,                           /* Source ID : 1 : Conencted to input terminal */
	0x00,0x00,                      /* Digital multiplier */
	0x03,                           /* Size of controls field for this terminal : 3 bytes */
									/* A bit set to 1 in the bmControls field indicates that
									 * the mentioned Control is supported for the video stream.
									 * D0: Brightness -> Exposure
									 * D1: Contrast -> Data EEPROM
									 * D2: Hue
									 * D3: Saturation
									 * D4: Sharpness -> White Balance R Gain
									 * D5: Gamma -> White Balance G Gain
									 * D6: White Balance Temperature -> White Balance B Gain
									 * D7: White Balance Component
									 * D8: Backlight Compensation
									 * D9: Gain
									 * D10: Power Line Frequency
									 * D11: Hue, Auto
									 * D12: White Balance Temperature, Auto
									 * D13: White Balance Component, Auto
									 * D14: Digital Multiplier
									 * D15: Digital Multiplier Limit
									 * D16: Analog Video Standard
									 * D17: Analog Video Lock Status
									 * D18: Contrast, Auto
									 * D19-D23: Reserved. Set to zero.
									 */
	0x73,0x13,0x00,                 /* Control supported */
	0x00,                           /* String desc index : Not used */

	/* Extension Unit Descriptor */
	0x1C,                           /* Descriptor size */
	0x24,                           /* Class specific interface desc type */
	0x06,                           /* Extension Unit Descriptor type */
	0x03,                           /* ID of this terminal */
	0xFF,0xFF,0xFF,0xFF,            /* 16 byte GUID */
	0xFF,0xFF,0xFF,0xFF,
	0xFF,0xFF,0xFF,0xFF,
	0xFF,0xFF,0xFF,0xFF,
	0x00,                           /* Number of controls in this terminal */
	0x01,                           /* Number of input pins in this terminal */
	0x02,                           /* Source ID : 2 : Connected to Proc Unit */
	0x03,                           /* Size of controls field for this terminal : 3 bytes */
	0x00,0x00,0x00,                 /* Not controls supported */
	0x00,                           /* String desc index : Not used */

	/* Output Terminal Descriptor */
	0x09,                           /* Descriptor size */
	0x24,                           /* Class specific interface desc type */
	0x03,                           /* Output Terminal Descriptor type */
	0x04,                           /* ID of this terminal */
	0x01,0x01,                      /* USB Streaming terminal type */
	0x00,                           /* No association terminal */
	0x03,                           /* Source ID : 3 : Connected to Extn Unit */
	0x00,                           /* String desc index : Not used */

	/* Video Control Status Interrupt Endpoint Descriptor */
	0x07,                           /* Descriptor size */
	CY_U3P_USB_ENDPNT_DESCR,        /* Endpoint Descriptor Type */
	CY_FX_EP_CONTROL_STATUS,        /* Endpoint address and description */
	CY_U3P_USB_EP_INTR,             /* Interrupt End point Type */
	0x00,0x04,                      /* Max packet size = 1024 bytes */
	0x01,                           /* Servicing interval */

	/* Super Speed Endpoint Companion Descriptor */
	0x06,                           /* Descriptor size */
	CY_U3P_SS_EP_COMPN_DESCR,       /* SS Endpoint Companion Descriptor Type */
	0x00,                           /* Max no. of packets in a Burst : 1 */
	0x00,                           /* Attribute: N.A. */
	0x00, 0x00,                     /* Bytes per interval:0 */

	/* Class Specific Interrupt Endpoint Descriptor */
	0x05,                           /* Descriptor size */
	0x25,                           /* Class Specific Endpoint Descriptor Type */
	CY_U3P_USB_EP_INTR,             /* End point Sub Type */
	0x40,0x00,                      /* Max packet size = 64 bytes */

	/* Standard Video Streaming Interface Descriptor (Alternate Setting 0) */
	0x09,                           /* Descriptor size */
	CY_U3P_USB_INTRFC_DESCR,        /* Interface Descriptor type */
	0x01,                           /* Interface number */
	0x00,                           /* Alternate setting number */
	0x01,                           /* Number of end points */
	0x0E,                           /* Interface class : CC_VIDEO */
	0x02,                           /* Interface sub class : CC_VIDEOSTREAMING */
	0x00,                           /* Interface protocol code : Undefined */
	0x00,                           /* Interface descriptor string index */

   /* Class-specific Video Streaming Input Header Descriptor */
	0x0E,                           /* Descriptor size */
	0x24,                           /* Class-specific VS I/f Type */
	0x01,                           /* Descriptor Subtype : Input Header */
	0x01,                           /* 1 format desciptor follows */
	0xFB,0x00,                      /* Total size of Class specific VS descr */
	CY_FX_EP_BULK_VIDEO,            /* EP address for BULK video data */
	0x00,                           /* No dynamic format change supported */
	0x04,                           /* Output terminal ID : 4 */
	0x00,                           /* Still image capture method 1 supported */
	0x00,                           /* Hardware trigger NOT supported */
	0x00,                           /* Hardware to initiate still image capture NOT supported */
	0x01,                           /* Size of controls field : 1 byte */
	0x00,                           /* D2 : Compression quality supported */

	/* Class specific Uncompressed VS format descriptor */
	0x1B,                           /* Descriptor size */
	0x24,                           /* Class-specific VS I/f Type */
	0x04,                           /* Subtype : uncompressed format I/F */
	0x01,                           /* Format desciptor index */
	0x07,                           /* Number of frame descriptor followed */
	'Y' ,'U' ,'Y' ,'2' ,            /* GUID used to identify streaming-encoding format: YUY2  */
	0x00,0x00,0x10,0x00,
	0x80,0x00,0x00,0xAA,
	0x00,0x38,0x9B,0x71,
	0x10,                           /* Number of bits per pixel */
	0x01,                           /* Optimum Frame Index for this stream: 1 */
	0x00,                           /* X dimension of the picture aspect ratio; Non-interlaced */
	0x00,                           /* Y dimension of the pictuer aspect ratio: Non-interlaced */
	0x00,                           /* Interlace Flags: Progressive scanning, no interlace */
	0x00,                           /* duplication of the video stream restriction: 0 - no restriction */

	/* Class specific Uncompressed VS frame descriptor 2560x1920@15*/
	0x1E,                           /* Descriptor size */
	0x24,                           /* Descriptor type*/
	0x05,                           /* Subtype: uncompressed frame I/F */
	0x01,                           /* Frame Descriptor Index */
	0x00,                           /* Still image capture method 1 supported, fixed frame rate */
	0x00, 0x0A,                     /* Width in pixel */
	0x80, 0x07,                     /* Height in pixel */
	0x00,0x00,0x50,0x46,            /* Min bit rate bits/s. */
	0x00,0x00,0x50,0x46,            /* Max bit rate bits/s. */
	0x00,0x00,0x96,0x00,            /* Maximum video or still frame size in bytes(Deprecated)*/
	0x2A, 0x2C, 0x0A, 0x00,         /* Default Frame Interval*/
	0x01,							/* Frame interval(Frame Rate) types: Only one frame interval supported */
	0x2A, 0x2C, 0x0A, 0x00,			/* Shortest Frame Interval */

	/* Class specific Uncompressed VS frame descriptor 1920x1080@30*/
	0x1E,                           /* Descriptor size */
	0x24,                           /* Descriptor type*/
	0x05,                           /* Subtype: uncompressed frame I/F */
	0x02,                           /* Frame Descriptor Index */
	0x00,                           /* Still image capture method 1 supported, fixed frame rate */
	0x80, 0x07,                     /* Width in pixel */
	0x38, 0x04,                     /* Height in pixel */
	0x00,0x00,0x50,0x46,            /* Min bit rate bits/s. */
	0x00,0x00,0x50,0x46,            /* Max bit rate bits/s. */
	0x00,0x48,0x3F,0x00,            /* Maximum video or still frame size in bytes(Deprecated)*/
	0x15, 0x16, 0x05, 0x00,         /* Default Frame Interval */
	0x01,							/* Frame interval(Frame Rate) types: Only one frame interval supported */
	0x15, 0x16, 0x05, 0x00,			/* Shortest Frame Interval */

	/* Class specific Uncompressed VS frame descriptor 1280x960@45*/
	0x1E,                           /* Descriptor size */
	0x24,                           /* Descriptor type*/
	0x05,                           /* Subtype: uncompressed frame I/F */
	0x03,                           /* Frame Descriptor Index */
	0x00,                           /* Still image capture method 1 supported, fixed frame rate */
	0x00, 0x05,                     /* Width in pixel */
	0xC0, 0x03,                     /* Height in pixel */
	0x00,0x00,0x50,0x46,            /* Min bit rate bits/s. */
	0x00,0x00,0x50,0x46,            /* Max bit rate bits/s. */
	0x00,0x80,0x25,0x00,            /* Maximum video or still frame size in bytes(Deprecated)*/
	0x0E, 0x64, 0x03, 0x00,         /* Default Frame Interval */
	0x01,							/* Frame interval(Frame Rate) types: Only one frame interval supported */
	0x0E, 0x64, 0x03, 0x00,			/* Shortest Frame Interval */

	/* Class specific Uncompressed VS frame descriptor 1280x800@60*/
	0x1E,                           /* Descriptor size */
	0x24,                           /* Descriptor type*/
	0x05,                           /* Subtype: uncompressed frame I/F */
	0x04,                           /* Frame Descriptor Index */
	0x00,                           /* Still image capture method 1 supported, fixed frame rate */
	0x00, 0x05,                     /* Width in pixel */
	0x20, 0x03,                     /* Height in pixel */
	0x00,0x00,0x50,0x46,            /* Min bit rate bits/s. */
	0x00,0x00,0x50,0x46,            /* Max bit rate bits/s. */
	0x00,0x40,0x1F,0x00,            /* Maximum video or still frame size in bytes(Deprecated)*/
	0x0A, 0x8B, 0x02, 0x00,         /* Default Frame Interval */
	0x01,							/* Frame interval(Frame Rate) types: Only one frame interval supported */
	0x0A, 0x8B, 0x02, 0x00,			/* Shortest Frame Interval */

	/* Class specific Uncompressed VS frame descriptor 960x950@60*/
	0x1E,                           /* Descriptor size */
	0x24,                           /* Descriptor type*/
	0x05,                           /* Subtype: uncompressed frame I/F */
	0x05,                           /* Frame Descriptor Index */
	0x00,                           /* Still image capture method 1 supported, fixed frame rate */
	0xC0, 0x03,                     /* Width in pixel */
	0xB6, 0x03,                     /* Height in pixel */
	0x00,0x00,0x50,0x46,            /* Min bit rate bits/s. */
	0x00,0x00,0x50,0x46,            /* Max bit rate bits/s. */
	0x00,0xD5,0x1B,0x00,            /* Maximum video or still frame size in bytes(Deprecated)*/
	0x0A, 0x8B, 0x02, 0x00,         /* Default Frame Interval */
	0x01,							/* Frame interval(Frame Rate) types: Only one frame interval supported */
	0x0A, 0x8B, 0x02, 0x00,			/* Shortest Frame Interval */

	/* Class specific Uncompressed VS frame descriptor 640x480@90 */
	0x1E,                           /* Descriptor size */
	0x24,                           /* Descriptor type*/
	0x05,                           /* Subtype: uncompressed frame I/F */
	0x06,                           /* Frame Descriptor Index */
	0x00,                           /* Still image capture method 1 supported, fixed frame rate */
	0x80, 0x02,                     /* Width in pixel */
	0xE0, 0x01,                     /* Height in pixel */
	0x00,0x00,0x50,0x46,            /* Min bit rate bits/s. */
	0x00,0x00,0x50,0x46,            /* Max bit rate bits/s. */
	0x00,0x60,0x09,0x00,            /* Maximum video or still frame size in bytes(Deprecated)*/
	0x07, 0xB2, 0x01, 0x00,         /* Default Frame Interval */
	0x01,							/* Frame interval(Frame Rate) types: Only one frame interval supported */
	0x07, 0xB2, 0x01, 0x00,			/* Shortest Frame Interval */

	/* Class specific Uncompressed VS frame descriptor 320x240@120 */
	0x1E,                           /* Descriptor size */
	0x24,                           /* Descriptor type*/
	0x05,                           /* Subtype: uncompressed frame I/F */
	0x07,                           /* Frame Descriptor Index */
	0x00,                           /* Still image capture method 1 supported, fixed frame rate */
	0x40, 0x01,                     /* Width in pixel */
	0xF0, 0x00,                     /* Height in pixel */
	0x00,0x00,0x50,0x46,            /* Min bit rate bits/s. */
	0x00,0x00,0x50,0x46,            /* Max bit rate bits/s. */
	0x00,0x58,0x02,0x00,            /* Maximum video or still frame size in bytes(Deprecated)*/
	0x85, 0x45, 0x01, 0x00,         /* Default Frame Interval */
	0x01,							/* Frame interval(Frame Rate) types: Only one frame interval supported */
	0x85, 0x45, 0x01, 0x00,			/* Shortest Frame Interval */

	/* Endpoint Descriptor for BULK Streaming Video Data */
	0x07,                           /* Descriptor size */
	CY_U3P_USB_ENDPNT_DESCR,        /* Endpoint Descriptor Type */
	CY_FX_EP_BULK_VIDEO,            /* Endpoint address and description */
	CY_U3P_USB_EP_BULK,             /* BULK End point */
	CY_FX_EP_BULK_VIDEO_PKT_SIZE_L, /* EP MaxPcktSize: 1024B */
	CY_FX_EP_BULK_VIDEO_PKT_SIZE_H, /* EP MaxPcktSize: 1024B */
	0x00,                           /* Servicing interval for data transfers */

	/* Super Speed Endpoint Companion Descriptor */
	0x06,                           /* Descriptor size */
	CY_U3P_SS_EP_COMPN_DESCR,       /* SS Endpoint Companion Descriptor Type */
	CY_FX_EP_BULK_VIDEO_PKTS_COUNT-1, /* Max number of packets per burst: CY_FX_EP_BULK_VIDEO_PKTS_COUNT */
	0x00,                           /* Attribute: Streams not defined */
	0x00,                           /* No meaning for bulk */
	0x00
};

/* Standard High Speed Configuration Descriptor(USB2.0) */
const uint8_t CyFxUSBHSConfigDscr[] =
{
	/* Configuration Descriptor Type */
	0x09,                           /* Descriptor Size */
	CY_U3P_USB_CONFIG_DESCR,        /* Configuration Descriptor Type */
	0xEB,0x00,                      /* Length of this descriptor and all sub descriptors */
	0x02,                           /* Number of interfaces */
	0x01,                           /* Configuration number */
	0x00,                           /* COnfiguration string index */
	0x80,                           /* Config characteristics - Bus powered */
	0xB4,                           /* Max power consumption of device (in 2mA unit) : 360mA */

	/* Interface Association Descriptor */
	0x08,                           /* Descriptor Size */
	CY_FX_INTF_ASSN_DSCR_TYPE,      /* Interface Association Descr Type: 11 */
	0x00,                           /* I/f number of first VideoControl i/f */
	0x02,                           /* Number of Video i/f */
	0x0E,                           /* CC_VIDEO : Video i/f class code */
	0x03,                           /* SC_VIDEO_INTERFACE_COLLECTION : Subclass code */
	0x00,                           /* Protocol : Not used */
	0x00,                           /* String desc index for interface */

	/* Standard Video Control Interface Descriptor */
	0x09,                           /* Descriptor size */
	CY_U3P_USB_INTRFC_DESCR,        /* Interface Descriptor type */
	0x00,                           /* Interface number */
	0x00,                           /* Alternate setting number */
	0x01,                           /* Number of end points */
	0x0E,                           /* CC_VIDEO : Interface class */
	0x01,                           /* CC_VIDEOCONTROL : Interface sub class */
	0x00,                           /* Interface protocol code */
	0x00,                           /* Interface descriptor string index */

	/* Class specific VC Interface Header Descriptor */
	0x0D,                           /* Descriptor size */
	0x24,                           /* Class Specific I/f Header Descriptor type */
	0x01,                           /* Descriptor Sub type : VC_HEADER */
	0x00,0x01,                      /* Revision of class spec : 1.0 */
	0x50,0x00,                      /* Total Size of class specific descriptors (till Output terminal) */
	0x00,0x36,0x6E,0x01,            /* Clock frequency : 24MHz(Deprecated) */
	0x01,                           /* Number of streaming interfaces */
	0x01,                           /* Video streaming I/f 1 belongs to VC i/f */

	/* Input (Camera) Terminal Descriptor */
	0x12,                           /* Descriptor size */
	0x24,                           /* Class specific interface desc type */
	0x02,                           /* Input Terminal Descriptor type */
	0x01,                           /* ID of this terminal */
	0x01,0x02,                      /* Camera terminal type */
	0x00,                           /* No association terminal */
	0x00,                           /* String desc index : Not used */
	0x00,0x00,                      /* No optical zoom supported */
	0x00,0x00,                      /* No optical zoom supported */
	0x00,0x00,                      /* No optical zoom supported */
	0x03,                           /* Size of controls field for this terminal : 3 bytes */
									/* A bit set to 1 indicates that the mentioned Control is
									 * supported for the video stream in the bmControls field
									 * D0: Scanning Mode
									 * D1: Auto-Exposure Mode
									 * D2: Auto-Exposure Priority
									 * D3: Exposure Time (Absolute)
									 * D4: Exposure Time (Relative)
									 * D5: Focus (Absolute)
									 * D6: Focus (Relative)
									 * D7: Iris (Absolute)
									 * D8: Iris (Relative)
									 * D9: Zoom (Absolute)
									 * D10: Zoom (Relative)
									 * D11: PanTilt (Absolute)
									 * D12: PanTilt (Relative)
									 * D13: Roll (Absolute)
									 * D14: Roll (Relative)
									 * D15: Reserved
									 * D16: Reserved
									 * D17: Focus, Auto
									 * D18: Privacy
									 * D19: Focus, Simple
									 * D20: Window
									 * D21: Region of Interest
									 * D22-D23: Reserved, set to zero
									 */
	0x00,0x00,0x00,                 /* bmControls field of camera terminal: No controls supported */

	/* Processing Unit Descriptor */
	0x0C,                           /* Descriptor size */
	0x24,                           /* Class specific interface desc type */
	0x05,                           /* Processing Unit Descriptor type */
	0x02,                           /* ID of this terminal */
	0x01,                           /* Source ID : 1 : Conencted to input terminal */
	0x00,0x00,                      /* Digital multiplier */
	0x03,                           /* Size of controls field for this terminal : 3 bytes */
									/* A bit set to 1 in the bmControls field indicates that
									 * the mentioned Control is supported for the video stream.
									 * D0: Brightness -> Exposure
									 * D1: Contrast -> Data EEPROM
									 * D2: Hue
									 * D3: Saturation
									 * D4: Sharpness -> White Balance R Gain
									 * D5: Gamma -> White Balance G Gain
									 * D6: White Balance Temperature -> White Balance B Gain
									 * D7: White Balance Component
									 * D8: Backlight Compensation
									 * D9: Gain
									 * D10: Power Line Frequency
									 * D11: Hue, Auto
									 * D12: White Balance Temperature, Auto
									 * D13: White Balance Component, Auto
									 * D14: Digital Multiplier
									 * D15: Digital Multiplier Limit
									 * D16: Analog Video Standard
									 * D17: Analog Video Lock Status
									 * D18: Contrast, Auto
									 * D19-D23: Reserved. Set to zero.
									 */
	0x73,0x13,0x00,                 /* Control supported */
	0x00,                           /* String desc index : Not used */

	/* Extension Unit Descriptor */
	0x1C,                           /* Descriptor size */
	0x24,                           /* Class specific interface desc type */
	0x06,                           /* Extension Unit Descriptor type */
	0x03,                           /* ID of this terminal */
	0xFF,0xFF,0xFF,0xFF,            /* 16 byte GUID */
	0xFF,0xFF,0xFF,0xFF,
	0xFF,0xFF,0xFF,0xFF,
	0xFF,0xFF,0xFF,0xFF,
	0x00,                           /* Number of controls in this terminal */
	0x01,                           /* Number of input pins in this terminal */
	0x02,                           /* Source ID : 2 : Connected to Proc Unit */
	0x03,                           /* Size of controls field for this terminal : 3 bytes */
	0x00,0x00,0x00,                 /* No controls supported */
	0x00,                           /* String desc index : Not used */

	/* Output Terminal Descriptor */
	0x09,                           /* Descriptor size */
	0x24,                           /* Class specific interface desc type */
	0x03,                           /* Output Terminal Descriptor type */
	0x04,                           /* ID of this terminal */
	0x01,0x01,                      /* USB Streaming terminal type */
	0x00,                           /* No association terminal */
	0x03,                           /* Source ID : 3 : Connected to Extn Unit */
	0x00,                           /* String desc index : Not used */

	/* Video Control Status Interrupt Endpoint Descriptor */
	0x07,                           /* Descriptor size */
	CY_U3P_USB_ENDPNT_DESCR,        /* Endpoint Descriptor Type */
	CY_FX_EP_CONTROL_STATUS,        /* Endpoint address and description */
	CY_U3P_USB_EP_INTR,             /* Interrupt End point Type */
	0x40,0x00,                      /* Max packet size = 64 bytes */
	0x08,                           /* Servicing interval : 8ms */

	/* Class Specific Interrupt Endpoint Descriptor */
	0x05,                           /* Descriptor size */
	0x25,                           /* Class Specific Endpoint Descriptor Type */
	CY_U3P_USB_EP_INTR,             /* End point Sub Type */
	0x40,0x00,                      /* Max packet size = 64 bytes */

	/* Standard Video Streaming Interface Descriptor (Alternate Setting 0) */
	0x09,                           /* Descriptor size */
	CY_U3P_USB_INTRFC_DESCR,        /* Interface Descriptor type */
	0x01,                           /* Interface number */
	0x00,                           /* Alternate setting number */
	0x01,                           /* Number of end points : Zero Bandwidth */
	0x0E,                           /* Interface class : CC_VIDEO */
	0x02,                           /* Interface sub class : CC_VIDEOSTREAMING */
	0x00,                           /* Interface protocol code : Undefined */
	0x00,                           /* Interface descriptor string index */

   /* Class-specific Video Streaming Input Header Descriptor */
	0x0E,                           /* Descriptor size */
	0x24,                           /* Class-specific VS I/f Type */
	0x01,                           /* Descriptotor Subtype : Input Header */
	0x01,                           /* 1 format desciptor follows */
	0x65,0x00,                      /* Total size of Class specific VS descr: 41 Bytes */
	CY_FX_EP_BULK_VIDEO,            /* EP address for BULK video data */
	0x00,                           /* No dynamic format change supported */
	0x04,                           /* Output terminal ID : 4 */
	0x00,                           /* Still image capture method 1 supported */
	0x00,                           /* Hardware trigger NOT supported */
	0x00,                           /* Hardware to initiate still image capture NOT supported */
	0x01,                           /* Size of controls field : 1 byte */
	0x00,                           /* D2 : Compression quality supported */


   /* Class specific Uncompressed VS format descriptor */
	0x1B,                           /* Descriptor size */
	0x24,                           /* Class-specific VS I/f Type */
	0x04,                           /* Subtype : uncompressed format I/F */
	0x01,                           /* Format desciptor index (only one format is supported) */
	0x02,                           /* number of frame descriptor followed */
	'Y' ,'U' ,'Y' ,'2' ,            /* GUID used to identify streaming-encoding format: YUY2  */
	0x00,0x00,0x10,0x00,
	0x80,0x00,0x00,0xAA,
	0x00,0x38,0x9B,0x71,
	0x10,                           /* Number of bits per pixel used to specify color in the decoded video frame.
									   0 if not applicable: 10 bit per pixel */
	0x01,                           /* Optimum Frame Index for this stream: 1 */
	0x00,                           /* X dimension of the picture aspect ratio: Non-interlaced in progressive scan */
	0x00,                           /* Y dimension of the picture aspect ratio: Non-interlaced in progressive scan*/
	0x00,                           /* Interlace Flags: Progressive scanning, no interlace */
	0x00,                           /* duplication of the video stream restriction: 0 - no restriction */

   /* Class specific Uncompressed VS Frame descriptor: 1280x960@15 */
	0x1E,                           /* Descriptor size */
	0x24,                           /* Descriptor type*/
	0x05,                           /* Subtype: uncompressed frame I/F */
	0x01,                           /* Frame Descriptor Index */
	0x00,                           /* Still image capture method 1 supported, fixed frame rate */
	0x00, 0x05,                     /* Width in pixel */
	0xC0, 0x03,                     /* Height in pixel */
	0x00,0x00,0x94,0x11,            /* Min bit rate bits/s. */
	0x00,0x00,0x94,0x11,            /* Max bit rate bits/s. */
	0x00,0x80,0x25,0x00,            /* Maximum video or still frame size in bytes(Deprecated)*/
	0x2A, 0x2C, 0x0A, 0x00,         /* Default Frame Interval*/
	0x01,							/* Frame interval(Frame Rate) types: Only one frame interval supported */
	0x2A, 0x2C, 0x0A, 0x00,			/* Shortest Frame Interval */

   /* Class specific Uncompressed VS Frame descriptor: 640x480@30 */
	0x1E,                           /* Descriptor size */
	0x24,                           /* Descriptor type*/
	0x05,                           /* Subtype: uncompressed frame I/F */
	0x02,                           /* Frame Descriptor Index */
	0x00,                           /* Still image capture method 1 supported, fixed frame rate */
	0x80,0x02,                      /* Width in pixel */
	0xE0,0x01,                      /* Height in pixel */
	0x00,0x00,0x94,0x11,            /* Min bit rate bits/s. */
	0x00,0x00,0x94,0x11,            /* Max bit rate bits/s. */
	0x00,0x60,0x09,0x00,            /* Maximum video or still frame size in bytes(Deprecated) */
	0x15, 0x16, 0x05, 0x00,         /* Default Frame Interval */
	0x01,							/* Frame interval(Frame Rate) types: Only one frame interval supported */
	0x15, 0x16, 0x05, 0x00,			/* Shortest Frame Interval */

	/* Endpoint Descriptor for BULK Streaming Video Data */
	0x07,                           /* Descriptor size */
	CY_U3P_USB_ENDPNT_DESCR,        /* Endpoint Descriptor Type */
	CY_FX_EP_BULK_VIDEO,            /* Endpoint address and description */
	0x02,                           /* BULK End point */
	CY_FX_EP_BULK_VIDEO_PKT_SIZE_L, /* EP MaxPcktSize: 512B */
	(CY_FX_EP_BULK_VIDEO_PKT_SIZE_H >> 1), /* EP MaxPcktSize: 512B */
	0x01                            /* Servicing interval for data transfers */
};

/* Standard Full Speed Configuration Descriptor(None) */
const uint8_t CyFxUSBFSConfigDscr[] =
{
	/* Configuration Descriptor Type */
	0x09,                           /* Descriptor Size */
	CY_U3P_USB_CONFIG_DESCR,        /* Configuration Descriptor Type */
	0x09,0x00,                      /* Length of this descriptor and all sub descriptors */
	0x00,                           /* Number of interfaces */
	0x01,                           /* Configuration number */
	0x00,                           /* Configuration strizng index */
	0x80,                           /* Config characteristics - Bus powered */
	0x32,                           /* Max power consumption of device (in 2mA unit) : 100mA */
};

