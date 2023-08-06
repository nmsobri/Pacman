package main

import "core:fmt"

main :: proc() {
  game, err := Game_Init()

  if err != ERROR_NONE {
    fmt.eprintf("Cannot init SDL")
    return
  }

  game->loop()
  defer game->close()
}
