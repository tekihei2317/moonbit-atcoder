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
  guard input.trim().split("\n").to_array() is [_n, a, b]
  let a = a.split(" ").map(to_int).to_array()
  let b = b.split(" ").map(to_int).to_array()

  a.sort()
  b.sort()
  let mut ans : Int64 = 0
  for i = 0; i < a.length(); i = i + 1 {
    ans += Int::abs(a[i] - b[i]).to_int64()
  }
  println(ans)
}
