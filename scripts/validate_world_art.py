#!/usr/bin/env python3
"""Check full-size world art and optimized previews without Pillow."""
from pathlib import Path
import binascii, hashlib, json, struct

ROOT = Path(__file__).resolve().parents[1]
WORLD = ROOT / "assets/03_world/dungeon"
assets = {
    "source/ruins_portal_art_original.png": ((2098,750),"66d5ea8c82aef1961d0b77d4b4fbd2224fe0f58d7d536ce9c05740d7a6c21ceb"),
    "source/ruins_props_atlas_original.png": ((1448,1086),"51b4a0b7cb3952e3ce424c19df8f6f73bdd54c5fc35d3c6989ecbb750e8781ee"),
    "exports/ruins_backdrop_448x160.png": ((448,160),"323180107f0ed9879570ce3a7a8c015c009316602286aa0bc4ecdb61bee8f439"),
    "exports/ruins_props_384x288_preview.png": ((384,288),"48dc15f72ead3a71182912a1a858c86572c84235779d46d985282f0c52b94e15"),
}
for name,(dimensions,expected_sha) in assets.items():
    path = WORLD / name
    data = path.read_bytes()
    assert data[:8] == b"\x89PNG\r\n\x1a\n", f"PNG signature: {name}"
    width,height = struct.unpack_from(">II",data,16)
    assert (width,height) == dimensions,(name,width,height)
    assert hashlib.sha256(data).hexdigest() == expected_sha,f"SHA256 mismatch: {name}"
    if "props" in name:
        assert (b"tRNS" in data or data[25] in (4,6)), f"Expected transparency: {name}"
    print(f"OK {name}: {width}x{height}")
art = json.loads((WORLD / "art_map.json").read_text(encoding="utf-8"))
for block in ("source","exports"):
    for key,entry in art[block].items():
        assert (ROOT/entry["path"]).is_file(),(block,key)
assert len(art["layers"]) == 5
assert art["source"]["props"]["alpha"] is True
for crop in art["crop_candidates_original_props_px"]:
    x,y,w,h = crop["box"]
    assert 0 <= x < 1448 and 0 <= y < 1086 and w>0 and h>0
    assert x+w<=1448 and y+h<=1086,(crop["id"],crop["box"])
assert art["gameplay_contract"].startswith("no combat")
print("OK: world art integrity, alpha and composition contract")
