# moonbit-atcoder

Moonbitで[AtCoder Beginners Selections](https://atcoder.jp/contests/abs)の10問を解いてみました。

## 説明

MoonbitをJavaScriptにコンパイルして提出します。

以下の2つのツールを使っています。

- [online-judge-tools/oj](https://github.com/online-judge-tools/oj)
  - サンプルのダウンロード、テスト
- [casey/just](https://github.com/casey/just)
  - 回答テンプレートのコピー、ojのラップ

```bash
# ojのインストール
pipx install "git+https://github.com/online-judge-tools/oj.git"

# justのインストール
brew install just
```

`oj`はMac / Homebrew環境では`pip`でインストールできなかったので、`pipx`でインストールします。また、`oj`の`PyPI`パッケージは更新されておらず以下の問題で動かなかったため、ソースコードを指定してインストールしました。

[Python 3.13 dont have distutils · Issue #935 · online-judge-tools/oj](https://github.com/online-judge-tools/oj/issues/935)

## 使い方

```bash
# template/ ディレクトリをコピーして準備
just prepare <問題名>

# テストケースをダウンロード
just download <URL>

# Moonbit->JSのビルド、テストケースの実行、テストが通ったらクリップボードにコピー
just test
```

`prepare -> p`、`download -> d`、`test -> t`のエイリアスが使えます。

`oj`には`submit`コマンドがありますが、AtCoderにCAPTCHA認証がある関係で使えなさそうだったため、クリップボードにコピーしています。

詳細: [ジャッジキューの処理遅延と今後の対応につきまして - AtCoder](https://atcoder.jp/posts/1456)

## メモ

`pipx`のインストール

```bash
brew install pipx
pipx ensurepath
exec $SHELL -l
```
