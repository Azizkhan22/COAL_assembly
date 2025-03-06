org 100h        

section .text
start:
    mov ax, 5      ; Load first number into AX
    add ax, 7      ; Add second number

    ; Convert sum to ASCII
    add ax, '0'    ; Convert single-digit sum to ASCII

    ; Print the result
    mov dl, al     ; Load ASCII sum into DL for printing
    mov ah, 02h    ; DOS interrupt for printing a character
    int 21h        ; Call DOS interrupt

    ; Exit program
    mov ah, 4Ch    ; DOS exit interrupt
    int 21h
