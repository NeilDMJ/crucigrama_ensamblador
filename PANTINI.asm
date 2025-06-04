INCLUDE TASMLIB.inc

.MODEL small
.STACK 100h
.DATA
menu1 db "1. Jugar Crucigrama$"
menu2 db "2. Salir$"
msgSel db "Selecciona una opcion: $"
opcion db ?

.CODE
main PROC
    mov ax, @data
    mov ds, ax

menu_inicio:
    NEWLINE
    PrintStr offset menu1
    NEWLINE
    PrintStr offset menu2
    NEWLINE
    PrintStr offset msgSel

    mov ah, 01h
    int 21h
    sub al, '0'
    mov opcion, al

    cmp opcion, 1
    je jugar
    cmp opcion, 2
    je salir
    jmp menu_inicio

jugar:
    call mostrar_tablero
    jmp menu_inicio

salir:
    mov ah, 4ch
    int 21h

main ENDP

EXTERN mostrar_tablero:NEAR
END main