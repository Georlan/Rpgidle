"""Validate PNG integrity, transparency and six distinct sprite poses (stdlib only)."""
from pathlib import Path
import hashlib
import struct
import zlib
import binascii

ROOT = Path(__file__).resolve().parents[1]
ATLAS = {
    "CR001": ("assets/01_creatures/CR001_Lunaro/sprite_sheets/CR001_G1_6poses_64x48.png", None),
    "CR002": ("assets/01_creatures/CR002_Brumelo/sprite_sheets/CR002_G1_6poses_64x48.png", "3451626a505c9f919a0b932b45242cc2a94fec76e72eb8649506e6354ce14d6e"),
    "CR003": ("assets/01_creatures/CR003_Ferru/sprite_sheets/CR003_G1_6poses_64x48.png", "b2fbff819e2a5639dfc46f1bc8ea5bd8648ba26af936cdb90ab696068895a753"),
}


def decode(path: Path):
    data = path.read_bytes()
    assert len(data) < 80_000 and data.startswith(b"\x89PNG\r\n\x1a\n"), path
    chunks = []
    off = 8
    while off < len(data):
        length = struct.unpack_from(">I", data, off)[0]
        tag = data[off + 4:off + 8]
        payload = data[off + 8:off + 8 + length]
        assert len(payload) == length and off + 12 + length <= len(data), path
        crc = struct.unpack_from(">I", data, off + 8 + length)[0]
        assert binascii.crc32(tag + payload) & 0xffffffff == crc, (path, tag)
        chunks.append((tag, payload))
        off += 12 + length
        if tag == b"IEND":
            break
    assert chunks[-1][0] == b"IEND" and off == len(data), path
    ihdr = next(payload for tag, payload in chunks if tag == b"IHDR")
    width, height, bits, ctype, comp, filt, interlace = struct.unpack(">IIBBBBB", ihdr)
    assert (width, height, bits) == (384, 48, 8), (path, width, height, bits)
    assert ctype in (3, 6) and interlace == 0 and comp == 0 and filt == 0
    assert ctype == 6 or any(t == b"tRNS" for t, _ in chunks), "Missing alpha"
    bpp = 1 if ctype == 3 else 4
    stride = width * bpp
    scan = zlib.decompress(b"".join(payload for tag, payload in chunks if tag == b"IDAT"))
    assert len(scan) == (stride + 1) * height, path
    out_rows = []
    prior = bytes(stride)
    pos = 0
    for _ in range(height):
        mode = scan[pos]
        row = scan[pos + 1:pos + 1 + stride]
        pos += stride + 1
        out = bytearray(stride)
        assert mode in (0, 1, 2, 3, 4), (path, mode)
        for i, value in enumerate(row):
            left = out[i - bpp] if i >= bpp else 0
            top = prior[i]
            corner = prior[i - bpp] if i >= bpp else 0
            if mode == 0:
                prediction = 0
            elif mode == 1:
                prediction = left
            elif mode == 2:
                prediction = top
            elif mode == 3:
                prediction = (left + top) // 2
            else:
                p = left + top - corner
                d = (abs(p - left), abs(p - top), abs(p - corner))
                prediction = (left, top, corner)[d.index(min(d))]
            out[i] = (value + prediction) & 255
        prior = bytes(out)
        out_rows.append(prior)
    frames = []
    for frame in range(6):
        frame_bytes = b"".join(row[frame * 64 * bpp:(frame + 1) * 64 * bpp] for row in out_rows)
        frames.append(hashlib.sha256(frame_bytes).digest())
        if ctype == 6:
            alpha = frame_bytes[3::4]
            assert any(a == 0 for a in alpha) and any(a > 0 for a in alpha), path
            feet = b"".join(row[frame * 64 * 4:(frame + 1) * 64 * 4] for row in out_rows[40:45])
            assert any(a > 0 for a in feet[3::4]), "Foot baseline missing"
    assert len(set(frames)) >= 4, f"Frames are too similar in {path.name}"
    return data


def main():
    for creature, (relative, expected_hash) in ATLAS.items():
        path = ROOT / relative
        data = decode(path)
        if expected_hash:
            assert hashlib.sha256(data).hexdigest() == expected_hash, f"Unexpected {creature} source"
        print(f"OK {creature}: 6 cells, 384x48, transparency, CRC, distinct frames")
    print("PASS: all creature sprite sheets")


if __name__ == "__main__":
    main()
