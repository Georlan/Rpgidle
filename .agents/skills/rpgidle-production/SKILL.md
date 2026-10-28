---
name: rpgidle-production
description: >
  Use for any change to Georlan/Rpgidle involving Godot 4.6.1,
  creature sprites, evolution forms, animation, interface, input,
  cards, dungeon, performance, tests, Steam packaging or asset import.
  Keep the approved game design, verify licenses, produce a small
  testable change and avoid adding mechanics without approval.
---

# Rpgidle — production assistant

## Scope and source of truth

Always read the relevant portions of:
- `docs/GAME_DESIGN.md` (approved gameplay principles);
- `docs/SYSTEM_SIGNATURE.md` (trainer's Potential, 1 signature per 3-creature team);
- `docs/OPEN_DECISIONS.md` (do not invent pending formulas);
- `docs/ASSET_PIPELINE.md` and `assets/metadata/manifest.json` for art tasks;
- `docs/REFERENCE_RESEARCH.md` for research, license and inspirations;
- `docs/CONTROLS_TEST_PLAN.md` for UI/input.

**Engine target is Godot 4.6.1**, matching the user's local Linux install.
External documentation and skills written for 4.7+ are conceptual references;
verify each API against 4.6.1 before changing gameplay code.

## Select the smallest specialist reference

1. **Sprites, animations, FX:** read upstream `create-game-assets`, `godot-animation` and `godot-gdscript`, but only the necessary sections. Source: https://github.com/gamedev-skills/awesome-gamedev-agent-skills
2. **UI, desktop overlay and gamepad:** read `godot-ui-control`, `input-systems` and `game-ui-ux`; verify focus loss, escape path, physical controller behavior.
3. **Reusable creatures and forms:** consult `godot-resources` and `godot-nodes-scenes`; keep creature identity and individual evolution unlocks separate from the global ranch registry.
4. **Tests/performance:** consult `godot-gdscript-headless-testing` and `performance-optimization`; run CI and, where possible, profile runtime costs.
5. **Shipping:** consult `steam-publish` only when preparing real store pages, builds, demos, depots or playtests, with authoritative Steamworks docs.
6. **Optional detailed Godot references:** Scenario Godot experts cover animation, UI, VFX and pipeline, but their 4.7.2 procedures require version adaptation. Do not install the Scenario MCP or spend money without user authorization.

Never bulk-install a skill collection, run an unknown installer, add credentials,
copy third-party game artwork or vendor plugins simply because they were found publicly.

## The smallest production cycle

1. Choose **one result**, such as "CR001 idle loop with stable foot pivot".
2. Inspect existing files and constraints; verify license/compatibility of dependencies.
3. Create/change source assets or GDScript in a small branch.
4. Validate with `godot --headless --path . --editor --import --quit` then the input smoke test; add a focused test where applicable.
5. Compare **actual in-engine** screenshot or exported clip at 1x and 3x, light and dark, and in desktop compact mode. A generated moodboard is not a sprite sheet; a CSS bob is not full animation.
6. Update asset manifest status and provenance; mark `concept`, `preview`, `in_review` or `approved` accurately.
7. Open a small PR. Merge only if required CI succeeds. A green headless CI does **not** substitute for visual QA or a physical controller test.

## Current approved mechanics (non-negotiable)

- Dungeon PvE idle, infinite with voluntary reset; creatures do not reset.
- 3 active creatures, 4 grades and individually unlocked interchangeable forms.
- Four combat attributes: Strength, Speed, Resistance and Intelligence.
- Permanent shared training across forms within the same individual.
- Trainer only has Potential; the System observes meaningful player decisions.
- 3 automatic technique cards per creature and **1 active trainer signature per team**.
- Ranch registers distinct discovered forms permanently.
- PvP normalization, premium game plus optional non-pay-to-win cosmetics.
- **Exact formulas, grades-to-letter scale, actual rewards and trigger logic remain unapproved.**

Do not implement speculative rules as canon.

## Art contract

- Use CRxxx stable IDs, form IDs, explicit file type and source/preview/export directories.
- Aim for silhouette recognition and consistent pixel grid, outline, baseline, palette and perspective.
- For animated sprites, preserve pivot; check loop seam, frame timing and transparency.
- Write texts and UI as real Godot controls, never embedded into generated game art.
- One creature with a verified idle/walk/attack is more valuable than six unanimated placeholders.
- Keep monetizable cosmetic layers separate from functional sprites and combat balance.

## Safety, ownership and IP

Research is inspiration, not import permission. Each third-party file must have its
specific license checked and attribution requirements recorded. A repository's MIT
license does **not** license another game's characters or store screenshots.
Do not change the commercial licensing of Rpgidle without explicit approval.
No secrets, Steam credentials, API keys, or paid infrastructure in Git.
