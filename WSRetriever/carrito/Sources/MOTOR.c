#include "MOTOR.h"
#include "TIME.h"
#include "PE_Types.h"

unsigned short dutybwd[21] = {0xFFFF, 0xF332,0xE665,0xD999,0xCCCC,0xBFFF,0xB332,0xA666,0x9999,0x8CCC,0x7FFF,0x7333,0x6666,0x5999,0x4CCC,0x4000,0x3333,0x2666,0x1999,0x0CCD,0x0000};
unsigned short dutyfwd[21] = {0x000, 0x0CCD, 0x199A, 0x2666, 0x3333, 0x4000, 0x4CCD, 0x5999, 0x6666, 0x7333, 0x8000, 0x8CCC, 0x9999, 0xA666, 0xB333, 0xBFFF, 0xCCCC, 0xD999, 0xE666, 0xF332, 0xFFFF};

void moveRight(unsigned short duty_sel, unsigned short dir, unsigned short duration){
  if(dir == 0){
    M2m_PutVal(TRUE);
    PWM2_SetRatio16(dutyfwd[duty_sel]);
    wait(duration);
    PWM2_SetRatio16(dutybwd[DUTY0]);
  }else if(dir == 1){
    M2m_PutVal(FALSE);
    PWM2_SetRatio16(dutybwd[duty_sel]);
    wait(duration);
    PWM2_SetRatio16(dutybwd[DUTY0]);
  }
}

void moveLeft(unsigned short duty_sel, unsigned short dir, unsigned short duration){
  if(dir == 0){
    M1m_PutVal(TRUE);
    PWM1_SetRatio16(dutyfwd[duty_sel]);
    wait(duration);
    PWM2_SetRatio16(dutyfwd[DUTY0]);
  }else if(dir == 1){
    M1m_PutVal(FALSE);
    PWM1_SetRatio16(dutybwd[duty_sel]);
    wait(duration);
    PWM2_SetRatio16(dutybwd[DUTY0]);
  }
}

void move(unsigned short duty_sel, unsigned short dir, unsigned short duration){
  if(dir == 0){
    M1m_PutVal(TRUE);
    M2m_PutVal(TRUE);
    PWM2_SetRatio16(dutyfwd[duty_sel]);
    PWM1_SetRatio16(dutyfwd[duty_sel - 1]);
    wait(duration);
    PWM1_SetRatio16(dutyfwd[DUTY0]);
    PWM2_SetRatio16(dutyfwd[DUTY0]);
  }else if(dir == 1){
    M1m_PutVal(FALSE);
    M2m_PutVal(FALSE);
    PWM2_SetRatio16(dutybwd[duty_sel]);
    PWM1_SetRatio16(dutybwd[duty_sel - 1]);
    wait(duration);
    PWM1_SetRatio16(dutybwd[DUTY0]);
    PWM2_SetRatio16(dutybwd[DUTY0]);
  }
}
