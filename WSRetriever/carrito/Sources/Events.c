/* ###################################################################
**     Filename    : Events.c
**     Project     : carrito_semana_6
**     Processor   : MCF51QE128CLK
**     Component   : Events
**     Version     : Driver 01.02
**     Compiler    : CodeWarrior ColdFireV1 C Compiler
**     Date/Time   : 2018-05-30, 09:03, # CodeGen: 0
**     Abstract    :
**         This is user's event module.
**         Put your event handler code here.
**     Settings    :
**     Contents    :
**         No public methods
**
** ###################################################################*/
/*!
** @file Events.c
** @version 01.02
** @brief
**         This is user's event module.
**         Put your event handler code here.
*/         
/*!
**  @addtogroup Events_module Events module documentation
**  @{
*/         
/* MODULE Events */

#include "Cpu.h"
#include "Events.h"
#include "VALUES.h"

unsigned short i = 1;
unsigned short sharpResMParcial = 0;
/* User includes (#include below this line is not maintained by Processor Expert) */

// variables de tiempo
unsigned short msCount = 0;

// variables de camara
unsigned short camFlag = CAM_IDLE;
unsigned char camRxBuf[CAM_BUFFER_SIZE];
unsigned short camRxBufCount = 0;
/*
** ===================================================================
**     Event       :  TI2_OnInterrupt (module Events)
**
**     Component   :  TI2 [TimerInt]
**     Description :
**         When a timer interrupt occurs this event is called (only
**         when the component is enabled - <Enable> and the events are
**         enabled - <EnableEvent>). This event is enabled only if a
**         <interrupt service/event> is enabled.
**     Parameters  : None
**     Returns     : Nothing
** ===================================================================
*/
void TI2_OnInterrupt(void)
{
  sharpCount++;
  
	if(waitFlag || timeoutFlag){
		msCount++;
	} else msCount = 0;
}

/*
** ===================================================================
**     Event       :  TI1_OnInterrupt (module Events)
**
**     Component   :  TI1 [TimerInt]
**     Description :
**         When a timer interrupt occurs this event is called (only
**         when the component is enabled - <Enable> and the events are
**         enabled - <EnableEvent>). This event is enabled only if a
**         <interrupt service/event> is enabled.
**     Parameters  : None
**     Returns     : Nothing
** ===================================================================
*/
void TI1_OnInterrupt(void)
{
//	if(sharpOK == FALSE ){
//		AD1_Measure(TRUE);
//		AD1_GetChanValue16(0,&sharpRes);
//		sharpRes = (sharpRes & 0xFFF0) >> 4;
//		sharpOK = TRUE;
//	}
//
//	for(;i<MAX_SHARP - 1;i++){
//		sharpResA[i]= sharpResA[i-1];
//		sharpResMParcial += sharpResA[i];
//	}
//	sharpResA[0] = sharpRes;
//	sharpResM = (sharpResMParcial + sharpRes)/MAX_SHARP;
//	i = 1;
//	sharpResMParcial = 0;

}

/*
** ===================================================================
**     Event       :  AD1_OnEnd (module Events)
**
**     Component   :  AD1 [ADC]
**     Description :
**         This event is called after the measurement (which consists
**         of <1 or more conversions>) is/are finished.
**         The event is available only when the <Interrupt
**         service/event> property is enabled.
**     Parameters  : None
**     Returns     : Nothing
** ===================================================================
*/
void AD1_OnEnd(void)
{
  /* Write your code here ... */
}


/*
** ===================================================================
**     Event       :  AS1_OnError (module Events)
**
**     Component   :  AS1 [AsynchroSerial]
**     Description :
**         This event is called when a channel error (not the error
**         returned by a given method) occurs. The errors can be read
**         using <GetError> method.
**         The event is available only when the <Interrupt
**         service/event> property is enabled.
**     Parameters  : None
**     Returns     : Nothing
** ===================================================================
*/
void  AS1_OnError(void)
{
  /* Write your code here ... */
}

/*
** ===================================================================
**     Event       :  AS1_OnRxChar (module Events)
**
**     Component   :  AS1 [AsynchroSerial]
**     Description :
**         This event is called after a correct character is received.
**         The event is available only when the <Interrupt
**         service/event> property is enabled and either the <Receiver>
**         property is enabled or the <SCI output mode> property (if
**         supported) is set to Single-wire mode.
**     Parameters  : None
**     Returns     : Nothing
** ===================================================================
*/
void  AS1_OnRxChar(void)
{
//  AS1_RecvChar(charRcv);
//  if(charRcv[0] == ':'){
//	  AS1_RecvBlock(blockRcv, RCV_MAX_BYTES, &bytesRcv);
//	  AS1_ClearRxBuf();
//  }
}

/*
** ===================================================================
**     Event       :  AS1_OnTxChar (module Events)
**
**     Component   :  AS1 [AsynchroSerial]
**     Description :
**         This event is called after a character is transmitted.
**     Parameters  : None
**     Returns     : Nothing
** ===================================================================
*/
void  AS1_OnTxChar(void)
{
  /* Write your code here ... */
}

