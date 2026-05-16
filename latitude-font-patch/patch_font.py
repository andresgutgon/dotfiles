#!/usr/bin/env python3
"""
Patch a Nerd Font TTF to add the Latitude logo as a colored glyph at U+E000.
Idempotent: re-running on an already-patched font replaces the existing layers.

Usage:
    patch_font.py <input.ttf> <output.ttf>

The script adds a COLR v0 + CPAL color table and these 5 glyphs:
  lat      base / monochrome fallback
  _lat_b   blue ring top      #0080FF  (palette 0)
  _lat_r   red ring top       #E63948  (palette 1)
  _lat_y   yellow inner top   #FEC61A  (palette 2)
  _lat_w   white bottom semi  #FFFFFF  (palette 3)
U+E000 is remapped to "lat" in every Unicode cmap subtable.
"""
import sys
from fontTools.ttLib import TTFont, newTable
from fontTools.ttLib.tables import otTables as ot
from fontTools.ttLib.tables.C_P_A_L_ import Color
from fontTools.pens.ttGlyphPen import TTGlyphPen
from fontTools.pens.cu2quPen import Cu2QuPen
from svg.path import parse_path, Move, Line, CubicBezier, QuadraticBezier, Close

# SVG paths verbatim from logo_only.svg (viewBox 112x112)
PATH_BLUE   = "M16.0002 53.9327C15.9994 53.9533 16.0011 53.9746 16.0002 53.9951L25.121 53.9951C26.1398 37.8812 39.6061 25.1116 56.0002 25.1116C72.3744 25.1116 85.8005 37.8781 86.8479 53.9951L96 53.9951C94.9598 32.8199 77.4609 15.9999 56.0006 15.9999C34.5612 15.9999 17.0719 32.7858 16.0013 53.9321L16.0002 53.9327Z"
PATH_WHITE  = "M16 57.9732C17.0254 79.1989 34.5275 96 55.9994 96C77.4724 96 94.9744 79.1991 95.9987 57.9732L16 57.9732Z"
PATH_RED    = "M29.1359 53.9941L40.0306 53.9941C41.0182 46.0705 47.8155 39.94 55.9996 39.94C64.164 39.94 70.9145 46.0976 71.9373 53.9941L82.8632 53.9941C81.8337 40.0295 70.2241 29.0898 55.9992 29.0898C41.7638 29.0898 30.1512 40.0524 29.1353 53.9941L29.1359 53.9941Z"
PATH_YELLOW = "M44.0777 53.9941L67.8897 53.9941C66.9136 48.2634 61.9955 43.8891 55.9984 43.8891C49.9818 43.8891 45.0314 48.2576 44.0767 53.9941L44.0777 53.9941Z"

# (R, G, B, A) — CPAL stores BGRA internally; the Color() ctor handles that.
COL_BLUE   = (0x00, 0x80, 0xFF, 0xFF)
COL_RED    = (0xE6, 0x39, 0x48, 0xFF)
COL_YELLOW = (0xFE, 0xC6, 0x1A, 0xFF)
COL_WHITE  = (0xFF, 0xFF, 0xFF, 0xFF)

# SVG (Y down, 112x112) -> font (Y up). Scaled so the logo's content (SVG y 16..96)
# lands at font y 200..1100 in a 1233-wide monospace cell at upem=2048.
SCALE = 11.25
TX = -13.5
TY = 1280.0


def t(p):
    return (SCALE * p.real + TX, -SCALE * p.imag + TY)


def draw(d_string, pen):
    """Walk an SVG `d` string and emit pen operations."""
    path = parse_path(d_string)
    contour_open = False
    for seg in path:
        if isinstance(seg, Move):
            if contour_open:
                pen.endPath()
            contour_open = True
            pen.moveTo(t(seg.end))
        elif isinstance(seg, Line):
            pen.lineTo(t(seg.end))
        elif isinstance(seg, CubicBezier):
            pen.curveTo(t(seg.control1), t(seg.control2), t(seg.end))
        elif isinstance(seg, QuadraticBezier):
            pen.qCurveTo(t(seg.control), t(seg.end))
        elif isinstance(seg, Close):
            pen.closePath()
            contour_open = False
    if contour_open:
        pen.closePath()


def build_glyph(*d_strings):
    """Build a single TTGlyph from one or more SVG path d-strings."""
    tt_pen = TTGlyphPen(None)
    cu2qu = Cu2QuPen(tt_pen, max_err=1.0, reverse_direction=False)
    for d in d_strings:
        draw(d, cu2qu)
    return tt_pen.glyph()


def main(in_path, out_path):
    font = TTFont(in_path)
    print(f"loaded {in_path}: upem={font['head'].unitsPerEm}, glyphs={font['maxp'].numGlyphs}")

    layer_defs = {
        "_lat_b": (PATH_BLUE,),
        "_lat_w": (PATH_WHITE,),
        "_lat_r": (PATH_RED,),
        "_lat_y": (PATH_YELLOW,),
    }
    glyphs = {name: build_glyph(*paths) for name, paths in layer_defs.items()}
    # Monochrome fallback: union of all 4 paths
    glyphs["lat"] = build_glyph(PATH_BLUE, PATH_WHITE, PATH_RED, PATH_YELLOW)

    glyf = font["glyf"]
    hmtx = font["hmtx"]
    order = font.getGlyphOrder()
    new_names = ["lat", "_lat_b", "_lat_w", "_lat_r", "_lat_y"]

    # Idempotent: only append names that aren't already present
    appended = [n for n in new_names if n not in order]
    if appended:
        font.setGlyphOrder(order + appended)

    for name in new_names:
        glyf[name] = glyphs[name]
        glyf[name].recalcBounds(glyf)
        # CRITICAL: lsb must equal xMin or Core Text shifts each COLR layer
        # by (lsb - xMin), misaligning the composite.
        hmtx.metrics[name] = (1233, glyf[name].xMin)

    font["maxp"].numGlyphs = len(font.getGlyphOrder())

    # Remap U+E000 to "lat" in every Unicode cmap subtable
    for sub in font["cmap"].tables:
        if sub.isUnicode():
            sub.cmap[0xE000] = "lat"

    # CPAL (palette) — palette order matches the colorID values used in COLR
    cpal = newTable("CPAL")
    cpal.version = 0
    cpal.numPaletteEntries = 4

    def mkcolor(rgba):
        r, g, b, a = rgba
        return Color(blue=b, green=g, red=r, alpha=a)

    cpal.palettes = [[mkcolor(COL_BLUE), mkcolor(COL_RED),
                      mkcolor(COL_YELLOW), mkcolor(COL_WHITE)]]
    font["CPAL"] = cpal

    # COLR v0 — back-to-front layer order
    colr = newTable("COLR")
    colr.version = 0

    def layer(name, color_id):
        lr = ot.LayerRecord()
        lr.name = name
        lr.colorID = color_id
        return lr

    colr.ColorLayers = {"lat": [
        layer("_lat_b", 0),  # blue (back)
        layer("_lat_w", 3),  # white covers bottom
        layer("_lat_r", 1),  # red
        layer("_lat_y", 2),  # yellow (front)
    ]}
    font["COLR"] = colr

    font.save(out_path)
    print(f"wrote {out_path}")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("usage: patch_font.py <input.ttf> <output.ttf>", file=sys.stderr)
        sys.exit(2)
    main(sys.argv[1], sys.argv[2])
