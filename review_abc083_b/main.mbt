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
fn digit_sum(x : Int) -> Int {
  // 各桁の和を求める
  let mut x = x
  let mut sum = 0
  while x > 0 {
    sum += x % 10
    x /= 10
  }
  sum
}

///|
test "digit_sum" {
  assert_eq(digit_sum(23), 5)
  assert_eq(digit_sum(3141), 9)
}

///|
fn main {
  let input = read_stdin()
  guard input.trim().split(" ").map(to_int).to_array() is [n, a, b]

  let mut ans = 0
  for i in 1..<=n {
    let sum = digit_sum(i)
    if a <= sum && sum <= b {
      ans += i
    }
  }
  println(ans)
}
