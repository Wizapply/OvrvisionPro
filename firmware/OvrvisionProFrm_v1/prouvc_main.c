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
 *  Files : prouvc_main.c
 *
***************************************************************************/

#include <cyu3system.h>
#include <cyu3os.h>
#include <cyu3dma.h>
#include <cyu3error.h>
#include <cyu3usb.h>
#include <cyu3uart.h>
#include <cyu3gpif.h>
#include <cyu3i2c.h>
#include <cyu3gpio.h>
#include <cyu3pib.h>
#include <cyu3utils.h>

#include "prouvc_main.h"
#include "ov5653_sensor.h"		// OV5653 sensor
#include "eeprom_data.h"		// EEPROM User data
#include "cyfxgpif2config.h"	// GPIF program design
//#include "gpio_test_pcd8544.h"

////////////////////// Global Variables //////////////////////

static CyU3PThread   uvcAppThread;                      /* UVC video streaming thread. */
static CyU3PThread   uvcAppEP0Thread;                   /* UVC control request handling thread. */
static CyU3PEvent    glFxUVCEvent;                      /* Event group used to signal threads. */
CyU3PDmaMultiChannel glChHandleUVCStream;               /* DMA multi-channel handle. */

/* Current UVC control request fields. See USB specification for definition. */
uint8_t  bmReqType, bRequest;                           /* bmReqType and bRequest fields. */
uint16_t wValue, wIndex, wLength;                       /* wValue, wIndex and wLength fields. */

CyBool_t        isUsbConnected = CyFalse;               /* Whether USB connection is active. */
CyU3PUSBSpeed_t usbSpeed = CY_U3P_NOT_CONNECTED;        /* Current USB connection speed. */
CyBool_t        glClearFeatureRqtReceived = CyFalse;    /* Whether a CLEAR_FEATURE (stop streaming) request has been received. */
CyBool_t        glStreamingStarted = CyFalse;           /* Whether USB host has started streaming data */

/* UVC Probe Control Settings for a USB connection. */
uint8_t glProbeCtrl[CY_FX_UVC_MAX_PROBE_SETTING] = {
    0x00, 0x00,                 /* bmHint : no hit */
    0x01,                       /* Use 1st Video format index */
    0x01,                       /* Use 1st Video frame index */
    0x00, 0x00, 0x00, 0x00,     /* Desired frame interval in the unit of 100ns*/
    0x00, 0x00,                 /* Key frame rate in key frame/video frame units: only applicable
                                   to video streaming with adjustable compression parameters */
    0x00, 0x00,                 /* PFrame rate in PFrame / key frame units: only applicable to
                                   video streaming with adjustable compression parameters */
    0x00, 0x00,                 /* Compression quality control: only applicable to video streaming
                                   with adjustable compression parameters */
    0x00, 0x00,                 /* Window size for average bit rate: only applicable to video
                                   streaming with adjustable compression parameters */
    0x00, 0x00,                 /* Internal video streaming i/f latency in ms */
    0x00, 0x00, 0x96, 0x00,     /* Max video frame size in bytes */
    0x00, 0x40, 0x00, 0x00      /* No. of bytes device can rx in single payload = 16 KB */
};

/* Video Probe Commit Control. This array is filled out when the host sends down the SET_CUR request. */
static uint8_t glCommitCtrl[CY_FX_UVC_MAX_PROBE_SETTING_ALIGNED];

/* Scratch buffer used for handling UVC class requests with a data phase. */
static uint8_t glEp0Buffer[64] __attribute__ ((aligned (64)));

/* UVC Header to be prefixed at the top of each 16 KB video data buffer. */
uint8_t volatile glUVCHeader[CY_FX_UVC_MAX_HEADER] =
{
    0x0C,                               /* Header Length */
    0x8C,                               /* Bit field header field */
    0x00, 0x00, 0x00, 0x00,             /* Presentation time stamp field */
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00  /* Source clock reference field */
};

volatile static CyBool_t glHitFV = CyFalse;               /* Whether end of frame (FV) signal has been hit. */
volatile static CyBool_t glGpif_initialized = CyFalse;    /* Whether the GPIF init function has been called. */
volatile static int32_t glDmaCount = 0;                   /* Count of buffers received and committed during the current video frame. */
volatile static int32_t glWDTCount = 0;                   /* Watch doc timer */

//Define
#define CY_FX_USB_UVC_SET_REQ_TYPE      (uint8_t)(0x21)         /* UVC Interface SET Request Type */
#define CY_FX_USB_UVC_GET_REQ_TYPE      (uint8_t)(0xA1)         /* UVC Interface GET Request Type */
#define CY_FX_USB_UVC_GET_CUR_REQ       (uint8_t)(0x81)         /* UVC GET_CUR Request */
#define CY_FX_USB_UVC_SET_CUR_REQ       (uint8_t)(0x01)         /* UVC SET_CUR Request */
#define CY_FX_USB_UVC_GET_MIN_REQ       (uint8_t)(0x82)         /* UVC GET_MIN Request */
#define CY_FX_USB_UVC_GET_MAX_REQ       (uint8_t)(0x83)         /* UVC GET_MAX Request */
#define CY_FX_USB_UVC_GET_RES_REQ       (uint8_t)(0x84)         /* UVC GET_RES Request */
#define CY_FX_USB_UVC_GET_LEN_REQ       (uint8_t)(0x85)         /* UVC GET_LEN Request */
#define CY_FX_USB_UVC_GET_INFO_REQ      (uint8_t)(0x86)         /* UVC GET_INFO Request */
#define CY_FX_USB_UVC_GET_DEF_REQ       (uint8_t)(0x87)         /* UVC GET_DEF Request */

#define CY_FX_UVC_STREAM_INTERFACE      (uint8_t)(1)            /* Streaming Interface : Alternate Setting 1 */
#define CY_FX_UVC_CONTROL_INTERFACE     (uint8_t)(0)            /* Control Interface */
#define CY_FX_UVC_PROBE_CTRL            (uint16_t)(0x0100)      /* wValue setting used to access PROBE control. */
#define CY_FX_UVC_COMMIT_CTRL           (uint16_t)(0x0200)      /* wValue setting used to access COMMIT control. */
#define CY_FX_UVC_INTERFACE_CTRL        (uint8_t)(0)            /* wIndex value used to select UVC interface control. */
#define CY_FX_UVC_CAMERA_TERMINAL_ID    (uint8_t)(1)            /* wIndex value used to select Camera terminal. */
#define CY_FX_UVC_PROCESSING_UNIT_ID    (uint8_t)(2)            /* wIndex value used to select Processing Unit. */
#define CY_FX_UVC_EXTENSION_UNIT_ID     (uint8_t)(3)            /* wIndex value used to select Extension Unit. */

//Events Define
#define CY_FX_UVC_STREAM_EVENT                  (1 << 0)
#define CY_FX_UVC_STREAM_ABORT_EVENT            (1 << 1)
#define CY_FX_UVC_VIDEO_CONTROL_REQUEST_EVENT   (1 << 2)
#define CY_FX_UVC_VIDEO_STREAM_REQUEST_EVENT    (1 << 3)

#define DEBUG_DMAERROR_OUTPUT (0)

////////////////////// Functions //////////////////////

//UVC Application Error Handler
static void UVCAppErrorHandler (CyU3PReturnStatus_t apiRetStatus)
{
	//Error stop
    for (;;)
    {
        CyU3PThreadSleep (100);
    }
}

static void UVCApplnAbortHandler (void)
{
	uint32_t flag;
	if (CyU3PEventGet (&glFxUVCEvent, CY_FX_UVC_STREAM_EVENT, CYU3P_EVENT_AND, &flag,CYU3P_NO_WAIT) == CY_U3P_SUCCESS)
	{
        /* Clear the Video Stream Request Event */
        CyU3PEventSet (&glFxUVCEvent, ~(CY_FX_UVC_STREAM_EVENT), CYU3P_EVENT_AND);
        /* Set Video Stream Abort Event */
        CyU3PEventSet (&glFxUVCEvent, CY_FX_UVC_STREAM_ABORT_EVENT, CYU3P_EVENT_OR);
	}
}

