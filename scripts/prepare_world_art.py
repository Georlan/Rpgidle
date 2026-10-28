#!/usr/bin/env python3
"""Regenerate small Godot previews from the exact image generation sources.

Requires Pillow installed ONLY in the art authoring environment:
    python3 -m pip install Pillow
    python3 scripts/prepare_world_art.py
Does not overwrite the source masters. No game runtime dependency.
"""
from pathlib import Path
try:
    from PIL import Image
except ImportError as exc:
    raise SystemExit("Install Pillow to author/re-export world art: python3 -m pip install Pillow") from exc

ROOT = Path(__file__).resolve().parents[1]
WORLD = ROOT / "assets/03_world/dungeon"
EXPORTS = WORLD / "exports"
EXPORTS.mkdir(parents=True, exist_ok=True)

def save_preview(source: Path, target: Path, width: int, palette: int, keep_alpha: bool) -> None:
    im = Image.open(source).convert("RGBA")
    height = round(im.height * width / im.width)
    im = im.resize((width,height), Image.Resampling.NEAREST)
    if keep_alpha:
        alpha = im.getchannel("A").point(lambda a: 255 if a >= 128 else 0)
        im.putalpha(alpha)
        clean = Image.new("RGBA", im.size, (0,0,0,0))
        clean.alpha_composite(im)
        result = clean.quantize(colors=palette, method=Image.Quantize.FASTOCTREE, dither=Image.Dither.NONE)
    else:
        result = im.convert("RGB").quantize(colors=palette, method=Image.Quantize.FASTOCTREE, dither=Image.Dither.NONE)
    result.save(target, "PNG", optimize=True, compress_level=9)
    print(f"{source.name} -> {target.name} ({width}x{height})")

save_preview(WORLD/"source/ruins_portal_art_original.png", EXPORTS/"ruins_backdrop_448x160.png", 448,16,False)
save_preview(WORLD/"source/ruins_props_atlas_original.png", EXPORTS/"ruins_props_384x288_preview.png",384,16,True)
