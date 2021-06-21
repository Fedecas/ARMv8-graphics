
.include "value.s"

arrAddr:    .skip MAP_TILES

.globl main
main:
    // Array address
    // x0 - framebuffer base address
    ldr x1, =arrAddr            // Main array base address

    // Constants
    mov x18, BOX_PIXELS         // Number of pixels in height/width of each tile
    mov x19, ROW_SIZE           // Size (bytes) of each screen row
    mov x20, MAP_COLS           // Number of columns in map
    mul x21, x19, x18           // Size (bytes) of each map row
    mov x22, BOX_SIZE           // Size (bytes) of each map column
    movz w23, 0xFF68, lsl 16    // Main color
    movk w23, 0xC5A9, lsl 0

    // Setup initial state
    bl init

mainLoop:
    // Next step of the ant
    bl nextStep

    // Draw elements in screen
    bl updateScreen

    // Wait some time
    bl delay

    // Repeat
	b mainLoop

// --------
delay:
    sub sp, sp, 8
    stur x9, [sp, 0]

    movz x9, DELAY_16, lsl 16
delayLoop:
    sub x9, x9, 1
    cbnz x9, delayLoop

    ldur x9, [sp, 0]
    add sp, sp, 8
    ret
