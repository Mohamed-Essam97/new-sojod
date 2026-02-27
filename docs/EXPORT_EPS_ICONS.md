# Exporting Icons from the Vecteezy Islamic EPS File

The file `vecteezy_islamic-line-icon-set-islamic-holiday-symbols-collection_6763604.eps` is an Adobe Illustrator EPS containing multiple Islamic icons. To extract them as individual SVG files for use in the app:

## Option 1: Using Inkscape (Recommended)

### 1. Install Inkscape

```bash
# macOS
brew install --cask inkscape

# Or download from https://inkscape.org/
```

### 2. Convert EPS to SVG

```bash
inkscape "/Users/amjaad/Downloads/vecteezy_islamic-line-icon-set-islamic-holiday-symbols-collection_6763604_207/vecteezy_islamic-line-icon-set-islamic-holiday-symbols-collection_6763604.eps" \
  --export-plain-svg=assets/icons/islamic_full.svg
```

### 3. Extract Individual Icons

**Method A: Manual export in Inkscape**
1. Open `islamic_full.svg` in Inkscape
2. Press `Ctrl+Shift+G` (Object > Ungroup) repeatedly until icons are separate
3. Select an icon → Right-click → Export PNG Image
4. Or: Select icon → File → Save As → choose "Plain SVG" (saves only selection if you copy first)

**Method B: Export by object ID**
1. Open the SVG in Inkscape
2. Select an icon → Object > Object Properties → note the **ID** (e.g. `path123`)
3. Run:
   ```bash
   inkscape islamic_full.svg --export-id=path123 --export-id-only \
     --export-filename=assets/icons/islamic/mosque.svg
   ```

**Method C: Use the script**
```bash
./scripts/export_eps_icons.sh
# Then follow the printed instructions
```

## Option 2: Using Adobe Illustrator

1. Open the EPS in Adobe Illustrator
2. Use the Layers panel - icons may be in separate layers
3. Select each layer/group → File → Export → Export As → SVG
4. Or: Select icon → Copy → New Document → Paste → Save As SVG

## Option 3: Download SVG Version from Vecteezy

If Vecteezy offers an SVG download for this pack, it may include separate files or a sprite sheet that's easier to split.

## Target Output

Place exported SVGs in `assets/icons/islamic/` and ensure they:
- Use `currentColor` or `stroke="currentColor"` so Flutter can tint them
- Have `viewBox="0 0 24 24"` for consistent sizing
- Are listed in `pubspec.yaml` under assets

## Quick Fix for Flutter Compatibility

If exported SVGs use fixed colors, replace with `currentColor`:

```bash
# In each SVG file, replace:
# fill="#000000" → fill="currentColor"
# stroke="#000000" → stroke="currentColor"
```
