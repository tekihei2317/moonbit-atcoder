///|
extern "js" fn read_stdin() -> String =
  #| function() {
  #|   const fs = require("fs");
  #|   return fs.readFileSync(0, "utf8");
  #| }

///|
fn main {
  let input = read_stdin()
  guard input.trim().split(" ").to_array().map(x => try! @strconv.parse_int(x))
    is [a, b]
  let ans = if a * b % 2 == 0 { "Even" } else { "Odd" }
  println(ans)
}
