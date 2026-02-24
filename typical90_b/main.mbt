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
fn check(n : Int, s : Int) -> Bool {
  let mut balance = 0
  for i in 0..<n {
    // 0が開き括弧、1が閉じ括弧とする
    if ((s >> (n - 1 - i)) & 1) == 0 {
      balance += 1
    } else {
      balance -= 1
    }
    if balance < 0 {
      return false
    }
  }
  return balance == 0
}

///|
fn bit_to_parenthesis(n : Int, s : Int) -> String {
  let mut str = ""
  for i in 0..<n {
    if ((s >> (n - 1 - i)) & 1) == 0 {
      str += "("
    } else {
      str += ")"
    }
  }
  str
}

///|
fn main {
  let input = read_stdin()
  let n = input.trim() |> to_int

  for s in 0..<(1 << n) {
    if check(n, s) {
      println(bit_to_parenthesis(n, s))
    }
  }
}
