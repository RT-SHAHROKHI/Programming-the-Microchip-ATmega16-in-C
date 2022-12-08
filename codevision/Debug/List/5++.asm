
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_digit:
	.DB  0x40,0xF9,0x24,0x30,0x19,0x12,0x2,0x78
	.DB  0x0,0x10
_hell:
	.DB  0x9,0x6,0xC7,0xC7

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include<mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include<delay.h>
;flash unsigned char
;digit[10]={0b01000000,0b011111001,0b00100100,0b00110000,0b00011001,0b00010010,0b00000010,0b01111000,0b00000000,0b0001000 ...
;flash unsigned char
;hell[4]={0b00001001 , 0b00000110 , 0b011000111 ,0b011000111  };       //----- it also could be like :  hel[3]={0b0000100 ...
;void  main(void)
; 0000 0008 {

	.CSEG
_main:
; .FSTART _main
; 0000 0009  char i=0;   // in 4 digit nymbers : stands for | [4]321 | &  2 digit nymbers : stands for | [2]1 |
; 0000 000A  char j=0;   // in 4 digit nymbers : stands for | 4[3]21 | &                               | 2[1] |
; 0000 000B  char m=0;   // in 4 digit nymbers : stands for | 43[2]1 |
; 0000 000C  char n=0;   // in 4 digit nymbers : stands for | 432[1] |
; 0000 000D  int z=0;    // just for show & time set
; 0000 000E 
; 0000 000F 
; 0000 0010  DDRB=0Xff;  // 7seg output
;	i -> R17
;	j -> R16
;	m -> R19
;	n -> R18
;	z -> R20,R21
	LDI  R17,0
	LDI  R16,0
	LDI  R19,0
	LDI  R18,0
	__GETWRN 20,21,0
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0011  PORTB=0X00; //
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0012 
; 0000 0013  DDRD=0Xff;  // for  output control
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0014  PORTD=0X00; //
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0015 
; 0000 0016  DDRA=0X00;  // for tst push btn [a6 a5] &  dip switch [a0 a1 a2 a3 a4]
	OUT  0x1A,R30
; 0000 0017 
; 0000 0018      while(1)
_0x3:
; 0000 0019     {
; 0000 001A         //part 1
; 0000 001B         if(PINA.0==1)// dip btn 1 -> pina.0
	SBIS 0x19,0
	RJMP _0x6
; 0000 001C         {
; 0000 001D                // j=9;  //for checking dec
; 0000 001E                // i=9;  //
; 0000 001F                 while(1)
_0x7:
; 0000 0020                 {
; 0000 0021                 A :
_0xA:
; 0000 0022                      for (z=0;z<25;z++) // show part
	__GETWRN 20,21,0
_0xC:
	__CPWRN 20,21,25
	BRGE _0xD
; 0000 0023                      {
; 0000 0024                        PORTD=1;
	RCALL SUBOPT_0x0
; 0000 0025                        PORTB=digit[i];
; 0000 0026                        delay_ms(1);
; 0000 0027 
; 0000 0028                        PORTD=0X02;
; 0000 0029                        PORTB=digit[j];
; 0000 002A                        delay_ms(1);
; 0000 002B                       }
	__ADDWRN 20,21,1
	RJMP _0xC
_0xD:
; 0000 002C 
; 0000 002D 
; 0000 002E                         while(PINA.5==0) goto dec ;  // if you want to check you can comment this line
	SBIS 0x19,5
	RJMP _0x11
; 0000 002F 
; 0000 0030                         if(j==9)
	CPI  R16,9
	BRNE _0x12
; 0000 0031                         {
; 0000 0032                           if(i==9)
	CPI  R17,9
	BRNE _0x13
; 0000 0033                           {
; 0000 0034                            //if (j==9)
; 0000 0035                            {i=-1;}  //  [9](9) -> [0](9not_important_here)  ; i=-1 cuse will be +1 and i will be = 0 IN  ...
	LDI  R17,LOW(255)
; 0000 0036                           }
; 0000 0037 
; 0000 0038                          j= -1 ;  // j from [9] -> [0]   in **
_0x13:
	LDI  R16,LOW(255)
; 0000 0039                          i+=1;  // number + 10 ; if A[9] + 0[1] = [a+1]0    here is [[[[ *  ]]]]
	SUBI R17,-LOW(1)
; 0000 003A                         }
; 0000 003B                         j+=1;   // number + 1            here is [[[[ ** ]]]]]
_0x12:
	SUBI R16,-LOW(1)
; 0000 003C 
; 0000 003D                        /*
; 0000 003E                         while(PINA.5==1)
; 0000 003F                         {
; 0000 0040                          for (z=0;z<25;z++) // show part
; 0000 0041                          {
; 0000 0042                          PORTD=1;
; 0000 0043                          PORTB=digit[i];
; 0000 0044                          delay_ms(1);
; 0000 0045 
; 0000 0046                          PORTD=0X02;
; 0000 0047                          PORTB=digit[j];
; 0000 0048                          delay_ms(1);
; 0000 0049                          }
; 0000 004A                         }
; 0000 004B                        */
; 0000 004C                         ////////////////////////////////////////////////////////////////////////
; 0000 004D 
; 0000 004E                 dec:
_0x11:
; 0000 004F 
; 0000 0050                       while(PINA.6==0) goto A ;  // if you want to check you can comment this line
	SBIS 0x19,6
	RJMP _0xA
; 0000 0051 
; 0000 0052                         if(j==0)
	CPI  R16,0
	BRNE _0x17
; 0000 0053                         {
; 0000 0054                           if(i==0)
	CPI  R17,0
	BRNE _0x18
; 0000 0055                           {
; 0000 0056                            if (j==0){ i=10; }  //  [0](0) ->
	CPI  R16,0
	BRNE _0x19
	LDI  R17,LOW(10)
; 0000 0057                           }
_0x19:
; 0000 0058 
; 0000 0059                          j= 10 ;  // j from [0] will be -> [9 ]   in **
_0x18:
	LDI  R16,LOW(10)
; 0000 005A                          i-=1;  // number - 10 ; if [j]A - [1]0 = [j-1]A    here is [[[[ *  ]]]]
	SUBI R17,LOW(1)
; 0000 005B                         }
; 0000 005C                         j-=1;   // number + 1            here is [[[[ ** ]]]]]
_0x17:
	SUBI R16,LOW(1)
; 0000 005D 
; 0000 005E                         while(PINA.6==1)
_0x1A:
	SBIS 0x19,6
	RJMP _0x1C
; 0000 005F                         {
; 0000 0060                          for (z=0;z<25;z++) // show part
	__GETWRN 20,21,0
_0x1E:
	__CPWRN 20,21,25
	BRGE _0x1F
; 0000 0061                          {
; 0000 0062                          PORTD=1;
	RCALL SUBOPT_0x0
; 0000 0063                          PORTB=digit[i];
; 0000 0064                          delay_ms(1);
; 0000 0065 
; 0000 0066                          PORTD=0X02;
; 0000 0067                          PORTB=digit[j];
; 0000 0068                          delay_ms(1);
; 0000 0069                          }
	__ADDWRN 20,21,1
	RJMP _0x1E
_0x1F:
; 0000 006A                         }
	RJMP _0x1A
_0x1C:
; 0000 006B 
; 0000 006C 
; 0000 006D 
; 0000 006E                     }
	RJMP _0x7
; 0000 006F 
; 0000 0070 
; 0000 0071 
; 0000 0072            }
; 0000 0073         //end part 1
; 0000 0074 
; 0000 0075            //part2     HELL
; 0000 0076            if(PINA.1==1) //dip btn 2 -> pina.1
_0x6:
	SBIS 0x19,1
	RJMP _0x20
; 0000 0077            {
; 0000 0078             for (z=0;z<250;z++)
	__GETWRN 20,21,0
_0x22:
	__CPWRN 20,21,250
	BRGE _0x23
; 0000 0079             {
; 0000 007A                 PORTD=1;
	LDI  R30,LOW(1)
	OUT  0x12,R30
; 0000 007B                 PORTB=hell[0];
	LDI  R30,LOW(_hell*2)
	LDI  R31,HIGH(_hell*2)
	RCALL SUBOPT_0x1
; 0000 007C                 delay_ms(1);
; 0000 007D 
; 0000 007E                  PORTD=0X02;
	LDI  R30,LOW(2)
	OUT  0x12,R30
; 0000 007F                  PORTB=hell[1];
	__POINTW1FN _hell,1
	RCALL SUBOPT_0x1
; 0000 0080                  delay_ms(1);
; 0000 0081 
; 0000 0082                  PORTD=0X04;
	LDI  R30,LOW(4)
	OUT  0x12,R30
; 0000 0083                  PORTB=hell[2];
	__POINTW1FN _hell,2
	RCALL SUBOPT_0x1
; 0000 0084                  delay_ms(1);
; 0000 0085 
; 0000 0086                  PORTD=0X08;
	LDI  R30,LOW(8)
	OUT  0x12,R30
; 0000 0087                  PORTB=hell[3];//    or  PORTB=hell[2]; again
	__POINTW1FN _hell,3
	RCALL SUBOPT_0x1
; 0000 0088                  delay_ms(1);
; 0000 0089             }
	__ADDWRN 20,21,1
	RJMP _0x22
_0x23:
; 0000 008A            }
; 0000 008B 
; 0000 008C         //part 3     0 TO 9999
; 0000 008D         if(PINA.2==1)// dip btn 3 -> pina.2
_0x20:
	SBIS 0x19,2
	RJMP _0x24
; 0000 008E         {
; 0000 008F          for (i=0;i<10;i++)
	LDI  R17,LOW(0)
_0x26:
	CPI  R17,10
	BRSH _0x27
; 0000 0090          {
; 0000 0091             for(j=0;j<10;j++)
	LDI  R16,LOW(0)
_0x29:
	CPI  R16,10
	BRSH _0x2A
; 0000 0092             {
; 0000 0093               for(m=0;m<10;m++)
	LDI  R19,LOW(0)
_0x2C:
	CPI  R19,10
	BRSH _0x2D
; 0000 0094               {
; 0000 0095                  for(n=0;n<10;n++)
	LDI  R18,LOW(0)
_0x2F:
	CPI  R18,10
	BRSH _0x30
; 0000 0096                  {
; 0000 0097                    for (z=0;z<25;z++)
	__GETWRN 20,21,0
_0x32:
	__CPWRN 20,21,25
	BRGE _0x33
; 0000 0098                    {
; 0000 0099                      PORTD=1;
	RCALL SUBOPT_0x0
; 0000 009A                      PORTB=digit[i];
; 0000 009B                      delay_ms(1);
; 0000 009C 
; 0000 009D                      PORTD=0X02;
; 0000 009E                      PORTB=digit[j];
; 0000 009F                      delay_ms(1);
; 0000 00A0 
; 0000 00A1                      PORTD=0X04;
	RCALL SUBOPT_0x2
; 0000 00A2                      PORTB=digit[m];
; 0000 00A3                      delay_ms(1);
; 0000 00A4 
; 0000 00A5                      PORTD=0X08;
	RCALL SUBOPT_0x3
; 0000 00A6                      PORTB=digit[n];
; 0000 00A7                      delay_ms(1);
; 0000 00A8 
; 0000 00A9                    }
	__ADDWRN 20,21,1
	RJMP _0x32
_0x33:
; 0000 00AA                  }
	SUBI R18,-1
	RJMP _0x2F
_0x30:
; 0000 00AB               }
	SUBI R19,-1
	RJMP _0x2C
_0x2D:
; 0000 00AC             }
	SUBI R16,-1
	RJMP _0x29
_0x2A:
; 0000 00AD           }
	SUBI R17,-1
	RJMP _0x26
_0x27:
; 0000 00AE         }
; 0000 00AF 
; 0000 00B0         //part 4      9999 TO 0
; 0000 00B1         if(PINA.3==1)// dip btn 4 -> pin.a3
_0x24:
	SBIS 0x19,3
	RJMP _0x34
; 0000 00B2         {
; 0000 00B3          for (i=9;i>0;i--)
	LDI  R17,LOW(9)
_0x36:
	CPI  R17,1
	BRLO _0x37
; 0000 00B4          {
; 0000 00B5             for(j=9;j>0;j--)
	LDI  R16,LOW(9)
_0x39:
	CPI  R16,1
	BRLO _0x3A
; 0000 00B6             {
; 0000 00B7 
; 0000 00B8               for(m=9;m>0;m--)
	LDI  R19,LOW(9)
_0x3C:
	CPI  R19,1
	BRLO _0x3D
; 0000 00B9               {
; 0000 00BA                  for(n=9;n>0;n--)
	LDI  R18,LOW(9)
_0x3F:
	CPI  R18,1
	BRLO _0x40
; 0000 00BB                  {
; 0000 00BC                    for (z=0;z<25;z++)
	__GETWRN 20,21,0
_0x42:
	__CPWRN 20,21,25
	BRGE _0x43
; 0000 00BD                    {
; 0000 00BE                      PORTD=1;
	RCALL SUBOPT_0x0
; 0000 00BF                      PORTB=digit[i];
; 0000 00C0                      delay_ms(1);
; 0000 00C1 
; 0000 00C2                      PORTD=0X02;
; 0000 00C3                      PORTB=digit[j];
; 0000 00C4                      delay_ms(1);
; 0000 00C5 
; 0000 00C6                      PORTD=0X04;
	RCALL SUBOPT_0x2
; 0000 00C7                      PORTB=digit[m];
; 0000 00C8                      delay_ms(1);
; 0000 00C9 
; 0000 00CA                      PORTD=0X08;
	RCALL SUBOPT_0x3
; 0000 00CB                      PORTB=digit[n];
; 0000 00CC                      delay_ms(1);
; 0000 00CD                   }
	__ADDWRN 20,21,1
	RJMP _0x42
_0x43:
; 0000 00CE                 }
	SUBI R18,1
	RJMP _0x3F
_0x40:
; 0000 00CF                }
	SUBI R19,1
	RJMP _0x3C
_0x3D:
; 0000 00D0             }
	SUBI R16,1
	RJMP _0x39
_0x3A:
; 0000 00D1          }
	SUBI R17,1
	RJMP _0x36
_0x37:
; 0000 00D2       }
; 0000 00D3 
; 0000 00D4         //part 5      MY PHONE NUMBER
; 0000 00D5         if(PINA.4==1)// dip btn 5 -> pina.4
_0x34:
	SBIS 0x19,4
	RJMP _0x44
; 0000 00D6         {
; 0000 00D7               while(1)
_0x45:
; 0000 00D8               {
; 0000 00D9                  for (z=0;z<250;z++) //--0912
	__GETWRN 20,21,0
_0x49:
	__CPWRN 20,21,250
	BRGE _0x4A
; 0000 00DA                  {
; 0000 00DB                      PORTD=1;
	LDI  R30,LOW(1)
	OUT  0x12,R30
; 0000 00DC                      PORTB=digit[0];
	LDI  R30,LOW(_digit*2)
	LDI  R31,HIGH(_digit*2)
	RCALL SUBOPT_0x1
; 0000 00DD                      delay_ms(1);
; 0000 00DE 
; 0000 00DF                      PORTD=0X02;
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x4
; 0000 00E0                      PORTB=digit[9];
; 0000 00E1                      delay_ms(1);
; 0000 00E2 
; 0000 00E3                      PORTD=0X04;
	LDI  R30,LOW(4)
	OUT  0x12,R30
; 0000 00E4                      PORTB=digit[1];
	__POINTW1FN _digit,1
	RCALL SUBOPT_0x1
; 0000 00E5                      delay_ms(1);
; 0000 00E6 
; 0000 00E7                      PORTD=0X08;
	LDI  R30,LOW(8)
	OUT  0x12,R30
; 0000 00E8                      PORTB=digit[2];
	__POINTW1FN _digit,2
	RCALL SUBOPT_0x1
; 0000 00E9                      delay_ms(1);
; 0000 00EA                  }
	__ADDWRN 20,21,1
	RJMP _0x49
_0x4A:
; 0000 00EB 
; 0000 00EC                     for (z=0;z<250;z++) //--933
	__GETWRN 20,21,0
_0x4C:
	__CPWRN 20,21,250
	BRGE _0x4D
; 0000 00ED                     {
; 0000 00EE                      PORTD=1;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x4
; 0000 00EF                      PORTB=digit[9];
; 0000 00F0                      delay_ms(1);
; 0000 00F1 
; 0000 00F2                      PORTD=0X02;
	LDI  R30,LOW(2)
	OUT  0x12,R30
; 0000 00F3                      PORTB=digit[3];
	__POINTW1FN _digit,3
	RCALL SUBOPT_0x1
; 0000 00F4                      delay_ms(1);
; 0000 00F5 
; 0000 00F6                      PORTD=0X04;
	LDI  R30,LOW(4)
	OUT  0x12,R30
; 0000 00F7                      PORTB=digit[3];
	__POINTW1FN _digit,3
	RCALL SUBOPT_0x1
; 0000 00F8                      delay_ms(1);
; 0000 00F9                     }
	__ADDWRN 20,21,1
	RJMP _0x4C
_0x4D:
; 0000 00FA 
; 0000 00FB                     for (z=0;z<250;z++) //--6709
	__GETWRN 20,21,0
_0x4F:
	__CPWRN 20,21,250
	BRGE _0x50
; 0000 00FC                     {
; 0000 00FD 
; 0000 00FE                      PORTD=1;
	LDI  R30,LOW(1)
	OUT  0x12,R30
; 0000 00FF                      PORTB=digit[6];
	__POINTW1FN _digit,6
	RCALL SUBOPT_0x1
; 0000 0100                      delay_ms(1);
; 0000 0101 
; 0000 0102                      PORTD=0x02;
	LDI  R30,LOW(2)
	OUT  0x12,R30
; 0000 0103                      PORTB=digit[7];
	__POINTW1FN _digit,7
	RCALL SUBOPT_0x1
; 0000 0104                      delay_ms(1);
; 0000 0105 
; 0000 0106                      PORTD=0X04;
	LDI  R30,LOW(4)
	OUT  0x12,R30
; 0000 0107                      PORTB=digit[0];
	LDI  R30,LOW(_digit*2)
	LDI  R31,HIGH(_digit*2)
	RCALL SUBOPT_0x1
; 0000 0108                      delay_ms(1);
; 0000 0109 
; 0000 010A                      PORTD=0X08;
	LDI  R30,LOW(8)
	RCALL SUBOPT_0x4
; 0000 010B                      PORTB=digit[9];
; 0000 010C                      delay_ms(1);
; 0000 010D                     }
	__ADDWRN 20,21,1
	RJMP _0x4F
_0x50:
; 0000 010E               }
	RJMP _0x45
; 0000 010F         }
; 0000 0110 
; 0000 0111     }
_0x44:
	RJMP _0x3
; 0000 0112  }
_0x51:
	RJMP _0x51
; .FEND

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(1)
	OUT  0x12,R30
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_digit*2)
	SBCI R31,HIGH(-_digit*2)
	LPM  R0,Z
	OUT  0x18,R0
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
	LDI  R30,LOW(2)
	OUT  0x12,R30
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_digit*2)
	SBCI R31,HIGH(-_digit*2)
	LPM  R0,Z
	OUT  0x18,R0
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x1:
	LPM  R0,Z
	OUT  0x18,R0
	LDI  R26,LOW(1)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(4)
	OUT  0x12,R30
	MOV  R30,R19
	LDI  R31,0
	SUBI R30,LOW(-_digit*2)
	SBCI R31,HIGH(-_digit*2)
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(8)
	OUT  0x12,R30
	MOV  R30,R18
	LDI  R31,0
	SUBI R30,LOW(-_digit*2)
	SBCI R31,HIGH(-_digit*2)
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	OUT  0x12,R30
	__POINTW1FN _digit,9
	RJMP SUBOPT_0x1


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
