
.include "value.s"

.globl init
.globl nextStep

init:
    mov x3, MAP_COLS / 2
    mov x4, MAP_ROWS / 2
    mov w7, w23
    mov w8, 0
    ret

rotate:
    cbz w7, turnRight
    sub w8, w8, 1
    b endRotate
turnRight:
    add w8, w8, 1
endRotate:
    and w8, w8, 3
    ret

changeColor:
    sub sp, sp, 16
    stur x7, [sp, 0]
    stur lr, [sp, 8]

    add w7, w7, w7, lsl 8
    add w7, w7, w7, lsl 16
    mvn w7, w7
    bl setCell

    ldur x7, [sp, 0]
    ldur lr, [sp, 8]
    add sp, sp, 16
    ret

move:
    cmp w8, 0       // left
    b.ne notLeft
    sub x3, x3, 1
    b endMove
notLeft:
    cmp w8, 1       // up
    b.ne notUp
    sub x4, x4, 1
    b endMove 
notUp:
    cmp w8, 2       // right
    b.ne notRight
    add x3, x3, 1
    b endMove
notRight:
    cmp w8, 3       // down
    add x4, x4, 1
endMove:
    ret

nextStep:
    sub sp, sp, 16
    stur lr, [sp, 0]
    stur x7, [sp, 8]

    bl getCell
    bl rotate
    bl changeColor
    bl move

    ldur lr, [sp, 0]
    stur x7, [sp, 8]
    add sp, sp, 16
    ret
