cpu "8085.tbl"
hof "int8"
org 9000h

LDA 81FFH     ;Operation is loaded from 81FF memory location
CPI 01H
JZ ADD

CPI 02H
JZ SUB

CPI 03H
JZ MULT

CPI 04H
JZ DIV

ADD:
mvi C,00H
LDA 8200H     ;First operand loaded from memory
MOV B,A       ;moved to B
LDA 8201H     ;Next operand loaded
ADD B         ;B is added to accumulator
JNC LABEL1	  ;if there is a carry increment C
INR C
LABEL1:
STA 8202H     ;saved sum in memory
MOV A,C 
STA 8203H     ;saved carry
RST 5

SUB:          ;Subtracts second number from first
MVI E,00H
LDA 8200H     ;First operand loaded from memory
MOV B,A       ;moved to B
LDA 8201H     ;Next operand loaded
CMP B         ;if B is smaller than A it will generate carry 1 otherwise 0
JNC L1        ;Jump to L1 if A is greater
INR E         ;otherwise make sign register 1
MOV C,A       ;Swap A and B
MOV A,B
MOV B,C
L1: 
SUB B         ;Subtract B from A
STA 8202H     ;Save answer in memory
MOV A,E
STA 8203H     ;store sign 1 is for negative and 0 for positive
RST 5

MULT:
LHLD 8200H    ;Take input from 8200 and 8201 in HL pair
XCHG          ;Copy data of HL to DE register pair
MOV C,D       ;Move D to C
MVI D,00H
LXI H,0000H
LABEL3: DAD D ;It will add data of DE pair(basically E as D is zero) to HL pair
DCR C         ;C times
JNZ LABEL3
SHLD 8202H    ;As C becomes zero store answer in HL to memory(8202 and 8203)
RST 5

DIV:
mvi C,00H
LDA 8200H     ;First operand loaded from memory
MOV B,A       ;moved to B
LDA 8201H     ;Next operand loaded
LOOP: CMP B   ;If B is smaller we will keep on subtracting it from A
JC LABEL4
SUB B
INR C         ;This will be our quotient 
JMP LOOP
LABEL4: 
STA 8202H     ;In accumulator our remainder was saved so we put that in memory 
MOV A,C
STA 8203H     ;Quotient is saved in 8203
RST 5