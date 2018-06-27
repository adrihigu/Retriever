#include "TIME.h"

extern unsigned short msCount;
unsigned short waitMark = 0;
unsigned short timeoutMark = 0;
unsigned short timeoutCap = 0;
bool waitFlag = FALSE;
bool timeoutFlag = FALSE;

void wait(unsigned short millisenconds){
  waitFlag = TRUE;
  waitMark = msCount;
  while(msCount >= waitMark){
    if(msCount - waitMark >= millisenconds){
      waitFlag = FALSE;
      return;
    };
  };
}

void setTimeout(unsigned short millisenconds){
  timeoutFlag = TRUE;
  timeoutMark = msCount;
  timeoutCap = millisenconds+msCount;
}

bool timeout(void){
  if(timeoutCap <= msCount && timeoutFlag == TRUE){
    timeoutFlag = FALSE;
    return TRUE;
  }else return FALSE;
}
