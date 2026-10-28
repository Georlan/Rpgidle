extends RefCounted
## Ações sem gameplay: testar navegação de teclado e gamepad na janela ativa.
## Godot InputMap é o contrato: não identificar teclas no restante da UI.
static var _installed: bool = false

static func install() -> void:
    if _installed:
        return
    _installed = true

    # Um gamepad não deve disparar comandos em um idle desktop sem foco.
    Input.ignore_joypad_on_unfocused_application = true

    _add_action("lab_next_screen", [KEY_E], [JOY_BUTTON_RIGHT_SHOULDER])
    _add_action("lab_previous_screen", [KEY_Q], [JOY_BUTTON_LEFT_SHOULDER])
    _add_action("lab_toggle_compact", [KEY_F1], [JOY_BUTTON_START])
    _add_action("lab_reset_preview", [KEY_R], [JOY_BUTTON_Y])

    # Controles nativos da UI; não criar um segundo sistema de foco.
    _add_keys_to_existing("ui_accept", [KEY_ENTER, KEY_SPACE], [JOY_BUTTON_A])
    _add_keys_to_existing("ui_cancel", [KEY_ESCAPE], [JOY_BUTTON_B])


static func _add_action(action_name: StringName, keys: Array, pads: Array) -> void:
    if not InputMap.has_action(action_name):
        InputMap.add_action(action_name)
    _add_keys_to_existing(action_name, keys, pads)


static func _add_keys_to_existing(action_name: StringName, keys: Array, pads: Array) -> void:
    if not InputMap.has_action(action_name):
        InputMap.add_action(action_name)
    for keycode in keys:
        var key_event := InputEventKey.new()
        key_event.physical_keycode = keycode
        if not InputMap.action_has_event(action_name, key_event):
            InputMap.action_add_event(action_name, key_event)
    for pad_button in pads:
        var pad_event := InputEventJoypadButton.new()
        pad_event.button_index = pad_button
        if not InputMap.action_has_event(action_name, pad_event):
            InputMap.action_add_event(action_name, pad_event)
