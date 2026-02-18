set quiet

alias p := prepare
alias d := download
alias t := test

[private]
resolve-dir:
  cat .atcoder-target

prepare dir:
  cp -R template "{{dir}}"
  printf "%s\n" "{{dir}}" > .atcoder-target
  echo "created {{dir}} and set as current target"

use dir:
  printf "%s\n" "{{dir}}" > .atcoder-target
  echo "current target: {{dir}}"

current:
  cat .atcoder-target || echo "(not set)"

download url:
  cd "$(just resolve-dir)" && oj download "{{url}}"

build:
  moon build --target js --release "$(just resolve-dir)"

test:
  dir="$(just resolve-dir)" && just build && cd "$dir" && oj test -c "node ../_build/js/release/build/$dir/$dir.js"
  just copy

copy:
  dir="$(just resolve-dir)" && pbcopy < "_build/js/release/build/$dir/$dir.js" && echo "copied _build/js/release/build/$dir/$dir.js"

all:
  just test
