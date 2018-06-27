#ifndef __CAM
#define __CAM
#endif

#include "Cpu.h"
#include "Events.h"
#include "AS2.h"
#include "VALUES.h"

bool camACK(void);

bool camReset(void);

bool camCMD(char *cmd);

bool camTCM(unsigned char *bytes);

unsigned char camDecodeMRaw(unsigned char *mPacket);

unsigned short camCMDAsync(const char *command);

unsigned short camCMDSync(const char *command);

// unsigned short camTCMRawAsync(unsigned char *data);
unsigned short camTCMRawAsync(void);

unsigned short camRSAsync(void);
// void camWaitCMDAsync(const char *cmd, char* msg, unsigned char ms);

// void camWaitRDataAsync(unsigned char *data, char* msg, unsigned char ms);

unsigned short camTCXRawSync(const char *command);
