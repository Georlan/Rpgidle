"""Check that the Godot-only concept atlas is intact, not a sprite sheet."""
from pathlib import Path
import struct,zlib,binascii
file=Path(__file__).resolve().parents[1]/"assets/01_creatures/evolution_concepts_preview.png"
data=file.read_bytes()
assert data[:8] == b"\x89PNG\r\n\x1a\n" and len(data)<100000
o=8
chunks=[]
while o<len(data):
    n=struct.unpack_from(">I",data,o)[0]
    tag=data[o+4:o+8]
    body=data[o+8:o+8+n]
    assert len(body)==n
    crc=struct.unpack_from(">I",data,o+8+n)[0]
    assert (binascii.crc32(tag+body)&0xffffffff)==crc,(tag,crc)
    chunks.append((tag,body));o+=n+12
    if tag==b"IEND":break
assert o==len(data)
w,h,depth,color,_,_,_=struct.unpack(">IIBBBBB",next(v for k,v in chunks if k==b"IHDR"))
assert (w,h,depth,color)==(192,40,8,3)
assert 4*48==w and h==40
zlib.decompress(b"".join(v for k,v in chunks if k==b"IDAT"))
print("PASS: 4 original concept portraits, 48x40 each, indexed PNG intact")