// Callback Functions
/* GpifCB callback function is invoked when FV triggers GPIF interrupt */
static void UVCFxGpifCB (CyU3PGpifEventType event, uint8_t currentState)
{
    if (event == CYU3P_GPIF_EVT_SM_INTERRUPT)
    {
        CyU3PReturnStatus_t apiRetStatus = CY_U3P_SUCCESS;
        glHitFV = CyTrue; /* Flag is reset to indicate that the partial buffer was committed to USB */

        /* Verify that the current state is a terminal state for the GPIF state machine. */
        switch (currentState)
        {
			/* We have a partial buffer. Commit the buffer manually. The Wrap Up API, here, helps produce a
			   partially filled buffer on the producer side. This action will cause CyU3PDmaMultiChannelGetBuffer API
			   in the UVCAppThread_Entry function to succeed one more time with less than full producer buffer count */
            case PARTIAL_BUF_IN_SCK0:
            	apiRetStatus = CyU3PDmaMultiChannelSetWrapUp (&glChHandleUVCStream, 0);
            	if(apiRetStatus != CY_U3P_SUCCESS) {/*nothing*/}
                break;
            case PARTIAL_BUF_IN_SCK1:
            	apiRetStatus = CyU3PDmaMultiChannelSetWrapUp (&glChHandleUVCStream, 1);
            	if(apiRetStatus != CY_U3P_SUCCESS) {/*nothing*/}
                break;
            case FULL_BUF_IN_SCK0:
            case FULL_BUF_IN_SCK1:
                /* Buffer is already full and would have been committed. Do nothing. */
                break;
            default:
                break;
        }
    }
}

static CyBool_t UVCApplnUSBSetupCB (uint32_t setupdat0, uint32_t setupdat1)
{
    CyBool_t uvcHandleReq = CyFalse;
    uint32_t status;

    /* Obtain Request Type and Request */
    bmReqType = (uint8_t)(setupdat0 & CY_FX_USB_SETUP_REQ_TYPE_MASK);
    bRequest  = (uint8_t)((setupdat0 & CY_FX_USB_SETUP_REQ_MASK) >> 8);
    wValue    = (uint16_t)((setupdat0 & CY_FX_USB_SETUP_VALUE_MASK) >> 16);
    wIndex    = (uint16_t)(setupdat1 & CY_FX_USB_SETUP_INDEX_MASK);
    wLength   = (uint16_t)((setupdat1 & CY_FX_USB_SETUP_LENGTH_MASK) >> 16);

    /*
    PCD8544_Clear();
    PCD8544_GotoXY(0,0);
    PCD8544_UINT32(bmReqType,5);
    PCD8544_GotoXY(0,1);
    PCD8544_UINT32(bRequest,5);
    PCD8544_GotoXY(0,2);
    PCD8544_UINT32(wValue,5);
    PCD8544_GotoXY(0,3);
    PCD8544_UINT32(wIndex,5);
    PCD8544_GotoXY(0,4);
    PCD8544_UINT32(wLength,5);
    PCD8544_GotoXY(0,5);
    PCD8544_UINT32(++g_updatetime,8);
    */

    /* Check for UVC Class Requests */
    switch (bmReqType)
    {
        case CY_FX_USB_UVC_GET_REQ_TYPE:
        case CY_FX_USB_UVC_SET_REQ_TYPE:
            /* UVC Specific requests are handled in the EP0 thread. */
            switch (wIndex & 0xFF)
            {
                case CY_FX_UVC_CONTROL_INTERFACE:
                    {
                        uvcHandleReq = CyTrue;
                        status = CyU3PEventSet (&glFxUVCEvent, CY_FX_UVC_VIDEO_CONTROL_REQUEST_EVENT, CYU3P_EVENT_OR);
                        if (status != CY_U3P_SUCCESS)
                            CyU3PUsbStall (0, CyTrue, CyFalse);
                    }
                    break;
                case CY_FX_UVC_STREAM_INTERFACE:
                    {
                        uvcHandleReq = CyTrue;
                        status = CyU3PEventSet (&glFxUVCEvent, CY_FX_UVC_VIDEO_STREAM_REQUEST_EVENT, CYU3P_EVENT_OR);
                        if (status != CY_U3P_SUCCESS)
                            CyU3PUsbStall (0, CyTrue, CyFalse);
                    }
                    break;
                default:
                    break;
            }
            break;

        case CY_FX_USB_SET_INTF_REQ_TYPE:
            if (bRequest == CY_FX_USB_SET_INTERFACE_REQ)
            {
            	/* MAC OS sends Set Interface Alternate Setting 0 command after
            	 * stopping to stream. This application needs to stop streaming. */
                if ((wIndex == CY_FX_UVC_STREAM_INTERFACE) && (wValue == 0))
                {
                	/* Stop GPIF state machine to stop data transfers through FX3 */
                    CyU3PGpifDisable (CyTrue);
                    glGpif_initialized = CyFalse;
                    glStreamingStarted = CyFalse;

                    /* Place the EP in NAK mode before cleaning up the pipe. */
                    CyU3PUsbSetEpNak (CY_FX_EP_BULK_VIDEO, CyTrue);
                    CyU3PBusyWait (100);

                    /* Reset and flush the endpoint pipe. */
                    CyU3PDmaMultiChannelReset (&glChHandleUVCStream);
                    CyU3PUsbFlushEp (CY_FX_EP_BULK_VIDEO);
                    CyU3PUsbSetEpNak (CY_FX_EP_BULK_VIDEO, CyFalse);
                    CyU3PBusyWait (200);

                    /* Clear the stall condition and sequence numbers. */
                    CyU3PUsbStall (CY_FX_EP_BULK_VIDEO, CyFalse, CyTrue);

                    uvcHandleReq = CyTrue;
                    /* Complete Control request handshake */
                    CyU3PUsbAckSetup ();
                    /* Indicate stop streaming to main thread */
                    glClearFeatureRqtReceived = CyTrue;
                    UVCApplnAbortHandler();
                }
            }
            break;
        case CY_U3P_USB_TARGET_ENDPT:
            if (bRequest == CY_U3P_USB_SC_CLEAR_FEATURE)
            {
                if (wIndex == CY_FX_EP_BULK_VIDEO)
                {
                	/* Windows OS sends Clear Feature Request after it stops streaming,
                	 * however MAC OS sends clear feature request right after it sends a
                	 * Commit -> SET_CUR request. Hence, stop streaming only of streaming
                	 * has started. */
                    if (glStreamingStarted == CyTrue)
                    {
                        /* Disable the GPIF state machine. */
                        CyU3PGpifDisable (CyTrue);
                        glGpif_initialized = CyFalse;
                        glStreamingStarted = CyFalse;

                        /* Place the EP in NAK mode before cleaning up the pipe. */
                        CyU3PUsbSetEpNak (CY_FX_EP_BULK_VIDEO, CyTrue);
                        CyU3PBusyWait (100);

                        /* Reset and flush the endpoint pipe. */
                        CyU3PDmaMultiChannelReset (&glChHandleUVCStream);
                        CyU3PUsbFlushEp (CY_FX_EP_BULK_VIDEO);
                        CyU3PUsbSetEpNak (CY_FX_EP_BULK_VIDEO, CyFalse);
                        CyU3PBusyWait (200);

                        /* Clear the stall condition and sequence numbers. */
                        CyU3PUsbStall (CY_FX_EP_BULK_VIDEO, CyFalse, CyTrue);

                        uvcHandleReq = CyTrue;
                        /* Complete Control request handshake */
                        CyU3PUsbAckSetup ();
                        /* Indicate stop streaming to main thread */
                        glClearFeatureRqtReceived = CyTrue;
                        UVCApplnAbortHandler();
                    }
                    else
                    {
                        uvcHandleReq = CyTrue;
                        CyU3PUsbAckSetup ();
                    }
                }
            }
            break;
        default:
            break;
    }

    /* Return status of request handling to the USB driver */
    return uvcHandleReq;
}

