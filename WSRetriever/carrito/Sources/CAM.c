#include "CAM.h"
#include "TIME.h"
#include "PCCOM.h"
#include "AS2.h"
#include "AS1.h"
#include "Events.h"


bool camACK(void){
  unsigned char rxBuffer[RX_BUFFER_SIZE]= "";
  unsigned short size = 0;
  setTimeout(RX_TIMEOUT);
  while(AS2_GetCharsInRxBuf() < 3){if(timeout()) return FALSE;};
  AS2_RecvBlock(rxBuffer,3, &size);
  if(rxBuffer[0] == 'A' && rxBuffer[1] == 'C' && rxBuffer[2] == 'K'){
    setTimeout(RX_TIMEOUT);
    while(TRUE){
      unsigned char colon = '\0';
      while(AS2_GetCharsInRxBuf() == 0){};
      AS2_RecvChar(&colon);
      while(AS1_GetCharsInTxBuf() > 0){};
      if(colon != '\r') AS1_SendChar(colon);
      if(colon == ':') break;
      if(timeout()) return FALSE;
    };
    return TRUE;
    AS1_SendChar('\n');
    AS1_SendChar('\r');
  } else return FALSE;
}

bool camReset(void){
  AS2_SendChar('R');
  AS2_SendChar('S');
  AS2_SendChar('\r');
  if(camACK() == TRUE){
	  return TRUE;
  }else return FALSE;
}

bool camCMD(char *cmd){
  unsigned short count = 0;
  while(cmd[count] != '\0'){
    AS2_SendChar(cmd[count++]);
  };
  AS2_SendChar('\r');
  while(AS2_GetCharsInTxBuf() > 0){};
  if(camACK() == TRUE){
  	  return TRUE;
    }else return FALSE;
}

bool camTCM(unsigned char* bytes){
  unsigned short count = 0;
  unsigned char hehexd = 0;
  AS2_SendChar('T');
  AS2_SendChar('C');
  AS2_SendChar('\r');
  while(AS2_GetCharsInRxBuf() < M_RAW_PACKET_SIZE){};
  AS2_RecvChar(bytes);                 // deshacerse de 255
  hehexd = bytes[0];
  if(bytes[0] == 255){
    AS2_RecvChar(bytes);               // deshacerce de "M"
    hehexd = bytes[0];
    while(count < M_RAW_PACKET_SIZE - 1){
      AS2_RecvChar(bytes+(count++));
    };
    return TRUE;
  }else{
    return FALSE;
  };
}

unsigned char camDecodeMRaw(unsigned char *mPacket){
  if(mPacket[0] > 65 && mPacket[7] > MIN_CONFIDENCE){
    return 'L';
  }else if(mPacket[0] < 25 && mPacket[7] > MIN_CONFIDENCE){
    return 'R';
  }else if(mPacket[5] > 120 && mPacket[7] > MIN_CONFIDENCE){
    return 'B';
  }else if(mPacket[5] > 60 && mPacket[7] > MIN_CONFIDENCE){
    return 'F';
  }else return 'B';
}

unsigned short camCMDSync(const char *command){
  unsigned short count = 0;
  while(camFlag != CMD_EXECUTED){
    if(camFlag == CAM_IDLE){
      while(command[count] != '\0'){
      AS2_SendChar(command[count++]);
      }
      AS2_SendChar('\r');
      setTimeout(300);
      camFlag = CK_PENDING;
    }else if(camFlag == CK_READY){
      count = 0;
      if(camRxBuf[0] == 'A'){
        camFlag = CAM_IDLE;
        count = 0;
        while(count < camRxBufCount){
          camRxBuf[count++] = '\0';
        }
        camRxBufCount = 0;
        return CMD_EXECUTED;
      }else if(camRxBuf[0] == 'N'){
        camFlag = CAM_IDLE;
        camRxBufCount = 0;
        count = 0;
      }
    }else if(timeout()){
      camRxBufCount = 0;
      camFlag = CAM_IDLE;
    }
  }
  // if(camFlag == CAM_IDLE){
  //   while(command[count] != '\0'){
  //     AS2_SendChar(command[count++]);
  //   };
  //   AS2_SendChar('\r');
  //   camFlag = CK_PENDING;
  //   return CMD_SENT;
  // }else if(camFlag == CK_PENDING && ){

  // }else if(camFlag == CK_READY){
  //   if(camRxBuf[0] == 'A' &&  rawModeFlag == FALSE){
  //     camFlag = CAM_IDLE;
  //     camRxBufCount = 0;
  //     return CMD_EXECUTED;      
  //   }else if(rawModeFlag == TRUE){
  //     camFlag = CAM_IDLE;
  //     camRxBufCount = 0;
  //     return CMD_EXECUTED;
  //   }else{
  //     camFlag = CAM_IDLE;
  //     camRxBufCount = 0;
  //     return CMD_REJECTED;      
  //   }
  // }
  // else return CAM_BUSY;
}

