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
  let input = read_stdin().trim()
  guard input.split("\n").to_array() is [npq, a]
  guard npq.split(" ").to_array().map(to_int) is [n, p, q]
  let a = a.split(" ").to_array().map(to_int)

  let mut ans = 0
  for i in 0..<n {
    for j in (i + 1)..<n {
      for k in (j + 1)..<n {
        for l in (k + 1)..<n {
          for m in (l + 1)..<n {
            let rem = [a[i], a[j], a[k], a[l], a[m]].fold(init=1, (acc, x) => {
              (acc.to_int64() * x.to_int64() % p.to_int64()).to_int()
            })
            if rem == q {
              ans += 1
            }
          }
        }
      }
    }
  }
  println(ans)
}
