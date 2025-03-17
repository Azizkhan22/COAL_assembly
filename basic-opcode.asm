[org 0x100]
section .data
    name db "Aziz ullah khan$"
    
section .text
    mov dx, name
    mov ah, 09h
    int 21h
    
    mov ax, 4C00h
    int 21h