/* This is the Callback function to handle the USB Events */
static void UVCApplnUSBEventCB (CyU3PUsbEventType_t evtype, uint16_t evdata)
{
    switch (evtype)
    {
        case CY_U3P_USB_EVENT_RESET:
            CyU3PGpifDisable (CyTrue);
            glGpif_initialized = CyFalse;
            glStreamingStarted = CyFalse;
            UVCApplnAbortHandler();
            break;
        case CY_U3P_USB_EVENT_SUSPEND:
            CyU3PGpifDisable (CyTrue);
            glGpif_initialized = CyFalse;
            glStreamingStarted = CyFalse;
            UVCApplnAbortHandler();
            break;
        case CY_U3P_USB_EVENT_DISCONNECT:
            CyU3PGpifDisable (CyTrue);
            glGpif_initialized = CyFalse;
            isUsbConnected = CyFalse;
            glStreamingStarted = CyFalse;
            UVCApplnAbortHandler();
            break;
        default:
            break;
    }
}

/* Callback for LPM requests. Always return true to allow host to transition device
 * into required LPM state U1/U2/U3. When data transmission is active LPM management
 * is explicitly disabled to prevent data transmission errors.
 */
static CyBool_t UVCApplnLPMRqtCB (CyU3PUsbLinkPowerMode link_mode)          /* USB 3.0 linkmode requested by Host */
{
    return CyTrue;
}

/* DMA callback providing notification when each buffer has been sent out to the USB host.
 * This is used to track whether all of the data has been sent out.
 */
void UvcApplnDmaCallback (CyU3PDmaMultiChannel *multiChHandle, CyU3PDmaCbType_t type, CyU3PDmaCBInput_t *input)
{
    if(type & CY_U3P_DMA_CB_PROD_EVENT)
    {
        CyU3PDmaBuffer_t    produced_buffer;
        CyU3PReturnStatus_t apiRetStatus;

		/* Check if we have a buffer ready to go. */
		apiRetStatus = CyU3PDmaMultiChannelGetBuffer (multiChHandle, &produced_buffer, CYU3P_NO_WAIT);
		while(apiRetStatus == CY_U3P_SUCCESS)
		{
			CyU3PMemCopy (produced_buffer.buffer - CY_FX_UVC_MAX_HEADER, (uint8_t *)glUVCHeader, CY_FX_UVC_MAX_HEADER);
			if ((produced_buffer.count < CY_FX_UVC_BUF_FULL_SIZE)) {
				(produced_buffer.buffer - CY_FX_UVC_MAX_HEADER)[1] |= 0x02; //EOF
			}

			/* Commit the updated DMA buffer to the USB endpoint. */
			apiRetStatus = CyU3PDmaMultiChannelCommitBuffer (multiChHandle, produced_buffer.count + CY_FX_UVC_MAX_HEADER, 0);
			if (apiRetStatus == CY_U3P_SUCCESS)
				glDmaCount++;
			else {
				glUVCHeader[1] |= 0x40;	 /* UVC header ERROR bit */
#if DEBUG_DMAERROR_OUTPUT
				CyU3PGpioSetValue(OVRPRO_GPIO0_PIN, CyTrue);
#endif
				CyU3PDmaMultiChannelDiscardBuffer(multiChHandle); //Delete buffer
				break;
			}

			apiRetStatus = CyU3PDmaMultiChannelGetBuffer (multiChHandle, &produced_buffer, CYU3P_NO_WAIT);
		}
    }

    if (type & CY_U3P_DMA_CB_CONS_EVENT)
    {
    	glDmaCount--;
        glStreamingStarted = CyTrue;
    }
}

/* This function initializes the USB Module, creates event group,
   sets the enumeration descriptors, configures the Endpoints and
   configures the DMA module for the UVC Application */
