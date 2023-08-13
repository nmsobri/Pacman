package main

import "game"
import "core:fmt"

main :: proc() {
  g, err := game.Game_Init()

  if err != game.ERROR_NONE {
    fmt.eprintf("Cannot init SDL")
    return
  }

  g->loop()
  defer g->close()
}
