///|
extern "js" fn read_stdin() -> String =
  #| function() {
  #|   const fs = require("fs");
  #|   return fs.readFileSync(0, "utf8");
  #| }

///|
fn _to_int(x : StringView) -> Int {
  try! @strconv.parse_int(x)
}

///|
fn main {
  let input = read_stdin().trim().split("\n").to_array()
  guard input is [_n, .. names]

  let st = @set.Set::new()
  for i, name in names {
    if !st.contains(name) {
      st.add(name)
      println(i + 1)
    }
  }
}