static void UVCApplnInit (void)
{
    CyU3PDmaMultiChannelConfig_t dmaMultiConfig;
    CyU3PEpConfig_t              endPointConfig;
    CyU3PReturnStatus_t          apiRetStatus;
    CyU3PGpioClock_t             gpioClock;
    CyU3PGpioSimpleConfig_t      gpioConfig;
    CyU3PPibClock_t              pibclock;

    isUsbConnected = CyFalse;
    glClearFeatureRqtReceived = CyFalse;

    /* Init the GPIO module */
    gpioClock.fastClkDiv = 2;
    gpioClock.slowClkDiv = 2;
    gpioClock.simpleDiv  = CY_U3P_GPIO_SIMPLE_DIV_BY_2;
    gpioClock.clkSrc     = CY_U3P_SYS_CLK;
    gpioClock.halfDiv    = 0;

    /* Initialize GPIO interface */
    apiRetStatus = CyU3PGpioInit (&gpioClock, NULL);
    if (apiRetStatus != 0)
    	UVCAppErrorHandler (apiRetStatus);

    /* GPIO pins are restricted and cannot be configured using I/O matrix configuration function, must use GpioOverride to configure it */
    apiRetStatus = CyU3PDeviceGpioOverride (OVRPRO_GPIO0_PIN, CyTrue);
    if (apiRetStatus != 0) UVCAppErrorHandler (apiRetStatus);
    apiRetStatus = CyU3PDeviceGpioOverride (OVRPRO_GPIO1_PIN, CyTrue);
    if (apiRetStatus != 0) UVCAppErrorHandler (apiRetStatus);
    apiRetStatus = CyU3PDeviceGpioOverride (OVRPRO_GPIO2_PIN, CyTrue);
    if (apiRetStatus != 0) UVCAppErrorHandler (apiRetStatus);
    apiRetStatus = CyU3PDeviceGpioOverride (OVRPRO_GPIO3_PIN, CyTrue);
    if (apiRetStatus != 0) UVCAppErrorHandler (apiRetStatus);
    apiRetStatus = CyU3PDeviceGpioOverride (OVRPRO_OVRESET_PIN, CyTrue);
    if (apiRetStatus != 0) UVCAppErrorHandler (apiRetStatus);

    /* GPIO_PIN is the Sensor reset pin */
    gpioConfig.outValue    = CyFalse;
    gpioConfig.driveLowEn  = CyTrue;
    gpioConfig.driveHighEn = CyTrue;
    gpioConfig.inputEn     = CyFalse;
    gpioConfig.intrMode    = CY_U3P_GPIO_NO_INTR;

    apiRetStatus           = CyU3PGpioSetSimpleConfig (OVRPRO_GPIO0_PIN, &gpioConfig);
    if (apiRetStatus != CY_U3P_SUCCESS) UVCAppErrorHandler (apiRetStatus);
    apiRetStatus           = CyU3PGpioSetSimpleConfig (OVRPRO_GPIO1_PIN, &gpioConfig);
    if (apiRetStatus != CY_U3P_SUCCESS) UVCAppErrorHandler (apiRetStatus);
    apiRetStatus           = CyU3PGpioSetSimpleConfig (OVRPRO_GPIO2_PIN, &gpioConfig);
    if (apiRetStatus != CY_U3P_SUCCESS) UVCAppErrorHandler (apiRetStatus);
    apiRetStatus           = CyU3PGpioSetSimpleConfig (OVRPRO_GPIO3_PIN, &gpioConfig);
    if (apiRetStatus != CY_U3P_SUCCESS) UVCAppErrorHandler (apiRetStatus);
    apiRetStatus           = CyU3PGpioSetSimpleConfig (OVRPRO_OVRESET_PIN, &gpioConfig);
    if (apiRetStatus != CY_U3P_SUCCESS) UVCAppErrorHandler (apiRetStatus);
    //How to use : Drive the GPIO high to bring the sensor out.
    //CyU3PGpioSetValue(OVRPRO_GPIO0_PIN, CyTrue);
    //CyU3PGpioSimpleSetValue(OVRPRO_GPIO0_PIN, CyTrue);

    /* Initialize the P-port. */
    pibclock.clkDiv      = 2;
    pibclock.clkSrc      = CY_U3P_SYS_CLK;
    pibclock.isDllEnable = CyFalse;
    pibclock.isHalfDiv   = CyFalse;
    apiRetStatus = CyU3PPibInit (CyTrue, &pibclock);
    if (apiRetStatus != CY_U3P_SUCCESS)
    	UVCAppErrorHandler (apiRetStatus);

    /* Setup the Callback to Handle the GPIF INTR event */
    CyU3PGpifRegisterCallback (UVCFxGpifCB);

    /* Image sensor initialization. Reset and then initialize with appropriate configuration. */
    apiRetStatus = OV5653SensorInit();
    if (apiRetStatus != CY_U3P_SUCCESS)
       UVCAppErrorHandler (apiRetStatus);

    /* EEPROM Load and initialization */
    LoadInitUserData_EEPROMtoRAM();

    /* USB initialization. */
    apiRetStatus = CyU3PUsbStart ();
    if (apiRetStatus != CY_U3P_SUCCESS)
    	UVCAppErrorHandler (apiRetStatus);

    /* Setup the Callback to Handle the USB Setup Requests */
    CyU3PUsbRegisterSetupCallback (UVCApplnUSBSetupCB, CyTrue);

    /* Setup the Callback to Handle the USB Events */
    CyU3PUsbRegisterEventCallback (UVCApplnUSBEventCB);

    /* Register a callback to handle LPM requests from the USB 3.0 host. */
    CyU3PUsbRegisterLPMRequestCallback (UVCApplnLPMRqtCB);

    /* Register the USB device descriptors with the driver. */
    CyU3PUsbSetDesc (CY_U3P_USB_SET_HS_DEVICE_DESCR, 0, (uint8_t *)CyFxUSBDeviceDscrHS);
    CyU3PUsbSetDesc (CY_U3P_USB_SET_SS_DEVICE_DESCR, 0, (uint8_t *)CyFxUSBDeviceDscrSS);

    /* BOS and Device qualifier descriptors. */
    CyU3PUsbSetDesc (CY_U3P_USB_SET_DEVQUAL_DESCR, 0, (uint8_t *)CyFxUSBDeviceQualDscr);
    CyU3PUsbSetDesc (CY_U3P_USB_SET_SS_BOS_DESCR, 0, (uint8_t *)CyFxUSBBOSDscr);

    /* Configuration descriptors. */
    CyU3PUsbSetDesc (CY_U3P_USB_SET_HS_CONFIG_DESCR, 0, (uint8_t *)CyFxUSBHSConfigDscr);
    CyU3PUsbSetDesc (CY_U3P_USB_SET_FS_CONFIG_DESCR, 0, (uint8_t *)CyFxUSBFSConfigDscr);
    CyU3PUsbSetDesc (CY_U3P_USB_SET_SS_CONFIG_DESCR, 0, (uint8_t *)CyFxUSBSSConfigDscr);

    /* String Descriptors */
    CyU3PUsbSetDesc (CY_U3P_USB_SET_STRING_DESCR, 0, (uint8_t *)CyFxUSBStringLangIDDscr);
    CyU3PUsbSetDesc (CY_U3P_USB_SET_STRING_DESCR, 1, (uint8_t *)CyFxUSBManufactureDscr);
    CyU3PUsbSetDesc (CY_U3P_USB_SET_STRING_DESCR, 2, (uint8_t *)CyFxUSBProductDscr);

    CyU3PThreadSleep(10);

    /* Configure the video streaming endpoint. */
    endPointConfig.enable   = 1;
    endPointConfig.epType   = CY_U3P_USB_EP_BULK;
    endPointConfig.pcktSize = CY_FX_EP_BULK_VIDEO_PKT_SIZE;
    endPointConfig.isoPkts  = 0;
    endPointConfig.burstLen = CY_FX_EP_BULK_VIDEO_PKTS_COUNT;
    endPointConfig.streams  = 0;
    apiRetStatus = CyU3PSetEpConfig (CY_FX_EP_BULK_VIDEO, &endPointConfig);
    if (apiRetStatus != CY_U3P_SUCCESS)
    	UVCAppErrorHandler (apiRetStatus);

    CyU3PUsbEPSetBurstMode (CY_FX_EP_BULK_VIDEO, CyTrue);
    CyU3PUsbFlushEp(CY_FX_EP_BULK_VIDEO);

    /* Configure the status interrupt endpoint.
       Note: This endpoint is not being used by the application as of now. This can be used in case
       UVC device needs to notify the host about any error conditions. A MANUAL_OUT DMA channel
       can be associated with this endpoint and used to send these data packets.
     */
    endPointConfig.enable   = 1;
    endPointConfig.epType   = CY_U3P_USB_EP_INTR;
    endPointConfig.pcktSize = 64;
    endPointConfig.isoPkts  = 0;
    endPointConfig.streams  = 0;
    endPointConfig.burstLen = 1;
    apiRetStatus = CyU3PSetEpConfig (CY_FX_EP_CONTROL_STATUS, &endPointConfig);
    if (apiRetStatus != CY_U3P_SUCCESS)
    	UVCAppErrorHandler (apiRetStatus);

    /* Create a DMA Manual channel for sending the video data to the USB host. */
    dmaMultiConfig.size           = CY_FX_UVC_STREAM_BUF_SIZE;
    dmaMultiConfig.count          = CY_FX_UVC_STREAM_BUF_COUNT;
    dmaMultiConfig.validSckCount  = 2;
    dmaMultiConfig.prodSckId [0]  = (CyU3PDmaSocketId_t)CY_U3P_PIB_SOCKET_0;
    dmaMultiConfig.prodSckId [1]  = (CyU3PDmaSocketId_t)CY_U3P_PIB_SOCKET_1;
    dmaMultiConfig.consSckId [0]  = (CyU3PDmaSocketId_t)(CY_U3P_UIB_SOCKET_CONS_0 | CY_FX_EP_VIDEO_CONS_SOCKET);
    dmaMultiConfig.prodAvailCount = 0;
    dmaMultiConfig.prodHeader     = CY_FX_UVC_MAX_HEADER;                 /* 12 byte UVC header to be added. */
    dmaMultiConfig.prodFooter     = CY_FX_UVC_MAX_FOOTER;                 /* 4 byte footer to compensate for the 12 byte header. */
    dmaMultiConfig.consHeader     = 0;
    dmaMultiConfig.dmaMode        = CY_U3P_DMA_MODE_BYTE;
    dmaMultiConfig.notification   = CY_U3P_DMA_CB_CONS_EVENT | CY_U3P_DMA_CB_PROD_EVENT;
    dmaMultiConfig.cb             = UvcApplnDmaCallback;
    apiRetStatus = CyU3PDmaMultiChannelCreate (&glChHandleUVCStream, CY_U3P_DMA_TYPE_MANUAL_MANY_TO_ONE, &dmaMultiConfig);
    if (apiRetStatus != CY_U3P_SUCCESS)
    	UVCAppErrorHandler (apiRetStatus);

    CyU3PThreadSleep(10);

   /* Reset the channel: Set to DSCR chain starting point in PORD/CONS SCKT; set DSCR_SIZE field in DSCR memory */
    apiRetStatus = CyU3PDmaMultiChannelReset(&glChHandleUVCStream);
    if (apiRetStatus != CY_U3P_SUCCESS)
        	UVCAppErrorHandler (apiRetStatus);

    /* Enable USB connection from the FX3 device, preferably at USB 3.0 speed. */
    apiRetStatus = CyU3PConnectState (CyTrue, CyTrue);
    if (apiRetStatus != CY_U3P_SUCCESS)
    	UVCAppErrorHandler (apiRetStatus);
    /*
    PCD8544_Initialise();
    PCD8544_Clear();

    PCD8544_GotoXY(0,0);
    PCD8544_String("OvrvisionPro");
    PCD8544_GotoXY(0,1);
    PCD8544_String(" Wizapply");

    PCD8544_GotoXY(0,3);
    PCD8544_String("GPIO Test!");
*/
    //PCD8544_LogoDraw();
}

// UVC Application i2c Init
static void UVCApplnI2CInit (void)
{
    CyU3PI2cConfig_t i2cConfig;
    CyU3PReturnStatus_t status;

    status = CyU3PI2cInit ();
    if (status != CY_U3P_SUCCESS)
        UVCAppErrorHandler (status);

    /*  Set I2C Configuration */
    i2cConfig.bitRate    = 400000;      /*  400 KHz */
    i2cConfig.isDma      = CyFalse;
    i2cConfig.busTimeout = 0xffffffffU;
    i2cConfig.dmaTimeout = 0xffff;
    status = CyU3PI2cSetConfig (&i2cConfig, 0);
    if (CY_U3P_SUCCESS != status)
        UVCAppErrorHandler (status);
}

