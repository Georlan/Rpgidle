"""Validate the first six-pose PNG atlas without additional dependencies."""
import binascii
from pathlib import Path
import struct

ROOT = Path(__file__).resolve().parents[1]
PATH = ROOT / "assets/01_creatures/CR001_Lunaro/sprite_sheets/CR001_G1_6poses_64x48.png"
blob = PATH.read_bytes()
assert blob[:8] == b"\x89PNG\r\n\x1a\n", "PNG signature"
position = 8
seen = []
while position < len(blob):
    assert position + 12 <= len(blob), "truncated chunk header"
    length = struct.unpack_from(">I", blob, position)[0]
    typ = blob[position+4:position+8]
    payload = blob[position+8:position+8+length]
    assert len(payload) == length, "truncated payload"
    actual = struct.unpack_from(">I", blob, position+8+length)[0]
    expected = binascii.crc32(typ + payload) & 0xFFFFFFFF
    assert actual == expected, f"CRC failed: {typ!r}"
    seen.append(typ)
    if typ == b"IHDR":
        width,height,bit_depth,color_type,_,_,_ = struct.unpack(">IIBBBBB",payload)
        assert (width,height) == (384,48), f"atlas size {width}x{height}"
        assert bit_depth == 8 and color_type == 3, "expected indexed PNG"
        assert width // 64 == 6 and height // 48 == 1, "six frames"
    position += length + 12
    if typ == b"IEND":
        assert position == len(blob), "PNG trailing data"
        break
assert seen[0] == b"IHDR" and seen[-1] == b"IEND", "invalid PNG layout"
assert b"tRNS" in seen, "alpha transparency missing"
assert len(blob) < 40_000, "keep prototype atlas small"
print("OK: CR001 six-pose transparent PNG valid, 384x48, six cells")
