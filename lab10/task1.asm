
[org 0x0100]

start:
    mov ax, 0x005A     ; Load 0x005A into AX
    push ax            ; Push AX onto the stack    
    jmp start

    mov ax, 0x4c00
    int 21h 
