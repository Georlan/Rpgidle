"""Validação sem dependências dos manifestos e da estrutura (pré-produção)."""
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
required = [
    "README.md",
    "docs/GAME_DESIGN.md",
    "docs/SYSTEM_SIGNATURE.md",
    "docs/OPEN_DECISIONS.md",
    "docs/VISUAL_DIRECTION.md",
    "assets/README.md",
    "assets/01_creatures/CR001_Lunaro/README.md",
    "assets/metadata/manifest.json",
    "assets/metadata/palette.json",
]
for item in required:
    assert (ROOT / item).is_file(), f"Required file missing: {item}"

manifest = json.loads((ROOT / "assets/metadata/manifest.json").read_text(encoding="utf-8"))
palette = json.loads((ROOT / "assets/metadata/palette.json").read_text(encoding="utf-8"))
assert manifest["schema_version"] == 1
ids = manifest["character_ids"]
assert isinstance(ids, list) and ids and len(ids) == len(set(ids))
assert all(isinstance(x, str) and re.fullmatch(r"CR\d{3,}", x) for x in ids)
assert "CR001" in ids, "Pilot CR001 must remain available"
assert isinstance(manifest["assets"], list)
paths = [item["path"] for item in manifest["assets"]]
assert len(paths) == len(set(paths)), "Duplicate asset paths"
for item in manifest["assets"]:
    assert set(("path", "status", "type")) <= set(item), item
    assert (ROOT / item["path"]).is_file(), f"Declared asset missing: {item['path']}"
assert all(value.startswith("#") and len(value) == 7 for value in palette["colors"].values())
print(f"OK: documentação e manifestos verificados ({len(ids)} criaturas registradas)")
