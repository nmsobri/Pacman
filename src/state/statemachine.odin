package state

import "core:fmt"

StateMachine :: struct {
  pushState:   proc(_: ^StateMachine, _: ^StateInterface),
  changeState: proc(_: ^StateMachine, _: ^StateInterface),
  popState:    proc(_: ^StateMachine),
  input:       proc(_: ^StateMachine) -> bool,
  update:      proc(_: ^StateMachine),
  render:      proc(_: ^StateMachine),
  states:      [dynamic]^StateInterface,
}

StateMachine_init :: proc() -> ^StateMachine {
  sm := new(StateMachine)

  sm.pushState = pushState
  sm.changeState = changeState
  sm.popState = popState
  sm.input = input
  sm.update = update
  sm.render = render

  return sm
}


@(private = "file")
pushState :: proc(self: ^StateMachine, state: ^StateInterface) {
  if len(self.states) != 0 {
    if self.states[len(self.states) - 1]->stateID() == state->stateID() do return

    self.states[len(self.states) - 1]->onExit()
  }

  append(&self.states, state)
  self.states[len(self.states) - 1]->onEnter()
}


@(private = "file")
changeState :: proc(self: ^StateMachine, state: ^StateInterface) {
  if len(self.states) != 0 {
    if self.states[len(self.states) - 1]->stateID() == state->stateID() do return

    if self.states[len(self.states) - 1]->onExit() {
      state := pop(&self.states)
      free(state)
    }
  }

  append(&self.states, state)
  self.states[len(self.states) - 1]->onEnter()
}


@(private = "file")
popState :: proc(self: ^StateMachine) {
  if len(self.states) != 0 {
    self.states[len(self.states) - 1]->onExit()
    state := pop(&self.states)
    free(state)
  }

  if len(self.states) != 0 do self.states[len(self.states) - 1]->onEnter()
}


@(private = "file")
input :: proc(self: ^StateMachine) -> bool {
  if len(self.states) != 0 do return self.states[len(self.states) - 1]->input()
  return false
}


@(private = "file")
update :: proc(self: ^StateMachine) {
  if len(self.states) != 0 do self.states[len(self.states) - 1]->update()
}


@(private = "file")
render :: proc(self: ^StateMachine) {
  if len(self.states) != 0 do self.states[len(self.states) - 1]->render()
}
