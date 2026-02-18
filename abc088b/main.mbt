///|
extern "js" fn read_stdin() -> String =
  #| function() {
  #|   const fs = require("fs");
  #|   return fs.readFileSync(0, "utf8");
  #| }

///|
fn main {
  let input = read_stdin()
  let lines = input.trim().split("\n").to_array()
  guard lines is [_, line]
  let a = line.split(" ").to_array().map(x => try! @strconv.parse_int(x))

  a.sort_by_key(x => -x)
  let mut ans = 0
  for i, x in a.iter2() {
    if i % 2 == 0 {
      ans += x
    } else {
      ans -= x
    }
  }
  println(ans)
}
