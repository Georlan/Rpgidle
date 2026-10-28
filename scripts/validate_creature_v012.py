"""Validate the approved creature exports without third-party dependencies."""
from pathlib import Path
import struct, zlib, binascii, hashlib

ROOT = Path(__file__).resolve().parents[1]
SHEETS = {
    "CR002": ("assets/01_creatures/CR002_Brumelo/sprite_sheets/CR002_G1_6poses_96x80.png",
              "5f06463ecfabc76c2e11a7d943078752083fa3dc719fa0d5db88ff53ed7d805e"),
    "CR003": ("assets/01_creatures/CR003_Ferru/sprite_sheets/CR003_G1_6poses_96x80.png",
              "6b1750f29bf6a9610bc956cef606d97e01f1bfff66efd0bcb609a8071f5b2784"),
}

def check(path: Path, expected: str) -> None:
    b=path.read_bytes()
    assert hashlib.sha256(b).hexdigest()==expected, f"Unexpected asset bytes: {path}"
    assert len(b)<30000 and b.startswith(b"\x89PNG\r\n\x1a\n")
    pos=8
    chunks={}
    while pos<len(b):
        n=struct.unpack_from(">I",b,pos)[0]
        typ=b[pos+4:pos+8]
        payload=b[pos+8:pos+8+n]
        crc=struct.unpack_from(">I",b,pos+8+n)[0]
        assert binascii.crc32(typ+payload)&0xffffffff==crc
        chunks.setdefault(typ,[]).append(payload)
        pos+=12+n
        if typ==b"IEND": break
    assert pos==len(b) and b"IHDR" in chunks and b"IEND" in chunks
    dims=struct.unpack(">IIBBBBB",chunks[b"IHDR"][0])
    assert dims==(576,80,8,3,0,0,0), dims
    transparency=chunks[b"tRNS"][0]
    assert 0 in transparency and any(v==255 for v in transparency)
    transparent=transparency.index(0)
    raw=zlib.decompress(b"".join(chunks[b"IDAT"]))
    assert len(raw)==80*(576+1)
    rows=[]
    prior=bytes(576)
    p=0
    for _ in range(80):
        flt=raw[p]
        src=raw[p+1:p+577]
        p+=577
        out=bytearray(576)
        for k, v in enumerate(src):
            left=out[k-1] if k>0 else 0
            up=prior[k]
            corner=prior[k-1] if k>0 else 0
            if flt==0:pred=0
            elif flt==1:pred=left
            elif flt==2:pred=up
            elif flt==3:pred=(left+up)//2
            elif flt==4:
                target=left+up-corner
                errors=(abs(target-left),abs(target-up),abs(target-corner))
                pred=(left,up,corner)[errors.index(min(errors))]
            else:raise AssertionError("Invalid PNG filter")
            out[k]=(v+pred)&255
        prior=bytes(out)
        rows.append(prior)
    hashes=set()
    for frame in range(6):
        pixels=b"".join(row[96*frame:96*(frame+1)] for row in rows)
        assert pixels.count(transparent)>0
        assert sum(c!=transparent for c in pixels)>200
        hashes.add(hashlib.sha256(pixels).digest())
    assert len(hashes)==6, "Poses must be different"
    print("OK",path.name,"576x80, transparency, six distinct poses")

if __name__=="__main__":
    for rel, sha in SHEETS.values():
        check(ROOT/rel,sha)
    print("PASS: current creature art exports")