// unsigned short camTCMRawAsync(unsigned char *data){
//   unsigned short count = 2;
//   unsigned short tempFlag = camFlag;
//   if(rawModeFlag == FALSE) return CAM_BUSY;
//   if(tempFlag == CAM_IDLE){
//     AS2_SendChar('T');
//     AS2_SendChar('C');
//     AS2_SendChar('\r');
//     camFlag = RDATA_PENDING;
//     return CAM_BUSY;
//   }else if(tempFlag == RDATA_READY){
//     while(count < M_RAW_PACKET_SIZE - 1){
//       data[count++] = camRxBuf[count];
//     };
//     AS1_SendBlock(camRxBuf, camRxBufCount, &count);
//     camRxBufCount = 0;
//     camFlag = CAM_IDLE;
//     return CMD_EXECUTED;
//   } else return CAM_BUSY;
// }

// void camWaitCMDAsync(const char *cmd, char* msg, unsigned char ms){
//   setTimeout(1000);
//   while(camCMDAsync(cmd) != CMD_EXECUTED){
//     if(timeout()){
//       print(msg);
//       camFlag = CAM_IDLE;
//       camRxBufCount = 0;
//       setTimeout(1000);
//     };
//     wait(ms);
//   };
// }

// void camWaitRDataAsync(unsigned char *data, char* msg, unsigned char ms){
//   while(camTCMRawAsync(data) != CMD_EXECUTED){
//     wait(ms);
//   };
// }

unsigned short camCMDAsync(const char *command){
  unsigned short count = 0;
  unsigned short tempFlag = camFlag;
  if(tempFlag == CAM_IDLE){
    while(command[count] != '\0'){
    	AS2_SendChar(command[count]);
    	count++;
    };
    AS2_SendChar('\r');
    camFlag = CK_PENDING;
    return CMD_SENT;
  }
  else return CAM_BUSY;
}

unsigned short camRSAsync(void){
  unsigned short tempFlag = camFlag;
  if(tempFlag == CAM_IDLE || tempFlag == CMD_REJECTED){
    AS2_SendChar('R');
    AS2_SendChar('S');
    AS2_SendChar('\r');
    camFlag = RS_PENDING;
    return CMD_SENT;
  }
  else return CAM_BUSY;
}

unsigned short camTCMRawAsync(void){
  if(camFlag == CAM_IDLE){
    AS2_SendChar('T');
    AS2_SendChar('C');
    AS2_SendChar('\r');
    camFlag = RDATA_PENDING;
    return CAM_BUSY;
  }else if(camFlag == CK_READY){ // 10 + XCK\r
    if(camRxBuf[0] == 'A'){
      camFlag = RDATA_READY;
      camRxBufCount = 0;
      return CAM_IDLE;
    }else{
      camFlag = CAM_IDLE;
      camRxBufCount = 0;
      return CMD_REJECTED;
    }
  }

}

unsigned short camTCXRawSync(const char *command){
  unsigned short count = 0;
  unsigned char hehexd = '\0';
  while(camFlag != CMD_EXECUTED){
    if(camFlag == CAM_IDLE){
      while(command[count] != '\0'){
        AS2_SendChar(command[count++]);
      };
      AS2_SendChar('\r');
      camFlag = RDATA_PENDING;
    }else if(camFlag == RDATA_PENDING && camRxBufCount == 23){ // 10 + XCK\r
      camFlag = RDATA_READY;
      camRxBufCount = 0;
      return CAM_IDLE;
    }else{
      count = 0;
      while(count < camRxBufCount){
        AS1_SendChar(camRxBuf[count++]);
      }
      print("//");
      while(AS1_GetCharsInTxBuf()!=0){};
    }
  }
}
