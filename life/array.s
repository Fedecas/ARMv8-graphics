
.globl moveToArrCoords
.globl moveToCopyCoords
.globl setCell
.globl setCopyCell
.globl getCell
.globl getCopyCell

moveToArrCoords:
    sub sp, sp, 8
    stur x9, [sp, 0]

    madd x9, x4, x20, x3
    add x1, x1, x9

    ldur x9, [sp, 0]
    add sp, sp, 8
    ret

moveToCopyCoords:
    sub sp, sp, 8
    stur x9, [sp, 0]

    madd x9, x4, x20, x3
    add x2, x2, x9

    ldur x9, [sp, 0]
    add sp, sp, 8
    ret

setCell:
    sub sp, sp, 16
    stur x1, [sp, 0]
    stur lr, [sp, 8]

    bl moveToArrCoords
    sturb w7, [x1]

    ldur x1, [sp, 0]
    ldur lr, [sp, 8]
    add sp, sp, 16
    ret

setCopyCell:
    sub sp, sp, 16
    stur x2, [sp, 0]
    stur lr, [sp, 8]

    bl moveToCopyCoords
    sturb w7, [x2]

    ldur x2, [sp, 0]
    ldur lr, [sp, 8]
    add sp, sp, 16
    ret

getCell:
    sub sp, sp, 16
    stur x1, [sp, 0]
    stur lr, [sp, 8]

    bl moveToArrCoords
    ldurb w7, [x1]

    ldur x1, [sp, 0]
    ldur lr, [sp, 8]
    add sp, sp, 16
    ret

getCopyCell:
    sub sp, sp, 16
    stur x2, [sp, 0]
    stur lr, [sp, 8]

    bl moveToCopyCoords
    ldurb w7, [x2]

    ldur x2, [sp, 0]
    ldur lr, [sp, 8]
    add sp, sp, 16
    ret
