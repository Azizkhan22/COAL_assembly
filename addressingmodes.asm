org 0x100

section .data
num db 5

section .text
start:
    mov al, 5   ; BX holds the address of 'array'
    add al, [num]    ; Load AL with first element (10)

    mov ah, 4Ch     ; Exit program
    int 21h
