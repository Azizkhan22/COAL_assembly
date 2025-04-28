[org 0x100]        ; COM file starting address

start:

    mov word [sp_index], 0

    mov ax, 10
    jmp stack_push
    mov ax, 20
    jmp stack_push
    mov ax, 30
    jmp stack_push
    mov ax, 40
    jmp stack_push
    mov ax, 50
    jmp stack_push

    mov ax, 60 ; (should show overflow handling)
    jmp stack_push
    
    jmp peek  ; result in AX

    jmp stack_pop   
    jmp stack_pop
    jmp stack_pop
    jmp stack_pop
    jmp stack_pop

    
    jmp stack_pop ;(should show underflow handling)
    
    mov ah, 0x4C
    int 0x21


stack_push:
    pusha

    mov bx, [sp_index]
    cmp bx, stack_size
    jae .overflow       ; if sp_index >= stack_size, overflow

    mov cx, bx          ; calculate address offset
    shl cx, 1           ; word array (2 bytes per word)

    mov [stack_array + cx], ax  ; store AX into stack
    inc word [sp_index]

    jmp .done

.overflow:    
    mov ax, 0FFFFh

.done:
    popa
    ret

stack_pop:
    pusha

    mov bx, [sp_index]
    cmp bx, 0
    je .underflow       ; if sp_index == 0, underflow

    dec word [sp_index]
    mov bx, [sp_index]
    shl bx, 1           ; word array, multiply index by 2

    mov ax, [stack_array + bx]

    jmp .done

.underflow:
    mov ax, 0EEEeh

.done:
    popa
    ret

peek:
    pusha

    mov bx, [sp_index]
    cmp bx, 0
    je .underflow       ; empty stack

    dec bx              ; peek at element below current sp_index
    shl bx, 1

    mov ax, [stack_array + bx]

    jmp .done

.underflow:
    mov ax, 0EEEeh

.done:
    popa
    ret


stack_size equ 5                    ; stack size IS defined here
stack_array dw stack_size dup(0)     ; Allocate memory
sp_index dw 0                        ; Stack pointer
