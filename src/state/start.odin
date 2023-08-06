package state

import sdl "vendor:sdl2"

Start :: struct {
  using vtable:  StateInterface,
  window:        ^sdl.Window,
  renderer:      ^sdl.Renderer,
  state_machine: ^StateMachine,
}

Start_Init :: proc(window: ^sdl.Window, renderer: ^sdl.Renderer, state_machine: ^StateMachine) -> ^Start {
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

  return start
}


update :: proc(self: ^StateInterface) {}

render :: proc(self: ^StateInterface) {}

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
        //   play_state := PlayState_init(self.window, self.renderer, self.state_machine)
        //   self.state_machine->changeState(play_state)
        return true
      }
    }
  }

  return true
}

stateID :: proc(self: ^StateInterface) -> string {
  return "Start"
}

onEnter :: proc(self: ^StateInterface) -> bool {
  return false
}

onExit :: proc(self: ^StateInterface) -> bool {
  return false
}
