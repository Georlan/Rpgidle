extends Control
## Vertical slice de INTERFACE: nenhuma decisão aqui calcula dano, loot ou progresso.
const Bindings = preload("res://game/scripts/input_bindings.gd")
const CreatureMotion = preload("res://game/scripts/creature_motion.gd")
const DungeonStage = preload("res://game/scripts/dungeon_stage.gd")

const SCREENS := ["Dungeon", "Criaturas", "Evoluções", "Rancho", "Sistema", "Arena"]
const PETS := [
    {
        "name": "Lunaro", "id": "CR001",
        "path": "res://assets/01_creatures/CR001_Lunaro/concept_forms/CR001_G1_concept_preview.png",
        "note": "Sprite experimental"
    },
    {
        "name": "Brumelo", "id": "CR002",
        "path": "res://assets/01_creatures/CR002_Brumelo/CR002_G1_placeholder.svg",
        "note": "Silhueta SVG"
    },
    {
        "name": "Ferru", "id": "CR003",
        "path": "res://assets/01_creatures/CR003_Ferru/CR003_G1_placeholder.svg",
        "note": "Silhueta SVG"
    }
]
const SIGNATURES := ["Proteção", "Ofensiva", "Estratégia"]
const THEMES := ["Bosque", "Crepúsculo", "Noite"]

var current_screen: int = 0
var preview_floor: int = 36
var selected_creature: int = 0
var preview_grade: int = 1
var preview_signature: int = 0
var preview_theme: int = 0
var compact: bool = false
var motion_enabled: bool = true
var auto_demo_enabled: bool = true

var _tabs: Array[Button] = []
var _page_title: Label
var _page_body: Label
var _action_bar: HFlowContainer
var _auto_demo_button: Button
var _pet_row: HBoxContainer
var _stage
var _hint: Label
var _content: VBoxContainer
var _navigation: HBoxContainer
var _compact_dock: HBoxContainer
var _compact_creatures: HBoxContainer
var _compact_status: Label
var _compact_expand: Button


func _ready() -> void:
    Bindings.install()
    get_window().title = "Rpgidle — Laboratório de Controles"
    _build_interface()
    _render()


func _unhandled_input(event: InputEvent) -> void:
    if event.is_echo() or not event.is_pressed():
        return
    if event.is_action_pressed("lab_toggle_compact"):
        _toggle_compact()
        get_viewport().set_input_as_handled()
        return
    if compact:
        if event.is_action_pressed("ui_cancel"):
            _toggle_compact()
            get_viewport().set_input_as_handled()
        return

    if event.is_action_pressed("lab_next_screen"):
        _switch_screen(1)
        get_viewport().set_input_as_handled()
    elif event.is_action_pressed("lab_previous_screen"):
        _switch_screen(-1)
        get_viewport().set_input_as_handled()
    elif current_screen == 0 and event.is_action_pressed("lab_reset_preview"):
        _reset_preview()
        get_viewport().set_input_as_handled()
    elif event is InputEventKey:
        if event.keycode >= KEY_1 and event.keycode <= KEY_6:
            _open_screen(event.keycode - KEY_1)
            get_viewport().set_input_as_handled()


