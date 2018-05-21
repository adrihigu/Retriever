/* ###################################################################
**     THIS COMPONENT MODULE IS GENERATED BY THE TOOL. DO NOT MODIFY IT.
**     Filename    : IO_Map.c
**     Project     : carrito
**     Processor   : MCF51QE128CLK
**     Component   : IO_Map
**     Version     : Driver 01.00
**     Compiler    : CodeWarrior ColdFireV1 C Compiler
**     Date/Time   : 2018-05-10, 14:19, # CodeGen: 13
**     Abstract    :
**         IO_Map.h - implements an IO device's mapping. 
**         This module contains symbol definitions of all peripheral 
**         registers and bits. 
**     Settings    :
**
**     Contents    :
**         No public methods
**
**     Copyright : 1997 - 2014 Freescale Semiconductor, Inc. 
**     All Rights Reserved.
**     
**     Redistribution and use in source and binary forms, with or without modification,
**     are permitted provided that the following conditions are met:
**     
**     o Redistributions of source code must retain the above copyright notice, this list
**       of conditions and the following disclaimer.
**     
**     o Redistributions in binary form must reproduce the above copyright notice, this
**       list of conditions and the following disclaimer in the documentation and/or
**       other materials provided with the distribution.
**     
**     o Neither the name of Freescale Semiconductor, Inc. nor the names of its
**       contributors may be used to endorse or promote products derived from this
**       software without specific prior written permission.
**     
**     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
**     ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
**     WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
**     DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
**     ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
**     (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
**     LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
**     ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
**     (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
**     SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**     
**     http: www.freescale.com
**     mail: support@freescale.com
** ###################################################################*/
/*!
** @file IO_Map.c
** @version 01.00
** @brief
**         IO_Map.h - implements an IO device's mapping. 
**         This module contains symbol definitions of all peripheral 
**         registers and bits. 
*/         
/*!
**  @addtogroup IO_Map_module IO_Map module documentation
**  @{
*/         
/* Based on CPU DB MCF51QE128_80, version 3.00.078 (RegistersPrg V2.33) */
/* DataSheet : MCF51QE128RM, Rev. 3, 9/2007 */

#include "PE_Types.h"
#include "IO_Map.h"

/*lint -save -esym(765, *) */


