# moonbit-atcoder

MoonbitでAtCoder

## 目標

- [ ] Moonbitで、AtCoder Beginners Selectionsの10問を解く
  - [x] 1~4問
  - [ ] 5~8問
  - [ ] 9~10問
- [x] [online-judge-tools/oj](https://github.com/online-judge-tools/oj)で、テストケースのダウンロード、実行、提出まで自動化する
  - 提出はCAPCHA認証がついたため、サードパーティーツールを使っての提出はできなくなっているようだ
  - [ジャッジキューの処理遅延と今後の対応につきまして - AtCoder](https://atcoder.jp/posts/1456?lang=ja)
- [ ] MoonbitでAtCoder Beginners Selection解いてみた、記事を書く
  - JavaScriptにコンパイルすること
  - 標準ライブラリの扱いについて、そのまま使えるものとインポートする必要があるもの
  - ディレクトリ構成などについて
  - moon runとmoon build
- コマンドランナーを使う（just）

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
