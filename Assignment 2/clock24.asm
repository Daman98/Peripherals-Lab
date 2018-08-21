cpu "8085.tbl"
hof "int8"

org 9000h
GTHEX: EQU 030EH				;Gets hex digits and displays them
HXDSP: EQU 034FH				;Expands hex digits for display
OUTPUT:EQU 0389H				;Outputs characters to display
CLEAR: EQU 02BEH				;Clears the display
RDKBD: EQU 03BAH				;Reads keyboard

CURDT: EQU 8FF1H				;address of display
UPDDT: EQU 044cH				;data of display
CURAD: EQU 8FEFH				;Updates Data field of the display
UPDAD: EQU 0440H				;Updates Address field of the display

MVI A,00H 						;next 14 instructions used to display
MVI B,00H 						;"cloc" on display showing start of clock

LXI H,8840H
MVI M,0CH

LXI H,8841H
MVI M,11H

LXI H,8842H
MVI M,00H

LXI H,8843H
MVI M,0CH

LXI H,8840H
CALL OUTPUT
CALL RDKBD
CALL CLEAR 						;clear the display


MVI A,00H
MVI B,00H
Call gthex 						;take input time from keyboard
MOV H,D 						;store in H-L register
MOV L,E

CHN_HR:							;check if hour if greater than 24
	MOV A,H
	CPI 24H
	JC CHN_MM
START:							;set hours to 0 if hours>=24
	MVI H,00H
	JC BLK_JMP
CHN_MM:							;check if min if greater than 60
	MOV A,L
	CPI 60H
	JC BLK_JMP
CHN_SEC:
	MVI L,00H 					;set min to 0 if hours>=60
BLK_JMP:
	;LXI H,0000H

CHNG_HR_MIN:							;start seconds counter from 0s
	SHLD CURAD
	MVI A,00H
INCR_SEC:
	STA CURDT
	CALL UPDAD					;update display
	CALL UPDDT
	CALL DELAY					;call delay which runs for 1second
	LDA CURDT
	ADI 01H						;increment seconds by 1
	DAA
	CPI 60H						;check if seconds reach 60
	JNZ INCR_SEC
	LHLD CURAD
	MOV A,L
	ADI 01H						;increment minutes by 1
	DAA
	MOV L,A
	CPI 60H 					;check if minutes reach 60
	JNZ CHNG_HR_MIN
	MVI L,00H
	MOV A,H
	ADI 01H 					;increment hour by 1
	DAA
	MOV H,A
	CPI 24H						;check if hour reach 24
	JNZ CHNG_HR_MIN
	LXI H,0000H
	JMP TWENTY_FOUR
DELAY: 							;delays machine by 1 second
	MVI C,03H
OUTLOOP:
	LXI D,0A604H
INLOOP: 						;reapeatedly run inloop as many times as
	DCX D 						;frequency of microprocessor
	MOV A,D
	ORA E
	JNZ INLOOP
	DCR C
	JNZ OUTLOOP
	RET