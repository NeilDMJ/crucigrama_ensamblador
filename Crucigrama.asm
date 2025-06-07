INCLUDE TASMLIB.inc

.model small
.stack 100h

.data

    buffer_1 DB 20 DUP(?)
    buffer_2 DB 20 DUP(?)
    buffer_3 DB 20 DUP(?)
    buffer_4 DB 20 DUP(?)
    buffer_5 DB 20 DUP(?) 
           
    ; Variables para dimensiones
    cols       dw 11       ; columnas
    rows       dw 9        ; filas
    cellW      dw 40       ; ancho de celda 
    cellH      dw 40       ; alto de celda
    X_inicial  dw 0
    Y_inicial  dw 0
    ancho      dw 34  
    
    ; Textos del mensaje
    INFO       DB 'PROFESIONES Y EMPLEOS$'
    MSGMENU    DB 'MENU$'
    MSGSTART   DB 'START CRUCIGRAMA$'
    MSGF1      DB 'F1$'
    MSGESC     DB 'ESC$'
    MSGEND     DB 'END CRUCIGRAMA$'
    INSTRUC    DB "Presiona 1-5 para seleccionar la palabra$"
    
    ; Posiciones para cada texto
    menuX      dw 15
    menuY      dw 15
    startX     dw 260
    startY     dw 150
    f1X        dw 410
    f1Y        dw 150
    endX       dw 260
    endY       dw 180
    f2X        dw 410
    f2Y        dw 180
    
    ; Pistas
    P_POLICIA  DB '4. Protege a la comunidad y hace cumplir la ley$'
    P_DOCTOR   DB '2. Cuida tu salud y trabaja en hospitales$'
    P_CHEF     DB '5. Prepara comida en un restaurante$'
    P_MUSICO   DB '1. Crea melodias y toca instrumentos$'
    P_PINTOR   DB '3. Crea arte con pinceles y colores$'
    
    PALABRAS DB 'MUSICO  '   ; fila 0
             DB 'DOCTOR  '   ; fila 1
             DB 'PINTOR  '   ; fila 2
             DB 'POLICIA '   ; fila 3
             DB 'CHEF    '   ; fila 4

.code
start:
    mov ax, @data
    mov ds, ax

    ; Cambiar a modo gr?fico 12h (640x480x16)
    SET_VIDEO_MODE 12h

    ; Fondo negro (color 0)
    SET_BACKGROUND_COLOR_12H 0

    CALL IMPRIMIR_EXTRAS
    CALL DIBUJAR_CRUCIGRAMA
    
    ; Mostrar mensaje de instrucci?n
    PRINT_STRING 7, 20,INSTRUC , 14
    
espera:
    ; Verificar teclas 1-5 y Enter
    CHECK_KEY '1', caso_1
    CHECK_KEY '2', caso_2
    CHECK_KEY '3', caso_3
    CHECK_KEY '4', caso_4
    CHECK_KEY '5', caso_5
    CHECK_KEY 27,  fin_programa  ; ESC
    
    jmp espera

caso_1:
    CALL DIBUJAR_CRUCIGRAMA
    CALL SELECCIONAR_1
    LEER_CADENA_ENTER buffer_1, 10
    COMPARE_FILA 0, buffer_1  
    cmp al,1
    jne salir
    CALL colocar_musico
salir:
    jmp espera

caso_2:
    CALL DIBUJAR_CRUCIGRAMA
    CALL SELECCIONAR_2
    LEER_CADENA_ENTER buffer_2, 10
    COMPARE_FILA 1, buffer_2  
    cmp al,1
    jne salir_1
    CALL colocar_doctor
salir_1:
    jmp espera

caso_3:
    CALL DIBUJAR_CRUCIGRAMA
    CALL SELECCIONAR_3
    jmp espera
    
caso_4:
    CALL DIBUJAR_CRUCIGRAMA
    CALL SELECCIONAR_4
    jmp espera
   
caso_5:
    CALL DIBUJAR_CRUCIGRAMA
    CALL SELECCIONAR_5
    jmp espera

fin_programa:
    ; Volver a modo texto
    SET_VIDEO_MODE 3h
    mov ax, 4C00h
    int 21h

