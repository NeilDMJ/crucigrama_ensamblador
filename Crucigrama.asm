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
    MSGF3      DB 'F3 $'
    MSGEND     DB 'END CRUCIGRAMA$'
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

    ; Cambiar a modo gr?fico 13h
    SET_VIDEO_MODE 13h
    
    SET_BACKGROUND_COLOR_13H 3
    
    mov si, X_inicial  ; Coordenada X inicial
    mov di, Y_inicial  ; Coordenada Y inicial
    mov bx, ancho      ; Alto (cuadrado = ancho x ancho)
    mov cx, ancho+30      ; Ancho
    mov al, 0h        ; Color (ej: rojo brillante)
    call dibujar_cuadrado

    call dibujarCuadricula

    ; Esperar tecla para salir
    mov ah, 0
    int 16h

    ; Regresar a modo texto
    SET_VIDEO_MODE 3h

    mov ax, 4C00h
    int 21h

; --------------------------
; Dibuja la cuadricula
; --------------------------
dibujarCuadricula proc
    mov cx, 0
filaLoop:
    mov dx, 0
colLoop:
    push cx
    push dx
    mov ax, dx
    mov bl, cellW
    mul bl             ; ax = dx * cellW
    mov si, ax         ; si = x

    mov ax, cx
    mov bl, cellH
    mul bl             ; ax = cx * cellH
    mov di, ax         ; di = y

    call dibujarRectangulo
    pop dx
    pop cx
    inc dx
    cmp dx, cols
    jl colLoop
    inc cx
    cmp cx, rows
    jl filaLoop
    ret
dibujarCuadricula endp

dibujarRectangulo proc
    push ax bx cx dx

    ; Lado superior
    mov cx, si
    mov dx, di
    mov bx, 0
sup_loop:
    call putpixel
    inc cx
    inc bx
    cmp bx, cellW
    jl sup_loop

    ; Lado inferior
    mov cx, si
    mov dx, di
    add dx, cellH
    dec dx
    mov bx, 0
inf_loop:
    call putpixel
    inc cx
    inc bx
    cmp bx, cellW
    jl inf_loop

    ; Lado izquierdo
    mov cx, si
    mov dx, di
    mov bx, 0
izq_loop:
    call putpixel
    inc dx
    inc bx
    cmp bx, cellH
    jl izq_loop

    ; Lado derecho
    mov cx, si
    add cx, cellW
    dec cx
    mov dx, di
    mov bx, 0
der_loop:
    call putpixel
    inc dx
    inc bx
    cmp bx, cellH
    jl der_loop

    pop dx cx bx ax
    ret
dibujarRectangulo endp

putpixel proc
    push ax bx cx dx
    mov ah, 0Ch
    mov al, 15     ; color blanco
    mov bh, 0
    int 10h
    pop dx cx bx ax
    ret
putpixel endp

putpixel_n proc
    push ax bx cx dx
    mov ah, 0Ch
    mov al, 0     ; color blanco
    mov bh, 0
    int 10h
    pop dx cx bx ax
    ret
putpixel_n endp


; SI = X inicial
; DI = Y inicial
; CX = ancho
; BX = alto
; AL = color

dibujar_cuadrado proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp            ; Guardar BP adicionalmente

    ; Configurar parámetros iniciales
    mov dx, di          ; DX = Y inicial (y será coordenada Y actual)
    mov di, si          ; DI = X inicial (guardamos el valor original)
    mov bp, cx          ; BP = ancho (se preserva para el bucle interno)
    push bx             ; Guardar alto en pila (contador de filas)

dibujar_fila:
    mov si, di          ; SI = X inicial (restablecer para cada fila)
    mov cx, bp          ; CX = ancho (contador de columnas)

dibujar_columna:
    call putpixel_n       ; Dibujar pixel en (SI, DX) - color en AL
    inc si              ; Siguiente columna (X+1)
    loop dibujar_columna

    inc dx              ; Siguiente fila (Y+1)
    
    ; Manejar contador de filas (alto)
    pop cx              ; Recuperar contador de filas
    dec cx              ; Decrementar contador
    jz fin_cuadrado     ; Terminar si es cero
    push cx             ; Sino, guardar nuevo valor
    jmp dibujar_fila    ; Repetir para siguiente fila

fin_cuadrado:
    pop bp              ; Restaurar registros
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
dibujar_cuadrado endp
end start