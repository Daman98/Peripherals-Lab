cpu "8085.tbl"
hof "int8"

org 9000h
GTHEX: EQU 030EH    		;Gets hex digits and displays them
HXDSP: EQU 034FH			;Expands hex digits for display
OUTPUT:EQU 0389H			;Outputs characters to display
CLEAR: EQU 02BEH			;Clears the display
RDKBD: EQU 03BAH			;Reads keyboard
KBINT: EQU 3CH		

CURDT: EQU 8FF1H			;address of display
UPDDT: EQU 044cH			;data of display
CURAD: EQU 8FEFH			;Updates Data field of the display
UPDAD: EQU 0440H			;Updates Address field of the display

MVI A,00H 					;next 14 instructions used to display
MVI B,00H 					;"cloc" on display showing start of clock 

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
CALL CLEAR 					;clear the display

MVI A,00H
MVI B,00H
Call gthex 					;take input time from keyboard
MOV H,D 					;store in H-L register
MOV L,E


CHN_MM:						;checks if minutes input is less than 60
	MOV A,L
	CPI 60H
	JC BLK_JMP
CHN_SEC:						;if min>60 set to 59
	MVI L,59H 	
BLK_JMP:
	;LXI H,0000H

CHN_HR_MIN:						;start seconds counter from 59s
	SHLD CURAD
	MVI A,59H
DECR_SEC:
    STA 8200H
    MVI A,0BH
    SIM						;check after each second if any interrupt is
	EI						;coming
	LDA 8200H
	STA CURDT				;update display
	CALL UPDAD
	CALL UPDDT
	CALL DELAY				;call delay which runs for 1second
    
	LDA CURDT
	CPI 00H 				;check if seconds reach 0
	JZ MIN
	CALL SUBTRACT_FUNCTION 				;bcd subtractor of seconds by 1
	JMP DECR_SEC
	MIN:
	LHLD CURAD
	MOV A,L
	CPI 00H 				;check if minute reach 0
	JZ HOUR					
	CALL SUBTRACT_FUNCTION 				;if not 0,reduce minute by 1;
	MOV L,A
	JMP CHN_HR_MIN
	HOUR:					;check if hour reach 0
	MVI L,59H				
	MOV A,H
	CPI 00H  				
	JZ BREAK 				;stop timer if hour reaches 0
	CALL SUBTRACT_FUNCTION
	MOV H,A
	JMP TWENTY_FOUR
BREAK:
	RST 5
DELAY:						;delays machine by 1 second
	MVI C,03H
OUTLOOP:
	LXI D,0A604H			
INLOOP:						;reapeatedly run inloop as many times as
	DCX D 					;frequency of microprocessor
	MOV A,D
	ORA E
	JNZ INLOOP
	DCR C
	JNZ OUTLOOP
	RET

LAB:  						;ISR to store values of program
	PUSH PSW
	CALL RDKBD 				;when another interrupt comes,restore original
	POP PSW					;values
	EI
	RET

SUBTRACT_FUNCTION:						;bcd subtractor 
 STA 8202H
 ANI 0FH
 CPI 00H
 JZ SUBTRACT_HELPER
 LDA 8202H
 DCR A
 RET
 SUBTRACT_HELPER:
 LDA 8202H
 SBI 07H
 RET

