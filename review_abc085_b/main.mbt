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
  guard input.trim().split("\n").to_array() is [_, .. d]
  let d = d.map(to_int)

  let set = @set.Set::from_array(d)
  println(set.length())
}
