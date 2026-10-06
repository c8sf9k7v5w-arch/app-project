"""Builds docs/screenshots/cover.png (2400x1350) from one screenshot per app.

Needs Pillow and the Roboto fonts shipped with the Flutter SDK.
"""
import os
import shutil

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = os.path.join(os.path.dirname(__file__), "..")
SHOTS = os.path.join(ROOT, "docs", "screenshots")
FLUTTER = os.path.dirname(os.path.dirname(os.path.realpath(shutil.which("flutter"))))
FONTS = os.path.join(FLUTTER, "bin", "cache", "artifacts", "material_fonts")

W, H = 2400, 1350
PW, PH, GAP, TOP = 520, 1125, 110, 150

bg = Image.new("RGB", (W, H))
draw = ImageDraw.Draw(bg)
top, bottom = (31, 41, 55), (17, 24, 39)
for y in range(H):
    t = y / H
    draw.line([(0, y), (W, y)], fill=tuple(int(top[i] * (1 - t) + bottom[i] * t) for i in range(3)))

x0 = (W - 3 * PW - 2 * GAP) // 2
for i, name in enumerate(["booking_1_services.png", "shop_1_catalog.png", "habits_1_today.png"]):
    shot = Image.open(os.path.join(SHOTS, name)).convert("RGB").resize((PW, PH), Image.LANCZOS)
    mask = Image.new("L", (PW, PH), 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, PW - 1, PH - 1], radius=48, fill=255)
    x = x0 + i * (PW + GAP)

    shadow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle(
        [x - 4, TOP + 10, x + PW + 24, TOP + PH + 38], radius=60, fill=(0, 0, 0, 140)
    )
    shadow = shadow.filter(ImageFilter.GaussianBlur(24))
    bg.paste(shadow, (0, 0), shadow)

    frame = Image.new("RGBA", (PW + 28, PH + 28), (0, 0, 0, 0))
    ImageDraw.Draw(frame).rounded_rectangle([0, 0, PW + 27, PH + 27], radius=60, fill=(10, 10, 12, 255))
    bg.paste(frame, (x - 14, TOP - 14), frame)
    bg.paste(shot, (x, TOP), mask)

title = "Flutter apps for Android & iOS"
font = ImageFont.truetype(os.path.join(FONTS, "Roboto-Bold.ttf"), 64)
draw = ImageDraw.Draw(bg)
draw.text(((W - draw.textlength(title, font=font)) / 2, 40), title, font=font, fill="white")
bg.save(os.path.join(SHOTS, "cover.png"), optimize=True)
