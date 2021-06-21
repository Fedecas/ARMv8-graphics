
.include "value.s"

.globl init
.globl nextGeneration

init:
    sub sp, sp, 32
    stur x3, [sp, 0]
    stur x4, [sp, 8]
    stur x7, [sp, 16]
    stur lr, [sp, 24]

    mov x3, (MAP_COLS / 2) - 3
    mov x4, (MAP_ROWS / 2) - 1
    mov w7, w23

    bl setCell
    add x3, x3, 1
    bl setCell
    add x3, x3, 3
    bl setCell
    add x3, x3, 1
    bl setCell
    add x3, x3, 1
    bl setCell

    add x4, x4, 1
    sub x3, x3, 3
    bl setCell

    sub x3, x3, 2
    add x4, x4, 1
    bl setCell

    ldur x3, [sp, 0]
    ldur x4, [sp, 8]
    ldur x7, [sp, 16]
    ldur lr, [sp, 24]
    add sp, sp, 32
    ret

checkCell:
    sub sp, sp, 8
    stur lr, [sp, 0]

    bl getCopyCell
    cbz x7, deadCell
    add x8, x8, 1
deadCell:

    ldur lr, [sp, 0]
    add sp, sp, 8
    ret

checkSides:
    sub sp, sp, 24
    stur x3, [sp, 0]
    stur x9, [sp, 8]
    stur lr, [sp, 16]

    mov x9, x3

    // left
    cmp x9, MIN_X
    b.eq endLeft
    sub x3, x9, 1
    bl checkCell
endLeft:

    // right
    cmp x9, MAX_X
    b.eq endRight
    add x3, x9, 1
    bl checkCell
endRight:

    ldur x3, [sp, 0]
    ldur x9, [sp, 8]
    ldur lr, [sp, 16]
    add sp, sp, 24
    ret

neighbours:
    sub sp, sp, 24
    stur x4, [sp, 0]
    stur x9, [sp, 8]
    stur lr, [sp, 16]

    mov x8, 0
    mov x9, x4

    // mid
    bl checkSides

    // top
    cmp x9, MIN_Y
    b.eq endTop
    sub x4, x9, 1
    bl checkCell
    bl checkSides
endTop:

    // bottom
    cmp x9, MAX_Y
    b.eq endBottom
    add x4, x9, 1
    bl checkCell
    bl checkSides
endBottom:

    ldur x4, [sp, 0]
    ldur x9, [sp, 8]
    ldur lr, [sp, 16]
    add sp, sp, 24
    ret

updateCell:
    sub sp, sp, 8
    stur lr, [sp, 0]

    bl neighbours       // x8
    bl getCopyCell      // x7
    cbz x7, isDead
    cmp x8, 2
    b.lo die
    cmp x8, 3
    b.hi die
    b end               // still live
die:
    mov x7, 0
    b end
isDead:
    cmp x8, 3
    b.ne end
    mov x7, x23
end:
    bl setCell

    ldur lr, [sp, 0]
    add sp, sp, 8
    ret

copyArrToCopy:
    sub sp, sp, 24
    stur x3, [sp, 0]
    stur x4, [sp, 8]
    stur lr, [sp, 16]

    mov x4, MAP_ROWS - 1
nextGenRow2:
    mov x3, MAP_COLS - 1
genRow2:
    bl getCell
    bl setCopyCell
    sub x3, x3, 1
    cmp x3, 0
    b.ge genRow2
    sub x4, x4, 1
    cmp x4, 0
    b.ge nextGenRow2

    ldur x3, [sp, 0]
    ldur x4, [sp, 8]
    ldur lr, [sp, 16]
    add sp, sp, 24
    ret

nextGeneration:
    sub sp, sp, 24
    stur x3, [sp, 0]
    stur x4, [sp, 8]
    stur lr, [sp, 16]

    bl copyArrToCopy

    mov x4, MAP_ROWS - 1
nextGenRow:
    mov x3, MAP_COLS - 1
genRow:
    bl updateCell
    sub x3, x3, 1
    cmp x3, 0
    b.ge genRow
    sub x4, x4, 1
    cmp x4, 0
    b.ge nextGenRow

    ldur x3, [sp, 0]
    ldur x4, [sp, 8]
    ldur lr, [sp, 16]
    add sp, sp, 24
    ret
