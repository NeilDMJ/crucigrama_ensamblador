;-----------------------------------
;           CRUCIGRAMA 
;-----------------------------------
INCLUDE TASMLIB.INC 
.MODEL SMALL
.STACK 120H
;-----------------------------------
;           ZONA DE DATOS 
;-----------------------------------
.DATA 
;-----------------------------------
;  ZONA DE DATOS PARA EL CRUCIGRAMA
;-----------------------------------
    cols       equ 11       ; columnas
    rows       equ 9        ; filas
    cellW      equ 15       ; ancho de celda
    cellH      equ 15       ; alto de celda
    X_inicial  equ 0
    Y_inicial  equ 0
    ancho      equ 135  
;-----------------------------------
;               MENU 
;-----------------------------------   
    MSGMENU    DB 'MENU$'                                        
    MSGSTART   DB 'START CRUCIGRAMA$'
    MSGF1      DB 'F1 $'
    MSGF2      DB 'F2 $'
    MSGEND     DB 'END CRUCIGRAMA$'
    MSGNUM     DB 'Press F1 to start, F2 to exit$'
;-----------------------------------
; ZONA DE DATOS PARA DIBUJAR LINEAS
;-----------------------------------
    PosicionX  DW 0
    PosicionY  DW 0
    PosicionY2 DW 70 
    PosicionX2 DW 0
    colorFondo DB 3            ; AZUL CLARO 
    colorLinea DB 8           ; GRIS MEDIO
.CODE
;-----------------------------------
;           ZONA DE CODIGO
;-----------------------------------
CRUCIGRAMA PROC FAR
    mov ax, @data
    mov ds, ax
    mov es, ax
    CALL MENU 
    
    RET                         
CRUCIGRAMA ENDP
;-----------------------------------
;           DIBUJAR MENU
;-----------------------------------
MENU PROC
SET_VIDEO_12H
MENU_START:
    MOV PosicionX, 0
    MOV PosicionX2, 640 
    MOV PosicionY, 1
    CALL PAINT_RECT
    GOTOXY 38, 2
    PRINT MSGMENU
    GOTOXY 28, 14
    PRINT MSGF1
    GOTOXY 34, 14 
    PRINT MSGSTART
    GOTOXY 60, 28
    PRINT MSGF2
    GOTOXY 64, 28
    PRINT MSGEND
ESPERAR_TECLA:
    MOV AH, 0
    INT 16h             
    
    CMP AH, 3Bh         
    JE INICIAR_JUEGO
    
    CMP AH, 3Ch         
    JE MENU_END
  
    JMP ESPERAR_TECLA   
INICIAR_JUEGO:
    CALL CRUCIGRAMA
    JMP MENU_START
MENU_END:
    SET_VIDEO_MODE 03h 
    RET
MENU ENDP
;--------------------------------
;         DIBUJAR LINEA
;--------------------------------
DRAW_LINE PROC
    PUSH CX AX DX BX
    MOV CX, PosicionX2
    MOV PosicionX, 0
LINE:
    DRAW_POINT colorLinea, PosicionX, PosicionY
    INC PosicionX
    LOOP LINE 
ENDLINE:
    POP BX DX AX CX
    RET
DRAW_LINE ENDP
;--------------------------------
;       DIBUJAR RECTANGULO
;--------------------------------
PAINT_RECT PROC
    PUSH AX DX BX
    MOV PosicionY, 0
    MOV CX, PosicionY2 
LINEREP:
    MOV CX, PosicionX2
    MOV PosicionX, 0
LINEX:
    DRAW_POINT 7, PosicionX, PosicionY
    INC PosicionX
    LOOP LINEX
REPL:
    INC PosicionY
    DEC PosicionY2
    MOV CX,PosicionY2
    LOOP LINEREP
EXIT:
    POP BX DX AX 
    RET 
PAINT_RECT ENDP
;------------------------------------
END CRUCIGRAMA