INCLUDE lib.inc

.model small
.stack 100h
.data
cols    equ 11       ; columnas
rows    equ 9       ; filas
cellW   equ 15       ; ancho de celda
cellH   equ 15       ; alto de celda
X_inicial equ 0
Y_inicial equ 0
ancho equ 135 

.code
start:
    mov ax, @data
    mov ds, ax

    ; Cambiar a modo gr?fico 13h
    SET_VIDEO_MODE 13h
    
    SET_BACKGROUND_COLOR_12h 12
    
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

    mov ax, 0A000h
    mov es, ax

    mov bx, dx         ; Y
    mov ax, bx
    shl ax, 6          ; Y*64
    shl bx, 8          ; Y*256
    add ax, bx         ; Y*320
    add ax, cx         ; X
    mov bx, ax         ; BX = offset en píxeles

    mov si, bx
    shr si, 1          ; SI = offset en bytes

    mov al, 0Fh        ; color (puedes cambiarlo)
    test bx, 1
    jz even_pixel
    ; Odd pixel: high nibble
    mov ah, es:[si]
    mov es:[si], al
    jmp fin_pixel
even_pixel:
    ; Even pixel: low nibble
    mov ah, [es:si]
    and ah, 0F0h
    or al, ah
    mov [es:si], al
fin_pixel:

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