func _build_interface() -> void:
    var background := ColorRect.new()
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    background.color = Color("#101920")
    background.mouse_filter = Control.MOUSE_FILTER_IGNORE
    add_child(background)

    var margin := MarginContainer.new()
    margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    margin.add_theme_constant_override("margin_left", 24)
    margin.add_theme_constant_override("margin_right", 24)
    margin.add_theme_constant_override("margin_top", 18)
    margin.add_theme_constant_override("margin_bottom", 18)
    add_child(margin)

    var layout := VBoxContainer.new()
    layout.add_theme_constant_override("separation", 14)
    margin.add_child(layout)

    var header := Label.new()
    header.text = "✦  RPG IDLE    /    LABORATÓRIO DE CONTROLES"
    header.add_theme_font_size_override("font_size", 21)
    header.add_theme_color_override("font_color", Color("#c69d66"))
    layout.add_child(header)

    _navigation = HBoxContainer.new()
    _navigation.add_theme_constant_override("separation", 6)
    layout.add_child(_navigation)
    for index in SCREENS.size():
        var tab := Button.new()
        tab.text = "%d · %s" % [index + 1, SCREENS[index]]
        tab.focus_mode = Control.FOCUS_ALL
        tab.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        tab.pressed.connect(_open_screen.bind(index))
        _navigation.add_child(tab)
        _tabs.append(tab)

    # Compact desktop view: keep the creatures visible and restore via mouse.
    _compact_dock = HBoxContainer.new()
    _compact_dock.visible = false
    _compact_dock.add_theme_constant_override("separation", 18)
    layout.add_child(_compact_dock)

    _compact_creatures = HBoxContainer.new()
    _compact_creatures.add_theme_constant_override("separation", 4)
    _compact_dock.add_child(_compact_creatures)
    for pet in PETS:
        var compact_picture := CreatureMotion.new()
        compact_picture.custom_minimum_size = Vector2(82, 68)
        compact_picture.configure(pet["id"], pet["path"], motion_enabled)
        _compact_creatures.add_child(compact_picture)

    _compact_status = Label.new()
    _compact_status.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    _compact_status.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    _compact_status.add_theme_color_override("font_color", Color("#ece3d2"))
    _compact_dock.add_child(_compact_status)

    _compact_expand = Button.new()
    _compact_expand.text = "Expandir"
    _compact_expand.focus_mode = Control.FOCUS_ALL
    _compact_expand.pressed.connect(_toggle_compact)
    _compact_dock.add_child(_compact_expand)
    _compact_dock.process_mode = Node.PROCESS_MODE_DISABLED

    var panel := PanelContainer.new()
    panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
    layout.add_child(panel)

    _content = VBoxContainer.new()
    _content.add_theme_constant_override("separation", 16)
    panel.add_child(_content)

    _page_title = Label.new()
    _page_title.add_theme_font_size_override("font_size", 28)
    _page_title.add_theme_color_override("font_color", Color("#ece3d2"))
    _content.add_child(_page_title)

    _page_body = Label.new()
    _page_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    _page_body.size_flags_vertical = Control.SIZE_EXPAND_FILL
    _page_body.add_theme_font_size_override("font_size", 17)
    _page_body.add_theme_color_override("font_color", Color("#bdd0c9"))
    _content.add_child(_page_body)

    _stage = DungeonStage.new()
    _stage.custom_minimum_size = Vector2(0, 245)
    _stage.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    _stage.size_flags_vertical = Control.SIZE_EXPAND_FILL
    _content.add_child(_stage)

    _pet_row = HBoxContainer.new()
    _pet_row.add_theme_constant_override("separation", 12)
    _content.add_child(_pet_row)

    _action_bar = HFlowContainer.new()
    _action_bar.add_theme_constant_override("h_separation", 9)
    _action_bar.add_theme_constant_override("v_separation", 7)
    _content.add_child(_action_bar)

    _hint = Label.new()
    _hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    _hint.text = "Mouse: clicar  |  Teclado: 1–6 telas, Q/E alternar, Enter confirmar, F1 compacto, R reinício (preview)  |  Controle: LB/RB telas, A confirmar, START compacto, Y reinício, B voltar"
    _hint.add_theme_font_size_override("font_size", 13)
    _hint.add_theme_color_override("font_color", Color("#6aae9f"))
    layout.add_child(_hint)


