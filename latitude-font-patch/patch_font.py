#!/usr/bin/env python3
"""
Patch a Nerd Font TTF to add the Latitude logo at multiple sizes.
Idempotent: re-running on an already-patched font replaces existing glyphs.

Usage:
    patch_font.py <input.ttf> <output.ttf>

Code points (COLR v0 + CPAL):
  U+E000   lat       1x  fits one cell (baseline)
  U+E001   lat_2x    2x  small overflow
  U+E002   lat_3x    3x  moderate overflow
  U+E003   lat_4x    4x  big overflow
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

# (R, G, B, A) — CPAL Color() stores BGRA internally; the ctor handles that.
COL_BLUE   = (0x00, 0x80, 0xFF, 0xFF)
COL_RED    = (0xE6, 0x39, 0x48, 0xFF)
COL_YELLOW = (0xFE, 0xC6, 0x1A, 0xFF)
COL_WHITE  = (0xFF, 0xFF, 0xFF, 0xFF)

# Cell geometry of Hack Nerd Font Mono at upem=2048
ADVANCE = 1233          # monospace cell width
CELL_CX = ADVANCE / 2   # 616.5 — horizontal center of cell
LOGO_CY = 650           # vertical center of where we draw the logo
SVG_CX  = 56            # logo center in SVG coords
SVG_CY  = 56

# 1x scale: original logo (height 80 SVG units -> 900 font units).
SCALE_1X = 11.25
# Multipliers for oversized variants. Each overflows the cell increasingly more,
# relying on terminal (iTerm2) glyph-overflow behavior.
VARIANTS = [
    # (codepoint, base_glyph_name, layer_prefix, scale_multiplier)
    (0xE000, "lat",    "_lat",   1),
    (0xE001, "lat_2x", "_latA",  2),
    (0xE002, "lat_3x", "_latB",  3),
    (0xE003, "lat_4x", "_latC",  4),
]


def make_transform(scale):
    """Return a function mapping SVG complex point -> (font_x, font_y)."""
    tx = CELL_CX - SVG_CX * scale          # so that svg(56) -> font(CELL_CX)
    ty = LOGO_CY + SVG_CY * scale          # so that svg(56) -> font(LOGO_CY), Y flipped
    def t(p):
        return (scale * p.real + tx, -scale * p.imag + ty)
    return t


def draw(d_string, pen, t):
    """Walk an SVG `d` string and emit pen operations using transform t."""
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


def build_glyph(d_strings, scale):
    """Build a single TTGlyph from one or more SVG path d-strings at given scale."""
    tt_pen = TTGlyphPen(None)
    cu2qu = Cu2QuPen(tt_pen, max_err=1.0, reverse_direction=False)
    t = make_transform(scale)
    for d in d_strings:
        draw(d, cu2qu, t)
    return tt_pen.glyph()


def build_variant(prefix, scale):
    """Build one full set of glyphs (4 layers + base) for a given scale.
    Returns dict mapping glyph name -> Glyph, with the base under key 'base'."""
    layers = {
        f"{prefix}_b": build_glyph([PATH_BLUE], scale),
        f"{prefix}_w": build_glyph([PATH_WHITE], scale),
        f"{prefix}_r": build_glyph([PATH_RED], scale),
        f"{prefix}_y": build_glyph([PATH_YELLOW], scale),
    }
    # Base is the monochrome union for fallback
    base = build_glyph([PATH_BLUE, PATH_WHITE, PATH_RED, PATH_YELLOW], scale)
    return layers, base


def main(in_path, out_path):
    font = TTFont(in_path)
    print(f"loaded {in_path}: upem={font['head'].unitsPerEm}, glyphs={font['maxp'].numGlyphs}")

    glyphs = {}
    colr_entries = {}  # base_name -> [(layer_name, palette_index), ...]
    cmap_updates = {}  # codepoint -> base_name

    for codepoint, base_name, prefix, mult in VARIANTS:
        scale = SCALE_1X * mult
        layers, base = build_variant(prefix, scale)
        glyphs[base_name] = base
        glyphs.update(layers)
        colr_entries[base_name] = [
            (f"{prefix}_b", 0),  # blue (back)
            (f"{prefix}_w", 3),  # white covers bottom
            (f"{prefix}_r", 1),  # red
            (f"{prefix}_y", 2),  # yellow (front)
        ]
        cmap_updates[codepoint] = base_name

    new_names = list(glyphs.keys())

    glyf = font["glyf"]
    hmtx = font["hmtx"]
    order = font.getGlyphOrder()

    appended = [n for n in new_names if n not in order]
    if appended:
        font.setGlyphOrder(order + appended)

    for name in new_names:
        glyf[name] = glyphs[name]
        glyf[name].recalcBounds(glyf)
        # CRITICAL: lsb must equal xMin or Core Text shifts each COLR layer
        # by (lsb - xMin), misaligning the composite.
        hmtx.metrics[name] = (ADVANCE, glyf[name].xMin)

    font["maxp"].numGlyphs = len(font.getGlyphOrder())

    # Update cmap entries for every variant
    for sub in font["cmap"].tables:
        if sub.isUnicode():
            for cp, name in cmap_updates.items():
                sub.cmap[cp] = name

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

    # COLR v0 — back-to-front layer order, one ColorGlyph per base
    colr = newTable("COLR")
    colr.version = 0

    def layer(name, color_id):
        lr = ot.LayerRecord()
        lr.name = name
        lr.colorID = color_id
        return lr

    colr.ColorLayers = {
        base_name: [layer(n, c) for n, c in entries]
        for base_name, entries in colr_entries.items()
    }
    font["COLR"] = colr

    font.save(out_path)
    print(f"wrote {out_path}")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("usage: patch_font.py <input.ttf> <output.ttf>", file=sys.stderr)
        sys.exit(2)
    main(sys.argv[1], sys.argv[2])
