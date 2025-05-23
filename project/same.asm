org 100h
jmp main


diskname         db 'disk.img', 0
input_name       db 'TEST.TXT', 0
buffer           times 256 db 0

menu_msg         db 0Dh, 0Ah, '1. Create File', 0Dh, 0Ah
                 db '2. Write to File', 0Dh, 0Ah
                 db '3. Read File', 0Dh, 0Ah
                 db '4. Delete File', 0Dh, 0Ah
                 db '5. Exit', 0Dh, 0Ah
                 db 'Enter choice: $'

msg_created      db 0Dh, 0Ah, 'File created successfully.$'
msg_written      db 0Dh, 0Ah, 'Text written successfully.$'
msg_read         db 0Dh, 0Ah, 'Displaying file contents.$'
msg_deleted      db 0Dh, 0Ah, 'File deleted successfully.$'
msg_error        db 0Dh, 0Ah, 'Error accessing file.$'

main:
    call cls

menu:
    call cls
    mov dx, menu_msg
    call print_str
    call get_char

    cmp al, '1'
    je do_create
    cmp al, '2'
    je do_write
    cmp al, '3'
    je do_read
    cmp al, '4'
    je do_delete
    cmp al, '5'
    je exit_prog
    jmp menu

do_create:
    call create_file
    call wait_key
    jmp menu

do_write:
    call write_file
    call wait_key
    jmp menu

do_read:
    call read_file
    call wait_key
    jmp menu

do_delete:
    call delete_file
    call wait_key
    jmp menu

exit_prog:
    mov ax, 4C00h
    int 21h


create_file:
    mov ah, 3Ch        ; Create file
    xor cx, cx         ; Normal file attributes
    mov dx, input_name ; File name
    int 21h         ; Call DOS interrupt
    jc error_handling   ; Jump if error occurred
    mov bx, ax         ; File handle
    call close_file
    call print_created
    ret

write_file:
    mov ah, 3Dh        ; Open file for writing
    mov al, 2       ; Open for writing
    mov dx, input_name ; File name
    int 21h
    jc error_handling

    mov bx, ax      ; File handle
    mov si, buffer  ; Clear buffer    
    mov di, buffer  ; Point to buffer
    mov cx, 256   ; Max size

.input_loop:
    mov ah, 01h        ; Read char
    int 21h
    cmp al, 0Dh        ; Enter?
    je .write_done      ; If yes, finish writing
    stosb               ;   Store char in buffer
    loop .input_loop  ; Continue input loop

.write_done:
    sub di, buffer     ; Get length of input into cx
    mov cx, di      ;  Set length for writing
    mov dx, buffer ; Point to buffer
    mov ah, 40h  ; Write to file
    int 21h

    call close_file
    call print_written
    ret

read_file:
    mov ah, 3Dh       ; Open file for reading
    xor al, al     ; Open for reading
    mov dx, input_name ; File name
    int 21h 
    jc error_handling

    mov bx, ax     ; File handle
    mov dx, buffer  ; Point to buffer      
    mov cx, 255  ; Max size
    mov ah, 3Fh  ; Read from file
    int 21h

    mov si, ax                  ; AX = bytes read
    mov byte [buffer + si], 0   ; Null terminator
    call close_file

    call cls                    ; Clear screen before displaying
    call print_read
    call print_green_text
    ret

delete_file:
    mov ah, 41h     ; Delete file
    mov dx, input_name ; File name
    int 21h
    jc error_handling
    call print_deleted
    ret

error_handling:
    mov dx, msg_error
    call print_str
    ret

close_file:
    mov ah, 3Eh   ; Close file
    int 21h
    ret

print_green_text:
    mov ax, 0B800h         ; Video memory segment
    mov es, ax         ; Set extra segment
    mov si, buffer ; Source index to buffer
    xor di, di                ; Top line: row 0, column 0

.print_loop:
    lodsb                ; Load byte from buffer
    cmp al, 0         ; Check for null terminator
    je .done  ; If yes, finish printing
    mov ah, 0x02              ; Green on black
    stosw               ; Store character and attribute
    jmp .print_loop

.done:
    ret


print_str:
    mov ah, 09h       ; DOS print string function
    int 21h
    ret

get_char:
    mov ah, 01h     ; DOS character input
    int 21h
    ret

wait_key:
    mov ah, 00h    ; BIOS keyboard function
    int 16h   ; Wait for keypress
    ret

cls:
    mov ax, 0600h   ; Clear screen function
    mov bh, 07    ; Attribute (light gray on black)
    mov cx, 0   ; Top left corner
    mov dx, 184Fh ; Bottom right corner
    int 10h     ; Call BIOS video interrupt
    mov ah, 02h     ; Set cursor position
    mov bh, 0      ; Page number
    mov dx, 0   
    int 10h   ; Move cursor to top left
    ret

print_created:
    mov dx, msg_created
    call print_str
    ret

print_written:
    mov dx, msg_written
    call print_str
    ret

print_read:
    mov dx, msg_read
    call print_str
    ret

print_deleted:
    mov dx, msg_deleted
    call print_str
    ret