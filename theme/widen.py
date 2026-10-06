#!/usr/bin/env python3
"""Lay the OrangeFox portrait theme out for a wider design width.

The stock theme is drawn on a 1080 px wide grid and scaled to the panel, so on
dizi (1600x2560) everything is 1.48x larger than its design size. This keeps
fonts, images and heights at 1:1 and stretches the layout horizontally instead:
every x position and every width of 100 px or more is multiplied by
new_width / 1080. Small widths (icons, scroll bars, line widths) stay as they
are. Percent units and %var% expressions are left alone, apart from the
literal numbers inside width-like variables.

Runs on the installed theme ($OUT/recovery/root/twres) from
BOARD_RECOVERY_IMAGE_PREPARE. ui.xml doubles as the marker: once its
resolution says the new width, the theme has already been converted.

Usage: widen.py <twres dir> <new width>
"""

import re
import sys
from pathlib import Path

BASE_WIDTH = 1080
MIN_SCALED_WIDTH = 100

# Width-like variables in vars.xml that must keep their pixel size.
FIXED_VARS = {
    "space_xs", "space_xl", "fastscroll_w", "pattern_line_w",
    "input_cursor_width", "bs_del_w", "progressbar_x",
}
X_VAR = re.compile(r"(_x|_x_[a-z0-9_]+|_x[0-9]+|_neg)$")
W_VAR = re.compile(r"(_w|_w_[a-z0-9_]+|_width|_width_[0-9]+)$")
NUMBER = re.compile(r"\b\d+\b")


def scale_all(value: str, k: float) -> str:
    """Scale every literal number in value."""
    return NUMBER.sub(lambda n: str(round(int(n.group(0)) * k)), value)


def scale_widths(value: str, k: float) -> str:
    """Scale the literal numbers in value that are big enough to be layout widths."""
    def one(n: re.Match) -> str:
        v = int(n.group(0))
        return str(round(v * k)) if v >= MIN_SCALED_WIDTH else n.group(0)

    return NUMBER.sub(one, value)


def used_vars(texts: list[str], attr: str) -> set[str]:
    """Names of the variables referenced in the given attribute anywhere in the theme."""
    names = set()
    for text in texts:
        for value in re.findall(rf'\b{attr}="([^"]*)"', text):
            names.update(re.findall(r"%([a-z0-9_]+)%", value))
    return names


def widen_vars(text: str, k: float, new_width: int, x_vars: set[str], w_vars: set[str]) -> str:
    def var(m: re.Match) -> str:
        name, value = m.group(1), m.group(2)
        if name == "screen_w":
            value = str(new_width)
        elif name == "center_x":
            value = str(new_width // 2)
        elif name in FIXED_VARS:
            pass
        elif X_VAR.search(name) or name in x_vars:
            value = scale_all(value, k)
        elif W_VAR.search(name) or name in w_vars:
            value = scale_widths(value, k)
        return f'<variable name="{name}" value="{value}"'

    return re.sub(r'<variable name="([a-z0-9_]+)" value="([^"]*)"', var, text)


def widen_placements(text: str, k: float) -> str:
    """Stretch the x and w of placements, and the w of shapes and images."""
    def placement(m: re.Match) -> str:
        tag = re.sub(r'\bx="(\d+)"', lambda n: f'x="{scale_all(n.group(1), k)}"', m.group(0))
        return re.sub(r'\bw="(\d+)"', lambda n: f'w="{scale_widths(n.group(1), k)}"', tag)

    def shape(m: re.Match) -> str:
        return re.sub(r'\bw="(\d+)"', lambda n: f'w="{scale_widths(n.group(1), k)}"', m.group(0))

    text = re.sub(r"<placement\b[^>]*>", placement, text)
    return re.sub(r"<(?:shape|image)\b[^>]*>", shape, text)


def main() -> None:
    twres = Path(sys.argv[1])
    new_width = int(sys.argv[2])
    k = new_width / BASE_WIDTH

    ui = twres / "ui.xml"
    text = ui.read_text()
    resolution = f'<resolution width="{new_width}"'
    if resolution in text:
        return
    ui.write_text(text.replace(f'<resolution width="{BASE_WIDTH}"', resolution))

    files = [x for x in twres.rglob("*.xml") if x != ui and "languages" not in x.parts]
    texts = {x: x.read_text(errors="surrogateescape") for x in files}
    x_vars = used_vars(list(texts.values()), "x") - used_vars(list(texts.values()), "y")
    w_vars = used_vars(list(texts.values()), "w") - used_vars(list(texts.values()), "h")

    for xml, text in texts.items():
        new = widen_placements(text, k)
        if xml.name == "vars.xml":
            new = widen_vars(new, k, new_width, x_vars, w_vars)
        if new != text:
            xml.write_text(new, errors="surrogateescape")


if __name__ == "__main__":
    main()