/*
** ===================================================================
**     Event       :  AS1_OnFullRxBuf (module Events)
**
**     Component   :  AS1 [AsynchroSerial]
**     Description :
**         This event is called when the input buffer is full;
**         i.e. after reception of the last character 
**         that was successfully placed into input buffer.
**     Parameters  : None
**     Returns     : Nothing
** ===================================================================
*/
void  AS1_OnFullRxBuf(void)
{
  /* Write your code here ... */
}

/*
** ===================================================================
**     Event       :  AS1_OnFreeTxBuf (module Events)
**
**     Component   :  AS1 [AsynchroSerial]
**     Description :
**         This event is called after the last character in output
**         buffer is transmitted.
**     Parameters  : None
**     Returns     : Nothing
** ===================================================================
*/
void  AS1_OnFreeTxBuf(void)
{
  /* Write your code here ... */
}

/*
** ===================================================================
**     Event       :  AS2_OnError (module Events)
**
**     Component   :  AS2 [AsynchroSerial]
**     Description :
**         This event is called when a channel error (not the error
**         returned by a given method) occurs. The errors can be read
**         using <GetError> method.
**         The event is available only when the <Interrupt
**         service/event> property is enabled.
**     Parameters  : None
**     Returns     : Nothing
** ===================================================================
*/
void  AS2_OnError(void)
{
  /* Write your code here ... */
}

/*
** ===================================================================
**     Event       :  AS2_OnRxChar (module Events)
**
**     Component   :  AS2 [AsynchroSerial]
**     Description :
**         This event is called after a correct character is received.
**         The event is available only when the <Interrupt
**         service/event> property is enabled and either the <Receiver>
**         property is enabled or the <SCI output mode> property (if
**         supported) is set to Single-wire mode.
**     Parameters  : None
**     Returns     : Nothing
** ===================================================================
*/
void  AS2_OnRxChar(void)
{
 // unsigned char hehexd = '\0';
 // if(camFlag == CK_PENDING && AS2_GetCharsInRxBuf() == CK_PKT_SIZE){
 //   while(AS2_GetCharsInRxBuf() != 0){
 //    camRxBufCount++;
 //    AS2_RecvChar(camRxBuf+camRxBufCount-1);
 //    hehexd = camRxBuf[camRxBufCount-1];
 //    AS1_SendChar(hehexd);
 //   }
 //   if(camRxBuf[camRxBufCount-1] == ':'){
 //     if(camRxBuf[0] == 'A'){
 //       camFlag = CK_READY;
 //     }else if(rawModeFlag == TRUE){
 //       camFlag = CK_READY;
 //     }else camFlag = CMD_REJECTED;
 //   }
 //   camRxBufCount = 0;
 // }else if(camFlag == RDATA_PENDING && AS2_GetCharsInRxBuf() == RDATA_PKT_SIZE){
 //     camFlag = RDATA_READY;
 // }else if(camFlag == RS_PENDING && AS2_GetCharsInRxBuf() > 5){
 //    // if(AS2_GetCharsInRxBuf() == RS_MSG_SIZE){
 //    //   camFlag = CAM_IDLE;
 //    //   AS2_ClearRxBuf();
 //    // } else if(AS2_GetCharsInRxBuf() == CK_PKT_SIZE){
 //    //   camFlag = CMD_REJECTED;
 //    //   AS2_ClearRxBuf();
 //    // }
 //    camRxBufCount = 0;
 //    while(AS2_GetCharsInRxBuf() != 0){
 //    AS2_RecvChar(&hehexd);
 //    AS1_SendChar(hehexd);
 //   }
 //    AS2_ClearRxBuf();
 // }else if(camRxBufCount >= CAM_BUFFER_SIZE){
 //   camFlag = CAM_IDLE;
 //   camRxBufCount = 0;
 // }
  camRxBufCount++;
  AS2_RecvChar(camRxBuf+camRxBufCount-1);
  if(camRxBuf[camRxBufCount-1] == ':') camFlag = CK_READY;
}

/*
** ===================================================================
**     Event       :  AS2_OnTxChar (module Events)
**
**     Component   :  AS2 [AsynchroSerial]
**     Description :
**         This event is called after a character is transmitted.
**     Parameters  : None
**     Returns     : Nothing
** ===================================================================
*/
void  AS2_OnTxChar(void)
{
  /* Write your code here ... */
}

/*
** ===================================================================
**     Event       :  AS2_OnFullRxBuf (module Events)
**
**     Component   :  AS2 [AsynchroSerial]
**     Description :
**         This event is called when the input buffer is full;
**         i.e. after reception of the last character 
**         that was successfully placed into input buffer.
**     Parameters  : None
**     Returns     : Nothing
** ===================================================================
*/
void  AS2_OnFullRxBuf(void)
{
  /* Write your code here ... */
}

/*
** ===================================================================
**     Event       :  AS2_OnFreeTxBuf (module Events)
**
**     Component   :  AS2 [AsynchroSerial]
**     Description :
**         This event is called after the last character in output
**         buffer is transmitted.
**     Parameters  : None
**     Returns     : Nothing
** ===================================================================
*/
void  AS2_OnFreeTxBuf(void)
{
  /* Write your code here ... */
}

/* END Events */

/*!
** @}
*/
/*
** ###################################################################
**
**     This file was created by Processor Expert 10.3 [05.09]
**     for the Freescale ColdFireV1 series of microcontrollers.
**
** ###################################################################
*/
