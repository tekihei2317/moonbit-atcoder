set quiet

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

download url dir:
  cd "{{dir}}" && oj download "{{url}}"

download-current url:
  cd "$(just resolve-dir)" && oj download "{{url}}"

build dir:
  moon build --target js --release "{{dir}}"

build-current:
  moon build --target js --release "$(just resolve-dir)"

test dir:
  moon build --target js --release "{{dir}}"
  cd "{{dir}}" && oj test -c "node ../_build/js/release/build/{{dir}}/{{dir}}.js"

test-current:
  dir="$(just resolve-dir)" && moon build --target js --release "$dir" && cd "$dir" && oj test -c "node ../_build/js/release/build/$dir/$dir.js"

copy dir:
  pbcopy < "_build/js/release/build/{{dir}}/{{dir}}.js"
  echo "copied _build/js/release/build/{{dir}}/{{dir}}.js"

copy-current:
  dir="$(just resolve-dir)" && pbcopy < "_build/js/release/build/$dir/$dir.js" && echo "copied _build/js/release/build/$dir/$dir.js"

all dir:
  just test "{{dir}}"
  just copy "{{dir}}"

all-current:
  just test-current
  just copy-current
