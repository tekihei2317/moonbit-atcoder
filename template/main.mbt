///|
extern "js" fn read_stdin() -> String =
  #| function() {
  #|   const fs = require("fs");
  #|   return fs.readFileSync(0, "utf8");
  #| }

///|
fn _unsafe_parse_int(x : StringView) -> Int {
  try! @strconv.parse_int(x)
}

///|
fn main {
  let _ = read_stdin()
}
