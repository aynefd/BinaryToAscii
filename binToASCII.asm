.ORIG x3000
AND R0, R0, #0
AND R1, R1, #0
AND R2, R2, #0
AND R3, R3, #0
AND R4, R4, #0
AND R5, R5, #0
AND R6, R6, #0
AND R7, R7, #0


LD R2,MyNum
LD R3,MyNumB
BRnzp DIVISION
OUTPUT JSR BinarytoASCII
LD R0, NewlineChar
OUT
LEA R0,ASCIIBUFF
PUTS

HALT





MyNum .FILL x000A
MyNumB .FILL x0005


;r2 and r3 will have the operands
;r0 will hold the answer
ADDITION ADD R0, R2, R3	;add R2 + R3 and store in R2
BRnzp OUTPUT

SUBTRACTION NOT R3, R3
ADD R3, R3, #1
ADD R0, R2, R3
BRnzp OUTPUT


MULT ADD R0, R0, R2
ADD R3, R3, #-1
BRp MULT
BRnzp OUTPUT


DIVISION ADD R6, R6, #0 ;counter
NOT R3, R3
ADD R3, R3, #1
DivLoop ADD R6, R6, #1
ADD R2, R2, R3
BRp DivLoop
ADD R0, R6, #0
BRnzp OUTPUT





;
; This algorithm takes the 2's complement representation of a signed
; integer, within the range -999 to +999, and converts it into an ASCII
; string consisting of a sign digit, followed by three decimal digits.
; R0 contains the initial value being converted.
;
BinarytoASCII LEA R1,ASCIIBUFF ; R1 points to string being generated
ADD R0,R0,#0 ; R0 contains the binary value
BRn NegSign ;
LD R2,ASCIIplus ; First store the ASCII plus sign
STR R2,R1,#0
BRnzp Begin100
NegSign LD R2,ASCIIminus ; First store ASCII minus sign
STR R2,R1,#0
NOT R0,R0 ; Convert the number to absolute
ADD R0,R0,#1 ; value; it is easier to work with.
;
Begin100 LD R2,ASCIIoffset ; Prepare for "hundreds" digit
;
LD R3,Neg100 ; Determine the hundreds digit
Loop100 ADD R0,R0,R3
BRn End100
ADD R2,R2,#1
BRnzp Loop100
;
End100 STR R2,R1,#1 ; Store ASCII code for hundreds digit
LD R3,Pos100
ADD R0,R0,R3 ; Correct R0 for one-too-many subtracts
;
LD R2,ASCIIoffset ; Prepare for "tens" digit
;
Begin10 LD R3,Neg10 ; Determine the tens digit
Loop10 ADD R0,R0,R3
BRn End10
ADD R2,R2,#1
BRnzp Loop10
;
End10 STR R2,R1,#2 ; Store ASCII code for tens digit
ADD R0,R0,#10 ; Correct R0 for one-too-many subtracts
Begin1 LD R2,ASCIIoffset ; Prepare for "ones" digit
ADD R2,R2,R0
STR R2,R1,#3
RET
;

ASCIIBUFF .BLKW 5 
ASCIIplus .FILL x002B
ASCIIminus .FILL x002D
ASCIIoffset .FILL x0030
Neg100 .FILL xFF9C
Pos100 .FILL x0064
Neg10 .FILL xFFF6
NewlineChar .FILL x000A


.END