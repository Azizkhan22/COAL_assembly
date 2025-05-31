[org 0x100]

mov ax, 5
mov [1234h], ax
mov bx, 1234h
mov ax, [bx]

mov ax, 4C00h
int 21h

number db 12