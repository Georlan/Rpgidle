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

    ui._open_screen(4)
    var signature: int = ui.preview_signature
    ui._next_signature()
    _check(ui.preview_signature == (signature + 1) % 3, "signature preview changes")

    ui._toggle_compact()
    _check(ui.compact, "compact activated")
    _check(ui.current_screen == 4, "screen persists in compact mode")
    ui._toggle_compact()
    _check(not ui.compact, "compact restored")

    ui.queue_free()
    print("PASS: navigation, controller mapping, dungeon preview, signature and compact mode")
    quit(0)


func _check(ok: bool, message: String) -> void:
    if not ok:
        _fail(message)


func _fail(message: String) -> void:
    push_error("FAIL: " + message)
    quit(1)
