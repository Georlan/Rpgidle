"""Validação sem dependências de manifests e estrutura (pré-produção)."""
import json
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
assert manifest["character_ids"] == ["CR001"]
assert isinstance(manifest["assets"], list)
for item in manifest["assets"]:
    assert set(("path", "status", "type")) <= set(item), item
    assert (ROOT / item["path"]).is_file(), f"Declared asset missing: {item['path']}"
assert all(value.startswith("#") and len(value) == 7 for value in palette["colors"].values())
print("OK: documentação e manifestos verificados")
