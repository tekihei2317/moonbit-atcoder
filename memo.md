# メモ

## 典型90問

とりあえず難易度の低い問題から解いているけれど、アルゴリズム収集するんだったら他の方法の方がいいかも？

### 9. [067 - Base 8 to 9（★2）](https://atcoder.jp/contests/typical90/tasks/typical90_bo)

手を動かしてみる。

N < 8^20だから、最大で8進数で20桁になる。2^60だから`int64`には収まる。

9進法に直して、9を5に書き換えて、それを5進法で解釈する、らしい。

8進法→10進法→9進法ならできるから、それでいいのかな。

21(8) = 8 * 2 + 1 = 17
17(10) = 9 + 8 = 18
8 → 5に変換して、15

なんかカスみたいなコードを書いてしまった、進数変換は頭がバグります。ランタイムエラーが出ちゃったので、Codexに書き直してもらった。

文字列の操作とか、char -> Intの変換とかが怪しいなぁ。

```mbt
///|
fn to_base_10(n : StringView) -> Int64 {
  let mut sum : Int64 = 0
  for ch in n {
    let digit : Int64 = match ch {
      '0' => 0
      '1' => 1
      '2' => 2
      '3' => 3
      '4' => 4
      '5' => 5
      '6' => 6
      '7' => 7
      _ => panic()
    }
    sum = sum * 8 + digit
  }
  sum
}

///|
test "to_base_10" {
  assert_eq(to_base_10("21"), 17)
}

///|
fn to_base_9_and_change_8_to_5(n : Int64) -> String {
  if n < 9 {
    let replaced : Int64 = if n == 8 { 5 } else { n }
    return replaced.to_string()
  }

  let q = n / 9
  let raw = n % 9
  let r : Int64 = if raw == 8 { 5 } else { raw }
  to_base_9_and_change_8_to_5(q) + r.to_string()
}

///|
test "to_base_9_and_change_8_to_5" {
  assert_eq(to_base_9_and_change_8_to_5(17), "15")
}

///|
fn main {
  let input = read_stdin()
  guard input.trim().split(" ").to_array() is [n, k]
  let mut n = n.to_string()
  let k = k |> to_int

  for _ in 0..<k {
    n = n |> to_base_10 |> to_base_9_and_change_8_to_5
  }
  println(n)
}
```

### 8. [061 - Deck（★2）](https://atcoder.jp/contests/typical90/tasks/typical90_bi)

数を、配列の前または後ろに追加していく。ある段階で、前からx番目にある数が何かを求める問題。

前から追加したものと、後ろから追加したものを持っておく。それぞれの要素数が分かれば、どの位置にあるのか分かるので、解ける。

添え字でバグらせてしまったけど、素直な問題だ。

```mbt
///|
fn main {
  let input = read_stdin()
  guard input.trim().split("\n").to_array() is [_q, .. tx]

  let front = []
  let back = []

  for line in tx {
    guard line.split(" ").to_array().map(to_int) is [t, x]

    match t {
      1 => front.push(x)
      2 => back.push(x)
      3 =>
        if x <= front.length() {
          // 前側にある場合
          let ans = front[front.length() - x]
          println(ans)
        } else {
          // 後ろ側にある場合
          let ans = back[x - front.length() - 1]
          println(ans)
        }
      _ => panic()
    }
  }
}
```

### 7. [055 - Select 5（★2）](https://atcoder.jp/contests/typical90/tasks/typical90_bc)

なんか普通に難しそうな気がする。5個選んだ積をPで割ったあまりがQになる選び方はいくつあるか。

Nが100なのが気になるな、5重ループはできないけど地味に小さいので...。

↑これ定数倍が軽い(1/120)のでACするらしい、マジかよ

intの掛け算だとオーバーフローするから、キャストが必要。

さて、JavaScriptだと通るかどうかですが、どうでしょう。TLEしました対戦ありがとうございました。

### 6. [033 - Not Too Bright（★2）](https://atcoder.jp/contests/typical90/tasks/typical90_ag)

これは単純に割り算で答えが求まりそうな気がする。貪欲に配置するのがおそらく最適解になりそうではある...

3 x 4だったら、

#.#.
....
#.#.

