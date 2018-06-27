#ifndef __MOTOR
#define __MOTOR
#endif

#include "PE_Types.h"

// #define DUTY0 0
// #define DUTY5 1
// #define DUTY10 2
// #define DUTY15 3
// #define DUTY20 4
// #define DUTY25 5
// #define DUTY30 6
// #define DUTY35 7
// #define DUTY40 8
// #define DUTY45 9
// #define DUTY50 10
// #define DUTY55 11
// #define DUTY60 12
// #define DUTY65 13
// #define DUTY70 14
// #define DUTY75 15
// #define DUTY80 16
// #define DUTY85 17
// #define DUTY90 18
// #define DUTY95 19
// #define DUTY100 20

#define FWD 0
#define BWD 1

#define DUTY0FWD 0
#define DUTY1FWD 0x028F // 655
#define bwd(duty) (duty ^0xFFFF)

#define FREE_RUN_FWD 0
#define FREE_RUN_BWD 1
#define MOTOR_STOPPED 2

extern bool freeRunLeft;
extern bool freeRunRight;

void freeLeft(byte duty_sel, byte dir);

void freeRight(byte duty_sel, byte dir);

void stopLeft(void);

void stopRight(void);

void stopFreeRun(void);

void freeRun(byte duty_sel_L, byte duty_sel_R, byte dir);

void moveRight(byte duty_sel, byte dir, unsigned short duration);

void moveLeft(byte duty_sel, byte dir, unsigned short duration);

void move(byte duty_sel_L, byte duty_sel_R, byte dir, unsigned short duration);