; ------------------------------------------------------------
; IMPRIMIR_EXTRAS: Muestra los elementos de texto en pantalla
; ------------------------------------------------------------
IMPRIMIR_EXTRAS PROC
    ; Imprimir t?tulo y opciones
    PRINT_STRING 3, 25, INFO, 12
    PRINT_STRING 3, 3, MSGMENU, 14
    PRINT_STRING 3, 61, MSGEND, 12
    PRINT_STRING 3, 57, MSGESC, 14
    
    ; Imprimir pistas
    PRINT_STRING 22, 28, P_MUSICO, 11
    PRINT_STRING 23, 28, P_DOCTOR, 11
    PRINT_STRING 24, 28, P_PINTOR, 11
    PRINT_STRING 25, 28, P_POLICIA, 11
    PRINT_STRING 26, 28, P_CHEF, 11
    
    ret
IMPRIMIR_EXTRAS ENDP

; ------------------------------------------------------------
; DIBUJAR_CRUCIGRAMA: Dibuja la estructura del crucigrama
; ------------------------------------------------------------
DIBUJAR_CRUCIGRAMA PROC
    ; M?SICO (vertical)
    DRAW_BOX 92, 100, ancho, ancho, 4
    DRAW_BOX 92, 134, ancho, ancho, 4
    DRAW_BOX 92, 168, ancho, ancho, 4
    DRAW_BOX 92, 202, ancho, ancho, 4
    DRAW_BOX 92, 236, ancho, ancho, 4
    DRAW_BOX 92, 270, ancho, ancho, 4
    
    ; POLIC?A (horizontal)
    DRAW_BOX 160, 167, ancho, ancho, 4
    DRAW_BOX 194, 167, ancho, ancho, 4
    DRAW_BOX 228, 167, ancho, ancho, 4
    DRAW_BOX 262, 167, ancho, ancho, 4
    DRAW_BOX 296, 167, ancho, ancho, 4
    DRAW_BOX 330, 167, ancho, ancho, 4
    DRAW_BOX 364, 167, ancho, ancho, 4
    
    ; PINTOR (vertical)
    DRAW_BOX 160, 166, ancho, ancho, 4
    DRAW_BOX 160, 200, ancho, ancho, 4
    DRAW_BOX 160, 234, ancho, ancho, 4
    DRAW_BOX 160, 268, ancho, ancho, 4
    DRAW_BOX 160, 302, ancho, ancho, 4
    DRAW_BOX 160, 336, ancho, ancho, 4
    
    ; CHEF (vertical)
    DRAW_BOX 296, 167, ancho, ancho, 4
    DRAW_BOX 296, 201, ancho, ancho, 4
    DRAW_BOX 296, 235, ancho, ancho, 4
    DRAW_BOX 296, 269, ancho, ancho, 4
    
    ; DOCTOR (horizontal)
    DRAW_BOX 58, 268, ancho, ancho, 4
    DRAW_BOX 92, 268, ancho, ancho, 4
    DRAW_BOX 126, 268, ancho, ancho, 4
    DRAW_BOX 160, 268, ancho, ancho, 4
    DRAW_BOX 194, 268, ancho, ancho, 4
    DRAW_BOX 228, 268, ancho, ancho, 4
    
    ret
DIBUJAR_CRUCIGRAMA ENDP

; ------------------------------------------------------------
; Procedimientos para seleccionar palabras (1-5)
; ------------------------------------------------------------
SELECCIONAR_1 PROC
    ; M?SICO
    DRAW_BOX 92, 100, ancho, ancho, 10
    DRAW_BOX 92, 134, ancho, ancho, 10
    DRAW_BOX 92, 168, ancho, ancho, 10
    DRAW_BOX 92, 202, ancho, ancho, 10
    DRAW_BOX 92, 236, ancho, ancho, 10
    DRAW_BOX 92, 270, ancho, ancho, 10
    RET
SELECCIONAR_1 ENDP

SELECCIONAR_2 PROC
    ; DOCTOR
    DRAW_BOX 58, 268, ancho, ancho, 9
    DRAW_BOX 92, 268, ancho, ancho, 9
    DRAW_BOX 126, 268, ancho, ancho, 9
    DRAW_BOX 160, 268, ancho, ancho, 9
    DRAW_BOX 194, 268, ancho, ancho, 9
    DRAW_BOX 228, 268, ancho, ancho, 9
    RET
