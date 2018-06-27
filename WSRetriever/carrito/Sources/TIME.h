#ifndef __TIME
#define __TIME
#endif

#include "Cpu.h"
#include "Events.h"
#include "VALUES.h"


void wait(unsigned short millisenconds);

void setTimeout(unsigned short millisenconds);

bool timeout(void);