//UVC Application Entry
void UVCAppThread_Entry (uint32_t input)
{
    CyU3PReturnStatus_t apiRetStatus;
    uint32_t flag;

    /* Initialize the I2C interface */
    UVCApplnI2CInit();
    /* Initialize the UVC Application */
    UVCApplnInit();

    for (;;)
    {
    	//WDT for macos
    	if(glUVCHeader[1] & 0x40) {
    		glWDTCount++;
    		if(glWDTCount >= 120000) {
				UVCApplnUSBSetupCB(CY_U3P_USB_TARGET_ENDPT | (CY_U3P_USB_SC_CLEAR_FEATURE<<8), CY_FX_EP_BULK_VIDEO);	//Reset
    		}
    	}else{
    		glWDTCount = 0;
    	}

    	 /* Waiting for the Video Stream Event */
		if (CyU3PEventGet (&glFxUVCEvent, CY_FX_UVC_STREAM_EVENT, CYU3P_EVENT_AND, &flag, CYU3P_NO_WAIT) == CY_U3P_SUCCESS
				&& glGpif_initialized == CyTrue)
		{
			/* If we have the end of frame signal and all of the committed data (including partial buffer)
			 * has been read by the USB host; we can reset the DMA channel and prepare for the next video frame. */
			if ((glHitFV == CyTrue) && (glDmaCount <= 0))
			{
				glHitFV = CyFalse;

				/* Reset USB EP and DMA Channel */
                CyU3PUsbFlushEp(CY_FX_EP_BULK_VIDEO);

                apiRetStatus = CyU3PDmaMultiChannelReset (&glChHandleUVCStream);
                if (apiRetStatus != CY_U3P_SUCCESS)
                	UVCAppErrorHandler(apiRetStatus);

                /* Start Channel Immediately */
                apiRetStatus = CyU3PDmaMultiChannelSetXfer (&glChHandleUVCStream, 0, 0);
                if (apiRetStatus != CY_U3P_SUCCESS)
                	UVCAppErrorHandler(apiRetStatus);

                glUVCHeader[1] ^= 0x01;	/* Toggle UVC header FRAME ID bit */
                glUVCHeader[1] &= 0xBF;	/* Error bit off */

#if DEBUG_DMAERROR_OUTPUT
				CyU3PGpioSetValue(OVRPRO_GPIO0_PIN, CyFalse);
#endif

				/* Jump to the start state of the GPIF state machine. 257 is used as an
				   arbitrary invalid state (> 255) number. */
                CyU3PGpifSMSwitch (257, 0, 257, 0, 2);
			}
		}
		else
		{
			/* If we have a stream abort request pending. */
			if (CyU3PEventGet (&glFxUVCEvent, CY_FX_UVC_STREAM_ABORT_EVENT, CYU3P_EVENT_AND_CLEAR, &flag, CYU3P_NO_WAIT) == CY_U3P_SUCCESS)
			{
				glDmaCount = 0;
				glWDTCount = 0;
				glHitFV = CyFalse;

#if DEBUG_DMAERROR_OUTPUT
				CyU3PGpioSetValue(OVRPRO_GPIO0_PIN, CyFalse);
#endif

				/* Sensor reset function */
				OV5653SensorReset();

				if (!glClearFeatureRqtReceived)
				{
					apiRetStatus = CyU3PDmaMultiChannelReset (&glChHandleUVCStream);
					if (apiRetStatus != CY_U3P_SUCCESS)
						UVCAppErrorHandler (apiRetStatus);

					/* Flush the Endpoint memory */
					CyU3PUsbFlushEp (CY_FX_EP_BULK_VIDEO);
				}

                glUVCHeader[1] = 0x8C;	//bit Reset

				glClearFeatureRqtReceived = CyFalse;
			}
			else
			{
				/* We are essentially idle at this point. Wait for the reception of a start streaming request. */
				CyU3PEventGet (&glFxUVCEvent, CY_FX_UVC_STREAM_EVENT, CYU3P_EVENT_AND, &flag, CYU3P_WAIT_FOREVER);

				/* Set DMA Channel transfer size, first producer socket */
				apiRetStatus = CyU3PDmaMultiChannelSetXfer (&glChHandleUVCStream, 0, 0);
				if (apiRetStatus != CY_U3P_SUCCESS)
					UVCAppErrorHandler (apiRetStatus);

				/* Initialize gpif configuration and waveform descriptors */
				if (glGpif_initialized == CyFalse)
				{
					/* Load GPIF */
				    apiRetStatus =  CyU3PGpifLoad ((CyU3PGpifConfig_t *) &CyFxGpifConfig);
				    if (apiRetStatus != CY_U3P_SUCCESS)
				    	UVCAppErrorHandler (apiRetStatus);

				    /* Start the state machine from the designated start state. */
				    apiRetStatus = CyU3PGpifSMStart (START, ALPHA_START);
				    if (apiRetStatus != CY_U3P_SUCCESS)
				    	UVCAppErrorHandler (apiRetStatus);

				    glGpif_initialized = CyTrue;
				}
				else
				{
					/* Jump to the start state of the GPIF state machine. 257 is used as an
					   arbitrary invalid state (> 255) number. */
					CyU3PGpifSMSwitch (257, 0, 257, 0, 2);
				}
			}
		}

        /* Allow other ready threads to run before proceeding. */
        CyU3PThreadRelinquish ();
    }
}

