"""Basic static checks for project-local agent guidance. No third-party deps."""
from pathlib import Path
import re

root = Path(__file__).resolve().parents[1]
paths = [
    root / "AGENTS.md",
    root / ".agents/skills/rpgidle-production/SKILL.md",
    root / "docs/REFERENCE_RESEARCH.md",
    root / "docs/PRODUCTION_PRIORITY.md",
    root / "docs/GAME_DESIGN.md",
    root / "docs/OPEN_DECISIONS.md",
    root / "docs/SYSTEM_SIGNATURE.md",
]
for path in paths:
    assert path.is_file() and path.stat().st_size > 100, f"Missing/empty: {path}"

skill = paths[1].read_text(encoding="utf-8")
assert skill.startswith("---\n"), "Skill must have YAML frontmatter"
end = skill.find("\n---\n", 4)
assert end > 0, "Missing closing frontmatter delimiter"
frontmatter = skill[4:end]
assert re.search(r"(?m)^name: rpgidle-production$", frontmatter)
assert re.search(r"(?m)^description:", frontmatter)
assert "Godot 4.6.1" in skill
assert "1 active trainer signature" in skill
research = paths[2].read_text(encoding="utf-8")
for link in (
    "gamedev-skills/awesome-gamedev-agent-skills",
    "scenario-labs/skills",
    "godotengine/godot-demo-projects",
    "Cassette_Beasts" # absent; checked via normalized URL below
):
    if link == "Cassette_Beasts":
        assert "cassettebeasts.com" in research
    else:
        assert link in research, f"Missing reference: {link}"
for phrase in ("MIT", "Godot 4.7", "Whimside", "Siralim Ultimate"):
    assert phrase in research, f"Missing license/version/competitor note: {phrase}"
print("OK: project skill and reference guidance present")
