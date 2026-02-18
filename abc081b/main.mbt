///|
fn min(a : Int, b : Int) -> Int {
  if a < b {
    a
  } else {
    b
  }
}

///|
fn div_count(num : Int) -> Int {
  let mut num = num
  let mut count = 0
  while num % 2 == 0 {
    num /= 2
    count = count + 1
  }
  count
}

///|
fn main {
  let input = read_stdin()
  match input.trim().split("\n").to_array() {
    [_n, a] => {
      let a = a.split(" ").map(x => try! @strconv.parse_int(x)).to_array()
      let mut ans = 30
      for num in a {
        ans = min(ans, div_count(num))
      }
      println(ans)
    }
    _ => panic()
  }
}
