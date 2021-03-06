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
#include "BitM1m.h"
#include "BitM2m.h"
#include "AD1.h"
#include "BitPTA2.h"
#include "BitPTA3.h"
// #include "moves.h"
/* Include shared modules, which are used for whole project */
#include "PE_Types.h"
#include "PE_Error.h"
#include "PE_Const.h"
#include "IO_Map.h"
#define TRUE 1
#define FALSE 0

/* User includes (#include below this line is not maintained by Processor Expert) */


unsigned char CodError;
unsigned short dutyRt = 0; // U seg

void main(void)
{
  /* Write your local variable definition here */

  /*** Processor Expert internal initialization. DON'T REMOVE THIS CODE!!! ***/
  PE_low_level_init();
  /*** End of Processor Expert internal initialization.                    ***/

  /* Write your code here */
  /* For example: for(;;) { } */
  for(;;){
	  CodError = AD1_Measure(TRUE);
	  CodError = AD1_GetChanValue16(0,&dutyRt);
	  CodError = PWM1p_SetRatio16(dutyRt);
	  CodError = PWM2p_SetRatio16(dutyRt);
	  
	  // LADO DERECHO
	  if(BitPTA2_GetVal() == TRUE){ // Adelante
		 BitM1m_ClrVal(); 
  	  }
  	  else{							// Atras
  		 BitM1m_SetVal();
  	  }
   }
  
  // LADO IZQUIERDO
	if(BitPTA3_GetVal() == TRUE){	// Adelante
		BitM2m_ClrVal(); 
	}
	else{							// Atras
		BitM2m_SetVal();
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
