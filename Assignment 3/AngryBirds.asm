cpu "8085.tbl"
hof "int8"

org 9000h

GTHEX: EQU 030EH
HXDSP: EQU 034FH
OUTPUT:EQU 0389H
CLEAR: EQU 02BEH
RDKBD: EQU 03BAH
KBINT: EQU 3CH

CURDT: EQU 8FF1H
UPDDT: EQU 044cH
CURAD: EQU 8FEFH
UPDAD: EQU 0440H

MVI A,8BH
OUT 03H

MVI A,20H
STA 8350H

MVI A,03H
STA 8351H

MVI A,00H
STA 8470H

MVI A,00H
STA 8710H

CALL INITIALIZE                      ;initialsing (a*b+s)%m values.
CALL INITIAL                         ;initialising the random 28 combinations at a certain memo location.
START:
	CALL GENERATE_RAN                ;generates a random value in 0 to 27.
	LDA 8212H
	CALL ADDR
	LHLD 8600H
	XCHG
	LDAX D                          ; loads the values as address of the given address location.
	STA CURDT                       ; value being selected in displayed.
	CALL UPDDT
	LDA CURDT
	OUT 00H                         ; sending the value to peripheral
	CALL DELAY
	LDA CURDT
	MOV B,A
	IN 01H                          ; takes input from peripheral and comapare it with the value given to peripheral
	CMP B
	JNZ NOT_INCREASE                ; if not same, score isn't increased and penalty is increased.
	LDA 8300H
	INR A                           ; otherwise score increased.
	STA 8300H
	JMP LOOP_DECREASE

	NOT_INCREASE:                   ; incrementing penalty by 1
	LDA 8301H
	INR A
	STA 8301H
	LOOP_DECREASE:                  ; decreasing the number of loops left.
	LDA 8400H
	DCR A
	STA 8400H
	CPI 00H                         ; if loop lefts are 0, then showing the score 
	JNZ START
	CALL SCORE
	LDA 8300H					    ;checking eligiblity for next level if score>3
	CPI 03H
	JC STOP
	LDA 8351H                      
	DCR A
	STA 8351H                      ; checking the level number and decreasing the count of remaining levels.
	LDA 8351H
	CPI 00H
	JC STOP
	CALL INITIALIZE
	LDA 8351H
	CPI 01H
	JZ LEVEL2_INIT               ; Jumping to level1.
	CALL LEVEL1
	MVI A,12H
	STA 8350H
	JMP START

LEVEL2_INIT:            		;Start of level 2.
	CALL LEVEL2
	MVI A,09H
	STA 8350H
	START1:
	CALL GENERATE_RAN          ;Adding the random generator to the address 8212.
	LDA 8212H
	CALL ADDRI
	LHLD 8600H
	XCHG
	LDAX D                     ;Traeting the value at the given address field as address for next inst.
	STA CURDT
	CALL UPDDT
	LDA CURDT
	OUT 00H                    ;Inputting random number to peripheral.
	LDA CURDT
	STA 8450H
	MVI A,00H
	STA 8470H
	CALL CALCULATE             ;Calculating the number of LEDs lit.
	LDA 8470H
	STA CURDT
	CALL UPDDT
	CALL DELAY
	IN 01H                      ;Acc has the value user input with Dip switches.
	CPI 01H
	JZ ONE			 ;if first LED is selected.
	CPI 02H
	JZ TWO 			;if second LED is selected.
	CPI 04H
	JZ THREE		;if third LED is selected.
	CPI 08H
	JZ FOURTH 		;if forth LED is selected.
	CPI 10H
	JZ FIVE 		;if fifth LED is selected.
	CPI 20H
	JZ SIX     		;if sixth LED is selected.
	CPI 40H
	JZ SEVENTH 		;if seventh LED is selected.
	CPI 80H
	JZ EIGHT 			;if eighth LED is selected.
	JMP NOT_INCREASE 			; else if nothing is selected increment penalty.

ONE:   							;Checking if one was selected and one is the total number of LEDs lit and updating score accordingly.
	LDA 8470H
	CPI 01H
	JNZ N_INC
	JMP INC
