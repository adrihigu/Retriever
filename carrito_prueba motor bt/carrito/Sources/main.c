/* ###################################################################
**     Filename    : main.c
**     Project     : carrito
**     Processor   : MCF51QE128CLK
**     Version     : Driver 01.00
**     Compiler    : CodeWarrior ColdFireV1 C Compiler
**     Date/Time   : 2018-05-02, 13:56, # CodeGen: 0
**     Abstract    :
**         Main module.
**         This module contains user's application code.
**     Settings    :
**     Contents    :
**         No public methods
**
** ###################################################################*/
/*!
** @file main.c
** @version 01.00
** @brief
**         Main module.
**         This module contains user's application code.
*/         
/*!
**  @addtogroup main_module main module documentation
**  @{
*/         
/* MODULE main */


/* Including needed modules to compile this module/procedure */
#include "Cpu.h"
#include "Events.h"
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
// #include "moves.h"
/* Include shared modules, which are used for whole project */
#include "PE_Types.h"
#include "PE_Error.h"
#include "PE_Const.h"
#include "IO_Map.h"
#include "MOTOR.h"
#include "TIME.h"
#include "VALUES.h"

/* User includes (#include below this line is not maintained by Processor Expert) */

unsigned char CodError;

// Variables de movimiento
signed short duty = 0x0001;		// Controla movimiento frontal: [0,2^15 -1]
signed short dutySide = 0x0001;	// Controla movimiento lateral: [-duty,duty]
signed short dutyFix = 0x0001; // Compensa la rueda izquierda: dL + M1p = M2p 
bool M1m = FALSE;
bool M2m = FALSE;

// Variables de envío serial
bool pwmOK = TRUE;				// Indica si la medida de los PWM está lista
bool sensOK = TRUE;				// Indica si la medida de los sensores digitales están listos
bool eventOK = TRUE;			// Indica si se va a enviar eventos
bool camOK = FALSE;				// Indica si la operación de la camara está lista
bool sharpOK = TRUE;			// Indica si la medida del infrarojo está lista

// Sensores analogicos
unsigned short sharpRes = 0;		// Lectura de la medida del sensor infrarrojo
unsigned short pot = 0;				// Lectura del potenciómetro
unsigned int sharpCount;

// Variables de la camara
unsigned char camArg[16];		// Argumentos para la instrucción de la cámara
unsigned char arg = 0;				// Numero de Bytes de los argumentos de la camara (longitud de camArg)
unsigned char camOP = 0; 		// Primitiva realizada
bool busy;						// TRUE -> Operacion sin terminar; FALSE -> Camara disponible
bool CK;						// TRUE -> ACK; FALSE -> NCK
unsigned char camPck;			// Tipo de paquete del resultado
unsigned char camRes[16]; 		// Resultado de la operación en ASCII
unsigned char res = 0;		    // encabezado + Numero de Bytes del resultado de la camara (longitud de camRes)

// Variables de eventos
bool ON = FALSE;				// Encendido del vehiculo
bool game = 0;					// 0 = seguir pelota; 1 = competir
bool E4 = TRUE;					// Comunicación serial desincronizada
bool E3 = FALSE;				// Esperando referencia de colores
bool E2 = FALSE;				// Esperando modo de juego
bool E1 = FALSE;				// Pelota objetivo OK
bool E0 = FALSE;				// Obstaculo desconocido

// Variables de recepción serial
bool sync = FALSE;				// Sincronización serial del DEMO
bool e4Rx;						// Sincronización serial del PC
bool e3Rx;
bool e2Rx;
bool e1Rx;
bool e0Rx;
bool camRx = FALSE;
bool pwmRx = TRUE;				// PC pide PWM
bool sensRx = TRUE;				// PC pide sensores digitales
bool movRx = TRUE;

// Control de pruebas
unsigned short mode = NORMAL;		// ECHO: reenvia lo que recibe por serial;
									// NORMAL: modo de envio y recepcion entre DEMO y PC

// Variables del puerto serial
unsigned char rxData[100];
unsigned char txData[100];
unsigned short send = 2;
unsigned short rcv = 2;
unsigned short rxByte;
unsigned short k, j, i = 100;

void main(void)
{
  /* Write your local variable definition here */

  /*** Processor Expert internal initialization. DON'T REMOVE THIS CODE!!! ***/
	PE_low_level_init();
  
  /*** End of Processor Expert internal initialization.                    ***/

  /* Write your code here */
  /* For example: for(;;) { } */
	for(;;){
		eventOK=TRUE;
		pwmOK = TRUE;
		// Si no está sincronizado, enciende led PTE7 (led Encendido -> FALSE)
		// Cuando está apagado, apaga motores
		if(ON == FALSE){
			duty = 0;
			dutySide = 0;
			dutyFix = 0;
			M2m=FALSE;
			M1m=FALSE;
		}

		if(movRx){
			// RUTINA DE asignación de MOVIMIENTO
			duty = (duty * 100)/0x7FFF;
			dutyFix = (dutyFix * 100)/0xFFFF;
			if(M1m){
				if(dutySide >= 0){
					dutySide = (dutySide * 100)/0x7FFF;
					freeRun((unsigned char)duty,(unsigned char)(duty+dutySide+dutyFix),BWD);
				}
				if(dutySide < 0){
					dutySide = (dutySide * 100)/(0x7FFF);
					freeRun((unsigned char)(duty-dutySide),(unsigned char)(duty + dutyFix),BWD);
				}
			}
			else{
				if(dutySide >= 0){
					dutySide = (dutySide * 100)/0x7FFF;
					freeRun((unsigned char)duty,(unsigned char)(duty+dutySide+ dutyFix),FWD);
				}
				if(dutySide < 0){
					dutySide = (dutySide * 100)/0x7FFF;
					freeRun((unsigned char)(duty-dutySide),(unsigned char)(duty+ dutyFix),FWD);
				}
			}
		movRx = FALSE;
		}

		// Mide los sensores digitales
		if(sensRx){
			// RUTINA QUE MIDE SENSORES
			sensOK = TRUE;
		}

		// Mide infrarrojo
		if(sharpOK == FALSE){
		// RUTINA QUE MIDE EL SHARP
			sharpOK = TRUE;
		}
	}
  /*** Don't write any code pass this line, or it will be deleted during code generation. ***/
  /*** Processor Expert end of main routine. DON'T MODIFY THIS CODE!!! ***/
  for(;;){}
  /*** Processor Expert end of main routine. DON'T WRITE CODE BELOW!!! ***/
} /*** End of main routine. DO NOT MODIFY THIS TEXT!!! ***/

/* END main */
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
