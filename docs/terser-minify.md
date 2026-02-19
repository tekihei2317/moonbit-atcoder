# Moonbitの生成コードをTerserでminifyする

実際にコードを生成して、minifyするのをやってみます。

## Hello

とりあえず最初はシンプルに。

```mbt
///|
fn main {
  println("Hello")
}
```

`moon build minify/`を実行。`_build/js/debug/`ディレクトリに生成される。

```js
function _M0IP311moonbitlang4core6string6StringP311moonbitlang4core7builtin4Show10to__string(self) {
  return self;
}
function _M0FP311moonbitlang4core7builtin7printlnGsE(input) {
  console.log(_M0IP311moonbitlang4core6string6StringP311moonbitlang4core7builtin4Show10to__string(input));
}
(() => {
  _M0FP311moonbitlang4core7builtin7printlnGsE("Hello");
})();
//# sourceMappingURL=minify.js.map
```

続いて、`moon build --release minify/`を実行。こちらは`_build/js/release`ディレクトリに生成される。

```js
function _M0FP311moonbitlang4core7builtin7printlnGsE(input) {
  console.log(input);
}
(() => {
  _M0FP311moonbitlang4core7builtin7printlnGsE("Hello");
})();
```

こちらの方が短くなっている。`println`を表す関数がある。`main`関数は即時実行関数式になっている。IIFE、名前はどうでもいいけど。以降はリリースビルドのコードを対象に試す。

## 足し算

```mbt
///|
fn main {
  println(3 + 5)
}
```

うお〜、めっちゃ長いコードが生成されているぞ。順番に何を表しているか、確認してまとめてもらった。数値を文字列に変換するコードが入っているから多いのかな。

substringの処理とか入ってるけど、ここでは使っていないはずなので、`terser`で消せているか確認したい。

- プログラム本体
  minify/main.mbt の println(3 + 5) が即時関数で実行され、最終的に 8 を出力しています（_build/js/release/build/
  minify/minify.js:106）。
- MoonBitランタイムの基本部品
  $compare_int, Result$Err/$Ok, $PanicError, $panic など（_build/js/release/build/minify/minify.js:1）。
- println 実装一式
  _M0FP...println... と、そのために必要な Show -> to_string -> Logger の流れ（_build/js/release/build/minify/
  minify.js:103）。
- Int の文字列化
  int_to_string_js, Int::to_string 相当（_build/js/release/build/minify/minify.js:18, :90）。
- StringBuilder/Logger 実装
  new, write_string, write_view, write_char, method table（_build/js/release/build/minify/minify.js:21 付近）。
- StringView と substring 安全処理
  String::sub_inner, CreatingViewError(InvalidIndex/IndexOutOfBounds), サロゲート判定（_build/js/release/build/
  minify/minify.js:12, :29, :42）。
- 比較演算のデフォルト実装
  Compare::op_le/op_ge の補助（_build/js/release/build/minify/minify.js:36, :39）。


