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

unsigned char ok[2] = "OK";

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
	// Avisa si no está sincronizado
	if(sync == FALSE){
		BitsPTE67_NegBit(0);
	} else{
		BitsPTE67_SetBit(0);
	}
	
	////////////////////////////
	
	// RUTINA DE TRANSMISION  //
	
	////////////////////////////
	
	i = 0;
	// Encabezado
	// 1 - 1 - 1 - pwmOK - sensOk - eventOK - camOK - sharpOK
	txData[0] = (1 << 7) + (pwmOK << 6) + (sensOK << 5) + (eventOK << 4) + res;
	i++;
	// codificacion de variables de movimiento
	if(pwmOK){
		txData[i] = (unsigned char)((dutySide & 0x0000C000) >> 14);
		i++;
		txData[i] = (unsigned char)((dutySide & 0x00003F80) >> 7);
		i++;
		txData[i] = (unsigned char)(dutySide & 0x0000007F);
		i++;
		txData[i] = (unsigned char)((((M1m) ? 1 : 0) << 3) + (((M2m) ? 1 : 0) << 2) + ((duty & 0x0000C000) >> 14));
		i++;
		txData[i] = (unsigned char)((duty & 0x00003F80) >> 7);
		i++;
		txData[i] = (unsigned char)(duty & 0x0000007F);
		i++;
		txData[i] = (unsigned char)((dutyFix & 0x0000C000) >> 14);
		i++;
		txData[i] = (unsigned char)((dutyFix & 0x00003F80) >> 7);
		i++;
		txData[i] = (unsigned char)(dutyFix & 0x0000007F);
		i++;
		pwmOK = FALSE;
		pwmRx = FALSE;
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
		sensRx = FALSE;
	}
	
	// Eventos y estado de la plataforma base
	// 0 - ON - game - E4 - E3 - E2 - E1 - E0
	if(eventOK){
		txData[i] = (0 << 7) + (ON << 6) + (game << 5) + (sync << 4) + (E3 << 3) + (E2 << 2) + (E1 << 1) + E0;
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
		for(j = 0; j < res; j++){
			txData[i] = camRes[j] & 0x7F;
			i++;
		}
		camOK = FALSE;
	}

	// Medida infrarojo del sharp (12b)
	// 0 - 0 - 0 - sharpRes[11 - 7] || 0 - sharpRes[6 - 0]
	txData[i] = (unsigned char)((sharpRes & 0x0F80) >> 7); 
	i++;
	txData[i] = (unsigned char)(sharpRes & 0x007F);
	i++;
	sharpOK = FALSE;

	ASPC_SendBlock(txData,i,&send);
	
	// Revisa si hay datos en el buffer para recepción serial
	j = ASPC_GetCharsInRxBuf();
	if(j != 0){		// Si los hay, inicia rutina de recepción
		ASPC_OnFullRxBuf();
	}
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
	//////////////////////////
	
	// RUTINA DE RECEPCION  //
	
	//////////////////////////
	
	ASPC_RecvBlock(rxData,j,&send);
	
	rxByte = 1;
	// Comprueba si hay sincronización con el encabezado
	if(rxData[0] & 0x80 != 0x80){
		sync = FALSE;
	}
	else{
		sync = TRUE;
	}
	
	
	// Decodificación del bloque
	if(sync){
		// Prepara envío de parámetros actuales
		if((rxData[0] & 0x40) == 0x40){
			pwmRx = TRUE;
			sensRx = TRUE;
		}
		
		// Decodificación de variables de movimiento
		if((rxData[0] & 0x20) == 0x20){			
			dutySide = (signed short)(((rxData[rxByte] & 0x03) << 14) + ((rxData[rxByte+1] & 0x7F) << 7) + (rxData[rxByte+2] & 0x7F));
			rxByte += 3;
			M1m = ((rxData[rxByte] & 0x08) == 0x08) ? TRUE : FALSE;
			M2m = ((rxData[rxByte] & 0x04) == 0x04) ? TRUE : FALSE;
			duty = (signed short)(((rxData[rxByte] & 0x03) << 14) + ((rxData[rxByte+1] & 0x7F) << 7) + (rxData[rxByte+2] & 0x7F));
			rxByte += 3;
			dutyFix = (signed short)(((rxData[rxByte] & 0x03) << 14) + ((rxData[rxByte+1] & 0x7F) << 7) + (rxData[rxByte+2] & 0x7F));
			rxByte += 3;
			movRx = TRUE;
		}
		
		// Decodifica evento proveniente del PC
		if((rxData[0] & 0x10) == 0x10){				
			ON = ((rxData[rxByte] & 0x40) >> 6);
			game = ((rxData[rxByte] & 0x20) >> 5);
			e4Rx = ((rxData[rxByte] & 0x10) >> 4);
			e3Rx = ((rxData[rxByte] & 0x08) >> 3);
			e2Rx = ((rxData[rxByte] & 0x04) >> 2);
			e1Rx = ((rxData[rxByte] & 0x02) >> 1);
			e0Rx = (rxData[rxByte] & 0x01);
			rxByte++;
		}
		
		// Decodifica instrucción de la cámara
		if((rxData[0] & 0x0F) != 0x00){
			camOP = (rxData[rxByte] & 0x70) >> 4;
			camRx = TRUE;
			rxByte++;
			for(i = 0; i < (rxData[rxByte-1] & 0x0F); i++){
				camArg[i] = rxData[rxByte+i];
			}
			rxByte += i;
		}
	}
	ASPC_ClearRxBuf();
}
/*
* ===================================================================
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
	// ASPC_ClearTxBuf();
  /* Write your code here ... */
}

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
	if(waitFlag || timeoutFlag){
		msCount++;
	} else msCount = 0;
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
