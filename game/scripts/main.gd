extends Control
## Vertical slice de INTERFACE: nenhuma decisão aqui calcula dano, loot ou progresso.
const Bindings = preload("res://game/scripts/input_bindings.gd")

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

var _tabs: Array[Button] = []
var _page_title: Label
var _page_body: Label
var _action_bar: HBoxContainer
var _pet_row: HBoxContainer
var _hint: Label
var _content: VBoxContainer
var _navigation: HBoxContainer


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

    _pet_row = HBoxContainer.new()
    _pet_row.add_theme_constant_override("separation", 12)
    _content.add_child(_pet_row)

    _action_bar = HBoxContainer.new()
    _action_bar.add_theme_constant_override("separation", 9)
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

    _page_title.text = SCREENS[current_screen] + "  /  DEMONSTRAÇÃO"
    match current_screen:
        0:
            _page_body.text = "Dungeon infinita — Andar %d\n\nReinício voluntário altera somente o andar nesta demonstração. Criaturas, atributos e formas não são reiniciados. Nenhum combate ou recompensa está sendo calculado." % preview_floor
            _render_pets()
            _add_action("Próximo andar (simulação)", _advance_preview)
            _add_action("Reiniciar andar (simulação)", _reset_preview)
        1:
            var pet: Dictionary = PETS[selected_creature]
            _page_body.text = "%s  •  %s\n\nForça | Velocidade | Resistência | Inteligência\n\nTrês cartas de técnicas automáticas por criatura. Valores, atributos efetivos e requisitos não estão definidos.\n\n%s" % [pet["name"], pet["id"], pet["note"]]
            _render_pets()
            _add_action("Próxima criatura (prévia)", _next_pet)
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
        var picture := TextureRect.new()
        picture.custom_minimum_size = Vector2(110, 100)
        picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
        picture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
        picture.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
        var path: String = pet["path"]
        if ResourceLoader.exists(path):
            picture.texture = load(path)
        block.add_child(picture)
        var title := Label.new()
        title.text = pet["name"]
        title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        block.add_child(title)
        _pet_row.add_child(block)


func _add_action(label: String, handler: Callable) -> void:
    var action := Button.new()
    action.text = label
    action.focus_mode = Control.FOCUS_ALL
    action.pressed.connect(handler)
    _action_bar.add_child(action)


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


func _reset_preview() -> void:
    preview_floor = 1
    _render()


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
    compact = not compact
    # Interface realmente expandida/compacta: mantém os controles para restauração.
    _navigation.visible = not compact
    _content.visible = not compact
    _hint.visible = not compact
    get_window().size = Vector2i(820, 160) if compact else Vector2i(1100, 660)
