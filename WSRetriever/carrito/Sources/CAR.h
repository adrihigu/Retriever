#ifndef __CAR
#define __CAR
#endif
#include "AS2.h"
#include "AS1.h"
#include "PCCOM.h"
#include "CAM.h"
#include "TIME.h"
#include "VALUES.h"

typedef unsigned short errorType;

errorType execMode(errorType error);

errorType getMode(void);

errorType updateDoggyTrayectory(void);

errorType startDoggy(void);

errorType car_Init();

void handleError(errorType error);