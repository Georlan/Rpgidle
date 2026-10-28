"""Validate candidate branching graph; this is not player state or unlock rules."""
import json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
data=json.loads((ROOT/"assets/metadata/evolution_preview.json").read_text())
assert data["schema_version"] == 1
assert data["status"] == "concept_preview_only"
assert data["grades"] == [1,2,3,4]
assert len(data["species"]) == 3
assert {x["species_id"] for x in data["species"]}=={"CR001","CR002","CR003"}
for item in data["species"]:
    sid=item["species_id"]; nodes=item["nodes"]
    assert len(nodes)==(1 if sid=="CR001" else 7)
    ids={n["form_id"]:n for n in nodes}
    assert len(ids)==len(nodes)
    for n in nodes:
        assert n["form_id"].startswith(sid+"_G")
        assert int(n["form_id"].split("_G")[1][0])==n["grade"]
        assert n["grade"] in (1,2,3,4)
        assert 0 <= n["lane"] <= 1
        assert n["art_status"] in ("existing_g1","concept_crop","undrawn")
        assert n["art_slot"] in (-1,0,1,2,3)
        for parent in n["parents"]:
            assert parent in ids
            assert ids[parent]["grade"]==n["grade"]-1, (parent,n["form_id"])
        if n["grade"]>1: assert n["parents"],n
    if sid!="CR001":
        assert len([n for n in nodes if n["grade"]==4])==2
        assert any(len(n["parents"])>1 for n in nodes), "must support convergence"
        assert len([n for n in nodes if n["grade"]==2])==2, "must branch"
assert not any(x in data for x in ("unlocked_forms","owned","inventory","player","discovered"))
print("PASS: read-only branched evolution preview, 4 grades, crossings, no saved unlock state")
