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
fn main {
  let input = read_stdin()
  guard input.trim().split("\n").map(to_int).to_array() is [a, b, c, x]

  let mut ans = 0
  for i in 0..<=a {
    for j in 0..<=b {
      for k in 0..<=c {
        let sum = 500 * i + 100 * j + 50 * k
        if sum == x {
          ans += 1
        }
      }
    }
  }
  println(ans)
}
