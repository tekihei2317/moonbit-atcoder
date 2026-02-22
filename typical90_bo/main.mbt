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
fn base8_to_long(n : StringView) -> Int64 {
  let mut res : Int64 = 0
  for ch in n {
    let digit = (ch.to_int() - ('0' |> Char::to_int)).to_int64()
    res = res * 8 + digit
  }
  res
}

///|
fn long_to_base9(n : Int64) -> String {
  if n == 0 {
    return "0"
  }
  let mut n = n
  let mut res = ""
  while n > 0 {
    res = (n % 9).to_string() + res
    n /= 9
  }
  res
}

///|
fn main {
  let input = read_stdin()
  guard input.trim().split(" ").to_array() is [n, k]
  let mut n = n.to_string()
  let k = k |> to_int

  for _ in 0..<k {
    n = n
      |> base8_to_long
      |> long_to_base9
      |> String::replace_all(old="8", new="5")
  }
  println(n)
}
