
org 100h                    ; Set program origin to 100h (COM format)
jmp main                    ; Jump to main program entry point

; Data section
diskname     db 'disk.img', 0      ; Name of disk image file
input_name   db 'TEST.TXT', 0      ; Default file name to work with
buffer       times 256 db 0        ; Buffer for file operations

menu_msg     db 0Dh, 0Ah, '1. Create File', 0Dh, 0Ah    ; Menu display text
             db '2. Write to File', 0Dh, 0Ah            ; with options for
             db '3. Read File', 0Dh, 0Ah                ; file operations
             db '4. Delete File', 0Dh, 0Ah              ; and program exit
             db '5. Exit', 0Dh, 0Ah                     
             db 'Enter choice: $'                        

msg_created  db 0Dh, 0Ah, 'File created successfully.$'     ; Success messages
msg_written  db 0Dh, 0Ah, 'Text written successfully.$'     ; for different
msg_read     db 0Dh, 0Ah, 'Displaying file contents.$'      ; operations
msg_deleted  db 0Dh, 0Ah, 'File deleted successfully.$'     
msg_error    db 0Dh, 0Ah, 'Error accessing file.$'         ; Error message

main:                      ; Main program entry point
    call cls              ; Clear screen on startup

menu:                     ; Menu loop start
    call cls             ; Clear screen for menu
    mov dx, menu_msg     ; Load menu message address
    call print_str       ; Display menu
    call get_char        ; Get user input

    cmp al, '1'          ; Compare input with menu options
    je do_create         ; Jump to create file handler
    cmp al, '2'          ; Check for write option
    je do_write          ; Jump to write handler
    cmp al, '3'          ; Check for read option
    je do_read           ; Jump to read handler
    cmp al, '4'          ; Check for delete option
    je do_delete         ; Jump to delete handler
    cmp al, '5'          ; Check for exit option
    je exit_prog         ; Exit if 5 selected
    jmp menu             ; Invalid input, show menu again

do_create:               ; Create file handler
    call create_file     ; Call create file function
    call wait_key       ; Wait for key press
    jmp menu            ; Return to menu

do_write:               ; Write file handler
    call write_file     ; Call write file function
    call wait_key       ; Wait for key press
    jmp menu            ; Return to menu

do_read:                ; Read file handler
    call read_file      ; Call read file function
    call wait_key       ; Wait for key press
    jmp menu            ; Return to menu

do_delete:              ; Delete file handler
    call delete_file    ; Call delete file function
    call wait_key       ; Wait for key press
    jmp menu            ; Return to menu

exit_prog:              ; Program exit point
    mov ax, 4C00h       ; DOS terminate function
    int 21h             ; Call DOS interrupt

create_file:            ; File creation function
    mov ah, 3Ch         ; DOS create file function
    xor cx, cx          ; Normal file attributes
    mov dx, input_name  ; Point to filename
    int 21h             ; Create file
    jc error_handling   ; Jump if error occurred
    mov bx, ax          ; Save file handle
    call close_file     ; Close the file
    call print_created  ; Show success message
    ret                 ; Return to caller

write_file:             ; File write function
    mov ah, 3Dh         ; DOS open file function
    mov al, 2           ; Open for writing
    mov dx, input_name  ; Point to filename
    int 21h             ; Open file
    jc error_handling   ; Jump if error

.input_loop:            ; Input loop for writing
    mov ah, 01h         ; DOS character input
    int 21h             ; Get character
    cmp al, 0Dh         ; Check for Enter key
    je .write_done      ; If Enter, finish writing
    stosb               ; Store character in buffer
    loop .input_loop    ; Continue input loop

.write_done:            ; Write completion
    sub di, buffer      ; Calculate input length
    mov cx, di          ; Set length for writing
    mov dx, buffer      ; Point to buffer
    mov ah, 40h         ; DOS write function
    int 21h             ; Write to file

read_file:              ; File read function
    mov ah, 3Dh         ; DOS open file function
    xor al, al          ; Open for reading
    mov dx, input_name  ; Point to filename
    int 21h             ; Open file
    jc error_handling   ; Jump if error

delete_file:            ; File deletion function
    mov ah, 41h         ; DOS delete file function
    mov dx, input_name  ; Point to filename
    int 21h             ; Delete file
    jc error_handling   ; Jump if error
    call print_deleted  ; Show success message
    ret                 ; Return to caller

error_handling:         ; Error handler
    mov dx, msg_error   ; Point to error message
    call print_str      ; Display error
    ret                 ; Return to caller

; Utility functions below
close_file:             ; File close function
    mov ah, 3Eh         ; DOS close file function
    int 21h             ; Close file
    ret                 ; Return to caller

print_green_text:       ; Green text display function
    mov ax, 0B800h      ; Video memory segment
    mov es, ax          ; Set extra segment
    mov si, buffer      ; Source index to buffer
    xor di, di          ; Start at top of screen

print_str:              ; String print function
    mov ah, 09h         ; DOS print string function
    int 21h             ; Print string
    ret                 ; Return to caller

get_char:               ; Character input function
    mov ah, 01h         ; DOS character input
    int 21h             ; Get character
    ret                 ; Return to caller

wait_key:               ; Key wait function
    mov ah, 00h         ; BIOS keyboard function
    int 16h             ; Wait for keypress
    ret                 ; Return to caller

cls:                    ; Clear screen function
    mov ax, 0600h       ; Scroll window up
    mov bh, 07          ; Normal attributes
    mov cx, 0           ; Upper left corner
    mov dx, 184Fh       ; Lower right corner
    int 10h             ; Clear screen
    mov ah, 02h         ; Set cursor position
    mov bh, 0           ; Page 0
    mov dx, 0           ; Top left
    int 10h             ; Move cursor
    ret                 ; Return to caller

