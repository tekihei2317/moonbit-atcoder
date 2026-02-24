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
fn solve(n : Int, y : Int) -> (Int, Int, Int) {
  for i = 0; i <= n; i = i + 1 {
    for j = 0; i + j <= n; j = j + 1 {
      let k = n - (i + j)
      let sum = 10000 * i + 5000 * j + 1000 * k
      if sum == y {
        return (i, j, k)
      }
    }
  }
  return (-1, -1, -1)
}

///|
fn main {
  guard read_stdin().trim().split(" ").map(to_int).to_array() is [n, y]
  let ans = solve(n, y)
  println("\{ans.0} \{ans.1} \{ans.2}")
}
