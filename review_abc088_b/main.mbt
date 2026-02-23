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
  guard input.trim().split("\n").to_array() is [_n, a]
  let a = a.split(" ").map(to_int).to_array()
  a.sort()
  let a = a.rev()

  let mut ans = 0
  for i, num in a {
    ans += if i % 2 == 0 { num } else { -num }
  }
  println(ans)
}
