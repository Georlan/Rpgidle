"""Validate visual-slice contracts; no runtime dependencies."""
from html.parser import HTMLParser
import json
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PROTOTYPE = ROOT / "prototypes/visual-slice-v02"
INDEX = PROTOTYPE / "index.html"
DATA = PROTOTYPE / "data.json"
MANIFEST = ROOT / "assets/metadata/manifest.json"

class Markup(HTMLParser):
    def __init__(self):
        super().__init__()
        self.ids = set()
        self.navs = []
        self.refs = []
    def handle_starttag(self, tag, attrs):
        d = dict(attrs)
        if "id" in d:
            self.ids.add(d["id"])
        if tag == "button" and "data-tab" in d:
            self.navs.append(d["data-tab"])
        for name in ("src","href"):
            if name in d:
                self.refs.append(d[name])

errors = []
def check(ok, msg):
    if not ok:
        errors.append(msg)

data = json.loads(DATA.read_text(encoding="utf-8"))
manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))
check(data.get("preview_only") is True, "Data must be explicitly preview-only")
check(data.get("active_creatures")==3, "Expected 3 active creatures")
check(data.get("technique_slots_per_creature")==3, "Expected 3 techniques per creature")
check(data.get("trainer_signature_slots")==1, "Expected 1 trainer signature")
check(data.get("canonical_requirements")=="unresolved", "Do not imply finalized evolution requirements")
creatures = data["creatures"]
ids = {c["id"] for c in creatures}
check(len(ids)==len(creatures) and len(ids)>=3, "Duplicate or missing starter IDs")
check(set(manifest["character_ids"]) == ids, "Manifest creature IDs differ from prototype")
for c in creatures:
    path = (PROTOTYPE / c["art"]).resolve()
    check(path.is_file(), f"Missing creature art: {c['art']}")
forms = data["forms"]
form_ids={f["id"] for f in forms}
check(len(form_ids)==len(forms), "Duplicate form IDs")
check({1,2,3,4} <= {f["grade"] for f in forms}, "Four evolution grades required")
for f in forms:
    check(f["owner"] in ids, f"Unknown creature owner: {f['id']}")
    if f.get("parent"):
        check(f["parent"] in form_ids, f"Missing parent: {f['id']}")
    if f.get("other_possible_parent"):
        check(f["other_possible_parent"] in form_ids, f"Missing alternate parent: {f['id']}")
for a in manifest["assets"]:
    path=ROOT/a["path"]
    check(path.is_file(), f"Missing asset: {a['path']}")
    if path.suffix.lower()==".svg" and path.is_file():
        try:
            ET.parse(path)
        except ET.ParseError as e:
            errors.append(f"Invalid SVG {path}: {e}")
page=Markup()
page.feed(INDEX.read_text(encoding="utf-8"))
check({"app","dock","shell"} <= page.ids, "Required HTML anchor missing")
check(set(page.navs)=={"dungeon","creatures","evolutions","ranch","trainer","arena"}, "Expected six navigation tabs")
for ref in page.refs:
    if ref.startswith(("#","http:","https:","data:")):
        continue
    check((PROTOTYPE / ref).resolve().is_file(), f"Missing HTML-linked file: {ref}")

js=(PROTOTYPE/"app.js").read_text(encoding="utf-8")
for name in ("renderDungeon","renderCreatures","renderEvolutions","renderRanch","renderTrainer","renderArena"):
    check(f"function {name}(" in js, f"Missing renderer: {name}")
if errors:
    for err in errors:
        print("ERROR:", err, file=sys.stderr)
    sys.exit(1)
print(f"OK: visual slice v0.2 validated, {len(creatures)} creature previews, {len(forms)} forms, {len(manifest['assets'])} assets")
