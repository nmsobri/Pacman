package entity

import "core:os"
import "core:fmt"
import "core:strings"

Board :: struct {
  board: [33][30]u8,
}

Board_init :: proc() -> Board {
  data, ok := os.read_entire_file("res/level/level1.txt")
  assert(ok, "Error reading level file")
  defer delete(data)

  it := string(data)

  for line in strings.split_lines_iterator(&it) {
    fmt.println(line)
  }

  return {}
}
