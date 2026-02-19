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
fn gcd(a : Int64, b : Int64) -> Int64 {
  let mut a = a
  let mut b = b
  while b != 0 {
    let r = a % b
    a = b
    b = r
  }
  a
}

///|
fn main {
  let input = read_stdin()
  guard input.trim().split(" ").to_array().map(to_int64) is [a, b, c]

  let g = gcd(gcd(a, b), c)
  let ans = a / g + b / g + (c / g - 3)
  println(ans)
}
