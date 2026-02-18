///|
extern "js" fn read_stdin() -> String =
  #| function() {
  #|   const fs = require("fs");
  #|   return fs.readFileSync(0, "utf8");
  #| }

///|
fn digit_sum(n : Int) -> Int {
  let mut sum = 0
  let mut n = n
  while n > 0 {
    sum += n % 10
    n /= 10
  }
  sum
}

///|
test "digit_sum" {
  assert_eq(digit_sum(314), 8)
}

///|
fn main {
  let input = read_stdin()
    .trim()
    .split(" ")
    .map(x => try! @strconv.parse_int(x))
    .to_array()
  guard input is [n, a, b]

  let mut ans = 0
  for i in 1..<=n {
    let sum = digit_sum(i)
    if a <= sum && sum <= b {
      ans += i
    }
  }
  println(ans)
}
