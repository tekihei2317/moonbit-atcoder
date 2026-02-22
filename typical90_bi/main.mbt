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
  guard input.trim().split("\n").to_array() is [_q, .. tx]

  let front = []
  let back = []

  for line in tx {
    guard line.split(" ").to_array().map(to_int) is [t, x]

    match t {
      1 => front.push(x)
      2 => back.push(x)
      3 =>
        if x <= front.length() {
          // 前側にある場合
          let ans = front[front.length() - x]
          println(ans)
        } else {
          // 後ろ側にある場合
          let ans = back[x - front.length() - 1]
          println(ans)
        }
      _ => panic()
    }
  }
}
