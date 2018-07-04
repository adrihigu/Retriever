/* ###################################################################
**     Filename    : Events.h
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
** @file Events.h
** @version 01.02
** @brief
**         This is user's event module.
**         Put your event handler code here.
*/         
/*!
**  @addtogroup Events_module Events module documentation
**  @{
*/         

#ifndef __Events_H
#define __Events_H
/* MODULE Events */

#include "PE_Types.h"
#include "PE_Error.h"
#include "PE_Const.h"
#include "IO_Map.h"
#include "PE_Timer.h"
#include "PWM1p.h"
#include "PWM2p.h"
#include "TI1.h"
#include "BitM1m.h"
#include "BitM2m.h"
#include "BitsPTA23.h"
#include "AD1.h"
#include "ASPC.h"
#include "BitsPTD23.h"
#include "BitsPTE67.h"
#include "TI2.h"
#define TRUE 1
#define FALSE 0
#define NORMAL 2
#define ECHO 3

extern unsigned char CodError;
extern bool pwmOK;
extern bool sensOK;
extern bool eventOK;
extern bool camOK;
extern bool camRx;
extern bool sharpOK;
extern signed short duty;
extern signed short dutySide;		// factor de giro
extern signed short dutyFix;
extern bool movRx;
extern bool M1m;
extern bool M2m;

extern unsigned short pot;			// Lectura potenciometro
extern unsigned short sharpRes;

extern unsigned char camOP; 		// Primitiva realizada
extern unsigned char camPck;		// Tipo de paquete del resultado
extern bool busy;					// FALSE si se recibio
extern bool CK;						// TRUE -> ACK; FALSE -> NCK
extern unsigned char camArg[16];		// Argumentos para la instrucción de la cámara
extern unsigned char camRes[16]; 	// Resultado de la operación en ASCII
extern unsigned char camBytes;		// Numero de Bytes del resultado de la camara// 
extern unsigned char arg;				// Numero de Bytes de los argumentos de la camara
extern unsigned char res;	
extern bool ON;						// Encendido del vehiculo
extern bool game;					// 0 = seguir pelota; 1 = competir
extern bool E4;						// Comunicación serial desincronizada
extern bool E3;						// Esperando referencia de colores
extern bool E2;						// Esperando modo de juego
extern bool E1;						// Pelota objetivo OK
extern bool E0;						// Obstaculo desconocido

// Variables de recepción serial
extern bool sync;
extern bool e4Rx;
extern bool e3Rx;
extern bool e2Rx;
extern bool e1Rx;
extern bool e0Rx;
extern bool pwmRx;
extern bool sensRx;

// Control de pruebas
extern unsigned short mode;

// Del serial
extern unsigned char rxData[100];
extern unsigned char txData[100];
extern unsigned short send;
extern unsigned short rcv;
extern unsigned short rxByte;
extern unsigned short k, j, i;

// Time
extern unsigned short msCount;
extern bool waitFlag;
extern bool timeoutFlag;

void AD1_OnEnd(void);
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

void TI1_OnInterrupt(void);
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

void ASPC_OnError(void);
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

void ASPC_OnRxChar(void);
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

void ASPC_OnTxChar(void);
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

void ASPC_OnFullRxBuf(void);
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

void ASPC_OnFreeTxBuf(void);
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

void TI2_OnInterrupt(void);
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

/* END Events */
#endif /* __Events_H*/

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
