org 0x100

section .data
array db 10, 20, 30, 40  ; Define an array of bytes

section .text
    mov bx, array   ; BX holds the address of 'array'
    mov al, [bx]    ; Load AL with first element (10)

    mov ah, 4Ch     ; Exit program
    int 21h
