[org 0x0100]

mov al, 11010001b
or al, 00001000b

mov ax, 0x4c00
int 0x21