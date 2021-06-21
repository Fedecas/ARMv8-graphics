
.equ SCREEN_WIDTH,          640
.equ SCREEN_HEIGHT,         480
.equ BITS_PER_PIXEL,        32
.equ PIXEL_BYTES,           (BITS_PER_PIXEL / 8)

//
.equ TILE_PIXELS,           1
.equ TILE_BYTES,            (TILE_PIXELS * PIXEL_BYTES)
.equ WIDTH_BYTES,           (SCREEN_WIDTH * PIXEL_BYTES)
.equ ROW_BYTES,             (SCREEN_WIDTH * TILE_BYTES)
.equ MAP_COLS,              (SCREEN_WIDTH / TILE_PIXELS)
.equ MAP_ROWS,              (SCREEN_HEIGHT / TILE_PIXELS)
.equ VEL_X,                 1
.equ VEL_Y,                 1
.equ MAX_X,                 (MAP_COLS - 1)
.equ MIN_X,                 0
.equ MAX_Y,                 (MAP_ROWS - 1)
.equ MIN_Y,                 0
.equ DELAY,                 0xFFF

.globl main
main:
    // Constantes
    // x0 base de FB
    mov x19, ROW_BYTES          // Bytes de cada fila del mapa
    mov x20, TILE_BYTES         // Bytes del ancho/alto de un tile
    mov x21, WIDTH_BYTES        // Bytes de cada fila de la pantalla
    mov x22, TILE_PIXELS        // Ancho/alto de un tile
    mov x23, VEL_X              // Cuánto aumenta x en cada frame
    mov x24, VEL_Y              // Cuánto aumenta y en cada frame

    // Inicializamos la animación
    mov x1, 0                   // Coordenada x inicial (en el mapa)
    mov x2, 0                   // Coordenada y inicial (en el mapa)
    mov x3, 1                   // Ancho (cantidad de tiles)
    mov x4, 1                   // Alto (cantidad de tiles)

    mov w5, 0xF                 // Color inicial

    mov x6, x23                 // Velocidad x inicial
    mov x7, x24                 // Velocidad y inicial

    mov w8, 0x100               // Modificador del color

    // Limpiamos la pantalla antes de iniciar
    bl cleanScreen

animLoop:
    // Guardamos el valor actual de las velocidades
    mov x9, x6
    mov x10, x7

    // Checkeamos que no se pase ningún límite y hacemos cambios si eso ocurre
    bl checkCollision

    // Dibujamos la caja en pantalla
    bl plotBox

    // Cambiamos de color si alguna velocidad cambió
    bl changeColor

    // Modificamos las velocidades
    add x1, x1, x6
    add x2, x2, x7

    // Esperamos un tiempo para ver los cambios
    bl delay

    // Repetimos infinitas veces
    b animLoop

// --------
moveToCoords:
/*
    Escribe en x0 la posición en pantalla para un X e Y relativos al mapa
    Parámetros:
        - x0    Base del FB
        - x1    X
        - x2    Y
 */
    sub sp, sp, 8
    stur x9, [sp]

    mul x9, x1, x20             // Transformamos x (x1) a tiles del mapa
    madd x9, x2, x19, x9        // Transformamos y (x2) a tiles del mapa y le sumamos x
    add x0, x0, x9              // Pasamos esas coordenadas relativas a absolutas en la pantalla

    ldur x9, [sp]
    add sp, sp, 8
    ret

plot:
    stur w5, [x0]       // Pintamos un pixel en pantalla
    ret

plotLine:
/*
    Dibuja una recta de largo x3 desde un punto x0
    Parámetros:
        - x0    Posición inicial
        - x3    Largo de la recta
 */
    sub sp, sp, 24
    stur x0, [sp, 0]
    stur x3, [sp, 8]
    stur lr, [sp, 16]

nextPixel:
    bl plot                     // Pintamos en la posición actual
    add x0, x0, PIXEL_BYTES     // Avanzamos un pixel
    sub x3, x3, 1
    cbnz x3, nextPixel

    ldur lr, [sp, 16]
    ldur x3, [sp, 8]
    ldur x0, [sp, 0]
    add sp, sp, 24
    ret

