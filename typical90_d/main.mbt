///|
extern "js" fn read_stdin() -> String =
  #| function() {
  #|   const fs = require("fs");
  #|   return fs.readFileSync(0, "utf8");
  #| }

///|
fn unsafe_parse_int(x : StringView) -> Int {
  try! @strconv.parse_int(x)
}

///|
fn add(a : Int, b : Int) -> Int {
  a + b
}

///|
fn main {
  let input = read_stdin()
  guard input.trim().split("\n").to_array() is [hw, .. rest]
  guard hw.split(" ").to_array().map(unsafe_parse_int) is [h, w]
  let arr = rest.map(x => x.split(" ").to_array().map(unsafe_parse_int))

  let sum_row = Array::makei(h, i => arr[i].fold(init=0, add))
  let sum_col = Array::makei(w, j => {
    arr.fold(init=0, (acc, row) => acc + row[j])
  })
  let ans = Array::makei(h, i => {
    Array::makei(w, j => sum_row[i] + sum_col[j] - arr[i][j])
    .map(x => x.to_string())
    .join(" ")
  }).join("\n")
  println(ans)
}
