///|
extern "js" fn read_stdin() -> String =
  #| function() {
  #|   const fs = require("fs");
  #|   return fs.readFileSync(0, "utf8");
  #| }

///|
fn main {
  let input = read_stdin()
  let mut ans = 0
  for char in input {
    if char == '1' {
      ans = ans + 1
    }
  }
  println(ans)
}
