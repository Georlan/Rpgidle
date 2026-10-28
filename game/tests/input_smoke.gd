extends SceneTree
## Smoke test in Godot's own runtime. No graphics, controller hardware or Steam needed.

func _initialize() -> void:
    call_deferred("_run")


func _run() -> void:
    var scene: PackedScene = load("res://game/scenes/main.tscn")
    if scene == null:
        _fail("Main scene did not load")
        return

    var ui := scene.instantiate()
    root.add_child(ui)
    await process_frame

    _check(ui.current_screen == 0, "starts in dungeon")
    _check(ui.preview_floor == 36, "starts at demonstration floor 36")

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

    ui._advance_preview()
    _check(ui.preview_floor == 37, "preview floor increments")
    ui._reset_preview()
    _check(ui.preview_floor == 1, "reset affects only the preview floor")
    _check(ui.selected_creature == 0, "reset preserves creature")
    _check(ui.preview_grade == 1, "reset preserves creature grade preview")

    ui._open_screen(1)
    await process_frame
    _check(ui._pet_row.get_child_count() >= 3, "three visual creature slots")
    var first_block: VBoxContainer = ui._pet_row.get_child(ui._pet_row.get_child_count() - 3) as VBoxContainer
    var first_picture: TextureRect = first_block.get_child(0) as TextureRect
    _check(first_picture.get("creature_id") == "CR001", "first sprite is CR001")
    _check(first_picture.get("has_pose_atlas") == true, "atlas loaded from PNG")
    for name in ["idle", "walk", "attack", "hurt", "skill"]:
        _check(first_picture.sprite_frame_count(name) >= 3, "sprite state has real frames: " + name)
    _check(first_picture.sprite_animation_name() == "idle", "initial idle sprite animation")
    _check(ui.auto_demo_enabled, "autoplay enabled by default in CR001 preview")
    _check(first_picture.demo_is_running(), "CR001 autoplay running on creature screen")
    _check(first_picture.demo_current_step() == 0, "demo starts in idle state")
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
    var signature: int = ui.preview_signature
    ui._next_signature()
    _check(ui.preview_signature == (signature + 1) % 3, "signature preview changes")

    ui._toggle_compact()
    _check(ui.compact, "compact activated")
    _check(ui.current_screen == 4, "screen persists in compact mode")
    _check(ui._compact_dock.visible, "compact mode displays creature dock")
    _check(ui._compact_creatures.get_child_count() == 3, "dock keeps all three creatures")
    _check(ui._compact_expand.visible, "mouse-accessible expand button exists")
    _check(not ui._content.visible, "full panels hidden in compact mode")
    ui._toggle_compact()
    _check(not ui.compact, "compact restored")
    _check(not ui._compact_dock.visible, "dock hidden in expanded mode")
    _check(ui._content.visible, "full panels restored")

    ui.queue_free()
    print("PASS: navigation, controller mapping, dungeon preview, signature and compact mode")
    quit(0)


func _check(ok: bool, message: String) -> void:
    if not ok:
        _fail(message)


func _fail(message: String) -> void:
    push_error("FAIL: " + message)
    quit(1)