```js
function $compare_int(a, b) {
  return (a >= b) - (a <= b);
}
function Result$Err$0$(param0) {
  this._0 = param0;
}
Result$Err$0$.prototype.$tag = 0;
function Result$Ok$0$(param0) {
  this._0 = param0;
}
Result$Ok$0$.prototype.$tag = 1;
const Error$moonbitlang$47$core$47$builtin$46$CreatingViewError$46$IndexOutOfBounds = { $tag: 1 };
const Error$moonbitlang$47$core$47$builtin$46$CreatingViewError$46$InvalidIndex = { $tag: 0 };
class $PanicError extends Error {}
function $panic() {
  throw new $PanicError();
}
const _M0FP311moonbitlang4core7builtin19int__to__string__js = (x, radix) => {
  return x.toString(radix);
};
const _M0FP095_40moonbitlang_2fcore_2fbuiltin_2eStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger = { method_0: _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger13write__string, method_1: _M0IP016_24default__implP311moonbitlang4core7builtin6Logger16write__substringGRP311moonbitlang4core7builtin13StringBuilderE, method_2: _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger11write__view, method_3: _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger11write__char };
function _M0MP311moonbitlang4core7builtin13StringBuilder11new_2einner(size_hint) {
  return { val: "" };
}
function _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger11write__char(self, ch) {
  const _bind = self;
  _bind.val = `${_bind.val}${String.fromCodePoint(ch)}`;
}
function _M0MP311moonbitlang4core6uint166UInt1623is__trailing__surrogate(self) {
  return _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__geGkE(self, 56320) && _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__leGkE(self, 57343);
}
function _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger13write__string(self, str) {
  const _bind = self;
  _bind.val = `${_bind.val}${str}`;
}
function _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__leGkE(x, y) {
  return $compare_int(x, y) <= 0;
}
function _M0IP016_24default__implP311moonbitlang4core7builtin7Compare6op__geGkE(x, y) {
  return $compare_int(x, y) >= 0;
}
function _M0MP311moonbitlang4core6string6String11sub_2einner(self, start, end) {
  const len = self.length;
  let end$2;
  if (end === undefined) {
    end$2 = len;
  } else {
    const _Some = end;
    const _end = _Some;
    end$2 = _end < 0 ? len + _end | 0 : _end;
  }
  const start$2 = start < 0 ? len + start | 0 : start;
  if (start$2 >= 0 && (start$2 <= end$2 && end$2 <= len)) {
    if (start$2 < len && _M0MP311moonbitlang4core6uint166UInt1623is__trailing__surrogate(self.charCodeAt(start$2))) {
      return new Result$Err$0$(Error$moonbitlang$47$core$47$builtin$46$CreatingViewError$46$InvalidIndex);
    }
    if (end$2 < len && _M0MP311moonbitlang4core6uint166UInt1623is__trailing__surrogate(self.charCodeAt(end$2))) {
      return new Result$Err$0$(Error$moonbitlang$47$core$47$builtin$46$CreatingViewError$46$InvalidIndex);
    }
    return new Result$Ok$0$({ str: self, start: start$2, end: end$2 });
  } else {
    return new Result$Err$0$(Error$moonbitlang$47$core$47$builtin$46$CreatingViewError$46$IndexOutOfBounds);
  }
}
function _M0IP016_24default__implP311moonbitlang4core7builtin6Logger16write__substringGRP311moonbitlang4core7builtin13StringBuilderE(self, value, start, len) {
  let _tmp;
  let _try_err;
  _L: {
    _L$2: {
      const _bind = _M0MP311moonbitlang4core6string6String11sub_2einner(value, start, start + len | 0);
      if (_bind.$tag === 1) {
        const _ok = _bind;
        _tmp = _ok._0;
      } else {
        const _err = _bind;
        _try_err = _err._0;
        break _L$2;
      }
      break _L;
    }
    _tmp = $panic();
  }
  _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger11write__view(self, _tmp);
}
function _M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(self) {
  const logger = _M0MP311moonbitlang4core7builtin13StringBuilder11new_2einner(0);
  _M0IP311moonbitlang4core3int3IntP311moonbitlang4core7builtin4Show6output(self, { self: logger, method_table: _M0FP095_40moonbitlang_2fcore_2fbuiltin_2eStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
  return logger.val;
}
function _M0MP311moonbitlang4core3int3Int18to__string_2einner(self, radix) {
  return _M0FP311moonbitlang4core7builtin19int__to__string__js(self, radix);
}
function _M0IP311moonbitlang4core6string10StringViewP311moonbitlang4core7builtin4Show10to__string(self) {
  return self.str.substring(self.start, self.end);
}
function _M0IP311moonbitlang4core7builtin13StringBuilderP311moonbitlang4core7builtin6Logger11write__view(self, str) {
  const _bind = self;
  _bind.val = `${_bind.val}${_M0IP311moonbitlang4core6string10StringViewP311moonbitlang4core7builtin4Show10to__string(str)}`;
}
function _M0IP311moonbitlang4core3int3IntP311moonbitlang4core7builtin4Show6output(self, logger) {
  logger.method_table.method_0(logger.self, _M0MP311moonbitlang4core3int3Int18to__string_2einner(self, 10));
}
function _M0FP311moonbitlang4core7builtin7printlnGiE(input) {
  console.log(_M0IP016_24default__implP311moonbitlang4core7builtin4Show10to__stringGiE(input));
}
(() => {
  _M0FP311moonbitlang4core7builtin7printlnGiE(8);
})();
```

## terserでminifyしてみる

`-m`=`--mangle`。`--top-level`が効いているっぽい。`1280/4756=27%`くらいまで減っている。

```text
$ npx terser _build/js/release/build/minify/minify.js | wc -c
    4756

$ npx terser _build/js/release/build/minify/minify.js -m | wc -c
    4342

$ npx terser _build/js/release/build/minify/minify.js --mangle --toplevel | wc -c
    1280
```

ちょっとオプションを調整。`--mangle`は変数名や関数名を短くする。`--compress`はコードを同じ意味の短い書き方に変える、という認識。

```text
$ npx terser _build/js/release/build/minify/minify.js \
  --compress toplevel=true,passes=3 \
  --mangle toplevel=true | wc -c
     983
```

生成コードをフォーマットしたもの。呼び出し順を確認しよう...と思ったけど長すぎるな。`terser`の挙動についてはもう少し必要に迫られた時に学びたい。
