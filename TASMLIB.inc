

NEWLINE MACRO 
    push ax
    push dx
    mov ah, 02h
    mov dl, 0Dh                         
    int 21h
    mov dl, 0Ah         
    int 21h
    pop dx
    pop ax
ENDM

PRINTC MACRO char
    mov ah, 0Eh
    mov al, char
    int 10h
ENDM

PrintStr MACRO ptr
    mov ah, 09h
    mov dx, ptr
    int 21h
ENDM