#include "MOTOR.h"
#include "TIME.h"
// steps 5%
// unsigned short dutybwd[21] = {0xFFFF, 0xF332,0xE665,0xD999,0xCCCC,0xBFFF,0xB332,0xA666,0x9999,0x8CCC,0x7FFF,0x7333,0x6666,0x5999,0x4CCC,0x4000,0x3333,0x2666,0x1999,0x0CCD,0x0000};
// unsigned short dutyfwd[21] = {0x000, 0x0CCD, 0x199A, 0x2666, 0x3333, 0x4000, 0x4CCD, 0x5999, 0x6666, 0x7333, 0x8000, 0x8CCC, 0x9999, 0xA666, 0xB333, 0xBFFF, 0xCCCC, 0xD999, 0xE666, 0xF332, 0xFFFF};
bool freeRunLeft = MOTOR_STOPPED;
bool freeRunRight = MOTOR_STOPPED;

void freeLeft(byte duty_sel, byte dir){
  if(dir == 0){
    M1m_PutVal(TRUE);
    PWM1_SetRatio16(DUTY1FWD * (unsigned short)duty_sel);
    freeRunLeft = FREE_RUN_FWD;
  }else if(dir == 1){
    M1m_PutVal(FALSE);
    PWM1_SetRatio16(bwd(DUTY1FWD * (unsigned short)duty_sel));
    freeRunLeft = FREE_RUN_BWD;
  }
}

void freeRight(byte duty_sel, byte dir){
  if(dir == 0){
    M2m_PutVal(TRUE);
    PWM2_SetRatio16(DUTY1FWD * (unsigned short)duty_sel);
    freeRunRight = FREE_RUN_FWD;
  }else if(dir == 1){
    M2m_PutVal(FALSE);
    PWM2_SetRatio16(bwd(DUTY1FWD * (unsigned short)duty_sel));
    freeRunRight = FREE_RUN_BWD;
  }
}

void stopLeft(void){
  if(freeRunLeft == FREE_RUN_FWD){
    PWM1_SetRatio16(DUTY0FWD);
  }else if(freeRunLeft == FREE_RUN_BWD){
    PWM1_SetRatio16(bwd(DUTY0FWD));
  }
  freeRunLeft = MOTOR_STOPPED;
}

void stopRight(void){
  if(freeRunRight == FREE_RUN_FWD){
    PWM2_SetRatio16(DUTY0FWD);
  }else if(freeRunRight == FREE_RUN_BWD){
    PWM2_SetRatio16(bwd(DUTY0FWD));
  }
  freeRunRight = MOTOR_STOPPED;
}

void moveLeft(byte duty_sel, byte dir, unsigned short duration){
  if(dir == 0){
    M2m_PutVal(TRUE);
    PWM1_SetRatio16(DUTY1FWD * (unsigned short)duty_sel);
    wait(duration);
    PWM1_SetRatio16(DUTY0FWD);
  }else if(dir == 1){
    M2m_PutVal(FALSE);
    PWM1_SetRatio16(bwd(DUTY1FWD * (unsigned short)duty_sel));
    wait(duration);
    PWM1_SetRatio16(bwd(DUTY0FWD));
  }
}

void moveRight(byte duty_sel, byte dir, unsigned short duration){
  if(dir == 0){
    M2m_PutVal(TRUE);
    PWM2_SetRatio16(DUTY1FWD * (unsigned short)duty_sel);
    wait(duration);
    PWM2_SetRatio16(DUTY0FWD);
  }else if(dir == 1){
    M2m_PutVal(FALSE);
    PWM2_SetRatio16(bwd(DUTY1FWD * (unsigned short)duty_sel));
    wait(duration);
    PWM2_SetRatio16(bwd(DUTY0FWD));
  }
}

void move(byte duty_sel_L, byte duty_sel_R, byte dir, unsigned short duration){
  if(dir == 0){
    M1m_PutVal(TRUE);
    M2m_PutVal(TRUE);
    PWM1_SetRatio16(DUTY1FWD * (unsigned short)duty_sel_L);
    PWM2_SetRatio16(DUTY1FWD * (unsigned short)duty_sel_R);
    wait(duration);
    PWM1_SetRatio16(DUTY0FWD);
    PWM2_SetRatio16(DUTY0FWD);
  }else if(dir == 1){
    M1m_PutVal(FALSE);
    M2m_PutVal(FALSE);
    PWM1_SetRatio16(bwd(DUTY1FWD * (unsigned short)duty_sel_L));
    PWM2_SetRatio16(bwd(DUTY1FWD * (unsigned short)duty_sel_R));
    wait(duration);
    PWM1_SetRatio16(bwd(DUTY0FWD));
    PWM2_SetRatio16(bwd(DUTY0FWD));
  }
}

void freeRun(byte duty_sel_L, byte duty_sel_R, byte dir){
  if(dir == 0){
    M1m_PutVal(TRUE);
    M2m_PutVal(TRUE);
    PWM1_SetRatio16(DUTY1FWD * (unsigned short)duty_sel_L);
    PWM2_SetRatio16(DUTY1FWD * (unsigned short)duty_sel_R);
    freeRunLeft = FREE_RUN_FWD;
    freeRunRight = FREE_RUN_FWD;
  }else if(dir == 1){
    M1m_PutVal(FALSE);
    M2m_PutVal(FALSE);
    PWM1_SetRatio16(bwd(DUTY1FWD * (unsigned short)duty_sel_L));
    PWM2_SetRatio16(bwd(DUTY1FWD * (unsigned short)duty_sel_R));
    freeRunLeft = FREE_RUN_BWD;
    freeRunRight = FREE_RUN_BWD;
  }
}

void stopFreeRun(void){
  if(freeRunLeft == FREE_RUN_FWD){
    PWM1_SetRatio16(DUTY0FWD);
  }else if(freeRunLeft == FREE_RUN_BWD){
    PWM1_SetRatio16(bwd(DUTY0FWD));
  }
  freeRunLeft = MOTOR_STOPPED;

  if(freeRunRight == FREE_RUN_FWD){
    PWM2_SetRatio16(DUTY0FWD);
  }else if(freeRunRight == FREE_RUN_BWD){
    PWM2_SetRatio16(bwd(DUTY0FWD));
  }
  freeRunRight = MOTOR_STOPPED; 
}

