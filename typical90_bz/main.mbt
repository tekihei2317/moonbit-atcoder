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
  let input = read_stdin()
  guard input.trim().split("\n").to_array() is [nm, .. abs]
  guard nm.split(" ").to_array().map(to_int) is [n, _m]

  let graph : Array[Array[Int]] = Array::makei(n, _ => [])
  for ab in abs {
    guard ab.split(" ").to_array().map(to_int) is [a, b]
    let a = a - 1
    let b = b - 1
    graph[a].push(b)
    graph[b].push(a)
  }

  let mut ans = 0
  for v, edges in graph {
    let small_count = edges.filter(u => u < v).length()
    if small_count == 1 {
      ans += 1
    }
  }
  println(ans)
}
