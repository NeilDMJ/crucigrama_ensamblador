SET_BACKGROUND_COLOR_12H MACRO color
    push ax
    push es
    push di
    push cx

    mov ax, 0A000h
    mov es, ax
    xor di, di
    mov al, color
    shl al, 4
    or al, color       ; AL = color en ambos nibbles
    mov cx, 38400      ; 640*480/2 bytes
    rep stosb

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
