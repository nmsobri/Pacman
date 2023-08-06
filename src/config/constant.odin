package config

import sdl "vendor:sdl2"

FPS :: 60
TICKS_PER_FRAME: f64 = 1000.0 / f64(FPS)

GAME_NAME :: "Pacmio"

WINDOW_HEIGHT :: 640
WINDOW_WIDTH :: 480

WINDOW_X :: sdl.WINDOWPOS_CENTERED
WINDOW_Y :: sdl.WINDOWPOS_CENTERED

WINDOW_FLAGS :: sdl.WindowFlags{.SHOWN}
