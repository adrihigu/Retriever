/* ###################################################################
**     Filename    : main.c
**     Project     : carrito_semana_6
**     Processor   : MCF51QE128CLK
**     Version     : Driver 01.00
**     Compiler    : CodeWarrior ColdFireV1 C Compiler
**     Date/Time   : 2018-05-30, 09:03, # CodeGen: 0
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
#include "TI1.h"
#include "TI2.h"
#include "AD1.h"
#include "AS1.h"
#include "PWM1.h"
#include "PWM2.h"
#include "AS2.h"
#include "M1m.h"
#include "M2m.h"
/* Include shared modules, which are used for whole project */
#include "PE_Types.h"
#include "PE_Error.h"
#include "PE_Const.h"
#include "IO_Map.h"

/* User includes (#include below this line is not maintained by Processor Expert) */

#define MAX_SHARP 12
#define TRUE 1
#define FALSE 0

// Sensores analogicos
unsigned short sharpRes = 0;		  // Lectura de la medida del sensor infrarrojo
unsigned short sharpResA[MAX_SHARP];  // Arreglo de Lecturas del Sharp
unsigned short sharpResM = 0;         // Valor medio de ultimas MAX_SHARP Lecturas del Sharp

// Variables de Movimiento
unsigned short duty = 0;
unsigned short dutySide = 0;
unsigned short dutyLeft = 6554;			// 10% adicional a la rueda izquierda
unsigned short dutyRight = 2000;
bool M1m = FALSE;
bool M2m = FALSE;
unsigned short dutyI = 0;
unsigned short dutyD = 0;
// Variables de camara
unsigned short xDesv;				//

// Varibles serial PC
unsigned char rxBuffer[30];
unsigned char txBuffer[30];
unsigned short send;

// Banderas
bool sharpOK = FALSE;
bool camOK = TRUE;

void main(void)
{
  /* Write your local variable definition here */

  /*** Processor Expert internal initialization. DON'T REMOVE THIS CODE!!! ***/
  PE_low_level_init();
  
  /*** End of Processor Expert internal initialization.                    ***/
  for(;;){
		if (sharpOK & camOK){
			txBuffer[0] = (unsigned char)(0x00FF & sharpRes);
			txBuffer[1] = (unsigned char)((0x0F00 & sharpRes) >> 8);
			AS2_SendBlock(txBuffer, 2, &send);
			
			///////////////////////////////
			
			// LOGICA MOVIMIENTO FRONTAL //
			
			///////////////////////////////
			
			rxBuffer[0] = (unsigned char)(sharpRes);
			rxBuffer[1] = (unsigned char)(sharpRes >> 8);
			
			dutyD = 0;
			dutyI = 0;
			
			AS2_SendBlock(rxBuffer, 2, &send);
			if((sharpRes > 520) & (sharpRes < 1250)){		// Objetivo lejano
				duty = ((1300 - sharpRes) * 0x7FFF) / (1100 - 520);
				dutyD += dutyRight;
				M1m = FALSE;
				M2m = FALSE;
			}else if((sharpRes >= 1250) & (sharpRes < 1300)){	// Objetivo en el rango
				duty = 0;				// 0%
				M1m = FALSE;
				M2m = FALSE;
			}else if((sharpRes >= 1300) & (sharpRes < 2500)){		// Objetivo cercano
				duty = 0x7FFF + (((2500 - sharpRes) * 0x7FFF) / (2500 - 1200));
				dutyI += dutyRight;
				M1m = TRUE;
				M2m = TRUE;			
			}
			
			/////////////////////
			
			// LOGICA DE GIROS //
			
			/////////////////////
			
			/*
			 * 
			 * camPos: pixeles de desviación de la referencia respecto al centroide
			 * 
			
			if((73 - camPos) > 3)){				// > 0 => Necesita girar izquierda
				dutyI = 0x4FFF;      		 		// 25%
				M1m = FALSE;
				
				dutyD = 0x4FFF ^ 0xFFFF;      		// 25%
				M2m = TRUE;
			}
			
			if((73 - camPos) < -3)){			// < 0 => Necesita girar derecha
				dutyI = 0x4FFF ^ 0xFFFF;      		// 25%
				M1m = TRUE;
				
				dutyD = 0x4FFF;      				// 25%
				M2m = FALSE;
			}
			
			if(((73 - camPos) >= -3) & ((73 - camPos) <= 3))){
				dutyI = 0;      				// 0%
				M1m = FALSE;
				
				dutyD = 0;      				// 0%
				M2m = FALSE;
			}
			 
			 * 
			 */
			
			PWM1_SetRatio16((duty + dutyI) ^ 0xFFFF);

			PWM2_SetRatio16((duty + dutyD) ^ 0xFFFF);
			
			M1m_PutVal(M1m);
			M2m_PutVal(M2m);
			sharpOK = FALSE;
			//camOK = FALSE;
		}
	}

  /* Write your code here */
  /* For example: for(;;) { } */

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
