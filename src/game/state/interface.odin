package state

StateInterface :: struct {
  update:  proc(_: ^StateInterface),
  render:  proc(_: ^StateInterface),
  input:   proc(_: ^StateInterface) -> bool,
  stateID: proc(_: ^StateInterface) -> string,
  onEnter: proc(_: ^StateInterface) -> bool,
  onExit:  proc(_: ^StateInterface) -> bool,
  variant: union {
    ^Start,
    ^Play,
    ^Pause,
    ^GameOver,
  },
}
