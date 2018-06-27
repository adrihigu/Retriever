#ifndef __MOTOR
#define __MOTOR
#endif

#define DUTY0 0
#define DUTY5 1
#define DUTY10 2
#define DUTY15 3
#define DUTY20 4
#define DUTY25 5
#define DUTY30 6
#define DUTY35 7
#define DUTY40 8
#define DUTY45 9
#define DUTY50 10
#define DUTY55 11
#define DUTY60 12
#define DUTY65 13
#define DUTY70 14
#define DUTY75 15
#define DUTY80 16
#define DUTY85 17
#define DUTY90 18
#define DUTY95 19
#define DUTY100 20

#define FWD 0
#define BWD 1

void moveRight(unsigned short duty_sel, unsigned short dir, unsigned short duration);

void moveLeft(unsigned short duty_sel, unsigned short dir, unsigned short duration);

void move(unsigned short duty_sel, unsigned short dir, unsigned short duration);