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

PRINTXYC MACRO xpos, ypos, charac
    push ax
    push bx
    push dx
    mov ah, 02h         ; Función: mover cursor
    mov bh, 0           ; Página 0
    mov dh, ypos        ; Fila (y)
    mov dl, xpos        ; Columna (x)
    int 10h
    mov ah, 0Eh         ; Función: imprimir carácter
    mov al, charac
    int 10h
    pop dx
    pop bx
    pop ax
ENDM

SETVIDEOMODE MACRO modo
    push ax
    mov ah, 00h
    mov al, modo
    int 10h
    pop ax
ENDM