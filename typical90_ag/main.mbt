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
  let input = read_stdin().trim()
  guard input.split(" ").to_array().map(to_int) is [h, w]
  let ans = if h == 1 || w == 1 { h * w } else { (h + 1) / 2 * ((w + 1) / 2) }
  println(ans)
}
