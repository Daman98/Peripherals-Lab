cpu "8085.tbl"
hof "int8"

org 9000h 

MVI A,8BH
OUT 03H

BEGIN:	
	CALL TERMCOND   ;Check if 2nd dip switch is high, if high then terminate.
	IN 01H
	ANI 004H   		
	CPI 04H
	JZ CONT         ;Check if 6th switch is high, if yes increment count else repeat.
	JMP BEGIN
	RST 5
;In this function we will simply increment the count and between every iteration we will check for 5th and second switch.

CONT:
	MVI A,01H            
	OUT 00H
	CALL DELAY
	MVI A,02H
	OUT 00H
	CALL DELAY
	MVI A,04H
	OUT 00H
	CALL DELAY
	MVI A,08H
	OUT 00H
	CALL DELAY
	MVI A,10H
	OUT 00H
	CALL DELAY
	MVI A,20H
	OUT 00H
	CALL DELAY
	MVI A,40H
	OUT 00H
	CALL DELAY
	MVI A,80H
	OUT 00H
	CALL DELAY
	JMP CONT

;Checking D2
TERMCOND:
	IN 01H
	ANI 040H
	CPI 40H
	JZ TERMINATE
	RET

;Check d5 and d2, if both low then we will delay and return.
DELAY:

CALL PAUSECOND
CALL TERMCOND

MVI C,03H

OUTLOOP:
	LXI D,0A604H

INLOOP:
	DCX D
	MOV A,D
	ORA E
	JNZ INLOOP
	DCR C
	JNZ OUTLOOP
	RET


TERMINATE:
	MVI A, 00H
	OUT 00H
	RST 5


PAUSECOND:

BEG:
	CALL TERMCOND
	IN 01H
	MOV D,A
	ANI 008H
	CPI 08H
	JZ BEG
	MOV A,D
	ANI 004H
	CPI 04H
	JNZ BEG
	RET