cpu "8085.tbl"
hof "int8"
org 9000h

LDA 81FFH          ;Operation is loaded from 81FF memory location
CPI 01H
JZ ADD

CPI 02H
JZ SUB

CPI 03H
JZ MULT

CPI 04H
JZ DIV

ADD:
MVI E,00h
LHLD 8200h        ;Load first 16 bit no.
MOV C,L           ;Copy it to B and C
MOV B,H
LHLD 8202h        ;Load next 16 bit no. in HL pair
DAD B             ;Add BC pair to HL pair
JNC LABEL1        ;If there is carry in above sum increment E
INR E
LABEL1:
SHLD 8204h        ;Store answer in memory
MOV A,E
STA 8206h         ;Store carry
RST 5

SUB:
MVI C,00H
MVI B,00H
LHLD 8202H        ;Load first 16 bit no. in HL pair
XCHG			  ;Copy it to DE pair 
LHLD 8200H        ;Load next 16 bit no. in HL pair
MOV A,E            
SUB L
JNC SKIP
INR C
SKIP: MOV E,A     ;Now we are subtracting DE pair from HL
MOV A,D
SUB C
SUB H
JNC SKIP2         ;If there is no borrow means answer is positive
INR B 			  ;and we go to SKIP2 ans store answer

MVI C,00H
LHLD 8200H        ;Otherwise we load no. in reverse order and then subtract
XCHG
LHLD 8202H 
MOV A,E
SUB L
JNC SKI
INR C
SKI: MOV E,A
MOV A,D
SUB C
SUB H
SKIP2: MOV D,A
XCHG
SHLD 8204H        ;Save answer in memory
MOV A,B
STA 8206H         ;Save sign bit 1 if negative 0 if positive
RST 5

MULT:
LHLD 8200H        ;Load first no. in HL pair
SPHL              ;Copy it to Stack
LHLD 8202H        ;Load second no. in HL pair
XCHG              ;Copy it to DE pair
LXI H,0000H
LXI B,0000H
NEXT: DAD SP      ;Now we will add values in stack to HL pair DE times
JNC LOOP
INX B             ;If no. becomes greater than 16 bit start increasing BC pair
LOOP: DCX D
MOV A,E
ORA D             ;Take or of D and E to check whether DE pair is 0 or not
JNZ NEXT           
SHLD 8204H        ;Save LSB to memory
MOV L,C
MOV H,B
SHLD 8206H        ;Now save MSB to memory
RST 5

DIV:
LXI B,0000H
LHLD 8200H        ;Load first no. from memory
XCHG              ;Copy HL pair to DE
LHLD 8202H        ;Load next no. 
LOOP2: MOV A,L    ;Subtract DE from HL till HL is greater tha DE
SUB E
MOV L,A
MOV A,H
SBB D
MOV H,A
JC LOOP1
INX B             ;increment BC pair(Quotient) 
JMP LOOP2
LOOP1: DAD D
SHLD 8204H        ;Store remainder in memory
MOV L,C
MOV H,B
SHLD 8206H        ;Store quotient
RST 5