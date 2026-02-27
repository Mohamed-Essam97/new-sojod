#!/bin/bash
# Export individual icons from Vecteezy Islamic icon EPS file
# Requires: Inkscape (install via: brew install --cask inkscape)

set -e

EPS_FILE="${1:-$HOME/Downloads/vecteezy_islamic-line-icon-set-islamic-holiday-symbols-collection_6763604_207/vecteezy_islamic-line-icon-set-islamic-holiday-symbols-collection_6763604.eps}"
OUTPUT_DIR="${2:-$(dirname "$0")/../assets/icons/islamic}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

if ! command -v inkscape &> /dev/null; then
  echo "Inkscape is required. Install it:"
  echo "  macOS:  brew install --cask inkscape"
  echo "  Ubuntu: sudo apt install inkscape"
  echo ""
  echo "Then run this script again."
  exit 1
fi

if [ ! -f "$EPS_FILE" ]; then
  echo "EPS file not found: $EPS_FILE"
  echo ""
  echo "Usage: $0 [path-to.eps] [output-dir]"
  echo "  Default EPS: ~/Downloads/vecteezy_.../vecteezy_...6763604.eps"
  echo "  Default output: $PROJECT_ROOT/assets/icons/islamic"
  exit 1
fi

mkdir -p "$OUTPUT_DIR"
TEMP_SVG="$OUTPUT_DIR/_temp_full.svg"

echo "Converting EPS to SVG..."
inkscape "$EPS_FILE" --export-plain-svg="$TEMP_SVG" 2>/dev/null || inkscape "$EPS_FILE" --export-type=svg --export-filename="$TEMP_SVG"

echo "SVG saved to: $TEMP_SVG"
echo ""
echo "Next steps (manual):"
echo "1. Open $TEMP_SVG in Inkscape"
echo "2. Use Object > Ungroup (Ctrl+Shift+G) to separate icon groups"
echo "3. Select each icon, note its ID (Object > Object Properties)"
echo "4. Export by ID: inkscape --export-id=OBJECT_ID --export-id-only --export-filename=icon_name.svg $TEMP_SVG"
echo ""
echo "Or use Object > Export PNG Image to export selected objects as SVG (File > Save As)"
echo ""
echo "Exporting full SVG for reference - you can manually crop icons from this."
echo "Done. Full SVG: $TEMP_SVG"
