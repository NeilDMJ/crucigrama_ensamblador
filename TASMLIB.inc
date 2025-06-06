
SET_VIDEO_MODE MACRO modo
    push ax
    mov ah, 00h
    mov al, modo
    int 10h
    pop ax
ENDM
SET_VIDEO_12H MACRO
    push ax
    mov ah, 00h
    mov al, 12H
    int 10h
    pop ax
ENDM

SALTO_LINEA MACRO
    PUSH AX
    PUSH DX
    MOV AH, 02H     ; funci??n para imprimir un car??cter
    MOV DL, 0DH     ; carriage return (CR)
    INT 21H
    MOV DL, 0AH     ; line feed (LF)
    INT 21H
    POP DX
    POP AX
ENDM

PRINT MACRO string
    PUSH AX
    PUSH DX
        
    MOV AH, 09h      ; DOS function: print string
    LEA DX, string   ; Load effective address of string
    INT 21h          ; Call DOS interrupt
        
    POP DX
    POP AX
ENDM
    
GOTOXY MACRO X, Y
    PUSH AX
    PUSH BX
    PUSH DX
    
    MOV AH, 02h     ; BIOS service to set cursor position
    MOV BH, 0       
    MOV DL, X       ; Column (X)
    MOV DH, Y       ; Row (Y)
    INT 10h         ; 
    
    POP DX
    POP BX
    POP AX
ENDM

DRAW_POINT MACRO color_point, x_point, y_point
    PUSH CX DX                          ;Dibuja un punto en la pantalla (En modo grafico)
        MOV AH,0CH                      ;Func 0C/Int 10h
        MOV AL,color_point              ;color 0-15
        MOV BH,0                        ;pagina (0 por default en esta aplicacion)
        MOV CX,x_point                  ;Columna
        MOV DX,y_point                  ;Fila
        INT 10H                         ;Interrupt 10h Video functions
    POP  DX CX
ENDM 