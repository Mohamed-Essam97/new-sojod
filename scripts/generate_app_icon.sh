#!/bin/bash
# Generate app_icon.png from app_icon.svg for flutter_launcher_icons
# Requires: brew install librsvg (for rsvg-convert) OR brew install imagemagick

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
SVG="$PROJECT_DIR/assets/logo/app_icon.svg"
OUT="$PROJECT_DIR/assets/logo/app_icon.png"

if [ ! -f "$SVG" ]; then
  echo "Error: $SVG not found"
  exit 1
fi

if command -v rsvg-convert &> /dev/null; then
  rsvg-convert -w 1024 -h 1024 -o "$OUT" "$SVG"
  echo "Generated $OUT with rsvg-convert"
elif command -v convert &> /dev/null || command -v magick &> /dev/null; then
  CONVERT="$(command -v convert || command -v magick)"
  $CONVERT -background none -resize 1024x1024 "$SVG" "$OUT"
  echo "Generated $OUT with ImageMagick"
else
  echo "Install a converter:"
  echo "  brew install librsvg   # for rsvg-convert"
  echo "  brew install imagemagick"
  echo ""
  echo "Or convert manually: open $SVG in a browser, screenshot/copy as 1024x1024 PNG to $OUT"
  exit 1
fi