こうかな。

3 x 6だったら、

#.#.#.
......
#.#.#.

こう。置ける列数は、Wを2で割った切り上げ。置ける列数は、Hを2で割った切り上げ。なので、これをかけたのが答え。

```mbt
///|
fn main {
  let input = read_stdin().trim()
  guard input.split(" ").to_array().map(to_int) is [h, w]
  let ans = (h + 1) / 2 * ((w + 1) / 2)
  println(ans)
}
```

不正解だった。cornerテストケースで全部落ちている。[提出 #73458512 - 競プロ典型 90 問](https://atcoder.jp/contests/typical90/submissions/73458512)

解説を読んで解き直し。ちゃんと上界がそれになることを考えている。あとコーナーケースはH = 1またはW = 1の場合で、これはそもそも2 x 2の正方形がないから全部点灯させてもOK。

### 5. [027 - Sign Up Requests （★2）](https://atcoder.jp/contests/typical90/tasks/typical90_aa)

これはSetを使ってシミュレーションしていけばいいですね。guardをネストするってできるのだろうか。

Setの使い方は標準ライブラリのドキュメントを確認しましょう。`add`と`contains`があるのでこれを使えばいいですね。

[mooncakes.io](https://mooncakes.io/docs/moonbitlang/core/set)

```mbt
///|
fn main {
  let input = read_stdin().trim().split("\n").to_array()
  guard input is [_n, .. names]

  let st = @set.Set::new()
  for i, name in names {
    if !st.contains(name) {
      st.add(name)
      println(i + 1)
    }
  }
}
```

### 4. [024 - Select +／- One（★2）](https://atcoder.jp/contests/typical90/tasks/typical90_x)

これはBeginners Selectionと似た問題ですね。

- 操作回数が十分にあるか
- パリティが一致しているか

の2つを確認すればOK。パリティについて、直感的には理解できるけど、なんか上手く説明できないな...。

「必要な操作回数と、操作できる回数の偶奇が一致していないといけない」なぜ？

綺麗に書けますね。

```mbt
///|
fn main {
  let input = read_stdin().trim().split("\n").to_array()
  guard input is [nk, a, b]
  guard nk.split(" ").to_array().map(to_int) is [n, k]
  let a = a.split(" ").to_array().map(to_int)
  let b = b.split(" ").to_array().map(to_int)

  let mut need = 0
  for i in 0..<n {
    need += Int::abs(a[i] - b[i])
  }

  let ans = if need <= k && need % 2 == k % 2 { "Yes" } else { "No" }
  println(ans)
}
```
### 3. [022 - Cubic Cake（★2）](https://atcoder.jp/contests/typical90/tasks/typical90_v)

最大公約数っぽい問題。

とりあえず2次元で考えてみる。4 x 6の長方形だったら、2 * 2の正方形に分けられる。縦は4/2=2個、横は6/2=3個だから、(2 - 1) + (3 - 1) = 3回切れば良い。

3次元の場合、奥行きも同様に計算できる。なので答えは`g = gcd(A, B, C)`として`(A / g - 1) + (B / g - 1) + (C / g - 1)`になる。

最大公約数の計算が問題だ。ユークリッドの互助法の実装方法は覚えてないから、教えてもらおう。

理屈がわかれば実装も思い出せると思うので、理解しておきたい。

[拡張ユークリッドの互除法を実装しよう #Python - Qiita](https://qiita.com/luuguas/items/1c0bc4fb7a5d8c7f3c07)

### 2. [010 - Score Sum Queries（★2）](https://atcoder.jp/contests/typical90/tasks/typical90_j)

累積和。

1組と2組で別々に答えを計算する必要があるから、2つ累積和の配列を持っておこう。

入力を受け取るのが一番難しい、笑。なんかいい感じのAPIのライブラリ作れないかなぁ。

入力サイズが大きいから、全部まとめて受け取ったら遅くならないか心配だ。

とりあえずテストケースは通ったので提出。500msくらい。意外と大丈夫だった。

実装は単純だが、入力を受け取る部分の方のコードの方が長い。

```mbt
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
```

### 1. [004 - Cross Sum（★2）](https://atcoder.jp/contests/typical90/tasks/typical90_d)

累積和。

`sum_row[i] := i行目の数の合計`、`sum_col[j] := 行行目の数の合計`をあらかじめ計算しておく。

`(i, j)`の答えは`sum_row[i] + sum_row[j] - a[i][j]`になる。

2次元配列をどう扱えば良いのか。要素数がわかっていれば難しくないけど...。

```mbt
///|
fn main {
  let h = 3
  let w = 5
  let arr = Array::make(h, Array::make(w, 0))
  for i = 0; i < h; i = i + 1 {
    let mut line = ""
    for j = 0; j < w; j = j + 1 {
      if j > 0 {
        line += " "
      }
      line += arr[i][j].to_string()
    }
    println(line)
  }
}
```

できた。かなり手続き的に書いているので、なんとかしたい。`try!`をよく使うので、`unsafe_perse_int`を書いた。テンプレートにも追加しておこう。

あと、`terser`で圧縮するのも追加しておきたいな。

```mbt
///|
fn unsafe_parse_int(x : StringView) -> Int {
  try! @strconv.parse_int(x)
}

///|
fn main {
  let input = read_stdin()
  guard input.trim().split("\n").to_array() is [hw, .. rest]
  guard hw.split(" ").to_array().map(unsafe_parse_int) is [h, w]
  let arr = rest.map(x => x.split(" ").to_array().map(unsafe_parse_int))

  let sum_row = Array::make(h, 0)
  let sum_col = Array::make(w, 0)

  for i in 0..<h {
    let mut sum = 0
    for j in 0..<w {
      sum += arr[i][j]
    }
    sum_row[i] = sum
  }
  for j in 0..<w {
    let mut sum = 0
    for i in 0..<h {
      sum += arr[i][j]
    }
    sum_col[j] = sum
  }

  for i in 0..<h {
    let mut line = ""
    for j in 0..<w {
      let ans = sum_row[i] + sum_col[j] - arr[i][j]
      if j > 0 {
        line += " "
      }
      line += ans.to_string()
    }
    println(line)
  }
}
```

できるだけ宣言的に。ぎこちないな...。制限時間結構危ないなと思ったけど、C++でも500msくらいかかってるからそんなもんか。

あと、フォーマッタのインデントが崩れてるのでこちらは手動修正しよう。


```mbt
///|
fn main {
  let input = read_stdin()
  guard input.trim().split("\n").to_array() is [hw, .. rest]
  guard hw.split(" ").to_array().map(unsafe_parse_int) is [h, w]
  let arr = rest.map(x => x.split(" ").to_array().map(unsafe_parse_int))

  let sum_row = Array::makei(h, i => arr[i].fold(init=0, add))
  let sum_col = Array::makei(w, j => {
    arr.fold(init=0, (acc, row) => acc + row[j])
  })
  let ans = Array::makei(h, i => {
    Array::makei(w, j => sum_row[i] + sum_col[j] - arr[i][j])
      .map(x => x.to_string())
      .join(" ")
  }).join("\n")
  println(ans)
}
```

次解く時は、Terserで短くしてから提出するようにしよう。

## 次に解く問題

あんまり時間をかけて考察したいわけではない。考えるより、コードを書きたい。

頻出のアルゴリズム、データ構造、テクニックを、Moonbitで綺麗に実装する方法を知りたい。そしてそれを、AIの参考にもなるように簡潔にまとめたい。

AtCoderの問題は、好きかと言われると怪しい。考察重視で実装が簡潔になることが多いので。重実装をときたいとは思わないが、そこそこの実装量が欲しい。昔の4問時代のABCは、変な問題が結構あって面白かった印象。あとはJOI過去問も面白かった。

本と並行して進めるとしたら、まだ読んだことがないものは、PAST過去問か鉄則本なので、どちらかが良いだろうか。とりあえず典型90問をやってみることにしようかな。簡単な問題から解いていこう。

## 目標

- [x] Moonbitで、AtCoder Beginners Selectionsの10問を解く
  - [x] 1~4問
  - [x] 5~8問
  - [x] 9~10問
- [x] [online-judge-tools/oj](https://github.com/online-judge-tools/oj)で、テストケースのダウンロード、実行、提出まで自動化する
  - 提出はCAPCHA認証がついたため、サードパーティーツールを使っての提出はできなくなっているようだ
  - [ジャッジキューの処理遅延と今後の対応につきまして - AtCoder](https://atcoder.jp/posts/1456?lang=ja)
- [x] コマンドランナーを使う（just）
- [ ] MoonbitでAtCoder Beginners Selection解いてみた、記事を書く
  - JavaScriptにコンパイルすること
  - 標準ライブラリの扱いについて、そのまま使えるものとインポートする必要があるもの
  - ディレクトリ構成などについて
  - moon runとmoon build

## 調べること

- ビルドターゲットについて。wasm、wasm-gc、native、javascriptがあるが、何が違うか。
- JavaScriptへのビルドで生成されるコードについて。extern jsについて。
- 標準ライブラリの使い方について。デフォルトで使えるものとインポートしないと使えないものがあるのが何が違うか。
- moon runとmoon buildの違い、moon buildの--releaseオプションは何が変わるか。

### ビルドターゲットについて

moon CLIの`--target`オプションには、`wasm`、`wasm-gc`、`js`、`native`、`llvm`が指定できる。

```text
      --target <TARGET>            Select output target [possible values: wasm, wasm-gc, js, native, llvm, all]
```

TODO: それぞれ何を生成するか調べる

- `wasm`:
- `wasm-gc`:
- `js`:
- `native`:
- `llvm`:

### JavaScriptへのビルドの生成コードについて

[Interacting with JavaScript in MoonBit: A First Look | MoonBit](https://www.moonbitlang.com/pearls/moonbit-jsffi)を読む。

### 標準ライブラリの使い方について

### moon runとmoon build、moon build --releaseの違いについて

## メモ

ディレクトリ構成は、moonbitのビルドと、ojの自動化するためにいい感じに調整しなければならない。

とりあえず1問解いて、ビルドして提出してみよう。

[提出 #73400294 - AtCoder Beginners Selection](https://atcoder.jp/contests/abs/submissions/73400294)

9万バイトでウケる。ビルドの方法とかも調べておかないといけない。とりあえず次の問題に進む。

---

main関数を二つ書くことはできないので、なんとかする必要がある。

標準入力を受け取って、標準出力に出力するスクリプトとして考えると良さそう。

スクリプトとして使うにはどうすればいいんだろう。どうやらディレクトリを切って（=パッケージを作る）、全部に`"is-main": true`をつければよいっぽい。

[提出 #73400533 - AtCoder Beginners Selection](https://atcoder.jp/contests/abs/submissions/73400533)

標準ライブラリを使わなかったら、そこそこ小さくなるっぽい。関数型的に書く方法がわからなかったのでこれで提出。

```mbt
///|
fn main {
  let input = read_stdin()
  let mut ans = 0
  for char in input {
    if char == '1' {
      ans = ans + 1
    }
  }
  println(ans)
}
```

---

次の問題を解く。read_stdinは毎回コピペしてるけど、いい感じにする方法はないだろうか。

ローカルでパッケージを作って、そこを参照するみたいな感じ。

`max`とか`min`とかあるのかな。気になる。とりあえず自前で実装した。

`@strconv`を使うとサイズがデカくなるのと、入力のパターンマッチがなんかダサいのが気になる。

`read_stdin`を別ファイルに切り出してみたが、1ファイルにバンドルされるのでそのままで大丈夫だった。ただ、AtCoderがMoonbitに対応したら1ファイルで提出するだろうから、まとめておくのが無難そう。

次の問題は、ojを使ってテストケースの実行などを行ってみることにする。

```mbt
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
```

---

パターンマッチは`guard`を使えば綺麗に書けることがわかった。起こらない自体を確認する場合はこれでOK。

```mbt
///|
fn main {
  let input = read_stdin()
  guard input.trim().split("\n").map(x => try! @strconv.parse_int(x)).to_array()
    is [a, b, c, x]

  let mut ans = 0
  for i = 0; i <= a; i = i + 1 {
    for j = 0; j <= b; j = j + 1 {
      for k = 0; k <= c; k = k + 1 {
        let sum = 500 * i + 100 * j + 50 * k
        if sum == x {
          ans = ans + 1
        }
      }
    }
  }
  println(ans)
}
```

ここからは`oj`を使ってテストケースのダウンロード、実行、提出をやってみることにする。まずはインストールしよう。

```bash
pip3 install online-judge-tools
```

はなんかPEP668とやらでダメだったので、pipxとやらを使うといいらしい。

```bash
brew install pipx
pipx install online-judge-tools
```

`/Users/{user}/.local/bin`をパスに入れる必要があるらしい。`pipx ensurepath`でできるので実行して、シェルを再起動する。

```bash
pipx ensurepath
exec $SHELL -l
which oj
```

インストールできた。テストケースのダウンロード等をやってみよう。何かモジュールが足りないっぽい。

```text
$ oj download https://atcoder.jp/contests/abs/tasks/abc087_b
Traceback (most recent call last):
  File "/Users/tekihei2317/.local/bin/oj", line 3, in <module>
    from onlinejudge_command.main import main
  File "/Users/tekihei2317/.local/pipx/venvs/online-judge-tools/lib/python3.14/site-packages/onlinejudge_command/main.py", line 19, in <module>
    import onlinejudge_command.update_checking as update_checking
  File "/Users/tekihei2317/.local/pipx/venvs/online-judge-tools/lib/python3.14/site-packages/onlinejudge_command/update_checking.py", line 1, in <module>
    import distutils.version
ModuleNotFoundError: No module named 'distutils'
```

このあたり。ソースコードは修正されているけれど、PyPIにアップロードできる人がいないから更新されていないらしい。

ソースコード持ってきてインストールするか、代わりにatcoder-cliなるものを使ってみるかのどちらか。

- [Python 3.13 dont have distutils · Issue #935 · online-judge-tools/oj](https://github.com/online-judge-tools/oj/issues/935)
- [oj no longer works with Python3.12 · Issue #930 · online-judge-tools/oj](https://github.com/online-judge-tools/oj/issues/930)

GitHubリポジトリからインストールできるっぽいので、やってみる。

```bash
pipx uninstall online-judge-tools
pipx install "git+https://github.com/online-judge-tools/oj.git"
```

カレントディレクトリの`test/`にサンプルがダウンロードされる。

```bash
oj download https://atcoder.jp/contests/abs/tasks/abc087_b
```

テストを実行する。

```bash
oj test -c "node ../_build/js/release/build/abc087b/abc087b.js"
```

通った。提出はどうしようかな。先にログインを済ませていないといけない。

```bash
oj login https://atcoder.jp/contests/abs/tasks/abc087_b
```

CUIじゃなぜかログインできなかったのでselenium入れる。

```bash
pipx inject online-judge-tools selenium
```

AtCoderのロボットではありませんが突破できなかったので、無理っぽい。うーん、提出は諦めてクリップボードにコピーするくらいにしておこうかな。

どうやら公式的にもそうなっているらしい。

[ジャッジキューの処理遅延と今後の対応につきまして - AtCoder](https://atcoder.jp/posts/1456?lang=ja)

---

テスト入れられるのも便利だね。

```mbt
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
```

コンパイルして実行するコマンドはこれで。プロジェクトルートからコンパイルするならパス少し変える。

次はjustfileを用意して、パスを書かなくても大丈夫にする。

```bash
moon build --release . && oj t -c "node ../_build/js/release/build/abc083b/abc083b.js"
```

---

`main.mbt`の標準入力と、`moon.pkg`の`strconv`はずっと使うから、テンプレートディレクトリを作ってそれをコピーして作成するようにしたい。

ソートする必要がある。コードジャンプでソートがあることはわかった。`sort_by`と`sort_by_key`があるのもわかった。

`moon doc Array`でAPI一覧が見れる。`reverse`はなさそうだった。代わりに`rev`と`rev_in_place`がある。

`in_place`は一般に追加のメモリを必要としないという意味。これは破壊的であることを意味する。`rev`は新しい配列を作る。

justfileを作って、試してみる。

---

数字が何種類あるかどうかを調べる。Setに入れて、要素数を数えればOKです。

標準ライブラリにsetがあるか確認。ありました。`@set.Set::from_array`して、`Set.length`で要素数を取れます。`Set.size`は非推奨。

---

2重ループをすればいいやつ。


```mbt
///|
fn main {
  let input = read_stdin()
  guard input.trim().split(" ").map(x => try! @strconv.parse_int(x)).to_array()
    is [n, y]

  let mut ans : (Int, Int, Int)? = None
  for i = 0; i <= n; i = i + 1 {
    for j = 0; i + j <= n; j = j + 1 {
      let k = n - (i + j)

      let total = 10000 * i + 5000 * j + 1000 * k
      if total == y {
        ans = Some((i, j, k))
      }
    }
  }
  let (x, y, z) = ans.unwrap_or((-1, -1, -1))
  println("\{x} \{y} \{z}")
}
```

`unwrap_or`で、`None`だった場合のデフォルト値を設定してOptionの中身を取り出す。

ループの部分を関数にすれば、`Option`を使わなくてもOK。

---

操作によってi文字目まで一致させられるか？を状態に持って、更新していく

状態:

dp[i] := trueのとき、i文字目まで一致させられる

遷移:

t = "dream" | "dreamer" | "erase" | "eraser"として、

dp[i + t.length] |= true if s[i..(i+t.length)] = t

配列を、要素数を指定して初期化する方法が必要。`moon doc Array`を見る。`Array::make(Int, T) -> Self[T]`がそれっぽい。

```mbt
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
      if i + t.length() > n {
        continue
      }
      // let ok = try! (s[i:i + t.length()] == t)
      let ok = try! s[i:].has_prefix(t)
      if ok {
        dp[i + t.length()] = true
      }
    }
  }
  println(if dp[n] { "YES" } else { "NO" })
}
```

`let ok = try! s[i:].has_prefix(t)`にしたら、スライスのオーバーフローを気にしなくていいかな？

---

x軸方向とy軸方向の移動量をそれぞれ`dx`、`dy`として、到達できる条件は

- 時間が十分にあること: t >= dx + dy
- 時間が余った場合に対応できること: t % 2 == (dx + dy) % 2

の2つ。全ての移動について、これらの条件が満たされていることを確認すればよい。

入力を受け取るのが一番難しい...。

`Point`構造体を作ったんだけど、これって構造体のコンストラクタってあるんだっけ。←なさそう。

一時変数を使ったり、`panic`しているところが綺麗じゃない。ちょっと改良しよう。

```mbt
///|
fn main {
  let input = read_stdin().trim()
  guard input.split("\n").to_array() is [_n, .. rest]
  let points = rest.map(x => {
    let nums = x.split(" ").map(x => try! @strconv.parse_int(x)).to_array()
    match nums {
      [t, x, y] => { t, x, y }
      _ => panic()
    }
  })

  let mut now = { t: 0, x: 0, y: 0 }
  let mut ok = true
  for next in points {
    let dt = Int::abs(next.t - now.t)
    let dx = Int::abs(next.x - now.x)
    let dy = Int::abs(next.y - now.y)

    if dt < dx + dy || dt % 2 != (dx + dy) % 2 {
      ok = false
    }
    now = next
  }
  println(if ok { "Yes" } else { "No" })
}
```

`try?`で`raise` -> `Result`に変換して、パース失敗の処理は`filter_map`で無視する感じの実装にした。他のコードもこういう実装をした方がいいかもしれない。

```mbt
///|
fn main {
  let input = read_stdin().trim()
  let lines = match input.split("\n").to_array() {
    [_n, .. rest] => rest.to_array()
    _ => []
  }
  let points = lines.filter_map(line => {
    match line.split(" ").to_array().map(x => try? @strconv.parse_int(x)) {
      [Ok(t), Ok(x), Ok(y)] => Some({ t, x, y })
      _ => None
    }
  })
  let mut now = { t: 0, x: 0, y: 0 }
  let mut ok = true
  for next in points {
    let dt = Int::abs(next.t - now.t)
    let dx = Int::abs(next.x - now.x)
    let dy = Int::abs(next.y - now.y)

    if dt < dx + dy || dt % 2 != (dx + dy) % 2 {
      ok = false
    }
    now = next
  }
  println(if ok { "Yes" } else { "No" })
}

```
