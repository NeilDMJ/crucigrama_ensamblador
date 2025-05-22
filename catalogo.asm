;definir un catalogo de profesiones para un crucigrama

.MODEL small
.STACK  100

;DEFINICION DE AREAS DE TRABAJO
.DATA

catalogo db "chef      "
         db "reportera "
         db "astronauta"
         db "policia   "
         db "doctor    "
buffer db 10 dup (?)

.CODE
PRINCI PROC FAR
   ;PROTOCOLO
   push ds
   sub ax,ax
   push ax
   MOV AX,@data
   MOV DS,AX

mov si, x         ; x = número de fila (0 a 4)
mov cx, 10        ; longitud de la palabra
mov di, offset buffer ; buffer donde guardarás la palabra

mov bx, 10
mul bx            ; AX = x * 10
add si, ax        ; SI = offset de la palabra en catalogo
mov si, ax        ; SI = x * 10

lea si, [catalogo + si] ; SI apunta al inicio de la palabra

copiar_palabra:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop copiar_palabra

   ;RETROCEDER
   pop ax
   mov ds,ax
   ret
PRINCI ENDP
END PRINCI