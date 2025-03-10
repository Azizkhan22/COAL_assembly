[org 0x100]

MOV AX, 5        ; Load AX with 5
INC AX           ; Increment AX (AX = 6)
    
MOV BX, 10       ; Load BX with 10
DEC BX           ; Decrement BX (BX = 9)

MOV AH, 4CH      ; Exit program
INT 21H