TWO: 							;Checking if two was selected and two is the total number of LEDs lit and updating score accordingly.
	LDA 8470H
	CPI 02H
	JNZ N_INC
	JMP INC
THREE:							;Checking if three was selected and three is the total number of LEDs lit and updating score 
	LDA 8470H
	CPI 03H
	JNZ N_INC
	JMP INC
FOUR: 							;Checking if four was selected and four is the total number of LEDs lit and updating score accordingly.
	LDA 8470H
	CPI 04H
	JNZ N_INC
	JMP INC
FIVE:							;Checking if five was selected and five is the total number of LEDs lit and updating score accordingly.
	LDA 8470H
	CPI 05H
	JNZ N_INC
	JMP INC
SIX:							;Checking if six was selected and six is the total number of LEDs lit and updating score accordingly.
	LDA 8470H
	CPI 06H
	JNZ N_INC
	JMP INC
SEVEN:							;Checking if seven was selected and seven is the total number of LEDs lit and updating score 
	LDA 8470H
	CPI 07H
	JNZ N_INC
	JMP INC
EIGHT:							;Checking if eight was selected and eight is the total number of LEDs lit and updating score 
	LDA 8470H
	CPI 08H
	JNZ N_INC
	JMP INC	
	INC:
	LDA 8300H
	ADI 01H
	STA 8300H
	JMP L_DEC

	N_INC:                   ;Not increasing the score, but increasing the penalty
	LDA 8301H
	ADI 01H
	STA 8301H

	L_DEC:                   ;Decreasing the number of levels left.
	LDA 8400H
	DCR A
	STA 8400H
	CPI 00H
	JNZ START1               
	CALL SCORE	    

	STOP:                 ;displaying game over- "over"
	MVI A,00H
	MVI B,00H
	
	LXI H,8840H
	MVI M,10H

	LXI H,8841H
	MVI M,13H

	LXI H,8842H
	MVI M,10H

	LXI H,8843H
	MVI M,16H

	LXI H,8840H          ; displaying game over using CURDT on data bits of board.
	CALL OUTPUT
	LDA 8700H
	STA CURDT
	CALL UPDDT
	CALL RDKBD
	CALL CLEAR

	MVI A,00H        
	MVI B,00H
	LXI H,8840H
	MVI M,00H

	LXI H,8841H
	MVI M,15H

	LXI H,8842H
	MVI M,0EH

	LXI H,8843H
	MVI M,14H

	LXI H,8840H        ;displaying score on data bits of board.
	CALL OUTPUT
	CALL RDKBD
	CALL CLEAR
	MVI A,00H
	OUT 00H
	RST 5

LEVEL1:
	MVI A,00H           ;marking the start of level 1 by displaying lev 1.
	MVI B,00H

	LXI H,8840H
	MVI M,11H

	LXI H,8841H
	MVI M,0EH

	LXI H,8842H
	MVI M,15H

	LXI H,8843H
	MVI M,11H

	LXI H,8840H
	CALL OUTPUT
	MVI A,01H
	STA CURDT
	CALL UPDDT
	CALL RDKBD
	CALL CLEAR
	RET

LEVEL2:			;marking the start of level 2 by displaying lev 2
	MVI A,00H
	MVI B,00H

	LXI H,8840H
	MVI M,11H

	LXI H,8841H
	MVI M,0EH

	LXI H,8842H
	MVI M,15H

	LXI H,8843H
	MVI M,11H

	LXI H,8840H
	CALL OUTPUT
	MVI A,02H
	STA CURDT
	CALL UPDDT
	CALL RDKBD
	CALL CLEAR
	RET

