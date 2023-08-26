package state

import "../../util"
import "../../config"
import sdl "vendor:sdl2"

FONT_DATA :: #load("../../../res/Futura.ttf")

Start :: struct {
  using vtable:  StateInterface,
  window:        ^sdl.Window,
  renderer:      ^sdl.Renderer,
  state_machine: ^StateMachine,
  font:          ^util.BitmapFont,
}


Start_Init :: proc(window: ^sdl.Window, renderer: ^sdl.Renderer, state_machine: ^StateMachine) -> ^StateInterface {
  start := new(Start)

  start.update = update
  start.render = render
  start.input = input
  start.stateID = stateID
  start.onEnter = onEnter
  start.onExit = onExit
  start.variant = start

  start.window = window
  start.renderer = renderer
  start.state_machine = state_machine
  start.font, _ = util.BitmapFont_init(start.renderer, FONT_DATA, 25)

  return start
}


@(private = "file")
update :: proc(self: ^StateInterface) {}


@(private = "file")
render :: proc(self: ^StateInterface) {
  self := self.variant.(^Start)

  sdl.SetRenderDrawColor(self.renderer, 0xFF, 0xFF, 0xFF, 0xFF)
  sdl.RenderClear(self.renderer)

  text := "Press Enter To Start"
  text_width := self.font->calculateTextWidth(text)
  self.font->renderText(i32((config.WINDOW_WIDTH / 2) - (text_width / 2)), i32(config.WINDOW_HEIGHT / 2 - (self.font->getGlyphHeight() / 2)), text, 255, 0, 0)
  sdl.RenderPresent(self.renderer)
}


@(private = "file")
input :: proc(self: ^StateInterface) -> bool {
  self, ok := self.variant.(^Start)
  assert(ok, "Cannot get Start State")

  event: sdl.Event

  for sdl.PollEvent(&event) {
    #partial switch event.type {
    case .QUIT:
      return false
    case .KEYDOWN:
      #partial switch (event.key.keysym.sym) {
      case .ESCAPE:
        return false
      case .RETURN:
        play_state := Play_init(self.window, self.renderer, self.state_machine)
        self.state_machine->changeState(play_state)
        return true
      }
    }
  }

  return true
}


@(private = "file")
stateID :: proc(self: ^StateInterface) -> string {
  return "Start"
}


@(private = "file")
onEnter :: proc(self: ^StateInterface) -> bool {
  return false
}


@(private = "file")
onExit :: proc(self: ^StateInterface) -> bool {
  return false
}
