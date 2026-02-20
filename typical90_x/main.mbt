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
  let input = read_stdin().trim().split("\n").to_array()
  guard input is [nk, a, b]
  guard nk.split(" ").to_array().map(to_int) is [n, k]
  let a = a.split(" ").to_array().map(to_int)
  let b = b.split(" ").to_array().map(to_int)

  let mut need = 0
  for i in 0..<n {
    need += Int::abs(a[i] - b[i])
  }

  let ans = if need <= k && need % 2 == k % 2 { "Yes" } else { "No" }
  println(ans)
}
