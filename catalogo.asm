; filepath: d:\Universidad\Programacion\ensamblador\proyecto_tercer_parcial\crucigrama_ensamblador\tablero.asm
; Crucigrama simple con las palabras: chef, reportero, astronauta, policia, doctor

.MODEL small
.STACK 100
.DATA
PUBLIC catalogo

; Palabras del catálogo
catalogo db "chef      "
         db "reportero "
         db "astronauta"
         db "policia   "
         db "doctor    "

; Tablero 12x10 (espacios vacíos = ' ')
tablero db 12*10 dup(' ')

; Caracteres especiales
hor db 196   ; '─'
ver db 179   ; '│'
esq_sup_izq db 218 ; '┌'
esq_sup_der db 191 ; '┐'
esq_inf_izq db 192 ; '└'
esq_inf_der db 217 ; '┘'
cruce db 197 ; '┼'

.CODE
main PROC FAR
    mov ax, @data
    mov ds, ax
