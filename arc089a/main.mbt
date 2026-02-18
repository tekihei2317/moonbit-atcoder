///|
extern "js" fn read_stdin() -> String =
  #| function() {
  #|   const fs = require("fs");
  #|   return fs.readFileSync(0, "utf8");
  #| }

///|
struct Point {
  t : Int
  x : Int
  y : Int
}

///|
fn main {
  let input = read_stdin().trim()
  let lines = match input.split("\n").to_array() {
    [_n, .. rest] => rest.to_array()
    _ => []
  }
  let points = lines.filter_map(line => {
    match line.split(" ").to_array().map(x => try? @strconv.parse_int(x)) {
      [Ok(t), Ok(x), Ok(y)] => Some({ t, x, y })
      _ => None
    }
  })
  let mut now = { t: 0, x: 0, y: 0 }
  let mut ok = true
  for next in points {
    let dt = Int::abs(next.t - now.t)
    let dx = Int::abs(next.x - now.x)
    let dy = Int::abs(next.y - now.y)

    if dt < dx + dy || dt % 2 != (dx + dy) % 2 {
      ok = false
    }
    now = next
  }
  println(if ok { "Yes" } else { "No" })
}
