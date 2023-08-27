package game

import "../util"
import "./state"
import "../config"
import "core:fmt"
import "core:bytes"
import "core:image/png"
import sdl "vendor:sdl2"
import "vendor:sdl2/mixer"

Errno :: distinct i32
ERROR_NONE: Errno : 0
ERROR_INIT: Errno : 1
ICON :: #load("../../res/logo.png")

Game :: struct {
  count:         u32,
  close:         proc(_: ^Game),
  loop:          proc(_: ^Game),
  setWindowIcon: proc(_: ^Game),

  //Properties
  window:        ^sdl.Window,
  renderer:      ^sdl.Renderer,
  timer:         ^util.Timer,
  state_machine: ^state.StateMachine,
}


Game_Init :: proc() -> (Game, Errno) {
  game := Game{}
  game.loop = loop
  game.close = close
  game.setWindowIcon = setWindowIcon

  // Init SDL
  if status := sdl.Init(sdl.INIT_VIDEO | sdl.INIT_AUDIO); status < 0 {
    fmt.eprintf("ERROR: %s\n", sdl.GetError())
    return {}, ERROR_INIT
  }

  // Initialize SDL_mixer
  if mixer.OpenAudio(44100, mixer.DEFAULT_FORMAT, 2, 2048) < 0 {
    fmt.eprintf("SDL_MIXER could not initialize! SDL_MIXER ERROR: %s\n", sdl.GetError())
    return {}, ERROR_INIT
  }

  game.window = sdl.CreateWindow(config.GAME_NAME, config.WINDOW_X, config.WINDOW_Y, config.WINDOW_WIDTH, config.WINDOW_HEIGHT, config.WINDOW_FLAGS)
  game.renderer = sdl.CreateRenderer(game.window, -1, {.ACCELERATED})

  game.timer = util.Timer_init()
  game.state_machine = state.StateMachine_init()
  game->setWindowIcon()

  start_state := state.Start_Init(game.window, game.renderer, game.state_machine)
  game.state_machine->changeState(start_state)

  return game, ERROR_NONE
}


@(private = "file")
loop :: proc(self: ^Game) {
  ever := true

  for ever {
    self.timer->startTimer()

    if ok := self.state_machine->input(); !ok do ever = false
    self.state_machine->update()
    self.state_machine->render()

    time_taken := f64(self.timer->getTicks())

    if time_taken < config.TICKS_PER_FRAME {
      delay := config.TICKS_PER_FRAME - time_taken
      sdl.Delay(u32(delay))

    }
  }
}


@(private = "file")
close :: proc(self: ^Game) {
  sdl.DestroyWindow(self.window)
  sdl.DestroyRenderer(self.renderer)
  free(self.state_machine)
  free(self.timer)
  sdl.Quit()
}


@(private = "file")
setWindowIcon :: proc(self: ^Game) {
  rmask, gmask, bmask, amask: u32

  when ODIN_ENDIAN == .Big {
    rmask = 0xFF000000
    gmask = 0x00FF0000
    bmask = 0x0000FF00
    amask = 0x000000FF
  } else when ODIN_ENDIAN == .Little {

    rmask = 0x000000FF
    gmask = 0x0000FF00
    bmask = 0x00FF0000
    amask = 0xFF000000
  }

  icon_image, err := png.load(ICON)

  if err != nil {
    fmt.eprintf("Cannot load Png file: %s\n", sdl.GetError())
    return
  }

  defer png.destroy(icon_image)

  icon_surface := sdl.CreateRGBSurfaceFrom(raw_data(bytes.buffer_to_bytes(&icon_image.pixels)), 64, 64, 32, 256, rmask, gmask, bmask, amask)
  defer sdl.FreeSurface(icon_surface)

  sdl.SetWindowIcon(self.window, icon_surface)
}
