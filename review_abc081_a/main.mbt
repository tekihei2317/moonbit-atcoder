///|
extern "js" fn read_stdin() -> String =
  #| function() {
  #|   const fs = require("fs");
  #|   return fs.readFileSync(0, "utf8");
  #| }

///|
fn main {
  let s = read_stdin().trim()
  let ans = s.iter().filter(c => c == '1').count()
  println(ans)
}
