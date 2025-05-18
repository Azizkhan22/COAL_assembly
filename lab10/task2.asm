

add_two_numbers:
    push ebp            
    mov ebp, esp        
    mov eax, [ebp+8]    
    add eax, [ebp+12]   
    pop ebp             
    ret

_start:
    
    push dword 7        
    push dword 5        
    call add_two_number
    add esp, 8          
    mov [result], eax   
    
    mov eax, 1          
    xor ebx, ebx
    int 0x80


    msg db "Result: %d", 10, 0
