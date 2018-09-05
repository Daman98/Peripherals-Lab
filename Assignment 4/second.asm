
cpu "8085.tbl"
hof "int8"
org 9000h
RDKBD: EQU 03BAH

MVI A,8BH                ; ports initialization for both peripherals.
OUT 43H

MVI A,80H
OUT 03H

MVI A,00H
STA 8600H

MVI A,00H
STA 8601H

START:

MVI D,00H 				 ; channel initialization
MVI E,00H
CALL CONVERT 			 ; converting analog to digital
STA 8501H
CALL DELAY

LDA 8501H

CALL DISPLAY			 ; displaying the converted value on data position.


LDA 8501H   			 ; stroring the number at two locations, one for clockwise movement and other for anti-clockwise(return to 0)
STA 8600H
LDA 8501H
STA 8601H

MVI A,88H				 ; stepper motor initialization 

LOOP:
PUSH PSW    			 ; saving the state
OUT 00H
LDA 8600H     			 ; rotating it for no. of times stored in 8600.
CPI 00H 				 ; if no. of rotations left=0, call stop
JZ STOP
LDA 8600H
DCR A 					 ; else decrease the no. of rotations left
STA 8600H
LDA 8600H   
JZ STOP
CALL DELAY
POP PSW 				
RRC						 ; rotating it in clockwise manner.
JMP LOOP

STOP: 					; waits for a keyboard input.
CALL RDKBD

MVI A,88H 			 	; port initialization
LOOP2:
PUSH PSW 				; saving the state
OUT 00H
LDA 8601H 				; rotating the same number of times just in anti clockwise manner.
CPI 00H
JZ START
LDA 8601H
DCR A
STA 8601H
LDA 8601H
JZ START
CALL DELAY
POP PSW
RLC						; doing in order to avoid drift
JMP LOOP2
JMP START


DELAY:    				; wasting time by looping in inloop and outloop
	MVI C,03H
OUTLOOP:
	LXI D,00FFH
INLOOP:  				; operated for 00ffh times.
	DCX D
	MOV A,D
	ORA E
	JNZ INLOOP
	DCR C
	JNZ OUTLOOP
	RET



CONVERT:                
	MVI A,00H 			; intilaize channel
	ORA D 				; add the channel no.
	OUT 40H

	; START SIGNAL
	MVI A,20H			; assert for start signal
	ORA D 				; for A to D conversion
	OUT 40H
	
	NOP
	NOP
	
	; START PULSE OVER
	MVI A,00H      		; start pulse over
	ORA D
	OUT 40H


WAIT1:	
	IN 42H				; check EOC
	ANI 01H
	JNZ WAIT1 			; check until EOC goes down
WAIT2:
	IN 42H				; check EOC
	ANI 01H
	JZ WAIT2			; wait until EOC goes up



; READ SIGNAL
	MVI A,40H
	ORA D
	OUT 40H
	NOP

	IN 41H				; GET THE CONVERTED DATA FROM PORT B

	PUSH PSW			; SAVE A SO THAT WE CAN DEASSERT THE SIGNAL

	MVI A,00H 			; DEASSERT READ SIGNAL 
	ORA D
	OUT 40H
	POP PSW

RET

DISPLAY:
		call DELAY 		
		LDA 8501H
		PUSH PSW		; save the digital value


DISPKBD:
		MOV A,E 		; channel number i sstored in LS byte of ad. field
		STA 8FEFH
		XRA A 			; zero is stored in M.S byte of ad. field
		STA 8FF0H
		POP PSW			; digital value is stored in data field
		STA 8FF1H
		PUSH D 			; save reg D and E.
		MVI B,00H
		CALL 0440H 		; display without dot the ad. field
		MVI B,00H
		CALL 0440H 		; display without dot the data field
		MVI B,00
		CALL 044CH 		; get back reg D and E.
		POP D
		RET

