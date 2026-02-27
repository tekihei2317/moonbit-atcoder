///|
extern "js" fn read_stdin() -> String =
  #| function() {
  #|   const fs = require("fs");
  #|   return fs.readFileSync(0, "utf8");
  #| }

///|
fn to_int64(x : StringView) -> Int64 {
  try! @strconv.parse_int64(x)
}

///|
fn main {
  let input = read_stdin()
  guard input.trim().split("\n").to_array() is [n, abc]
  let n = n |> to_int64
  guard abc.split(" ").to_array().map(to_int64) is [a, b, c]

  let mut ans = 1001001001
  for i = 0; i < 10000; i = i + 1 {
    let ai = a * i.to_int64()
    if ai > n {
      break
    }
    let mut rest = n - ai
    for j = 0; i + j < 10000; j = j + 1 {
      if rest < 0 {
        break
      }
      if rest % c != 0 {
        rest -= b
        continue
      }
      let k = (rest / c).to_int()
      ans = Int::min(ans, i + j + k)
      rest -= b
    }
  }
  println(ans)
}