plotBox:
/*
    Dibuja una caja en el mapa
    Parámetros:
        - x0    Base del FB
        - x1    X relativo al mapa
        - x2    Y relativo al mapa
        - x3    Ancho de la caja (en tiles)
        - x4    Alto de la caja (en tiles)
        - x5    Color
 */
    sub sp, sp, 32
    stur x0, [sp, 0]
    stur x3, [sp, 8]
    stur x4, [sp, 16]
    stur lr, [sp, 24]

    bl moveToCoords         // Nos posicionamos en la pantalla de acuerdo a X e Y

    mul x3, x3, x22         // Pasamos el ancho de tiles a pixeles
    mul x4, x4, x22         // Pasamos el alto de tiles a pixeles
nextRow:
    bl plotLine             // Dibujamos la fila actual
    add x0, x0, x21         // Bajamos una fila
    sub x4, x4, 1
    cbnz x4, nextRow

    ldur x0, [sp, 0]
    ldur x3, [sp, 8]
    ldur x4, [sp, 16]
    ldur lr, [sp, 24]
    add sp, sp, 32
    ret

// --------
cleanScreen:
/*
    Pinta toda la pantalla de un color
 */
    sub sp, sp, 48
    stur x1, [sp, 0]
    stur x2, [sp, 8]
    stur x3, [sp, 16]
    stur x4, [sp, 24]
    stur x5, [sp, 32]
    stur lr, [sp, 40]

    mov x1, 0
    mov x2, 0
    mov x3, MAP_COLS
    mov x4, MAP_ROWS
    mov w5, 0xA1C5
    bl plotBox

    ldur x1, [sp, 0]
    ldur x2, [sp, 8]
    ldur x3, [sp, 16]
    ldur x4, [sp, 24]
    ldur x5, [sp, 32]
    ldur lr, [sp, 40]
    add sp, sp, 48
    ret

// --------
delay:
/*
    Hace busy-waiting para esperar a la siguiente iteración
 */
    sub sp, sp, 8
    stur x9, [sp, 0]

    mov w9, DELAY
delayLoop:
    sub x9, x9, 1
    cbnz x9, delayLoop

    ldur x9, [sp, 0]
    add sp, sp, 8
    ret

// --------
checkCollision:
/*
    Verifica que la caja no esté en los límites y si es así invierte la velocidad
    Parámetros:
        - x1    Coordenada X de la caja en el mapa
        - x2    Coordenada Y de la caja en el mapa
        - x6    Velocidad X
        - x7    Velocidad Y
 */
    // Verificamos para X
    cmp x1, MAX_X           // Vemos si está en el extremo derecho
    b.lt notRight
    sub x6, xzr, x23        // Le asignamos velocidad X negativa
notRight:
    cmp x1, MIN_X           // Vemos si está en el extremo izquierdo
    b.gt notLeft
    mov x6, x23             // Le asignamos velocidad X positiva
notLeft:

    // Verificamos para Y
    cmp x2, MAX_Y           // Vemos si está en el extremo inferior
    b.lt notBottom
    sub x7, xzr, x24        // Le asignamos velocidad Y negativa
notBottom:
    cmp x2, MIN_Y           // Vemos si está en el extremo superior
    b.gt notTop
    mov x7, x24             // Le asignamos velocidad Y positiva
notTop:
    ret

// --------
/*
    Compara las velocidades y si hay diferencias se cambia de color
    Parámetros:
        - x9    Velocidad X anterior
        - x6    Velocidad X actual
        - x10   Velocidad Y anterior
        - x7    Velocidad Y actual
        - x5    Color actual
        - x8    Modificador de color
 */
changeColor:
    cmp x9, x6
    b.ne change
    cmp x10, x7
    b.ne change
    b notChange
change:
    add w5, w5, w8
notChange:
    ret
