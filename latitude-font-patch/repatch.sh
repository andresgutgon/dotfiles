#!/usr/bin/env bash
# Re-apply the Latitude logo patch to HackNerdFontMono-Regular.ttf.
# Run this after `brew upgrade` (or any other Nerd Font update).
#
# Behavior:
#   - Finds the Hack Nerd Font in ~/Library/Fonts.
#   - Detects whether it's already patched (has a "lat" glyph at U+E000).
#     If yes, no-op. If no, backs up to .bak and patches in place.
#   - The .bak is preserved (it's your clean original). If a .bak already exists,
#     it is NOT overwritten.

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON="${LATITUDE_FONT_PATCH_PYTHON:-python3}"
FONT_DIR="$HOME/Library/Fonts"
FONT="$FONT_DIR/HackNerdFontMono-Regular.ttf"
BAK="$FONT.bak"

if [ ! -f "$FONT" ]; then
  echo "error: font not found at $FONT" >&2
  exit 1
fi

# Ensure Python deps are installed (idempotent)
if ! "$PYTHON" -c "import fontTools, svg.path" 2>/dev/null; then
  echo "installing fonttools + svg.path"
  "$PYTHON" -m pip install --user --quiet fonttools "svg.path"
fi

# Skip if already patched
if "$PYTHON" - "$FONT" <<'PY' 2>/dev/null
import sys
from fontTools.ttLib import TTFont
f = TTFont(sys.argv[1])
sys.exit(0 if "lat" in f.getGlyphOrder() else 1)
PY
then
  echo "font is already patched -- nothing to do"
  exit 0
fi

# Back up if no backup exists
if [ ! -f "$BAK" ]; then
  cp "$FONT" "$BAK"
  echo "backed up original to $BAK"
fi

TMP="$(mktemp -t HackNerdFontMono-XXXXXX).ttf"
trap 'rm -f "$TMP"' EXIT

"$PYTHON" "$HERE/patch_font.py" "$FONT" "$TMP"
mv "$TMP" "$FONT"

echo "patched $FONT (restart iTerm2 / your terminal to see the change)"
