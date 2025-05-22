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
   
   escribe PROC
 PUSH AX
 MOV AH,02  ; Caracter a desplegar almacenado en dl
 INT 21h
 POP AX
 RET 
escribe ENDP

SALIR_DOS PROC
   MOV AH,4CH
   INT 21H
RET
SALIR_DOS ENDP

LEE PROC
   MOV AH,01
   INT 21H
RET
LEE ENDP

POS_CUR PROC
PUSH AX
PUSH BX
PUSH DX
MOV AH,02
MOV BH,0
MOV DH,05
MOV DL,20
INT 10h
POP DX
POP BX
POP AX
RET
POS_CUR ENDP

limpiar_pantalla PROC
PUSH AX
PUSH BX
PUSH CX
PUSH DX
MOV AX,0600h
MOV BH,71h      ; FONDO BLANCO CON PRIMER PLANO AZUL
MOV CX,0000H
MOV DX,184FH
INT 10h
POP DX
POP CX
POP BX
POP AX
RET
limpiar_pantalla ENDP

;C?digo para la Subrutina Ascii-Binario

Ascii_Binario PROC
    CMP AL,30h
    JL ERROR
    CMP AL,39h
    JG LETRA
    SUB AL,30h  ; Restar 30h
    JMP FINN
LETRA:  CMP AL,41h
    JL ERROR
    CMP AL,46h
    JG ERROR
    SUB AL,37h  ; Restar 37h
    JMP FINN
ERROR:  MOV AL,0
FINN :   RET
Ascii_Binario ENDP


;C?digo para la Subrutina Binario-Ascii

Binario_Ascii PROC
    CMP DL,9h
    JG SUMA37
    ADD DL,30h
    JMP FIN
SUMA37: ADD DL,37h
FIN :  RET
Binario_Ascii ENDP

;C?digo para la Subrutina Empaqueta

Empaqueta PROC
    PUSH cx
    CALL LEE    ; Leer el primera car
    CALL Ascii_Binario  ;Procesa 1er. caracter
    MOV cl,04
    SHL al,cl   ; Instrucci?n l?gica de corrimiento a la izquierda 
    MOV ch,al   ; Almacenando el valor de AL a un registro auxiliar
    CALL LEE    ; Leer el segundo car
    CALL Ascii_Binario  ;Procesa 2o. caracter
    ADD al,ch   ; Sumar  el contenido de los registros
    POP cx
    RET
Empaqueta ENDP


;C?digo para la Subrutina Desempaqueta
Desempaqueta PROC
    PUSH dx
    PUSH cx
    MOV dh,dl   ; Guardando el valor original en DH
    MOV cl,4
    SHR dl,cl   ; Cuatro corrimientos a la derecha
    CALL Binario_Ascii
    CALL escribe
    MOV dl,dh   ; Recuperando el dato de DH
    AND dl,0Fh  ; Aplicando mascara
    CALL Binario_Ascii
    CALL escribe
    POP cx
    POP dx
    RET
Desempaqueta ENDP

MENSAJE PROC
PUSH AX
MOV AH,09H
INT 21H
POP AX
RET
MENSAJE ENDP

PRINCI ENDP
END PRINCI