SCORE: 				;displaying score
	MVI A,00H
	MVI B,00H

	LXI H,8840H
	MVI M,05H

	LXI H,8841H
	MVI M,0CH

	LXI H,8842H
	MVI M,00H

	LXI H,8843H
	MVI M,14H

	LXI H,8840H
	CALL OUTPUT

	LDA 8300H		;displaying score using data bits of board.
	STA CURDT
	LDA 8300H
	MOV B,A
	LDA 8710H
	ADD B
	STA 8710H
	LDA 8700H
	MOV B,A
	LDA 8710H
	CMP B
	JC DISPLAY
	LDA 8710H
	STA 8700H
	
	DISPLAY:		;dispalying penalty
	CALL UPDDT
	CALL RDKBD
	CALL CLEAR

	MVI A,00H
	MVI B,00H

	LXI H,8844H
	MVI M,11H

	LXI H,8845H
	MVI M,0EH

	LXI H,8846H
	MVI M,0FH

	LXI H,8847H
	MVI M,13H

	LXI H,8844H
	CALL OUTPUT

	LDA 8301H		;displaying penalty using data bits of board
	STA CURDT
	CALL UPDDT
	CALL RDKBD
	CALL CLEAR
	RET	

CALCULATE:                      ; Calculating the total number of LEDs which are litup. Returning the result in 8470H.
	LDA 8450H  					; if first Led is glowing.
	ANI 001H
	CPI 01H
	JNZ SECOND
	LDA 8470H
	INR A
	STA 8470H

	SECOND:						; if second Led is glowing.
	LDA 8450H
	ANI 002H
	CPI 02H
	JNZ THIRD
	LDA 8470H
	INR A	
	STA 8470H

	THIRD:				 		; if third Led is glowing.
	LDA 8450H
	ANI 004H
	CPI 04H
	JNZ FOURTH
	LDA 8470H
	INR A
	STA 8470H

	FOURTH:						; if fourth Led is glowing.
	LDA 8450H
	ANI 008H
	CPI 08H
	JNZ FIFTH
	LDA 8470H
	INR A
	STA 8470H

	FIFTH:						; if fifth Led is glowing.
	LDA 8450H
	ANI 010H
	CPI 10H
	JNZ SIXTH
	LDA 8470H
	INR A
	STA 8470H

	SIXTH:						; if sixth Led is glowing.
	LDA 8450H
	ANI 020H
	CPI 20H
	JNZ SEVENTH
	LDA 8470H
	INR A
	STA 8470H

	SEVENTH:					; if seventh Led is glowing.
	LDA 8450H
	ANI 040H
	CPI 40H
	JNZ EIGHTH
	LDA 8470H
	INR A
	STA 8470H
	
	EIGHTH:						; if eighth Led is glowing.
	LDA 8450H
	ANI 080H
	CPI 80H
	JNZ LAST
	LDA 8470H
	INR A
	STA 8470H
	LAST:
	RET


ADDR:                         ; Adder function
	MVI E,00h
	LXI H,8501H
	MOV C,L
	MOV B,H
	LHLD 8212H
	DAD B
	JNC LABEL1
	INR E
	LABEL1:SHLD 8600H
	RET

ADDRI:
	MVI E,00h
	LXI H,851DH
	MOV C,L
	MOV B,H
	LHLD 8212H
	DAD B
	JNC LABEL13
	INR E
	LABEL13:SHLD 8600H
	RET	


GENERATE_RAN:                 		;Genrates Random Variable (a*b+s)%m
	CALL MULTIPLY
	LDA 8202H			;8202 has a*b ans s=01D, adding both of them.
	ADI 01DH
	STA 8202H                 
	CALL MOD1   			  ;taking mod with a large number
	CALL MOD2     			  ; taking mod with 28 so that it fits in 0 to 27.
	LDA 8206H
	STA 8200H
	RET

MULTIPLY:                    		 ;Multiplies value stored at 8200 and 8201 and stores it in 8202.
	LHLD 8200H
	XCHG
	MOV C,D
	MVI D,00H
	LXI H,0000H
	LABEL3: DAD D
	DCR C
	JNZ LABEL3
	SHLD 8202H
	RET

