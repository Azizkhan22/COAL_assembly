[org 100h]

jmp start

start:
    MOV CX, len-1            
    OUTER_LOOP:
        PUSH CX              
        MOV SI, 0            
        MOV CX, len-1        

    INNER_LOOP:
        MOV AL, [array + SI]     
        MOV BL, [array + SI + 1] 
        CMP AL, BL               
        JLE NO_SWAP              


        MOV [array + SI], BL     
        MOV [array + SI + 1], AL 

    NO_SWAP:
        INC SI                 
        LOOP INNER_LOOP        
        POP CX                 
        LOOP OUTER_LOOP        

    mov ax, 4C00h
    int 21H

array DB  9, 5, 2, 8, 1, 3, 4, 7, 6, 0  
len   EQU 10                            
temp  DB  0                             
