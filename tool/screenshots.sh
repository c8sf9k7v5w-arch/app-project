#!/usr/bin/env bash
# Regenerates every screenshot in docs/screenshots and the cover image.
set -euo pipefail
cd "$(dirname "$0")/.."
for app in booking_app shop_app habit_tracker; do
  (cd "apps/$app" && SCREENSHOTS=1 flutter test --update-goldens test/screenshot_test.dart)
done
python3 tool/make_cover.py