MOD1:					; Right now 8202 contains value of (a*b+s) and 8204 pair value of m.
	LXI B,0000H
	LHLD 8204H               	; Mod of value stored at 8202 with value stored at 8204 and return result in 8206.
	XCHG
	LHLD 8202H
	LOOP2: MOV A,L
	SUB E
	MOV L,A
	MOV A,H
	SBB D
	MOV H,A
	JC LOOP1
	INX B
	JMP LOOP2
	LOOP1: DAD D
	SHLD 8206H
	RET

MOD2:                        ; Mod of new a(stored at 8206) with 28
	LXI B,0000H
	LHLD 8210H
	XCHG
	LHLD 8206H
	LOOP21: MOV A,L
	SUB E
	MOV L,A
	MOV A,H
	SBB D
	MOV H,A
	JC LOOP11
	INX B
	JMP LOOP21
	LOOP11: DAD D
	SHLD 8212H
	RET

DELAY:                         ; Creating a time delay by calling inloop 0A604times and that is again called 20 or 12 or 9
								; times depending on the number of level.
	LDA 8350H
	MOV C,A
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

INITIALIZE:                      ;Initialsing all the param for calculation of random number.
	MVI A,00H                    ;Initialising level with 0
	STA 8300H

	MVI A,00H   				 ;Initialising score with 0 
	STA 8301H

	MVI A,05H                    ;Iniatialsing penalty with 0
	STA 8400H

	MVI A,9FH                    ;Value of m stored in 8204 and 8205.
	STA 8204H

	MVI A,26H
	STA 8205H

	MVI A,1CH
	STA 8210H

	MVI A,00H
	STA 8211H
	RET	

INITIAL:						; initialsing at 28 continous location the value of numbers chosen 2 at a time.
		MVI A,03H
		STA 8501H

		MVI A,05H
		STA 8502H

		MVI A,09H
		STA 8503H

		MVI A,11H
		STA 8504H

		MVI A,21H
		STA 8505H

		MVI A,41H
		STA 8506H

		MVI A,81H
		STA 8507H

		MVI A,06H
		STA 8508H

		MVI A,0AH
		STA 8509H

		MVI A,12H
		STA 8510H

		MVI A,22H
		STA 8511H

		MVI A,42H
		STA 8512H

		MVI A,82H
		STA 8513H

		MVI A,0CH
		STA 8514H

		MVI A,14H
		STA 8515H

		MVI A,24H
		STA 8516H

		MVI A,44H
		STA 8517H

		MVI A,84H
		STA 8518H

		MVI A,18H
		STA 8519H

		MVI A,28H
		STA 8520H

		MVI A,48H
		STA 8521H

		MVI A,88H
		STA 8522H

		MVI A,30H
		STA 8523H

		MVI A,50H
		STA 8524H

		MVI A,90H
		STA 8525H

		MVI A,60H
		STA 8526H

		MVI A,0A0H
		STA 8527H

		MVI A,0C0H
		STA 8528H

		MVI A,1FH
		STA 8529H

		MVI A,2FH
		STA 8530H

		MVI A,3FH
		STA 8531H

		MVI A,4FH
		STA 8532H

		MVI A,5FH
		STA 8533H

		MVI A,6FH
		STA 8534H

		MVI A,7FH
		STA 8535H

		MVI A,8FH
		STA 8536H

		MVI A,9FH
		STA 8537H

		MVI A,0AFH
		STA 8538H

		MVI A,0BFH
		STA 8539H

		MVI A,0CFH
		STA 8540H

		MVI A,0DFH
		STA 8541H

		MVI A,0EFH
		STA 8542H

		MVI A,0FFH
		STA 8543H

		MVI A,0EH
		STA 8544H

		MVI A,1EH
		STA 8545H

		MVI A,2EH
		STA 8546H

		MVI A,3EH
		STA 8547H

		MVI A,4EH
		STA 8548H

		MVI A,5EH
		STA 8549H

		MVI A,6EH
		STA 8550H

		MVI A,7EH
		STA 8551H

		MVI A,8EH
		STA 8552H

		MVI A,9EH
		STA 8553H

		MVI A,0AEH
		STA 8554H

		MVI A,0BEH
		STA 8555H

		MVI A,0CEH
		STA 8556H

		RET
