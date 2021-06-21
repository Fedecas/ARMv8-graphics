
.include "value.s"

.globl updateScreen
.globl plotBox

updateScreen:
    sub sp, sp, 32
    stur x3, [sp, 0]
    stur x4, [sp, 8]
    stur x7, [sp, 16]
    stur lr, [sp, 24]

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
    ldur x7, [sp, 16]
    ldur lr, [sp, 24]
    add sp, sp, 32
    ret

moveToCoords:
    sub sp, sp, 8
    stur x9, [sp, 0]

    mul x9, x3, x22
    madd x9, x4, x21, x9
    add x0, x0, x9

    ldur x9, [sp, 0]
    add sp, sp, 8
    ret

plot:
    stur w7, [x0]
    ret

plotLine:
    sub sp, sp, 16
    stur x0, [sp, 0]
    stur lr, [sp, 8]

    mov x5, x18
nextPixel:
    bl plot
    add x0, x0, PIXEL_SIZE
    sub x5, x5, 1
    cbnz x5, nextPixel

    ldur x0, [sp, 0]
    ldur lr, [sp, 8]
    add sp, sp, 16
    ret

plotBox:
    sub sp, sp, 32
    stur x0, [sp, 0]
    stur x5, [sp, 8]
    stur x6, [sp, 16]
    stur lr, [sp, 24]

    bl moveToCoords

    mov x6, x18
nextRow:
    bl plotLine
    add x0, x0, x19
    sub x6, x6, 1
    cbnz x6, nextRow

    ldur x0, [sp, 0]
    ldur x5, [sp, 8]
    ldur x6, [sp, 16]
    ldur lr, [sp, 24]
    add sp, sp, 32
    ret
