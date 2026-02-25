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
fn[T : Compare] lower_bound(arr : Array[T], value : T) -> Int {
  match arr.binary_search(value) {
    Err(i) => i
    Ok(i) => i
  }
}

///|
fn main {
  let input = read_stdin()
  guard input.trim().split("\n").to_array() is [_n, a, _q, .. b]
  let a = a.split(" ").map(to_int).to_array()
  let b = b.map(to_int)

  a.sort()
  for b in b {
    let index = lower_bound(a, b)
    let mut ans = 1001001001
    if index < a.length() {
      ans = Int::min(ans, Int::abs(a[index] - b))
    }
    if index - 1 >= 0 {
      ans = Int::min(ans, Int::abs(a[index - 1] - b))
    }
    println(ans)
  }
}