/* * * * *  8-BIT REGISTERS  * * * * * * * * * * * * * * * */
/* NVFTRIM - macro for reading non volatile register       Nonvolatile ICS Fine Trim; 0x000003FE */
/* NVICSTRM - macro for reading non volatile register      Nonvolatile ICS Trim Register; 0x000003FF */
/* NVBACKKEY0 - macro for reading non volatile register    Backdoor Comparison Key 0; 0x00000400 */
/* NVBACKKEY1 - macro for reading non volatile register    Backdoor Comparison Key 1; 0x00000401 */
/* NVBACKKEY2 - macro for reading non volatile register    Backdoor Comparison Key 2; 0x00000402 */
/* NVBACKKEY3 - macro for reading non volatile register    Backdoor Comparison Key 3; 0x00000403 */
/* NVBACKKEY4 - macro for reading non volatile register    Backdoor Comparison Key 4; 0x00000404 */
/* NVBACKKEY5 - macro for reading non volatile register    Backdoor Comparison Key 5; 0x00000405 */
/* NVBACKKEY6 - macro for reading non volatile register    Backdoor Comparison Key 6; 0x00000406 */
/* NVBACKKEY7 - macro for reading non volatile register    Backdoor Comparison Key 7; 0x00000407 */
/* NVPROT - macro for reading non volatile register        Nonvolatile Flash Protection Register; 0x0000040D */
/* NVOPT - macro for reading non volatile register         Nonvolatile Flash Options Register; 0x0000040F */
volatile PTADSTR _PTAD;                                    /* Port A Data Register; 0xFFFF8000 */
volatile PTADDSTR _PTADD;                                  /* Port A Data Direction Register; 0xFFFF8001 */
volatile PTBDSTR _PTBD;                                    /* Port B Data Register; 0xFFFF8002 */
volatile PTBDDSTR _PTBDD;                                  /* Port B Data Direction Register; 0xFFFF8003 */
volatile PTCDSTR _PTCD;                                    /* Port C Data Register; 0xFFFF8004 */
volatile PTCDDSTR _PTCDD;                                  /* Port C Data Direction Register; 0xFFFF8005 */
volatile PTDDSTR _PTDD;                                    /* Port D Data Register; 0xFFFF8006 */
volatile PTDDDSTR _PTDDD;                                  /* Port D Data Direction Register; 0xFFFF8007 */
volatile PTEDSTR _PTED;                                    /* Port E Data Register; 0xFFFF8008 */
volatile PTEDDSTR _PTEDD;                                  /* Port E Data Direction Register; 0xFFFF8009 */
volatile PTFDSTR _PTFD;                                    /* Port F Data Register; 0xFFFF800A */
volatile PTFDDSTR _PTFDD;                                  /* Port F Data Direction Register; 0xFFFF800B */
volatile KBI1SCSTR _KBI1SC;                                /* KBI1 Status and Control Register; 0xFFFF800C */
volatile KBI1PESTR _KBI1PE;                                /* KBI1 Pin Enable Register; 0xFFFF800D */
volatile KBI1ESSTR _KBI1ES;                                /* KBI1 Edge Select Register; 0xFFFF800E */
volatile IRQSCSTR _IRQSC;                                  /* Interrupt request status and control register; 0xFFFF800F */
volatile ADCSC1STR _ADCSC1;                                /* Status and Control Register 1; 0xFFFF8010 */
volatile ADCSC2STR _ADCSC2;                                /* Status and Control Register 2; 0xFFFF8011 */
volatile ADCCFGSTR _ADCCFG;                                /* Configuration Register; 0xFFFF8016 */
volatile APCTL1STR _APCTL1;                                /* Pin Control 1 Register; 0xFFFF8017 */
volatile APCTL2STR _APCTL2;                                /* Pin Control 2 Register; 0xFFFF8018 */
volatile APCTL3STR _APCTL3;                                /* Pin Control 3 Register; 0xFFFF8019 */
volatile ACMP1SCSTR _ACMP1SC;                              /* ACMP1 Status and Control Register; 0xFFFF801A */
volatile ACMP2SCSTR _ACMP2SC;                              /* ACMP2 Status and Control Register; 0xFFFF801B */
volatile PTGDSTR _PTGD;                                    /* Port G Data Register; 0xFFFF801C */
volatile PTGDDSTR _PTGDD;                                  /* Port G Data Direction Register; 0xFFFF801D */
volatile PTHDSTR _PTHD;                                    /* Port H Data Register; 0xFFFF801E */
volatile PTHDDSTR _PTHDD;                                  /* Port H Data Direction Register; 0xFFFF801F */
volatile SCI1C1STR _SCI1C1;                                /* SCI1 Control Register 1; 0xFFFF8022 */
volatile SCI1C2STR _SCI1C2;                                /* SCI1 Control Register 2; 0xFFFF8023 */
volatile SCI1S1STR _SCI1S1;                                /* SCI1 Status Register 1; 0xFFFF8024 */
volatile SCI1S2STR _SCI1S2;                                /* SCI1 Status Register 2; 0xFFFF8025 */
volatile SCI1C3STR _SCI1C3;                                /* SCI1 Control Register 3; 0xFFFF8026 */
volatile SCI1DSTR _SCI1D;                                  /* SCI1 Data Register; 0xFFFF8027 */
volatile SPI1C1STR _SPI1C1;                                /* SPI1 Control Register 1; 0xFFFF8028 */
volatile SPI1C2STR _SPI1C2;                                /* SPI1 Control Register 2; 0xFFFF8029 */
volatile SPI1BRSTR _SPI1BR;                                /* SPI1 Baud Rate Register; 0xFFFF802A */
volatile SPI1SSTR _SPI1S;                                  /* SPI1 Status Register; 0xFFFF802B */
volatile SPI1DSTR _SPI1D;                                  /* SPI1 Data Register; 0xFFFF802D */
volatile PTJDSTR _PTJD;                                    /* Port J Data Register; 0xFFFF802E */
volatile PTJDDSTR _PTJDD;                                  /* Port J Data Direction Register; 0xFFFF802F */
volatile IIC1ASTR _IIC1A;                                  /* IIC Address Register; 0xFFFF8030 */
volatile IIC1FSTR _IIC1F;                                  /* IIC Frequency Divider Register; 0xFFFF8031 */
volatile IIC1C1STR _IIC1C1;                                /* IIC Control Register 1; 0xFFFF8032 */
volatile IIC1SSTR _IIC1S;                                  /* IIC Status Register; 0xFFFF8033 */
volatile IIC1DSTR _IIC1D;                                  /* IIC Data I/O Register; 0xFFFF8034 */
volatile IIC1C2STR _IIC1C2;                                /* IIC Control Register 2; 0xFFFF8035 */
volatile ICSC1STR _ICSC1;                                  /* ICS Control Register 1; 0xFFFF8038 */
volatile ICSC2STR _ICSC2;                                  /* ICS Control Register 2; 0xFFFF8039 */
volatile ICSTRMSTR _ICSTRM;                                /* ICS Trim Register; 0xFFFF803A */
volatile ICSSCSTR _ICSSC;                                  /* ICS Status and Control Register; 0xFFFF803B */
volatile KBI2SCSTR _KBI2SC;                                /* KBI2 Status and Control Register; 0xFFFF803C */
volatile KBI2PESTR _KBI2PE;                                /* KBI2 Pin Enable Register; 0xFFFF803D */
volatile KBI2ESSTR _KBI2ES;                                /* KBI2 Edge Select Register; 0xFFFF803E */
volatile TPM1SCSTR _TPM1SC;                                /* TPM1 Status and Control Register; 0xFFFF8040 */
volatile TPM1C0SCSTR _TPM1C0SC;                            /* TPM1 Timer Channel 0 Status and Control Register; 0xFFFF8045 */
volatile TPM1C1SCSTR _TPM1C1SC;                            /* TPM1 Timer Channel 1 Status and Control Register; 0xFFFF8048 */
volatile TPM1C2SCSTR _TPM1C2SC;                            /* TPM1 Timer Channel 2 Status and Control Register; 0xFFFF804B */
volatile TPM2SCSTR _TPM2SC;                                /* TPM2 Status and Control Register; 0xFFFF8050 */
volatile TPM2C0SCSTR _TPM2C0SC;                            /* TPM2 Timer Channel 0 Status and Control Register; 0xFFFF8055 */
volatile TPM2C1SCSTR _TPM2C1SC;                            /* TPM2 Timer Channel 1 Status and Control Register; 0xFFFF8058 */
volatile TPM2C2SCSTR _TPM2C2SC;                            /* TPM2 Timer Channel 2 Status and Control Register; 0xFFFF805B */
volatile TPM3SCSTR _TPM3SC;                                /* TPM3 Status and Control Register; 0xFFFF8060 */
volatile TPM3C0SCSTR _TPM3C0SC;                            /* TPM3 Timer Channel 0 Status and Control Register; 0xFFFF8065 */
volatile TPM3C1SCSTR _TPM3C1SC;                            /* TPM3 Timer Channel 1 Status and Control Register; 0xFFFF8068 */
volatile TPM3C2SCSTR _TPM3C2SC;                            /* TPM3 Timer Channel 2 Status and Control Register; 0xFFFF806B */
volatile TPM3C3SCSTR _TPM3C3SC;                            /* TPM3 Timer Channel 3 Status and Control Register; 0xFFFF806E */
volatile TPM3C4SCSTR _TPM3C4SC;                            /* TPM3 Timer Channel 4 Status and Control Register; 0xFFFF8071 */
volatile TPM3C5SCSTR _TPM3C5SC;                            /* TPM3 Timer Channel 5 Status and Control Register; 0xFFFF8074 */
volatile SRSSTR _SRS;                                      /* System Reset Status Register; 0xFFFF9800 */
volatile SOPT1STR _SOPT1;                                  /* System Options Register 1; 0xFFFF9802 */
volatile SOPT2STR _SOPT2;                                  /* System Options Register 2; 0xFFFF9803 */
volatile SPMSC1STR _SPMSC1;                                /* System Power Management Status and Control 1 Register; 0xFFFF9808 */
volatile SPMSC2STR _SPMSC2;                                /* System Power Management Status and Control 2 Register; 0xFFFF9809 */
volatile SPMSC3STR _SPMSC3;                                /* System Power Management Status and Control 3 Register; 0xFFFF980B */
volatile SCGC1STR _SCGC1;                                  /* System Clock Gating Control 1 Register; 0xFFFF980E */
volatile SCGC2STR _SCGC2;                                  /* System Clock Gating Control 2 Register; 0xFFFF980F */
volatile FCDIVSTR _FCDIV;                                  /* FLASH Clock Divider Register; 0xFFFF9820 */
volatile FOPTSTR _FOPT;                                    /* Flash Options Register; 0xFFFF9821 */
volatile FCNFGSTR _FCNFG;                                  /* Flash Configuration Register; 0xFFFF9823 */
volatile FPROTSTR _FPROT;                                  /* Flash Protection Register; 0xFFFF9824 */
volatile FSTATSTR _FSTAT;                                  /* Flash Status Register; 0xFFFF9825 */
volatile FCMDSTR _FCMD;                                    /* Flash Command Register; 0xFFFF9826 */
volatile RTCSCSTR _RTCSC;                                  /* RTC Status and Control Register; 0xFFFF9830 */
volatile RTCCNTSTR _RTCCNT;                                /* RTC Counter Register; 0xFFFF9831 */
volatile RTCMODSTR _RTCMOD;                                /* RTC Modulo Register; 0xFFFF9832 */
volatile SPI2C1STR _SPI2C1;                                /* SPI2 Control Register 1; 0xFFFF9838 */
volatile SPI2C2STR _SPI2C2;                                /* SPI2 Control Register 2; 0xFFFF9839 */
volatile SPI2BRSTR _SPI2BR;                                /* SPI2 Baud Rate Register; 0xFFFF983A */
volatile SPI2SSTR _SPI2S;                                  /* SPI2 Status Register; 0xFFFF983B */
volatile SPI2DSTR _SPI2D;                                  /* SPI2 Data Register; 0xFFFF983D */
volatile PTAPESTR _PTAPE;                                  /* Port A Pull Enable Register; 0xFFFF9840 */
volatile PTASESTR _PTASE;                                  /* Port A Slew Rate Enable Register; 0xFFFF9841 */
volatile PTADSSTR _PTADS;                                  /* Port A Drive Strength Selection Register; 0xFFFF9842 */
volatile PTBPESTR _PTBPE;                                  /* Port B Pull Enable Register; 0xFFFF9844 */
volatile PTBSESTR _PTBSE;                                  /* Port B Slew Rate Enable Register; 0xFFFF9845 */
volatile PTBDSSTR _PTBDS;                                  /* Port B Drive Strength Selection Register; 0xFFFF9846 */
volatile PTCPESTR _PTCPE;                                  /* Port C Pull Enable Register; 0xFFFF9848 */
volatile PTCSESTR _PTCSE;                                  /* Port C Slew Rate Enable Register; 0xFFFF9849 */
volatile PTCDSSTR _PTCDS;                                  /* Port C Drive Strength Selection Register; 0xFFFF984A */
volatile PTDPESTR _PTDPE;                                  /* Port D Pull Enable Register; 0xFFFF984C */
volatile PTDSESTR _PTDSE;                                  /* Port D Slew Rate Enable Register; 0xFFFF984D */
volatile PTDDSSTR _PTDDS;                                  /* Port D Drive Strength Selection Register; 0xFFFF984E */
volatile PTEPESTR _PTEPE;                                  /* Port E Pull Enable Register; 0xFFFF9850 */
volatile PTESESTR _PTESE;                                  /* Port E Slew Rate Enable Register; 0xFFFF9851 */
volatile PTEDSSTR _PTEDS;                                  /* Port E Drive Strength Selection Register; 0xFFFF9852 */
volatile PTFPESTR _PTFPE;                                  /* Port F Pull Enable Register; 0xFFFF9854 */
volatile PTFSESTR _PTFSE;                                  /* Port F Slew Rate Enable Register; 0xFFFF9855 */
volatile PTFDSSTR _PTFDS;                                  /* Port F Drive Strength Selection Register; 0xFFFF9856 */
volatile PTGPESTR _PTGPE;                                  /* Port G Pull Enable Register; 0xFFFF9858 */
volatile PTGSESTR _PTGSE;                                  /* Port G Slew Rate Enable Register; 0xFFFF9859 */
volatile PTGDSSTR _PTGDS;                                  /* Port G Drive Strength Selection Register; 0xFFFF985A */
volatile PTHPESTR _PTHPE;                                  /* Port H Pull Enable Register; 0xFFFF985C */
volatile PTHSESTR _PTHSE;                                  /* Port H Slew Rate Enable Register; 0xFFFF985D */
volatile PTHDSSTR _PTHDS;                                  /* Port H Drive Strength Selection Register; 0xFFFF985E */
volatile PTJPESTR _PTJPE;                                  /* Port J Pull Enable Register; 0xFFFF9860 */
volatile PTJSESTR _PTJSE;                                  /* Port J Slew Rate Enable Register; 0xFFFF9861 */
volatile PTJDSSTR _PTJDS;                                  /* Port J Drive Strength Selection Register; 0xFFFF9862 */
volatile IIC2ASTR _IIC2A;                                  /* IIC Address Register; 0xFFFF9868 */
volatile IIC2FSTR _IIC2F;                                  /* IIC Frequency Divider Register; 0xFFFF9869 */
volatile IIC2C1STR _IIC2C1;                                /* IIC Control Register 1; 0xFFFF986A */
volatile IIC2SSTR _IIC2S;                                  /* IIC Status Register; 0xFFFF986B */
volatile IIC2DSTR _IIC2D;                                  /* IIC Data I/O Register; 0xFFFF986C */
volatile IIC2C2STR _IIC2C2;                                /* IIC Control Register 2; 0xFFFF986D */
volatile SCI2C1STR _SCI2C1;                                /* SCI2 Control Register 1; 0xFFFF9872 */
volatile SCI2C2STR _SCI2C2;                                /* SCI2 Control Register 2; 0xFFFF9873 */
volatile SCI2S1STR _SCI2S1;                                /* SCI2 Status Register 1; 0xFFFF9874 */
volatile SCI2S2STR _SCI2S2;                                /* SCI2 Status Register 2; 0xFFFF9875 */
volatile SCI2C3STR _SCI2C3;                                /* SCI2 Control Register 3; 0xFFFF9876 */
volatile SCI2DSTR _SCI2D;                                  /* SCI2 Data Register; 0xFFFF9877 */
volatile PTCSETSTR _PTCSET;                                /* Port C Data Set Register; 0xFFFF9878 */
volatile PTESETSTR _PTESET;                                /* Port E Data Set Register; 0xFFFF9879 */
volatile PTCCLRSTR _PTCCLR;                                /* Port C Data Clear Register; 0xFFFF987A */
volatile PTECLRSTR _PTECLR;                                /* Port E Data Clear Register; 0xFFFF987B */
volatile PTCTOGSTR _PTCTOG;                                /* Port C Toggle Register; 0xFFFF987C */
volatile PTETOGSTR _PTETOG;                                /* Port E Toggle Register; 0xFFFF987D */
volatile INTC_FRCSTR _INTC_FRC;                            /* INTC Force Interrupt Register; 0xFFFFFFD3 */
volatile INTC_PL6P7STR _INTC_PL6P7;                        /* INTC Programmable Level 6, Priority 7 Register; 0xFFFFFFD8 */
volatile INTC_PL6P6STR _INTC_PL6P6;                        /* INTC Programmable Level 6, Priority 6 Register; 0xFFFFFFD9 */
volatile INTC_WCRSTR _INTC_WCR;                            /* INTC Wake-up Control Register; 0xFFFFFFDB */
volatile INTC_SFRCSTR _INTC_SFRC;                          /* INTC Set Interrupt Force Register; 0xFFFFFFDE */
volatile INTC_CFRCSTR _INTC_CFRC;                          /* INTC Clear Interrupt Force Register; 0xFFFFFFDF */
volatile INTC_SWIACKSTR _INTC_SWIACK;                      /* INTC Software IACK Register; 0xFFFFFFE0 */
volatile INTC_LVL1IACKSTR _INTC_LVL1IACK;                  /* INTC Level 1 IACK Register; 0xFFFFFFE4 */
volatile INTC_LVL2IACKSTR _INTC_LVL2IACK;                  /* INTC Level 2 IACK Register; 0xFFFFFFE8 */
volatile INTC_LVL3IACKSTR _INTC_LVL3IACK;                  /* INTC Level 3 IACK Register; 0xFFFFFFEC */
volatile INTC_LVL4IACKSTR _INTC_LVL4IACK;                  /* INTC Level 4 IACK Register; 0xFFFFFFF0 */
volatile INTC_LVL5IACKSTR _INTC_LVL5IACK;                  /* INTC Level 5 IACK Register; 0xFFFFFFF4 */
volatile INTC_LVL6IACKSTR _INTC_LVL6IACK;                  /* INTC Level 6 IACK Register; 0xFFFFFFF8 */
volatile INTC_LVL7IACKSTR _INTC_LVL7IACK;                  /* INTC Level 7 IACK Register; 0xFFFFFFFC */


