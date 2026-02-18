///|
extern "js" fn read_stdin() -> String =
  #| function() {
  #|   const fs = require("fs");
  #|   return fs.readFileSync(0, "utf8");
  #| }

///|
fn main {
  let line = read_stdin()
  guard line.trim().split("\n").map(x => try! @strconv.parse_int(x)).to_array()
    is [_, .. d]

  let ans = @set.Set::from_array(d).length()
  println(ans)
}
