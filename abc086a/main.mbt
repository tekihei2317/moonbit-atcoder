///|
extern "js" fn read_stdin() -> String =
  #| function() {
  #|   const fs = require("fs");
  #|   return fs.readFileSync(0, "utf8");
  #| }

///|
fn main {
  let input = read_stdin()
    .trim()
    .split(" ")
    .to_array()
    .map(s => try! @strconv.parse_int(s))

  let ans = match input {
    [a, b] => if a * b % 2 == 1 { "Odd" } else { "Even" }
    _ => panic()
  }

  println(ans)
}
