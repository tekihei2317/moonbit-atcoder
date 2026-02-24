///|
extern "js" fn read_stdin() -> String =
  #| function() {
  #|   const fs = require("fs");
  #|   return fs.readFileSync(0, "utf8");
  #| }

///|
fn to_int(x : StringView) -> Int {
  try! @strconv.parse_int(x)
}

///|
struct Plan {
  t : Int
  x : Int
  y : Int
}

///|
fn main {
  let input = read_stdin()
  guard input.trim().split("\n").to_array() is [_, .. plans]
  let plans = plans.map(plan => {
    guard plan.split(" ").map(to_int).to_array() is [t, x, y]
    Plan::{ t, x, y }
  })

  // 全ての移動ができるかどうかを判定する
  let mut now = { t: 0, x: 0, y: 0 }
  for plan in plans {
    let dt = plan.t - now.t
    let dx = Int::abs(plan.x - now.x)
    let dy = Int::abs(plan.y - now.y)

    if dt < dx + dy || dt % 2 != (dx + dy) % 2 {
      println("No")
      return
    }
    now = plan
  }
  println("Yes")
}