SELECCIONAR_2 ENDP

SELECCIONAR_3 PROC
    ; PINTOR
    DRAW_BOX 160, 166, ancho, ancho, 13
    DRAW_BOX 160, 200, ancho, ancho, 13
    DRAW_BOX 160, 234, ancho, ancho, 13
    DRAW_BOX 160, 268, ancho, ancho, 13
    DRAW_BOX 160, 302, ancho, ancho, 13
    DRAW_BOX 160, 336, ancho, ancho, 13
    RET
SELECCIONAR_3 ENDP

SELECCIONAR_4 PROC
    ; POLIC?A
    DRAW_BOX 160, 167, ancho, ancho, 14
    DRAW_BOX 194, 167, ancho, ancho, 14
    DRAW_BOX 228, 167, ancho, ancho, 14
    DRAW_BOX 262, 167, ancho, ancho, 14
    DRAW_BOX 296, 167, ancho, ancho, 14
    DRAW_BOX 330, 167, ancho, ancho, 14
    DRAW_BOX 364, 167, ancho, ancho, 14
    RET
SELECCIONAR_4 ENDP

SELECCIONAR_5 PROC
    ; CHEF
    DRAW_BOX 296, 167, ancho, ancho, 11
    DRAW_BOX 296, 201, ancho, ancho, 11
    DRAW_BOX 296, 235, ancho, ancho, 11
    DRAW_BOX 296, 269, ancho, ancho, 11
    RET
SELECCIONAR_5 ENDP

colocar_musico PROC

    PRINT_CHAR  7,13,77,4
    PRINT_CHAR  9,13,85,4
    PRINT_CHAR 11,13,83,4
    PRINT_CHAR 13,13,73,4
    PRINT_CHAR 15,13,67,4
    PRINT_CHAR 17,13,79,4
    ret
    colocar_musico ENDP

colocar_policia PROC

    PRINT_CHAR 11,22,80,4
    PRINT_CHAR 11,26,79,4
    PRINT_CHAR 11,30,76,4
    PRINT_CHAR 11,34,73,4
    PRINT_CHAR 11,38,67,4
    PRINT_CHAR 11,42,73,4
    PRINT_CHAR 11,46,65,4
    ret
    colocar_policia ENDP

colocar_pintor PROC

    PRINT_CHAR 11,22,80,4
    PRINT_CHAR 13,22,73,4
    PRINT_CHAR 15,22,78,4
    PRINT_CHAR 17,22,84,4
    PRINT_CHAR 19,22,79,4
    PRINT_CHAR 21,22,82,4
    ret
    colocar_pintor ENDP

colocar_chef PROC

    PRINT_CHAR 11,38,67,4
    PRINT_CHAR 13,38,72,4
    PRINT_CHAR 15,38,69,4
    PRINT_CHAR 17,38,70,4
    ret
    colocar_chef ENDP

colocar_doctor PROC

    PRINT_CHAR 17,9,68,4
    PRINT_CHAR 17,13,79,4
    PRINT_CHAR 17,17,67,4
    PRINT_CHAR 17,22,84,4
    PRINT_CHAR 17,25,79,4
    PRINT_CHAR 17,29,82,4
    ret
 colocar_doctor ENDP

; ------------------------------------------------------------
; PRINT_STRING: Muestra una cadena en posici?n espec?fica
; ------------------------------------------------------------
print_string proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    ; ? Convertir DI (Y en p?xeles) ? fila_texto = Y ? 16
    mov ax,di
    xor dx,dx
    mov cx,16
    div cx          ; AX = fila_texto, DX = resto
    mov dh,al       ; DH = fila (0?29)

    mov ax,si
    xor dx,dx
    mov cl,8
    div cl          
    mov dl,al       

    mov ah,02h
    mov bh,0        ; P?gina de video
    int 10h

    mov si,dx    
next_char:
    mov al,[si]
    cmp al,'$'
    je done_print
    mov ah,0Eh
    mov bh,0
    ; BL ya tiene el color
    int 10h
    inc si
    jmp next_char

done_print:
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_string endp

end start