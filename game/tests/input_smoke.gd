extends SceneTree
## Smoke test in Godot's own runtime. No graphics, controller hardware or Steam needed.

const BestiaryCatalog = preload("res://game/scripts/bestiary_catalog.gd")
const EvolutionPreviewData = preload("res://game/scripts/evolution_preview_data.gd")
var _failures: int = 0


func _initialize() -> void:
    call_deferred("_run")


func _run() -> void:
    var scene: PackedScene = load("res://game/scenes/main.tscn")
    if scene == null:
        _fail("Main scene did not load")
        return

    var ui := scene.instantiate()
    root.add_child(ui)
    print("SMOKE: scene instantiated")
    await process_frame
    if ui._stage == null:
        _fail("DungeonStage failed to instantiate")
        return

    _check(BestiaryCatalog.known_species_count() == 3, "bestiary knows only three prototype species")
    _check(BestiaryCatalog.species_by_id("CR002").get("display_name", "") == "Brumelo", "bestiary species lookup")
    _check(BestiaryCatalog.form_by_id("CR003", "CR003_G1").get("grade", 0) == 1, "bestiary form lookup")
    _check(BestiaryCatalog.form_by_id("CR003", "CR003_G4").is_empty(), "unknown evolution is not invented")
    _check(BestiaryCatalog.species_by_id("CR999").is_empty(), "unregistered species rejected")
    _check(ui.current_screen == 0, "starts in dungeon")
    _check(ui.theme != null, "visual theme assigned")
    _check(ui.theme.has_stylebox("normal", "Button"), "button component has style")
    _check(ui.theme.has_stylebox("panel", "PanelContainer"), "panel component has style")
    _check(ui._page_title.text == "Dungeon", "screen heading is concise")
    _check(ui.preview_floor == 36, "starts at demonstration floor 36")
    _check(ui._stage.visible, "dungeon stage is visible at startup")
    _check(ui._stage.creature_count() == 3, "dungeon stage includes 3 creatures")
    _check(ui._stage.backdrop_size() == Vector2i(448, 160), "professional pixel backdrop imported")
    _check(ui._stage.is_preview_running(), "dungeon scene starts in preview mode")
    _check(ui._stage.floor_preview() == 36, "dungeon floor preview stays synchronized")
    print("SMOKE: initial idle state")
    _check(ui._stage.phase_for_time(0.3) == "explore", "exploration phase")
    _check(ui._stage.phase_for_time(3.6) == "engage", "engage phase")
    _check(ui._stage.phase_for_time(5.0) == "resolve", "resolve phase")
    _check(ui._stage.phase_for_time(6.9) == "advance", "advance phase")
    _check(ui._stage.preview_speed() == 1.0, "idle simulation starts at 1x")
    ui._toggle_dungeon_speed()
    _check(ui._stage.preview_speed() == 2.0, "speed button sets 2x")
    ui._stage._process(1.0)
    _check(ui._stage.preview_progress() > 0.23, "2x advances the simulated timeline")
    ui._toggle_dungeon_pause()
    _check(ui._stage.is_paused(), "pause is recorded")
    _check(not ui._stage.is_preview_running(), "pause stops visual loop")
    var paused_progress: float = ui._stage.preview_progress()
    ui._stage._process(1.0)
    _check(is_equal_approx(ui._stage.preview_progress(), paused_progress), "paused cycle doesn't advance")
    ui._toggle_dungeon_pause()
    _check(ui._stage.is_preview_running(), "auto resumes")
    ui._stage._process(10.0)
    _check(ui.preview_floor >= 38, "completing visual cycles advances preview floors")
    _check(ui._stage.floor_preview() == ui.preview_floor, "floor stays synchronized")
    ui._toggle_dungeon_speed()
    _check(ui._stage.preview_speed() == 1.0, "speed toggles back to 1x")

    _check(InputMap.has_action("lab_next_screen"), "next screen action")
    _check(InputMap.has_action("lab_previous_screen"), "previous screen action")
    _check(InputMap.has_action("lab_toggle_compact"), "compact action")
    _check(InputMap.has_action("lab_reset_preview"), "reset action")
    _check(bool(ProjectSettings.get_setting("input_devices/joypads/ignore_joypad_on_unfocused_application", false)), "gamepad ignored without focus")

    var shoulder := InputEventJoypadButton.new()
    shoulder.button_index = JOY_BUTTON_RIGHT_SHOULDER
    _check(InputMap.event_is_action(shoulder, "lab_next_screen"), "RB mapped")
    var start := InputEventJoypadButton.new()
    start.button_index = JOY_BUTTON_START
    _check(InputMap.event_is_action(start, "lab_toggle_compact"), "Start mapped")

    ui._switch_screen(1)
    _check(ui.current_screen == 1, "screen changed")
    ui._switch_screen(-1)
    _check(ui.current_screen == 0, "screen returned")

    ui._reset_preview()
    _check(ui.preview_floor == 1, "reset affects only the preview floor")
    _check(ui._stage.floor_preview() == 1, "stage reset changes only floor metadata")
    _check(ui._stage.preview_progress() < 0.05, "preview cycle reset restores start phase")
    _check(ui.selected_creature == 0, "reset preserves creature")
    _check(ui.preview_grade == 1, "reset preserves creature grade preview")

    print("SMOKE: completed idle pause/speed/reset")
    ui._open_screen(1)
    _check(not ui._stage.visible, "dungeon stage hidden on creature tab")
    _check(not ui._stage.is_preview_running(), "dungeon scene is paused when hidden")
    await process_frame
    _check(ui._pet_row.get_child_count() >= 3, "three visual creature slots")
    _check(ui._detail_cards.visible, "creature dossier visible")
    _check(ui._detail_cards.get_child_count() == 3, "attributes, technique header and slots")
    ui._open_screen(2)
    _check(ui._evolution_graph.visible, "evolution graph visible")
    _check(ui._evolution_graph.node_count() == 7, "Brumelo has seven preview nodes over four grades")
    _check(ui._evolution_graph.selected_id == "CR002_G1", "initial G1 concept selected")
    _check(ui._detail_cards.visible, "evolution detail visible")
    ui._evolution_graph.select_form("CR002_G3_A")
    _check(ui.selected_preview_form_id == "CR002_G3_A", "selecting branch updates detail")
    _check(ui._page_body.text.contains("RAMIFICADA"), "tree does not claim linear evolution")
    ui._next_evolution_species()
    _check(ui._evolution_graph.node_count() == 7, "Ferru has branch preview too")
    _check(ui.selected_preview_form_id == "CR003_G1", "switch species resets candidate focus")
    ui._next_evolution_species()
    _check(ui._evolution_graph.node_count() == 1, "Lunaro has no invented future forms")
    _check(EvolutionPreviewData.node_by_id("CR002", "CR002_G4_A").get("grade", 0) == 4, "fourth grade candidate metadata")
    _check(EvolutionPreviewData.node_by_id("CR003", "CR003_G4_X").is_empty(), "unknown form rejected")
    ui._open_screen(3)
    _check(ui._page_body.text.contains("BESTIÁRIO"), "ranch has searchable bestiary section")
    _check(ui._detail_cards.get_child_count() >= 2, "catalog details shown without discovery state")
    var registry_index: int = ui.preview_registry_species
    ui._next_registry_species()
    _check(ui.preview_registry_species != registry_index, "catalog selection changes species")
    ui._open_screen(1)
    await process_frame
    var first_block: VBoxContainer = ui._pet_row.get_child(ui._pet_row.get_child_count() - 3) as VBoxContainer
    var first_picture: TextureRect = first_block.get_child(0) as TextureRect
    _check(first_picture.get("creature_id") == "CR001", "first sprite is CR001")
    _check(first_picture.get("has_pose_atlas") == true, "atlas loaded from PNG")
    _check(first_picture.sprite_cell_size() == Vector2i(64, 48), "Lunaro retains original dimensions")
    for name in ["idle", "walk", "attack", "hurt", "skill"]:
        _check(first_picture.sprite_frame_count(name) >= 3, "sprite state has real frames: " + name)
    # Verify the two new individual atlases also load via SpriteFrames in the actual engine.
    for idx in [1, 2]:
        var creature_block: VBoxContainer = ui._pet_row.get_child(idx) as VBoxContainer
        var creature_picture: TextureRect = creature_block.get_child(0) as TextureRect
        _check(creature_picture.get("has_pose_atlas") == true, "new G1 atlas loaded for %s" % creature_picture.get("creature_id"))
        _check(creature_picture.sprite_cell_size() == Vector2i(96, 80), "approved art uses 96x80 grid")
        for state in ["idle", "walk", "attack", "hurt", "skill"]:
            _check(creature_picture.sprite_frame_count(state) >= 3, "new creature frames: " + state)
        creature_picture.play_state("walk")
        _check(creature_picture.sprite_animation_name() == "walk", "walk uses native frames")
        creature_picture.set_motion_enabled(false)
        _check(creature_picture.sprite_animation_name() == "idle", "motion off freezes at idle")
        creature_picture.set_motion_enabled(true)
    _check(first_picture.sprite_animation_name() == "idle", "initial idle sprite animation")
    _check(ui.auto_demo_enabled, "autoplay enabled by default in CR001 preview")
    _check(first_picture.demo_is_running(), "CR001 autoplay running on creature screen")
    _check(first_picture.demo_current_step() == 0, "demo starts in idle state")
    print("SMOKE: awaiting creature autoplay")
    await create_timer(1.75).timeout
    _check(first_picture.demo_current_step() == 1, "autoplay advanced to walking")
    _check(first_picture.get("motion_state") == "walk", "autoplay entered walk")
    ui._show_motion_state("attack")
    _check(not first_picture.demo_is_running(), "manual selection stops autoplay")
    _check(not ui.auto_demo_enabled, "manual override updates autoplay setting")
    _check(first_picture.sprite_animation_name() == "attack", "attack uses pose frames")
    ui._show_motion_state("walk")
    _check(first_picture.get("motion_state") == "walk", "walk preview state started")
    _check(first_picture.sprite_animation_name() == "walk", "walk uses pose frames")
    ui._toggle_auto_demo()
    _check(first_picture.demo_is_running(), "autoplay can restart from manual state")
    _check(ui.auto_demo_enabled, "autoplay toggle enabled")
    ui._toggle_motion_enabled()
    _check(not ui.motion_enabled, "motion can be disabled")
    _check(not first_picture.demo_is_running(), "reducing motion stops autoplay")
    _check(first_picture.sprite_animation_name() == "idle", "motion off returns to idle pose")
    _check(first_picture.scale == Vector2.ONE, "disabled motion restores original scale")
    ui._toggle_motion_enabled()
    _check(ui.motion_enabled, "motion can be reenabled")
    _check(first_picture.demo_is_running(), "autoplay resumes when motion is reenabled")
    ui._toggle_compact()
    _check(not first_picture.demo_is_running(), "compact mode suspends full-preview autoplay")
    _check(ui._compact_dock.visible, "compact mode still displays pets")
    ui._toggle_compact()
    _check(first_picture.demo_is_running(), "expanded mode resumes autoplay")
    ui._open_screen(4)
    _check(ui._signature_preview.visible, "trainer screen shows signature visual")
    _check(ui._signature_preview.texture != null, "signature image resource imported")
    var signature: int = ui.preview_signature
    ui._next_signature()
    _check(ui.preview_signature == (signature + 1) % 3, "signature preview changes")

    ui._open_screen(0)
    _check(ui._stage.is_preview_running(), "returning to dungeon resumes scene")
    ui._toggle_compact()
    _check(not ui._stage.is_preview_running(), "compact mode pauses dungeon animation")
    _check(ui.compact, "compact activated")
    _check(ui.current_screen == 0, "screen persists in compact mode")
    _check(ui._compact_dock.visible, "compact mode displays creature dock")
    _check(ui._compact_creatures.get_child_count() == 3, "dock keeps all three creatures")
    _check(ui._compact_expand.visible, "mouse-accessible expand button exists")
    _check(not ui._content.visible, "full panels hidden in compact mode")
    ui._toggle_compact()
    _check(ui._stage.is_preview_running(), "expand resumes dungeon preview")
    ui._toggle_motion_enabled()
    _check(not ui._stage.is_preview_running(), "reducing motion pauses dungeon")
    ui._toggle_motion_enabled()
    _check(ui._stage.is_preview_running(), "motion enabled resumes dungeon")
    _check(not ui.compact, "compact restored")
    _check(not ui._compact_dock.visible, "dock hidden in expanded mode")
    _check(ui._content.visible, "full panels restored")

    print("SMOKE: reached final assertions")
    ui.queue_free()
    if _failures > 0:
        print("FAIL: %d input and idle regression assertions" % _failures)
        quit(1)
    else:
        print("PASS: input, auto dungeon, pause, speed, reset and compact")
        quit(0)


func _check(ok: bool, message: String) -> void:
    if not ok:
        _failures += 1
        push_error("FAIL: " + message)


func _fail(message: String) -> void:
    push_error("FAIL: " + message)
    quit(1)
