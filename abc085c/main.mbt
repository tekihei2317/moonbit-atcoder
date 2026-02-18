///|
extern "js" fn read_stdin() -> String =
  #| function() {
  #|   const fs = require("fs");
  #|   return fs.readFileSync(0, "utf8");
  #| }

///|
fn main {
  let input = read_stdin()
  guard input.trim().split(" ").map(x => try! @strconv.parse_int(x)).to_array()
    is [n, y]

  let mut ans : (Int, Int, Int)? = None
  for i = 0; i <= n; i = i + 1 {
    for j = 0; i + j <= n; j = j + 1 {
      let k = n - (i + j)

      let total = 10000 * i + 5000 * j + 1000 * k
      if total == y {
        ans = Some((i, j, k))
      }
    }
  }

  let (x, y, z) = ans.unwrap_or((-1, -1, -1))
  println("\{x} \{y} \{z}")
}