func _render() -> void:
    for child in _pet_row.get_children():
        child.queue_free()
    for child in _action_bar.get_children():
        child.queue_free()
    for i in _tabs.size():
        _tabs[i].modulate = Color("#c69d66") if i == current_screen else Color.WHITE

    _compact_status.text = "Andar %d  ·  3 criaturas\nModo compacto — apenas visual" % preview_floor
    _stage.visible = current_screen == 0
    _stage.set_floor_preview(preview_floor)
    _stage.set_playing(current_screen == 0 and not compact and motion_enabled)
    _page_body.size_flags_vertical = Control.SIZE_SHRINK_BEGIN if current_screen == 0 else Control.SIZE_EXPAND_FILL
    _page_title.text = SCREENS[current_screen] + "  /  DEMONSTRAÇÃO"
    match current_screen:
        0:
            _page_body.text = "Dungeon infinita — Andar %d\n\nReinício voluntário altera somente o andar nesta demonstração. Criaturas, atributos e formas não são reiniciados. Nenhum combate ou recompensa está sendo calculado." % preview_floor
            _add_action("Próximo andar (simulação)", _advance_preview)
            _add_action("Reiniciar andar (simulação)", _reset_preview)
        1:
            var pet: Dictionary = PETS[selected_creature]
            _page_body.text = "%s  •  %s\n\nForça | Velocidade | Resistência | Inteligência\n\nTrês cartas de técnicas automáticas por criatura. Valores, atributos efetivos e requisitos não estão definidos.\n\n%s" % [pet["name"], pet["id"], pet["note"]]
            _render_pets()
            _add_action("Próxima criatura (prévia)", _next_pet)
            if selected_creature == 0:
                _add_action("Idle", _show_motion_state.bind("idle"))
                _add_action("Caminhar", _show_motion_state.bind("walk"))
                _add_action("Atacar", _show_motion_state.bind("attack"))
                _add_action("Dano", _show_motion_state.bind("hurt"))
                _add_action("Habilidade", _show_motion_state.bind("skill"))
                _auto_demo_button = _add_action("Auto: ligado" if auto_demo_enabled else "Auto: parado", _toggle_auto_demo)
                _add_action("Pausar/retomar movimento", _toggle_motion_enabled)
        2:
            _page_body.text = "CR001 — Grau %d / 4\n\nFormas intercambiáveis são liberadas individualmente pela criatura. O registro do rancho conta formas distintas. Ainda não há requisitos matemáticos aprovados." % preview_grade
            _render_pets()
            _add_action("Ver próximo grau", _next_grade)
        3:
            _page_body.text = "Rancho — tema visual: %s\n\nTrês criaturas ativas, demais registradas no rancho. Cosméticos futuros não terão vantagem competitiva." % THEMES[preview_theme]
            _render_pets()
            _add_action("Trocar tema cosmético (prévia)", _next_theme)
        4:
            _page_body.text = "Potencial: exclusivo do treinador\n\nCarta de Assinatura: %s\n\nRompimento → Refinamento → Maestria. A assinatura representa decisões relevantes da dungeon e afeta a equipe inteira. Só uma ativa por vez." % SIGNATURES[preview_signature]
            _render_pets()
            _add_action("Inspecionar assinatura (não desbloqueia)", _next_signature)
        5:
            _page_body.text = "Arena 3 × 3\n\nEquipes e cartas serão normalizadas com limites competitivos. Matchmaking, servidor, cartas, dano e replay não estão implementados."
            _render_pets()
    _hint.visible = not compact


func _render_pets() -> void:
    for pet in PETS:
        var block := VBoxContainer.new()
        block.custom_minimum_size = Vector2(130, 136)
        var picture := CreatureMotion.new()
        picture.custom_minimum_size = Vector2(110, 100)
        picture.configure(pet["id"], pet["path"], motion_enabled)
        block.add_child(picture)
        var title := Label.new()
        title.text = pet["name"]
        title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        block.add_child(title)
        _pet_row.add_child(block)
        if pet["id"] == "CR001" and current_screen == 1 and selected_creature == 0 and auto_demo_enabled and motion_enabled and not compact:
            picture.start_demo()


func _add_action(label: String, handler: Callable) -> Button:
    var action := Button.new()
    action.text = label
    action.focus_mode = Control.FOCUS_ALL
    action.pressed.connect(handler)
    _action_bar.add_child(action)
    return action


