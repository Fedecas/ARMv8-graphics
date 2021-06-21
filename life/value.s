
.ifndef VALUE_S
.equ VALUE_S,               1

.equ SCREEN_WIDTH,          640
.equ SCREEN_HEIGHT,         480
.equ BITS_PER_PIXEL,        32
.equ PIXEL_SIZE,            (BITS_PER_PIXEL / 8)

.equ BOX_PIXELS,            5
.equ BOX_SIZE,              (BOX_PIXELS * PIXEL_SIZE)
.equ ROW_SIZE,              (SCREEN_WIDTH * PIXEL_SIZE)

.equ MAP_COLS,              (SCREEN_WIDTH / BOX_PIXELS)
.equ MAP_ROWS,              (SCREEN_HEIGHT / BOX_PIXELS)
.equ MAP_TILES,             (MAP_COLS * MAP_ROWS)

.equ MIN_X,                 0
.equ MAX_X,                 (MAP_COLS - 1)
.equ MIN_Y,                 0
.equ MAX_Y,                 (MAP_ROWS - 1)

.equ DELAY_16,              0x1F

.endif
