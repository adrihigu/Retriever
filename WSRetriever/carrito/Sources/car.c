#include "CAR.h"
#include "MOTOR.h"

// Sensores analogicos
unsigned short sharpRes = 0;      // Lectura de la medida del sensor infrarrojo
unsigned short sharpResA[MAX_SHARP];  // Arreglo de Lecturas del Sharp
unsigned short sharpResM = 0;         // Valor medio de ultimas MAX_SHARP Lecturas del Sharp
bool rawModeFlag = FALSE;
// Variables de Movimiento
unsigned short duty = 0;
unsigned short dutySide = 0;
unsigned short dutyLeft = 6554;     // 10% adicional a la rueda izquierda
unsigned short dutyRight = 2000;
bool M1m = FALSE;
bool M2m = FALSE;
unsigned short dutyI = 0;
unsigned short dutyD = 0;
// Variables de camara
unsigned short xDesv;       //

// Varibles serial PC
unsigned char rxBuffer[30];
unsigned char txBuffer[30];
unsigned short send;

unsigned char modeFlag;
unsigned char nextMode = START_DOGGY;
// Banderas
bool sharpOK = FALSE;
unsigned short mx = 0;
unsigned short sharpCount = 0;
//
char itoaBuf[30];

errorType execMode(errorType error){
  errorType errorCode;
  if(error == OK){
    switch(modeFlag){
      case START_DOGGY :
        startDoggy();
        break;
      case RESTART_DOGGY :
        break;
      case DOGGY_MODE :
          errorCode = updateDoggyTrayectory();
          return errorCode;
        break;
      default :
        printLn("maquina IDLE");
        //print("\27[2K\r");
        break;
    }
  } else return MODE_ERROR;
}
errorType getMode(void){
  modeFlag = nextMode;
  return OK;
}
//errorType clearDoggyTraget(void){
//
//}

errorType updateDoggyTrayectory(void){
  camTCMRawAsync();
  if(timeout() == TRUE && camFlag == RDATA_PENDING){
    camFlag = CAM_IDLE;
    stopFreeRun();
  }
  if (sharpOK == TRUE && camFlag == RDATA_READY){
      print("Data: ");
      printNum((int)camRxBuf[7], itoaBuf);
      print(" ");
      printNum((int)camRxBuf[6],itoaBuf);
      print(" ");
      printNum((int)sharpRes,itoaBuf);
      print(" ");
      print("|");
      print(" ");
      // txBuffer[0] = (unsigned char)(0x00FF & sharpRes);
      // txBuffer[1] = (unsigned char)((0x0F00 & sharpRes) >> 8);
      //AS1_SendBlock(txBuffer, 2, &send);
      /////////////////////
      
      // LOGICA DE GIROS //
      
      /////////////////////

      //AS1_SendChar(camRxBuf[6]);
      if(camRxBuf[6] < 30 ){       // > 0 => Necesita girar izquierda
        freeRight(35, FWD);
        print("IZQ ");
      }
      
      else if(camRxBuf[6] > 50){      // < 0 => Necesita girar derecha
        freeLeft(35, FWD);
        print("DER ");
      }
      
      else if(camRxBuf[6] > 30 && camRxBuf[6] < 50){
        ///////////////////////////////
        
        // LOGICA MOVIMIENTO FRONTAL //
        
        ///////////////////////////////
        
        if((sharpRes > 520) & (sharpRes < 2100)){     // Objetivo lejano
        // if(camRxBuf[7] < 50){     // Objetivo lejano
          //duty = ((2100 - sharpRes) * 0x7FFF) / (2100 - 520);
          freeRun(35, 35, FWD);
          print("FWD ");
          
        }else if((sharpRes >= 2100) & (sharpRes < 2350)){ // Objetivo en el rango
          // }else if(camRxBuf[7] > 50 && camRxBuf[7] < 90){ // Objetivo en el rango
          stopFreeRun();
          print("CTR ");
          
        }else if((sharpRes >= 2350) & (sharpRes < 2600)){   // Objetivo cercano
          // }else if(camRxBuf[7] > 90 ){   // Objetivo cercano
          duty = 0x7FFF + (((2600 - sharpRes) * 0x7FFF) / (2600 - 2450));
          freeRun(35, 35, BWD);
          print("BWD "); 
        }else{
          stopFreeRun();
          print("STP ");
        }
        

      }else if(camRxBuf[6]==0 && camRxBuf[7]==0 && camRxBuf[8]==0 && camRxBuf[9]==0 && camRxBuf[10]==0 && camRxBuf[11]==0 && camRxBuf[12]==0){
        stopFreeRun();
        print("LST ");
      }
      
      //printNumLn(420, itoaBuf);
       
      
       // PWM1_SetRatio16((duty + dutyI) ^ 0xFFFF);
       // PWM2_SetRatio16((duty + dutyD) ^ 0xFFFF);
      
       // M1m_PutVal(M1m);
       // M2m_PutVal(M2m);
       // wait(500);
       // PWM1_SetRatio16(0 ^ 0xFFFF);
       // PWM2_SetRatio16(0 ^ 0xFFFF);
      
       // M1m_PutVal(FALSE);
       // M2m_PutVal(FALSE);
      sharpOK = FALSE;
      camFlag = CAM_IDLE;
      camTCMRawAsync();
      setTimeout(300);
      printLn("");
      // printLn("\27[2J");
    }

  if(sharpCount >= 100){
    AD1_Measure(TRUE);
    AD1_GetChanValue16(0,&sharpRes);
    sharpRes = (sharpRes & 0xFFF0) >> 4;
    sharpCount = 0;
    sharpOK = TRUE;
  }
}

errorType startDoggy(void){
  //rawModeFlag = TRUE;
  printLn("Ponga el Objetivo frente a la camara");
  wait(1500);
  camCMDSync("TW");
  wait(1000);
  camTCMRawAsync();
  nextMode= DOGGY_MODE;
}
  
errorType car_Init(){
  wait(5000);
  printLn("Reiniciando camara...");
  camCMDSync("RS");
  
  printLn("Encendiendo Luz de rastreo");
  camCMDSync("L1 1");

  printLn("Configurando registros");
  camCMDSync("CR 18 44");
  camCMDSync("CR 18 44 19 32");

  printLn("Luz de rastreo en modo automatico");
  camCMDSync("L1 2");

  printLn("Configurando camara en modo poll");
  camCMDSync("PM 1");

  printLn("Configurando camara en modo raw");
  camCMDSync("RM 1");
  while(AS1_GetCharsInTxBuf() != 0){};
  nextMode = START_DOGGY;
}

void handleError(errorType error){
  return;
}

