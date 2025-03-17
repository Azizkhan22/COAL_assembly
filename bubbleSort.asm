.MODEL SMALL
.STACK 100H
.DATA
    array DB  9, 5, 2, 8, 1, 3, 4, 7, 6, 0  ; Unsorted array
    len   EQU 10                            ; Number of elements
    temp  DB  ?                             ; Temporary storage for swapping

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX               ; Load data segment

    MOV CX, len-1            ; Outer loop (n-1 passes)
OUTER_LOOP:
    PUSH CX                  ; Save outer loop counter
    MOV SI, 0                ; SI points to array start
    MOV CX, len-1            ; Inner loop runs n-1 times

INNER_LOOP:
    MOV AL, [array + SI]     ; Load A[i] into AL
    MOV BL, [array + SI + 1] ; Load A[i+1] into BL
    CMP AL, BL               ; Compare A[i] and A[i+1]
    JLE NO_SWAP              ; If A[i] <= A[i+1], no swap

    ; Swap A[i] and A[i+1]
    MOV [array + SI], BL     ; A[i] = A[i+1]
    MOV [array + SI + 1], AL ; A[i+1] = A[i]

NO_SWAP:
    INC SI                   ; Move to next element
    LOOP INNER_LOOP           ; Repeat inner loop

    POP CX                   ; Restore outer loop counter
    LOOP OUTER_LOOP           ; Repeat outer loop

    ; Program exit
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN
