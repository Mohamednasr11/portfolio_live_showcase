#!/usr/bin/env bash
set -euo pipefail

if ! command -v flutter >/dev/null 2>&1; then
  sdk="${TMPDIR:-/tmp}/portfolio-flutter-3.47.9"
  if [[ ! -x "$sdk/bin/flutter" ]]; then
    git clone --depth 1 --branch 3.47.9 https://github.com/flutter/flutter.git "$sdk"
  fi
  export PATH="$sdk/bin:$PATH"
fi

flutter pub get
dart format --output=none --set-exit-if-changed lib/main.dart lib/portfolio lib/showcase/showcase_page.dart test/portfolio_test.dart
flutter analyze
flutter test
flutter build web --release