func _open_screen(index: int) -> void:
    current_screen = wrapi(index, 0, SCREENS.size())
    _render()
    if not compact:
        _tabs[current_screen].grab_focus()


func _switch_screen(delta: int) -> void:
    _open_screen(current_screen + delta)


func _advance_preview() -> void:
    preview_floor += 1
    _render()
    _stage.trigger_preview_action()


func _reset_preview() -> void:
    preview_floor = 1
    _render()


func _show_motion_state(state: String, manual: bool = true) -> void:
    # A motion preview, not combat. Manual selection overrides the autoplay schedule.
    if manual:
        auto_demo_enabled = false
    for block in _pet_row.get_children():
        if block.get_child_count() > 0:
            var picture := block.get_child(0)
            if picture is CreatureMotion and picture.creature_id == "CR001":
                if manual:
                    picture.stop_demo()
                picture.play_state(state)
    _update_auto_demo_button()


func _update_auto_demo_button() -> void:
    if is_instance_valid(_auto_demo_button):
        _auto_demo_button.text = "Auto: ligado" if auto_demo_enabled else "Auto: parado"


func _toggle_auto_demo() -> void:
    auto_demo_enabled = not auto_demo_enabled
    for block in _pet_row.get_children():
        if block.get_child_count() == 0:
            continue
        var picture := block.get_child(0)
        if picture is CreatureMotion and picture.creature_id == "CR001":
            if auto_demo_enabled and motion_enabled and not compact:
                picture.start_demo()
            else:
                picture.stop_demo()
                picture.play_state("idle")
    _update_auto_demo_button()


func _toggle_motion_enabled() -> void:
    motion_enabled = not motion_enabled
    for block in _pet_row.get_children():
        if block.get_child_count() > 0:
            var picture := block.get_child(0)
            if picture is CreatureMotion:
                picture.set_motion_enabled(motion_enabled)
    for picture in _compact_creatures.get_children():
        if picture is CreatureMotion:
            picture.set_motion_enabled(motion_enabled)
    _stage.set_playing(current_screen == 0 and not compact and motion_enabled)
    if motion_enabled and auto_demo_enabled and not compact:
        _resume_preview_demo()


func _resume_preview_demo() -> void:
    if current_screen != 1 or selected_creature != 0 or not motion_enabled or not auto_demo_enabled or compact:
        return
    for block in _pet_row.get_children():
        if block.get_child_count() == 0:
            continue
        var picture := block.get_child(0)
        if picture is CreatureMotion and picture.creature_id == "CR001":
            picture.start_demo()


func _next_pet() -> void:
    selected_creature = wrapi(selected_creature + 1, 0, PETS.size())
    _render()


func _next_grade() -> void:
    preview_grade = wrapi(preview_grade, 1, 5)
    _render()


func _next_theme() -> void:
    preview_theme = wrapi(preview_theme + 1, 0, THEMES.size())
    _render()


func _next_signature() -> void:
    preview_signature = wrapi(preview_signature + 1, 0, SIGNATURES.size())
    _render()


func _toggle_compact() -> void:
    if not compact:
        for block in _pet_row.get_children():
            if block.get_child_count() > 0:
                var picture := block.get_child(0)
                if picture is CreatureMotion:
                    picture.stop_demo()
    compact = not compact
    _stage.set_playing(current_screen == 0 and not compact and motion_enabled)
    # Interface realmente expandida/compacta: mantém os controles para restauração.
    _navigation.visible = not compact
    _content.visible = not compact
    _hint.visible = not compact
    _compact_dock.visible = compact
    _compact_dock.process_mode = Node.PROCESS_MODE_INHERIT if compact else Node.PROCESS_MODE_DISABLED
    get_window().size = Vector2i(820, 160) if compact else Vector2i(1100, 660)
    if compact:
        _compact_expand.grab_focus()
    else:
        _tabs[current_screen].grab_focus()
        _resume_preview_demo()
