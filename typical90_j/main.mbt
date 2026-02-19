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
fn read() -> (Int, Array[(Int, Int)], Int, Array[(Int, Int)]) {
  let lines = read_stdin().trim().split("\n").to_array()
  let mut idx = 0

  let n = to_int(lines[idx])
  idx += 1

  let cp = Array::make(n, (0, 0))
  for i in 0..<n {
    guard lines[idx].split(" ").to_array().map(to_int) is [c, p]
    cp[i] = (c, p)
    idx += 1
  }

  let q = to_int(lines[idx])
  idx += 1

  let lr = Array::make(q, (0, 0))
  for i in 0..<q {
    guard lines[idx].split(" ").to_array().map(to_int) is [l, r]
    lr[i] = (l, r)
    idx += 1
  }

  return (n, cp, q, lr)
}

///|
fn main {
  let (n, cp, q, lr) = read()

  let sum1 = Array::make(n + 1, 0)
  let sum2 = Array::make(n + 1, 0)
  for index, x in cp {
    if x.0 == 1 {
      sum1[index + 1] = sum1[index] + x.1
      sum2[index + 1] = sum2[index]
    } else {
      sum1[index + 1] = sum1[index]
      sum2[index + 1] = sum2[index] + x.1
    }
  }

  for i in 0..<q {
    // [l, r)
    let l = lr[i].0 - 1
    let r = lr[i].1
    println("\{sum1[r] - sum1[l]} \{sum2[r] - sum2[l]}")
  }
}
