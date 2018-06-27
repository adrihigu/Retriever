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

#include "TIME.h"
#include "CAM.h"
#include "PCCOM.h"
#include "CAR.h"
#include "MOTOR.h"

void main(void)
{
  /* Write your local variable definition here */
	unsigned short errorCode = 0;
  /*** Processor Expert internal initialization. DON'T REMOVE THIS CODE!!! ***/
  PE_low_level_init();
  
  /*** End of Processor Expert internal initialization.                    ***/
  //car_Init();
  

for (;;)
{
  // confirmar modo de ejecucion
  //errorCode = getMode();

  //handleError(execMode(OK));
  // moveLeft(DUTY50, FWD, 300);
  // wait(2000);
  // moveLeft(DUTY50, BWD, 300);
  // wait(2000);
  //  moveRight(DUTY50, FWD, 300);
  //  wait(2000);
  //  moveRight(DUTY50, BWD, 300);
  //  wait(2000);
   move(DUTY50, FWD, 1000);
   wait(1000);
   move(DUTY50, BWD, 1000);
   wait(1000);
//  handleError(updateCamData());
//
//  handleError(updateSharpData());
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
