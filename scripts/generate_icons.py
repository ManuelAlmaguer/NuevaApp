#!/usr/bin/env python3
"""Genera los iconos de NuevaApp (legacy PNG + foreground adaptativo).

Uso:  /home/user/.venv-img/bin/python scripts/generate_icons.py
"""
from __future__ import annotations

import os
from PIL import Image, ImageDraw, ImageFont

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RES = os.path.join(ROOT, "app", "src", "main", "res")
FONT = "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"

INDIGO_TOP = (99, 102, 241)
INDIGO_BOTTOM = (49, 46, 129)
TEAL = (13, 148, 136)

LEGACY = {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}
ADAPTIVE = {"mdpi": 108, "hdpi": 162, "xhdpi": 216, "xxhdpi": 324, "xxxhdpi": 432}


def vertical_gradient(size: int, top: tuple[int, int, int], bottom: tuple[int, int, int]) -> Image.Image:
    img = Image.new("RGB", (1, size))
    px = img.load()
    for y in range(size):
        t = y / max(size - 1, 1)
        px[0, y] = tuple(round(top[i] + (bottom[i] - top[i]) * t) for i in range(3))
    return img.resize((size, size), Image.BICUBIC)


def draw_glyph(img: Image.Image, size: int, scale: float = 0.46) -> None:
    """Dibuja la 'N' con un acento teal (barra diagonal)."""
    draw = ImageDraw.Draw(img)
    font = ImageFont.truetype(FONT, int(size * scale))
    text = "N"
    box = draw.textbbox((0, 0), text, font=font)
    tw, th = box[2] - box[0], box[3] - box[1]
    draw.text(((size - tw) / 2 - box[0], (size - th) / 2 - box[1]), text, font=font, fill=(255, 255, 255))
    # acento inferior
    bar_w, bar_h = int(size * 0.22), max(4, int(size * 0.045))
    x0 = (size - bar_w) / 2
    y0 = size * 0.705
    r = bar_h / 2
    draw.rounded_rectangle([x0, y0, x0 + bar_w, y0 + bar_h], radius=r, fill=TEAL)


def rounded_mask(size: int, radius_ratio: float = 0.22) -> Image.Image:
    mask = Image.new("L", (size, size), 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, size - 1, size - 1], radius=size * radius_ratio, fill=255)
    return mask


def circle_mask(size: int) -> Image.Image:
    mask = Image.new("L", (size, size), 0)
    ImageDraw.Draw(mask).ellipse([0, 0, size - 1, size - 1], fill=255)
    return mask


def build_legacy(size: int, circular: bool) -> Image.Image:
    base = vertical_gradient(size, INDIGO_TOP, INDIGO_BOTTOM).convert("RGBA")
    draw_glyph(base, size)
    mask = circle_mask(size) if circular else rounded_mask(size)
    out = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    out.paste(base, (0, 0), mask)
    return out


def build_foreground(size: int) -> Image.Image:
    """Foreground adaptativo: lienzo 108dp, glifo dentro de la zona segura (72dp)."""
    canvas = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    inner = int(size * 72 / 108)
    layer = Image.new("RGBA", (inner, inner), (0, 0, 0, 0))
    draw_glyph(layer, inner, scale=0.52)
    offset = (size - inner) // 2
    canvas.paste(layer, (offset, offset), layer)
    return canvas


def main() -> None:
    for density, px in LEGACY.items():
        folder = os.path.join(RES, f"mipmap-{density}")
        os.makedirs(folder, exist_ok=True)
        build_legacy(px, False).save(os.path.join(folder, "ic_launcher.png"))
        build_legacy(px, True).save(os.path.join(folder, "ic_launcher_round.png"))

    for density, px in ADAPTIVE.items():
        folder = os.path.join(RES, f"mipmap-{density}")
        os.makedirs(folder, exist_ok=True)
        build_foreground(px).save(os.path.join(folder, "ic_launcher_foreground.png"))

    store = os.path.join(ROOT, "store")
    os.makedirs(store, exist_ok=True)
    build_legacy(512, False).save(os.path.join(store, "icon-512.png"))
    print("Iconos generados.")


if __name__ == "__main__":
    main()