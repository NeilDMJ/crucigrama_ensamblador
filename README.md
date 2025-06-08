| **Macro (Nombre y Parámetros)** | **Funcionalidad** |
|-------------------------------|--------------------|
| `SET_VIDEO_MODE mode` | Establece el modo de video especificado en `mode` usando la interrupción `INT 10h`. |
| `SET_BACKGROUND_COLOR_12H color` | Cambia el color de fondo en el modo de video 12h (640x480) al color indicado (0-15). Utiliza `INT 10h, AH=0Bh`. |
| `DRAW_HORIZONTAL_LINE x1, y, length, col` | Dibuja una línea horizontal de longitud `length`, comenzando en la coordenada `(x1, y)` con el color `col`. Utiliza `INT 10h, AH=0Ch`. |
| `DRAW_VERTICAL_LINE x, y1, length, col` | Dibuja una línea vertical desde la posición `(x, y1)` hacia abajo, de longitud `length` y color `col`. |
| `DRAW_BOX x, y, width, height, col` | Dibuja un rectángulo (solo contorno) en la posición `(x, y)` con ancho `width`, alto `height` y color `col`. Usa líneas horizontales y verticales. |
| `DRAW_FILLED_BOX x, y, width, height, col` | Dibuja un rectángulo sólido (relleno) desde la posición `(x, y)` con dimensiones `width x height` y color `col`. |
| `PRINT_STRING row, col, msg, color` | Imprime una cadena de texto (`msg`) en modo texto en la posición `(row, col)` con color `color`. Utiliza `INT 10h` para posicionar y `INT 21h` para imprimir. |
| `PRINT_CHAR row, col, char, color` | Imprime un carácter ASCII (`char`) en la posición de texto `(row, col)` con el color de atributo `color`. Utiliza `INT 10h` para posicionar e imprimir. |
| `DRAW_BUTTON x, y, width, height, btn_color, text_row, text_col, text, text_color` | Dibuja un botón con fondo de color `btn_color` y borde blanco en `(x, y)` de tamaño `width x height`. Imprime texto `text` en modo texto en la posición `(text_row, text_col)` con color `text_color`. |
