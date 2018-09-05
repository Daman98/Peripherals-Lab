
cpu "8085.tbl"
hof "int8"
org 9000h

MVI A,8BH                ; ports initialization for both peripherals.
OUT 43H

MVI A,80H
OUT 03H


MVI A,88H
LOOP:
PUSH PSW                 ; saving the state
OUT 00H
MVI D,00H                ; channel initialization
MVI E,00H
CALL CONVERT             ; converting analog to digital
STA 8501H
MOV B,A 			
MVI A,0FFH				 ; subtracting the value from FF and running the delay loop for the new number of times.
SUB B
MOV C,A
STA 8500H				 ; for a larger value, delay has to be small and vice-versa.
CALL DELAY

MVI D,00H
MVI E,00H   			 ; channel initialization
MVI A,32H
MVI C,04H
STA 8500H
LDA 8501H				 

CALL DISPLAY             ; displaying the converted value on data position.
POP PSW
RRC						 ; rotating clockwise
JMP LOOP


DELAY:                   ; delaying the whole process by square of value of number stored at 8500.
	LOOP4a:  MVI D,01H
	LOOP1a: LDA 8500H  
	MOV E, A
	LOOP2a:  DCR E
	    JNZ LOOP2a
	    DCR D
	    JNZ LOOP1a
	    DCR C
	    JNZ LOOP4a
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

