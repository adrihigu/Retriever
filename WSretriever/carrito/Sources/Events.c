/* ###################################################################
**     Filename    : Events.c
**     Project     : carrito
**     Processor   : MCF51QE128CLK
**     Component   : Events
**     Version     : Driver 01.02
**     Compiler    : CodeWarrior ColdFireV1 C Compiler
**     Date/Time   : 2018-05-02, 13:56, # CodeGen: 0
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

unsigned char rxData[100];
unsigned char txData[100];
unsigned short send = 2;
unsigned short i,j;

/* User includes (#include below this line is not maintained by Processor Expert) */

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
	i = 0;
	// Encabezado
	// 1 - 1 - 1 - pwmOK - sensOk - eventOK - camOK - sharpOK
	txData[0] = (1 << 7) + (pwmOK << 6) + (sensOK << 5) + (eventOK << 4) + (camBytes + 1);
	i++;
	// Envio de datos relacionados a los PWM
	// 0 - 0 - M1m - M2m - duty[15-12] || 0 - duty[11-5] || 0 - duty[4-0] - dutySide[15-14] || 0 - dutySide[13-7] || 0 - dutySide[6-0]
	if(pwmOK){
		txData[i] = (0 << 7) + (0 << 6) + (BitM1m_GetVal() << 5) + (BitM2m_GetVal() << 4) + (unsigned char)((duty & 0xF000) >> 12);
		i++;
		txData[i] = (0 << 7) +  (unsigned char)((duty & 0x0FE0) >> 5);
		i++;
		txData[i] = (0 << 7) +  (unsigned char)((duty & 0x001F) << 2) + (unsigned char)((dutySide & 0xC000) >> 14);
		i++;
		txData[i] = (0 << 7) +  (unsigned char)((dutySide & 0x3F80) >> 7);
		i++;
		txData[i] = (0 << 7) +  (unsigned char)(dutySide & 0x007F);
		i++;
		pwmOK = FALSE;
	}

	// Medidas de potenciometro (12b) y pulsadores
	// 0 - Dig4 - Dig3 - Dig2 - Dig1 - 0 - 0 - 0 ||  0 - 0 - 0 - Pot[11-7] || 0 - Pot[6-0]
	if(sensOK){
		txData[i] = (BitsPTD23_GetBit(1) << 6) + (BitsPTD23_GetBit(0) << 5) + (BitsPTA23_GetBit(1) << 4) + (BitsPTA23_GetBit(0) << 3);
		i++;
		txData[i] = (unsigned char)((pot & 0x0F80) >> 7); 
		i++;
		txData[i] = (unsigned char)(pot & 0x007F);
		i++;
		sensOK = FALSE;
	}
	
	// Eventos y estado de la plataforma base
	// 0 - ON - game - E4 - E3 - E2 - E1 - E0
	if(eventOK){
		txData[i] = (0 << 7) + (ON << 6) + (game << 5) + (E4 << 4) + (E3 << 3) + (E2 << 2) + (E1 << 1) + E0;
		i++;
		eventOK = FALSE;
	}
	
	// Primitivas de procesamiento de la camara frontal
	// busy: 1 -> ocupado, 0 -> disponible
	// CK: 1 -> ACK, 0 -> NCK
	// 0 - camOP[7-5] - camPck[4-3] - busy - CK || camRes[0] || ... || camRes[camBytes - 1]
	if(camOK){
		txData[i] = (0 << 7) + ((camOP & 0x07) << 4) + ((camPck & 0x03) << 2) + (busy << 1) + (CK);
		i++;
		for(j = 0; j < camBytes; j++){
			txData[i] = camRes[j] & 0x7F;
			i++;
		}
		camOK = FALSE;
	}

	// Medida infrarojo del sharp
	// 0 - sharpRes[6 - 0]
	if(sharpOK){
		txData[i] = (unsigned char)((sharpRes & 0x0F80) >> 7); 
		i++;
		txData[i] = (unsigned char)(sharpRes & 0x007F);
		i++;
		sharpOK = FALSE;
	}

	ASPC_SendBlock(txData,i,&send);
}

/*
** ===================================================================
**     Event       :  ASPC_OnError (module Events)
**
**     Component   :  ASPC [AsynchroSerial]
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
void  ASPC_OnError(void)
{
  /* Write your code here ... */
}

/*
** ===================================================================
**     Event       :  ASPC_OnRxChar (module Events)
**
**     Component   :  ASPC [AsynchroSerial]
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
void  ASPC_OnRxChar(void)
{
  /* Write your code here ... */
}

/*
** ===================================================================
**     Event       :  ASPC_OnTxChar (module Events)
**
**     Component   :  ASPC [AsynchroSerial]
**     Description :
**         This event is called after a character is transmitted.
**     Parameters  : None
**     Returns     : Nothing
** ===================================================================
*/
void  ASPC_OnTxChar(void)
{
  /* Write your code here ... */
}

/*
** ===================================================================
**     Event       :  ASPC_OnFullRxBuf (module Events)
**
**     Component   :  ASPC [AsynchroSerial]
**     Description :
**         This event is called when the input buffer is full;
**         i.e. after reception of the last character 
**         that was successfully placed into input buffer.
**     Parameters  : None
**     Returns     : Nothing
** ===================================================================
*/
void  ASPC_OnFullRxBuf(void)
{
  /* Write your code here ... */
}

/*
** ===================================================================
**     Event       :  ASPC_OnFreeTxBuf (module Events)
**
**     Component   :  ASPC [AsynchroSerial]
**     Description :
**         This event is called after the last character in output
**         buffer is transmitted.
**     Parameters  : None
**     Returns     : Nothing
** ===================================================================
*/
void  ASPC_OnFreeTxBuf(void)
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