/* * * * *  16-BIT REGISTERS  * * * * * * * * * * * * * * * */
volatile RGPIO_DIRSTR _RGPIO_DIR;                          /* RGPIO Data Direction Register; 0x00C00000 */
volatile RGPIO_DATASTR _RGPIO_DATA;                        /* RGPIO Data Register; 0x00C00002 */
volatile RGPIO_ENBSTR _RGPIO_ENB;                          /* RGPIO Pin Enable Register; 0x00C00004 */
volatile RGPIO_CLRSTR _RGPIO_CLR;                          /* RGPIO Clear Data Register; 0x00C00006 */
volatile RGPIO_SETSTR _RGPIO_SET;                          /* RGPIO Set Data Register; 0x00C0000A */
volatile RGPIO_TOGSTR _RGPIO_TOG;                          /* RGPIO Toggle Data Register; 0x00C0000E */
volatile ADCRSTR _ADCR;                                    /* Data Result Register; 0xFFFF8012 */
volatile ADCCVSTR _ADCCV;                                  /* Compare Value Register; 0xFFFF8014 */
volatile SCI1BDSTR _SCI1BD;                                /* SCI1 Baud Rate Register; 0xFFFF8020 */
volatile TPM1CNTSTR _TPM1CNT;                              /* TPM1 Timer Counter Register; 0xFFFF8041 */
volatile TPM1MODSTR _TPM1MOD;                              /* TPM1 Timer Counter Modulo Register; 0xFFFF8043 */
volatile TPM1C0VSTR _TPM1C0V;                              /* TPM1 Timer Channel 0 Value Register; 0xFFFF8046 */
volatile TPM1C1VSTR _TPM1C1V;                              /* TPM1 Timer Channel 1 Value Register; 0xFFFF8049 */
volatile TPM1C2VSTR _TPM1C2V;                              /* TPM1 Timer Channel 2 Value Register; 0xFFFF804C */
volatile TPM2CNTSTR _TPM2CNT;                              /* TPM2 Timer Counter Register; 0xFFFF8051 */
volatile TPM2MODSTR _TPM2MOD;                              /* TPM2 Timer Counter Modulo Register; 0xFFFF8053 */
volatile TPM2C0VSTR _TPM2C0V;                              /* TPM2 Timer Channel 0 Value Register; 0xFFFF8056 */
volatile TPM2C1VSTR _TPM2C1V;                              /* TPM2 Timer Channel 1 Value Register; 0xFFFF8059 */
volatile TPM2C2VSTR _TPM2C2V;                              /* TPM2 Timer Channel 2 Value Register; 0xFFFF805C */
volatile TPM3CNTSTR _TPM3CNT;                              /* TPM3 Timer Counter Register; 0xFFFF8061 */
volatile TPM3MODSTR _TPM3MOD;                              /* TPM3 Timer Counter Modulo Register; 0xFFFF8063 */
volatile TPM3C0VSTR _TPM3C0V;                              /* TPM3 Timer Channel 0 Value Register; 0xFFFF8066 */
volatile TPM3C1VSTR _TPM3C1V;                              /* TPM3 Timer Channel 1 Value Register; 0xFFFF8069 */
volatile TPM3C2VSTR _TPM3C2V;                              /* TPM3 Timer Channel 2 Value Register; 0xFFFF806C */
volatile TPM3C3VSTR _TPM3C3V;                              /* TPM3 Timer Channel 3 Value Register; 0xFFFF806F */
volatile TPM3C4VSTR _TPM3C4V;                              /* TPM3 Timer Channel 4 Value Register; 0xFFFF8072 */
volatile TPM3C5VSTR _TPM3C5V;                              /* TPM3 Timer Channel 5 Value Register; 0xFFFF8075 */
volatile SDIDSTR _SDID;                                    /* System Device Identification Register; 0xFFFF9806 */
volatile SCI2BDSTR _SCI2BD;                                /* SCI2 Baud Rate Register; 0xFFFF9870 */

/*lint -restore */

/* EOF */
/*!
** @}
*/
/*
** ###################################################################
**
**     This file was created by Processor Expert 10.3 [05.09]
**     for the Freescale ColdFireV1 series of microcontrollers.
**
** ###################################################################
*/
