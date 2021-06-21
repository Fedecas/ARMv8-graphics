
.include "value.s"

.globl updateScreen
.globl plotBox

updateScreen:
    sub sp, sp, 48
    stur x3, [sp, 0]
    stur x4, [sp, 8]
    stur x5, [sp, 16]
    stur x6, [sp, 24]
    stur x7, [sp, 32]
    stur lr, [sp, 40]

    mov x5, 1
    mov x6, 1

    mov x4, MAP_ROWS - 1
drawNextRow:
    mov x3, MAP_COLS - 1
drawCell:
    bl getCell
    cbz x7, paint
    mov x7, x23
paint:
    bl plotBox
    sub x3, x3, 1
    cmp x3, 0
    b.ge drawCell
    sub x4, x4, 1
    cmp x4, 0
    b.ge drawNextRow

    ldur x3, [sp, 0]
    ldur x4, [sp, 8]
    ldur x5, [sp, 16]
    ldur x6, [sp, 24]
    ldur x7, [sp, 32]
    ldur lr, [sp, 40]
    add sp, sp, 48
    ret

moveToCoords:
    sub sp, sp, 8
    stur x9, [sp, 0]

    mul x9, x3, x22             // Transformamos x (x3) a tiles del mapa
    madd x9, x4, x21, x9        // Transformamos y (x4) a tiles del mapa y le sumamos x
    add x0, x0, x9              // Pasamos esas coordenadas relativas a absolutas en la pantalla

    ldur x9, [sp, 0]
    add sp, sp, 8
    ret

plot:
    stur w7, [x0]       // Pintamos un pixel en pantalla
    ret

plotLine:
    sub sp, sp, 24
    stur x0, [sp, 0]
    stur x5, [sp, 8]
    stur lr, [sp, 16]

nextPixel:
    bl plot                     // Pintamos en la posición actual
    add x0, x0, PIXEL_SIZE      // Avanzamos un pixel
    sub x5, x5, 1
    cbnz x5, nextPixel

    ldur x0, [sp, 0]
    ldur x5, [sp, 8]
    ldur lr, [sp, 16]
    add sp, sp, 24
    ret

plotBox:
    sub sp, sp, 32
    stur x0, [sp, 0]
    stur x5, [sp, 8]
    stur x6, [sp, 16]
    stur lr, [sp, 24]

    bl moveToCoords         // Nos posicionamos en la pantalla de acuerdo a X e Y

    mul x5, x5, x18         // Pasamos el ancho de tiles a pixeles
    mul x6, x6, x18         // Pasamos el alto de tiles a pixeles
nextRow:
    bl plotLine             // Dibujamos la fila actual
    add x0, x0, x19         // Bajamos una fila
    sub x6, x6, 1
    cbnz x6, nextRow

    ldur x0, [sp, 0]
    ldur x5, [sp, 8]
    ldur x6, [sp, 16]
    ldur lr, [sp, 24]
    add sp, sp, 32
    ret
