SET_BACKGROUND_COLOR_13H MACRO color
    push ax
    push es
    push di
    push cx

    mov ax, 0A000h      ; segmento de video modo 13h
    mov es, ax
    xor di, di          ; offset 0
    mov al, color       ; color de fondo (0-255)
    mov cx, 64000       ; 320*200 píxeles
    rep stosb           ; llena la pantalla

    pop cx
    pop di
    pop es
    pop ax
ENDM

SET_VIDEO_MODE MACRO modo
    push ax
    mov ah, 00h
    mov al, modo
    int 10h
    pop ax
ENDM

