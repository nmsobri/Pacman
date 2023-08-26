package state

import "core:os"
import "core:fmt"
import "../entity"
import "core:strings"
import sdl "vendor:sdl2"

Play :: struct {
  using vtable:  StateInterface,
  window:        ^sdl.Window,
  renderer:      ^sdl.Renderer,
  state_machine: ^StateMachine,
  board:         entity.Board,
}

Play_init :: proc(window: ^sdl.Window, renderer: ^sdl.Renderer, state_machine: ^StateMachine) -> ^StateInterface {
  play := new(Play)

  play.update = update
  play.render = render
  play.input = input
  play.stateID = stateID
  play.onEnter = onEnter
  play.onExit = onExit
  play.variant = play

  play.window = window
  play.renderer = renderer
  play.state_machine = state_machine

  return play
}


@(private = "file")
update :: proc(self: ^StateInterface) {

}


@(private = "file")
render :: proc(self: ^StateInterface) {
  self, ok := self.variant.(^Play)
  assert(ok, "Cannot get Play State")
  sdl.RenderClear(self.renderer)


  sdl.RenderPresent(self.renderer)
}


@(private = "file")
input :: proc(self: ^StateInterface) -> bool {
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
        // play_state := Play_init(self.window, self.renderer, self.state_machine)
        // self.state_machine->changeState(play_state)
        return true
      }
    }
  }
  return true
}


@(private = "file")
stateID :: proc(self: ^StateInterface) -> string {
  return "Play"
}


@(private = "file")
onEnter :: proc(self: ^StateInterface) -> bool {
  return false
}


@(private = "file")
onExit :: proc(self: ^StateInterface) -> bool {
  return false
}
