///|
extern "js" fn read_stdin() -> String =
  #| function() {
  #|   const fs = require("fs");
  #|   return fs.readFileSync(0, "utf8");
  #| }

///|
fn main {
  let input = read_stdin()
  guard input.trim().split("\n").map(x => try! @strconv.parse_int(x)).to_array()
    is [a, b, c, x]

  let mut ans = 0
  for i = 0; i <= a; i = i + 1 {
    for j = 0; j <= b; j = j + 1 {
      for k = 0; k <= c; k = k + 1 {
        let sum = 500 * i + 100 * j + 50 * k
        if sum == x {
          ans = ans + 1
        }
      }
    }
  }
  println(ans)
}