//Handler for control requests addressed to the Processing Unit.
static void UVCHandleProcessingUnitRqts(void)
{
    CyU3PReturnStatus_t apiRetStatus = CY_U3P_SUCCESS;
    uint16_t readCount;

    //uint8_t* pEp0Buffer8 = (uint8_t*)&glEp0Buffer[0];	unused
    uint16_t* pEp0Buffer16 = (uint16_t*)&glEp0Buffer[0];

    switch (wValue)
    {
         case OVRPRO_UVC_PU_BRIGHTNESS_CONTROL:	//Brightness
			switch (bRequest)
			{
			  case CY_FX_USB_UVC_GET_LEN_REQ: /* Length of data = 2 byte. */
				  glEp0Buffer[0] = 2;
				  CyU3PUsbSendEP0Data (1, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_CUR_REQ: /* Current value. */
				  (*pEp0Buffer16)= OV5653SensorGetExp();
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_MIN_REQ: /* Minimum */
				  (*pEp0Buffer16)= (uint16_t)0;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_MAX_REQ: /* Maximum */
				  (*pEp0Buffer16)= (uint16_t)0x7FFF;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_RES_REQ: /* Resolution 0.5 line */
				  (*pEp0Buffer16)= (uint16_t)0x0008;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_INFO_REQ: /* Both GET and SET requests are supported, auto modes supported */
				  (*pEp0Buffer16)= (uint16_t)3;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_DEF_REQ: /* Default value */
				  (*pEp0Buffer16)= (uint16_t)16000;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_SET_CUR_REQ: /* Update value */
				  apiRetStatus = CyU3PUsbGetEP0Data (CY_FX_UVC_MAX_PROBE_SETTING_ALIGNED, glEp0Buffer, &readCount);
				  if (apiRetStatus == CY_U3P_SUCCESS)
					  OV5653SensorSetExp((*pEp0Buffer16));
				  break;
			  default: CyU3PUsbStall (0, CyTrue, CyFalse);
				  break;
			 }
             break;
		 case OVRPRO_UVC_PU_GAIN_CONTROL:	//Gain
			switch (bRequest)
			{
			  case CY_FX_USB_UVC_GET_LEN_REQ: /* Length of data = 2 byte. */
				  glEp0Buffer[0] = 2;
				  CyU3PUsbSendEP0Data (1, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_CUR_REQ: /* Current value. */
				  (*pEp0Buffer16)= (uint16_t)OV5653SensorGetGain();
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_MIN_REQ: /* Minimum */
				  (*pEp0Buffer16)= (uint16_t)0;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_MAX_REQ: /* Maximum */
				  (*pEp0Buffer16)= (uint16_t)0x2F;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_RES_REQ: /* Resolution */
				  (*pEp0Buffer16)= (uint16_t)1;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_INFO_REQ: /* Both GET and SET requests are supported, auto modes supported */
				  (*pEp0Buffer16)= (uint16_t)3;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_DEF_REQ: /* Default value */
				  (*pEp0Buffer16)= (uint16_t)8;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_SET_CUR_REQ: /* Update value */
				  apiRetStatus = CyU3PUsbGetEP0Data (CY_FX_UVC_MAX_PROBE_SETTING_ALIGNED, glEp0Buffer, &readCount);
				  if (apiRetStatus == CY_U3P_SUCCESS)
					  OV5653SensorSetGain(glEp0Buffer[0]);
				  break;
			  default: CyU3PUsbStall (0, CyTrue, CyFalse);
				  break;
			 }
			 break;
		 case OVRPRO_UVC_PU_SHARPNESS_CONTROL:	//Sharpness
				switch (bRequest)
				{
				  case CY_FX_USB_UVC_GET_LEN_REQ: /* Length of data = 2 byte. */
					  glEp0Buffer[0] = 2;
					  CyU3PUsbSendEP0Data (1, (uint8_t *)glEp0Buffer);
					  break;
				  case CY_FX_USB_UVC_GET_CUR_REQ: /* Current value. */
					  (*pEp0Buffer16)= OV5653SensorGetRGainWB();
					  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
					  break;
				  case CY_FX_USB_UVC_GET_MIN_REQ: /* Minimum */
					  (*pEp0Buffer16)= (uint16_t)0;
					  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
					  break;
				  case CY_FX_USB_UVC_GET_MAX_REQ: /* Maximum */
					  (*pEp0Buffer16)= (uint16_t)4095;
					  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
					  break;
				  case CY_FX_USB_UVC_GET_RES_REQ: /* Resolution */
					  (*pEp0Buffer16)= (uint16_t)1;
					  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
					  break;
				  case CY_FX_USB_UVC_GET_INFO_REQ: /* Both GET and SET requests are supported, auto modes supported */
					  (*pEp0Buffer16)= (uint16_t)3;
					  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
					  break;
				  case CY_FX_USB_UVC_GET_DEF_REQ: /* Default value */
					  (*pEp0Buffer16)= (uint16_t)1472;
					  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
					  break;
				  case CY_FX_USB_UVC_SET_CUR_REQ: /* Update value */
					  apiRetStatus = CyU3PUsbGetEP0Data (CY_FX_UVC_MAX_PROBE_SETTING_ALIGNED, glEp0Buffer, &readCount);
					  if (apiRetStatus == CY_U3P_SUCCESS)
						  OV5653SensorSetRGainWB((*pEp0Buffer16));
					  break;
				  default: CyU3PUsbStall (0, CyTrue, CyFalse);
					  break;
				}
			break;
		 case OVRPRO_UVC_PU_GAMMA_CONTROL:	//Gamma
			switch (bRequest)
			{
			  case CY_FX_USB_UVC_GET_LEN_REQ: /* Length of data = 2 byte. */
				  glEp0Buffer[0] = 2;
				  CyU3PUsbSendEP0Data (1, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_CUR_REQ: /* Current value. */
				  (*pEp0Buffer16)= OV5653SensorGetGGainWB();
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_MIN_REQ: /* Minimum */
				  (*pEp0Buffer16)= (uint16_t)0;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_MAX_REQ: /* Maximum */
				  (*pEp0Buffer16)= (uint16_t)4095;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_RES_REQ: /* Resolution */
				  (*pEp0Buffer16)= (uint16_t)1;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_INFO_REQ: /* Both GET and SET requests are supported, auto modes supported */
				  (*pEp0Buffer16)= (uint16_t)3;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_DEF_REQ: /* Default value */
				  (*pEp0Buffer16)= (uint16_t)1024;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_SET_CUR_REQ: /* Update value */
				  apiRetStatus = CyU3PUsbGetEP0Data (CY_FX_UVC_MAX_PROBE_SETTING_ALIGNED, glEp0Buffer, &readCount);
				  if (apiRetStatus == CY_U3P_SUCCESS)
					  OV5653SensorSetGGainWB((*pEp0Buffer16));
				  break;
			  default: CyU3PUsbStall (0, CyTrue, CyFalse);
				  break;
			}
			break;
		 case OVRPRO_UVC_PU_WHITE_BALANCE_TEMPERATURE_CONTROL:	//WBT
			switch (bRequest)
			{
			  case CY_FX_USB_UVC_GET_LEN_REQ: /* Length of data = 2 byte. */
				  glEp0Buffer[0] = 2;
				  CyU3PUsbSendEP0Data (1, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_CUR_REQ: /* Current value. */
				  (*pEp0Buffer16)= OV5653SensorGetBGainWB();
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_MIN_REQ: /* Minimum */
				  (*pEp0Buffer16)= (uint16_t)0;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_MAX_REQ: /* Maximum */
				  (*pEp0Buffer16)= (uint16_t)4095;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_RES_REQ: /* Resolution */
				  (*pEp0Buffer16)= (uint16_t)1;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_INFO_REQ: /* Both GET and SET requests are supported, auto modes supported */
				  (*pEp0Buffer16)= (uint16_t)3;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_DEF_REQ: /* Default value */
				  (*pEp0Buffer16)= (uint16_t)1336;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_SET_CUR_REQ: /* Update value */
				  apiRetStatus = CyU3PUsbGetEP0Data (CY_FX_UVC_MAX_PROBE_SETTING_ALIGNED, glEp0Buffer, &readCount);
				  if (apiRetStatus == CY_U3P_SUCCESS)
					  OV5653SensorSetBGainWB((*pEp0Buffer16));
				  break;
			  default: CyU3PUsbStall (0, CyTrue, CyFalse);
				  break;
			}
			break;
		 case OVRPRO_UVC_PU_WHITE_BALANCE_TEMPERATURE_AUTO_CONTROL:	//WBT_Auto
			switch (bRequest)
			{
			  case CY_FX_USB_UVC_GET_LEN_REQ: /* Length of data = 1 byte. */
				  glEp0Buffer[0] = 1;
				  CyU3PUsbSendEP0Data (1, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_CUR_REQ: /* Current value. */
				  glEp0Buffer[0] = OV5653SensorGetWBTAuto ();
				  CyU3PUsbSendEP0Data (1, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_MIN_REQ: /* Minimum  */
				  glEp0Buffer[0] = 0;
				  CyU3PUsbSendEP0Data (1, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_MAX_REQ: /* Maximum */
				  glEp0Buffer[0] = 1;
				  CyU3PUsbSendEP0Data (1, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_RES_REQ: /* Resolution */
				  glEp0Buffer[0] = 1;
				  CyU3PUsbSendEP0Data (1, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_INFO_REQ: /* Both GET and SET requests are supported, auto modes not supported */
				  glEp0Buffer[0] = 3;
				  CyU3PUsbSendEP0Data (1, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_DEF_REQ: /* Default value */
				  glEp0Buffer[0] = 0;
				  CyU3PUsbSendEP0Data (1, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_SET_CUR_REQ: /* Update value. */
				  apiRetStatus = CyU3PUsbGetEP0Data (CY_FX_UVC_MAX_PROBE_SETTING_ALIGNED, glEp0Buffer, &readCount);
				  if (apiRetStatus == CY_U3P_SUCCESS)
					  OV5653SensorSetWBTAuto(glEp0Buffer[0]);
				  break;
			  default: CyU3PUsbStall (0, CyTrue, CyFalse);
				  break;
			}
			break;
		case OVRPRO_UVC_PU_BACKLIGHT_COMPENSATION_CONTROL:	//BLC
			switch (bRequest)
			{
			  case CY_FX_USB_UVC_GET_LEN_REQ: /* Length of data = 2 byte. */
				  glEp0Buffer[0] = 2;
				  CyU3PUsbSendEP0Data (1, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_CUR_REQ: /* Current value. */
				  (*pEp0Buffer16)= OV5653SensorGetBLC();
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_MIN_REQ: /* Minimum */
				  (*pEp0Buffer16)= (uint16_t)0;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_MAX_REQ: /* Maximum */
				  (*pEp0Buffer16)= (uint16_t)1023;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_RES_REQ: /* Resolution */
				  (*pEp0Buffer16)= (uint16_t)1;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_INFO_REQ: /* Both GET and SET requests are supported, auto modes supported */
				  (*pEp0Buffer16)= (uint16_t)3;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_DEF_REQ: /* Default value */
				  (*pEp0Buffer16)= (uint16_t)32;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_SET_CUR_REQ: /* Update value */
				  apiRetStatus = CyU3PUsbGetEP0Data (CY_FX_UVC_MAX_PROBE_SETTING_ALIGNED, glEp0Buffer, &readCount);
				  if (apiRetStatus == CY_U3P_SUCCESS)
					  OV5653SensorSetBLC((*pEp0Buffer16));
				  break;
			  default: CyU3PUsbStall (0, CyTrue, CyFalse);
				  break;
			}
			break;
		case OVRPRO_UVC_PU_CONTRAST_CONTROL:	//Data EEPROM
			switch (bRequest)
			{
			  case CY_FX_USB_UVC_GET_LEN_REQ: /* Length of data = 2 byte. */
				  glEp0Buffer[0] = 2;
				  CyU3PUsbSendEP0Data (1, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_CUR_REQ: /* Current value. */
				  (*pEp0Buffer16)= (uint16_t)GetUserData();
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_MIN_REQ: /* Minimum */
				  (*pEp0Buffer16)= (uint16_t)0;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_MAX_REQ: /* Maximum */
				  (*pEp0Buffer16)= (uint16_t)0x7FFF;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_RES_REQ: /* Resolution */
				  (*pEp0Buffer16)= (uint16_t)1;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_INFO_REQ: /* Both GET and SET requests are supported, auto modes supported */
				  (*pEp0Buffer16)= (uint16_t)3;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_GET_DEF_REQ: /* Default value */
				  (*pEp0Buffer16)= (uint16_t)0;
				  CyU3PUsbSendEP0Data (2, (uint8_t *)glEp0Buffer);
				  break;
			  case CY_FX_USB_UVC_SET_CUR_REQ: /* Update value */
				  apiRetStatus = CyU3PUsbGetEP0Data (CY_FX_UVC_MAX_PROBE_SETTING_ALIGNED, glEp0Buffer, &readCount);
				  if (apiRetStatus == CY_U3P_SUCCESS)
					  UserDataProcessor((*pEp0Buffer16));
				  break;
			  default: CyU3PUsbStall (0, CyTrue, CyFalse);
				  break;
			}
			break;
		default:
			CyU3PUsbStall (0, CyTrue, CyFalse);
			break;
	}
}

// Handler for control requests addressed to the UVC Camera Terminal unit.
static void UVCHandleCameraTerminalRqts(void)
{
    CyU3PReturnStatus_t apiRetStatus = CY_U3P_SUCCESS;
    uint16_t readCount;

    switch (wValue)
    {
		case OVRPRO_UVC_CT_ROLL_ABSOLUTE_CONTROL:	//Roll
			switch (bRequest)
			{
		  	  	case CY_FX_USB_UVC_GET_LEN_REQ: /* Length of data = 1 byte. */
		  	  		glEp0Buffer[0] = 1;
		  	  		CyU3PUsbSendEP0Data (1, (uint8_t *)glEp0Buffer);
		  	  		break;
				case CY_FX_USB_UVC_GET_INFO_REQ: /* Support GET/SET queries. */
					glEp0Buffer[0] = 3;
					CyU3PUsbSendEP0Data (1, (uint8_t *)glEp0Buffer);
					break;
				case CY_FX_USB_UVC_GET_CUR_REQ: /* Current value. */
					glEp0Buffer[0] = OV5653SensorGetCurRoll();
					CyU3PUsbSendEP0Data (1, (uint8_t *)glEp0Buffer);
					break;
				case CY_FX_USB_UVC_GET_MIN_REQ: /* Minimum value. */
					glEp0Buffer[0] = 0;
					CyU3PUsbSendEP0Data (1, (uint8_t *)glEp0Buffer);
					break;
				case CY_FX_USB_UVC_GET_MAX_REQ: /* Maximum value. */
					glEp0Buffer[0] = 3;
					CyU3PUsbSendEP0Data (1, (uint8_t *)glEp0Buffer);
					break;
				case CY_FX_USB_UVC_GET_RES_REQ: /* Resolution. */
					glEp0Buffer[0] = 1;
					CyU3PUsbSendEP0Data (1, (uint8_t *)glEp0Buffer);
					break;
				case CY_FX_USB_UVC_GET_DEF_REQ: /* Default value. */
					glEp0Buffer[0] = 0;
					CyU3PUsbSendEP0Data (1, (uint8_t *)glEp0Buffer);
					break;
				case CY_FX_USB_UVC_SET_CUR_REQ: /* Update value. */
					apiRetStatus = CyU3PUsbGetEP0Data (CY_FX_UVC_MAX_PROBE_SETTING_ALIGNED, glEp0Buffer, &readCount);
					if (apiRetStatus == CY_U3P_SUCCESS)
						OV5653SensorSetModRoll(glEp0Buffer[0]);
					break;
				default: CyU3PUsbStall (0, CyTrue, CyFalse);
					break;
			}
			break;
		default:
			CyU3PUsbStall (0, CyTrue, CyFalse);
			break;
	}
}

// Handler for the video streaming control requests.
static void UVCHandleVideoStreamingRqts(void)
{
    CyU3PReturnStatus_t apiRetStatus = CY_U3P_SUCCESS;
    uint16_t readCount;

    switch (wValue)
    {
        case CY_FX_UVC_PROBE_CTRL:
        case CY_FX_UVC_COMMIT_CTRL:
            switch (bRequest)
            {
                case CY_FX_USB_UVC_GET_INFO_REQ:
                    glEp0Buffer[0] = 3;                /* GET/SET requests are supported. */
                    CyU3PUsbSendEP0Data (1, (uint8_t *)glEp0Buffer);
                    break;
                case CY_FX_USB_UVC_GET_LEN_REQ:
                    glEp0Buffer[0] = CY_FX_UVC_MAX_PROBE_SETTING;
                    CyU3PUsbSendEP0Data (1, (uint8_t *)glEp0Buffer);
                    break;
                case CY_FX_USB_UVC_GET_CUR_REQ:
                case CY_FX_USB_UVC_GET_MIN_REQ:
                case CY_FX_USB_UVC_GET_MAX_REQ:
                case CY_FX_USB_UVC_GET_DEF_REQ: /* There is only one setting per USB speed. */
                    CyU3PUsbSendEP0Data (CY_FX_UVC_MAX_PROBE_SETTING, (uint8_t *)glProbeCtrl);
                    break;
                case CY_FX_USB_UVC_SET_CUR_REQ:
                    apiRetStatus = CyU3PUsbGetEP0Data (CY_FX_UVC_MAX_PROBE_SETTING_ALIGNED, glCommitCtrl, &readCount);
                    if (apiRetStatus == CY_U3P_SUCCESS)
                    {
                        if (readCount > CY_FX_UVC_MAX_PROBE_SETTING)
                        	break;

						/* Copy the relevant settings from the host provided data into the active data structure. */
						glProbeCtrl[2] = glCommitCtrl[2];
						glProbeCtrl[3] = glCommitCtrl[3];
						glProbeCtrl[4] = glCommitCtrl[4];
						glProbeCtrl[5] = glCommitCtrl[5];
						glProbeCtrl[6] = glCommitCtrl[6];
						glProbeCtrl[7] = glCommitCtrl[7];

						glProbeCtrl[18] = glCommitCtrl[18];
						glProbeCtrl[19] = glCommitCtrl[19];
						glProbeCtrl[20] = glCommitCtrl[20];
						glProbeCtrl[21] = glCommitCtrl[21];

						if (wValue == CY_FX_UVC_COMMIT_CTRL)
						{
							unsigned char frameIdx = glCommitCtrl[3];
							if (usbSpeed == CY_U3P_SUPER_SPEED)
								OV5653SensorControl(frameIdx);
							else
								OV5653SensorControl(10 + frameIdx);	//10=Offset

							/* We can start streaming video now. */
							CyU3PEventSet (&glFxUVCEvent, CY_FX_UVC_STREAM_EVENT, CYU3P_EVENT_OR);
						}
                    }
                    break;
                default:
                    CyU3PUsbStall (0, CyTrue, CyFalse);
                    break;
            }
            break;
        default:
            CyU3PUsbStall (0, CyTrue, CyFalse);
            break;
    }
}

//Control Thread
void UVCAppEP0Thread_Entry (uint32_t input)
{
    uint32_t eventMask = (CY_FX_UVC_VIDEO_CONTROL_REQUEST_EVENT | CY_FX_UVC_VIDEO_STREAM_REQUEST_EVENT);
    uint32_t eventFlag;

    for (;;)
    {
    	if (CyU3PEventGet (&glFxUVCEvent, eventMask, CYU3P_EVENT_OR_CLEAR, &eventFlag, CYU3P_WAIT_FOREVER) == CY_U3P_SUCCESS)
		{
    		/* If this is the first request received during this connection, query the connection speed. */
			if (!isUsbConnected)
			{
				usbSpeed = CyU3PUsbGetSpeed();
				if (usbSpeed != CY_U3P_NOT_CONNECTED)
					isUsbConnected = CyTrue;

				/* Disable USB 3.0 LPM while Buffer is being transmitted out*/
				if(usbSpeed == CY_U3P_SUPER_SPEED) {
					CyU3PUsbLPMDisable ();
					CyU3PUsbSetLinkPowerState (CyU3PUsbLPM_U0);
					CyU3PBusyWait (200);
				}
			}

			if (eventFlag & CY_FX_UVC_VIDEO_CONTROL_REQUEST_EVENT)
			{
				switch ((wIndex >> 8))
				{
					case CY_FX_UVC_PROCESSING_UNIT_ID:
						UVCHandleProcessingUnitRqts();
						break;
					case CY_FX_UVC_CAMERA_TERMINAL_ID:
						UVCHandleCameraTerminalRqts();
						break;
					case CY_FX_UVC_EXTENSION_UNIT_ID:
					case CY_FX_UVC_INTERFACE_CTRL:
					default:
						/* Unsupported request. Fail by stalling the control endpoint. */
						CyU3PUsbStall (0, CyTrue, CyFalse);
						break;
				}
			}

			if (eventFlag & CY_FX_UVC_VIDEO_STREAM_REQUEST_EVENT)
			{
				if (wIndex != CY_FX_UVC_STREAM_INTERFACE)
					CyU3PUsbStall (0, CyTrue, CyFalse);
				else
					UVCHandleVideoStreamingRqts();
			}
		}

        /* Allow other ready threads to run. */
        CyU3PThreadRelinquish ();
    }
}


////////////////////// FX3 Call Handler //////////////////////

//First Function Handler
void CyFxApplicationDefine (void)
{
    void *ptr1, *ptr2;
    uint32_t retThrdCreate;
    uint32_t apiRetStatus;

    /* Create UVC event group */
    apiRetStatus = CyU3PEventCreate (&glFxUVCEvent);
    if (apiRetStatus != CY_U3P_SUCCESS)
    	goto fatalErrorHandler;

    /* Allocate the memory for the thread stacks. */
    ptr1 = CyU3PMemAlloc (UVC_APP_THREAD_STACK);
    ptr2 = CyU3PMemAlloc (UVC_APP_EP0_THREAD_STACK);
    if ((ptr1 == 0) || (ptr2 == 0))
        goto fatalErrorHandler;

    /* Create the UVC application thread. */
    retThrdCreate = CyU3PThreadCreate (&uvcAppThread,   /* UVC Thread structure */
            "30:UVC App Thread",                        /* Thread Id and name */
            UVCAppThread_Entry,                         /* UVC Application Thread Entry function */
            0,                                          /* No input parameter to thread */
            ptr1,                                       /* Pointer to the allocated thread stack */
            UVC_APP_THREAD_STACK,                       /* UVC Application Thread stack size */
            UVC_APP_THREAD_PRIORITY,                    /* UVC Application Thread priority */
            UVC_APP_THREAD_PRIORITY,                    /* Threshold value for thread pre-emption. */
            CYU3P_NO_TIME_SLICE,                        /* No time slice for the application thread */
            CYU3P_AUTO_START                            /* Start the Thread immediately */
            );

    if (retThrdCreate != 0) {
        goto fatalErrorHandler;
    }

    CyU3PThreadSleep (10);

    /* Create the control request handling thread. */
    retThrdCreate = CyU3PThreadCreate (&uvcAppEP0Thread,        /* UVC Thread structure */
            "31:UVC App EP0 Thread",                            /* Thread Id and name */
            UVCAppEP0Thread_Entry,                              /* UVC Application EP0 Thread Entry function */
            0,                                                  /* No input parameter to thread */
            ptr2,                                               /* Pointer to the allocated thread stack */
            UVC_APP_EP0_THREAD_STACK,                           /* UVC Application Thread stack size */
            UVC_APP_EP0_THREAD_PRIORITY,                        /* UVC Application Thread priority */
            UVC_APP_EP0_THREAD_PRIORITY,                        /* Threshold value for thread pre-emption. */
            CYU3P_NO_TIME_SLICE,                                /* No time slice for the application thread */
            CYU3P_AUTO_START                                    /* Start the Thread immediately */
            );

    if (retThrdCreate != 0) {
        goto fatalErrorHandler;
    }

    return;

fatalErrorHandler:
    /* Add custom recovery or debug actions here */
    /* Loop indefinitely */
    while (1);
}

/* Main entry point for the C code. We perform device initialization and start
 * the ThreadX RTOS here. */
int main (void)
{
    CyU3PReturnStatus_t apiRetStatus;
    CyU3PIoMatrixConfig_t io_cfg;
    CyU3PSysClockConfig_t clock_cfg;

    clock_cfg.setSysClk400 = CyTrue;
    clock_cfg.cpuClkDiv = 2;
    clock_cfg.dmaClkDiv = 2;
    clock_cfg.mmioClkDiv = 2;
    clock_cfg.useStandbyClk = CyFalse;
    clock_cfg.clkSrc = CY_U3P_SYS_CLK;

    /* Initialize the device */
    apiRetStatus = CyU3PDeviceInit (&clock_cfg);
    if (apiRetStatus != CY_U3P_SUCCESS) {
        goto handle_fatal_error;
    }

    /* Turn on instruction cache to improve firmware performance. Use Release build to improve it further */
    apiRetStatus = CyU3PDeviceCacheControl (CyTrue, CyFalse, CyFalse);

    /* Configure the IO matrix for the device. */
    io_cfg.isDQ32Bit        = CyTrue;
    io_cfg.lppMode          = CY_U3P_IO_MATRIX_LPP_DEFAULT;
    io_cfg.gpioSimpleEn[0]  = 0;
    io_cfg.gpioSimpleEn[1]  = 0;
    io_cfg.gpioComplexEn[0] = 0;
    io_cfg.gpioComplexEn[1] = 0;
    io_cfg.useUart          = CyFalse;
    io_cfg.useI2C           = CyTrue;		/* I2C is used for the sensor interface. */
    io_cfg.useI2S           = CyFalse;
    io_cfg.useSpi           = CyFalse;

    apiRetStatus = CyU3PDeviceConfigureIOMatrix (&io_cfg);
    if (apiRetStatus != CY_U3P_SUCCESS) {
        goto handle_fatal_error;
    }

    /* This is a non returnable call for initializing the RTOS kernel */
    CyU3PKernelEntry ();

    /* Dummy return to make the compiler happy */
    return 0;

handle_fatal_error:
    /* Cannot recover from this error. */
    while (1);
}


