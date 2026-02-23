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
fn div_count(num : Int) -> Int {
  let mut num = num
  let mut count = 0
  while num % 2 == 0 {
    num /= 2
    count += 1
  }
  count
}

///|
fn main {
  let input = read_stdin()
  guard input.trim().split("\n").to_array() is [_n, a]
  let a = a.split(" ").map(to_int)
  let ans = a.map(div_count).fold(init=30, Int::min)
  println(ans)
}
