///|
extern "js" fn read_stdin() -> String =
  #| function() {
  #|   const fs = require("fs");
  #|   return fs.readFileSync(0, "utf8");
  #| }

///|
fn main {
  let s = read_stdin().trim()
  let ts = ["dream", "dreamer", "erase", "eraser"]
  let n = s.length()

  let dp = Array::make(n + 1, false)
  dp[0] = true

  for i = 0; i < n; i = i + 1 {
    if !dp[i] {
      continue
    }
    for t in ts {
      let ok = try! s[i:].has_prefix(t)
      if ok {
        dp[i + t.length()] = true
      }
    }
  }
  println(if dp[n] { "YES" } else { "NO" })
}
