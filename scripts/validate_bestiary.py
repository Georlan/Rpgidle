"""Schema checks for the static bestiary only; never invents player discoveries."""
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PATH = ROOT / "assets/metadata/bestiary_catalog.json"
obj = json.loads(PATH.read_text(encoding="utf-8"))
assert obj["schema_version"] == 1
assert obj["grades_supported"] == [1, 2, 3, 4]
assert len(obj["species"]) >= 3
species_ids = set()
form_ids = set()
for species in obj["species"]:
    sid = species["species_id"]
    assert re.fullmatch(r"CR\d{3,}", sid), sid
    assert sid not in species_ids, sid
    species_ids.add(sid)
    assert species["name_status"] == "provisional"
    assert species["forms"], sid
    for form in species["forms"]:
        fid = form["form_id"]
        assert re.fullmatch(re.escape(sid) + r"_G[1-4](?:_[a-z0-9_]+)?", fid), fid
        assert fid not in form_ids, fid
        assert form["grade"] in (1, 2, 3, 4)
        assert f"_G{form['grade']}" in fid
        assert form["branch_key"] == "base" or re.fullmatch("[a-z0-9_]+", form["branch_key"])
        assert form["asset"].startswith("res://assets/"), form["asset"]
        assert (ROOT / form["asset"].removeprefix("res://")).is_file(), form["asset"]
        form_ids.add(fid)
    assert any(f["grade"] == 1 for f in species["forms"]), sid
# Catalog isn't a save file. This deliberately excludes individual and ranch state.
assert not any(k in obj for k in ("players", "instances", "unlocked_forms", "discovered_forms", "inventory"))
print(f"PASS: bestiary {len(species_ids)} species / {len(form_ids)} candidate forms; no player state")
