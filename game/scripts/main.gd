extends Control
## Interface de prévia com teste de combate isolado e parâmetros provisórios.
const DungeonTrial = preload("res://game/scripts/dungeon_trial.gd")
const Bindings = preload("res://game/scripts/input_bindings.gd")
const CreatureMotion = preload("res://game/scripts/creature_motion.gd")
const DungeonStage = preload("res://game/scripts/dungeon_stage.gd")
const VisualTheme = preload("res://game/scripts/visual_theme.gd")
const BestiaryCatalog = preload("res://game/scripts/bestiary_catalog.gd")
const EvolutionPreviewData = preload("res://game/scripts/evolution_preview_data.gd")
const EvolutionGraph = preload("res://game/scripts/evolution_graph.gd")

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
        "note": "Arte G1 em revisão"
    },
    {
        "name": "Ferru", "id": "CR003",
        "path": "res://assets/01_creatures/CR003_Ferru/CR003_G1_placeholder.svg",
        "note": "Arte G1 em revisão"
    }
]
const SIGNATURES := ["Proteção", "Ofensiva", "Estratégia"]
const THEMES := ["Bosque", "Crepúsculo", "Noite"]

var trial = null
var current_screen: int = 0
var preview_floor: int = 36
var selected_creature: int = 0
var preview_grade: int = 1
var preview_evolution_species: int = 1
var preview_registry_species: int = 0
var selected_preview_form_id: String = ""
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
var _detail_cards: VBoxContainer
var _evolution_graph: Control
var _stage
var _signature_preview: TextureRect
var _hint: Label
var _content: VBoxContainer
var _navigation: HBoxContainer
var _compact_dock: HBoxContainer
var _compact_creatures: HBoxContainer
var _compact_status: Label
var _compact_expand: Button


func _ready() -> void:
    Bindings.install()
    theme = VisualTheme.make_theme()
    get_window().title = "Rpgidle — Prévia Visual"
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
    elif current_screen == 0 and event is InputEventKey and event.keycode == KEY_P:
        _toggle_dungeon_pause()
        get_viewport().set_input_as_handled()
    elif current_screen == 0 and event is InputEventKey and event.keycode == KEY_V:
        _toggle_dungeon_speed()
        get_viewport().set_input_as_handled()
    elif event is InputEventKey:
        if event.keycode >= KEY_1 and event.keycode <= KEY_6:
            _open_screen(event.keycode - KEY_1)
            get_viewport().set_input_as_handled()


func _build_interface() -> void:
    var background := ColorRect.new()
    background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    background.color = VisualTheme.INK
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
    header.text = "✦   RPG IDLE       /       CÓDICE"
    header.add_theme_font_size_override("font_size", 22)
    header.add_theme_color_override("font_color", VisualTheme.GOLD)
    layout.add_child(header)

    _navigation = HBoxContainer.new()
    _navigation.add_theme_constant_override("separation", 6)
    layout.add_child(_navigation)
    for index in SCREENS.size():
        var tab := Button.new()
        tab.text = "%d   %s" % [index + 1, SCREENS[index]]
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
    _content.add_theme_constant_override("separation", 12)
    panel.add_child(_content)

    _page_title = Label.new()
    _page_title.add_theme_font_size_override("font_size", 25)
    _page_title.add_theme_color_override("font_color", Color("#ece3d2"))
    _content.add_child(_page_title)

    _page_body = Label.new()
    _page_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    _page_body.size_flags_vertical = Control.SIZE_EXPAND_FILL
    _page_body.add_theme_font_size_override("font_size", 14)
    _page_body.add_theme_color_override("font_color", VisualTheme.MUTED)
    _content.add_child(_page_body)

    _signature_preview = TextureRect.new()
    _signature_preview.custom_minimum_size = Vector2(110, 150)
    _signature_preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    _signature_preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    _signature_preview.texture = load("res://assets/02_cards/signature/signature_frame_concept.svg")
    _signature_preview.visible = false
    _content.add_child(_signature_preview)

    _stage = DungeonStage.new()
    _stage.visual_cycle_completed.connect(_on_stage_cycle_completed)
    _stage.visual_phase_changed.connect(_on_stage_phase_changed)
    _stage.custom_minimum_size = Vector2(0, 270)
    _stage.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    _stage.size_flags_vertical = Control.SIZE_EXPAND_FILL
    _content.add_child(_stage)

    _evolution_graph = EvolutionGraph.new()
    _evolution_graph.custom_minimum_size = Vector2(0, 210)
    _evolution_graph.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    _evolution_graph.candidate_selected.connect(_on_preview_form_selected)
    _evolution_graph.visible = false
    _content.add_child(_evolution_graph)

    _pet_row = HBoxContainer.new()
    _pet_row.add_theme_constant_override("separation", 12)
    _content.add_child(_pet_row)

    _detail_cards = VBoxContainer.new()
    _detail_cards.add_theme_constant_override("separation", 8)
    _content.add_child(_detail_cards)

    _action_bar = HFlowContainer.new()
    _action_bar.add_theme_constant_override("h_separation", 9)
    _action_bar.add_theme_constant_override("v_separation", 7)
    _content.add_child(_action_bar)

    _hint = Label.new()
    _hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    _hint.text = "1–6 telas    ·    Q/E navegar    ·    P pausa    ·    V velocidade    ·    R reiniciar    ·    F1 desktop    /    Controle: LB/RB, A, B, Start"
    _hint.add_theme_font_size_override("font_size", 11)
    _hint.add_theme_color_override("font_color", Color("#6aae9f"))
    layout.add_child(_hint)


func _render() -> void:
    # Detach immediately; queue_free alone leaves stale UI nodes until next frame.
    for child in _pet_row.get_children():
        _pet_row.remove_child(child)
        child.queue_free()
    for child in _action_bar.get_children():
        _action_bar.remove_child(child)
        child.queue_free()
    for child in _detail_cards.get_children():
        _detail_cards.remove_child(child)
        child.queue_free()
    _detail_cards.visible = current_screen == 1 or current_screen == 2 or current_screen == 3
    _evolution_graph.visible = current_screen == 2
    for i in _tabs.size():
        VisualTheme.navigation(_tabs[i], i == current_screen)

    _compact_status.text = "Andar %d  ·  3 criaturas\nModo compacto — apenas visual" % preview_floor
    _stage.visible = current_screen == 0
    _signature_preview.visible = current_screen == 4
    _stage.set_floor_preview(preview_floor)
    _stage.set_playing(current_screen == 0 and not compact and motion_enabled)
    _page_body.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
    _page_title.text = SCREENS[current_screen]
    match current_screen:
        0:
            _add_action("Retomar auto" if _stage.is_paused() else "Pausar auto", _toggle_dungeon_pause)
            _add_action("Velocidade: %dx" % int(_stage.preview_speed()), _toggle_dungeon_speed)
            _add_action("Reiniciar teste" if trial != null else "Reiniciar prévia", _reset_preview)
            if trial == null:
                _add_action("Iniciar teste jogável", _start_trial)
            else:
                _add_action("Postura: %s" % ("Pressão" if trial.stance == "pressao" else "Proteção"), _toggle_trial_stance)
                _add_action("Sair do teste", _exit_trial)
        1:
            var pet: Dictionary = PETS[selected_creature]
            _page_body.text = "%s   •   %s        /        Força · Velocidade · Resistência · Inteligência\nTrês técnicas automáticas por criatura. Visual experimental, sem atributos calculados." % [pet["name"], pet["id"]]
            _render_pets()
            _render_creature_details()
            _add_action("Próxima criatura (prévia)", _next_pet)
            _add_action("Idle", _show_motion_state.bind("idle"))
            _add_action("Caminhar", _show_motion_state.bind("walk"))
            _add_action("Atacar", _show_motion_state.bind("attack"))
            _add_action("Dano", _show_motion_state.bind("hurt"))
            _add_action("Habilidade", _show_motion_state.bind("skill"))
            if selected_creature == 0:
                _auto_demo_button = _add_action("Auto: ligado" if auto_demo_enabled else "Auto: parado", _toggle_auto_demo)
            _add_action("Pausar/retomar movimento", _toggle_motion_enabled)
        2:
            var species_id: String = String(PETS[preview_evolution_species]["id"])
            var graph_info: Dictionary = EvolutionPreviewData.species_graph(species_id)
            _evolution_graph.configure(graph_info)
            var nodes: Array = graph_info.get("nodes", [])
            if selected_preview_form_id.is_empty() or EvolutionPreviewData.node_by_id(species_id, selected_preview_form_id).is_empty():
                selected_preview_form_id = String(nodes[0]["form_id"]) if not nodes.is_empty() else ""
            _evolution_graph.select_form(selected_preview_form_id)
            _page_body.text = "%s   /   ÁRVORE RAMIFICADA • 4 GRAUS • CONCEITOS" % PETS[preview_evolution_species]["name"]
            _render_evolution_details()
            _add_action("Próxima espécie", _next_evolution_species)
            _add_action("Espécie anterior", _previous_evolution_species)
        3:
            _page_body.text = "BESTIÁRIO DO SISTEMA   /   %d ESPÉCIES NO CATÁLOGO • NÃO É O REGISTRO DO JOGADOR" % BestiaryCatalog.known_species_count()
            _render_pets()
            _render_bestiary_details()
            _add_action("Consultar próxima espécie", _next_registry_species)
            _add_action("Habitat: %s (cosmético)" % THEMES[preview_theme], _next_theme)
        4:
            _page_body.text = "CARTA DE ASSINATURA   /   %s\nPotencial exclusivo do treinador. Uma carta ativa para a equipe inteira." % SIGNATURES[preview_signature]
            _render_pets()
            _add_action("Inspecionar assinatura (não desbloqueia)", _next_signature)
        5:
            _page_body.text = "ARENA 3 × 3   /   Em desenvolvimento\nComposições e cartas terão limites competitivos. Sem partidas conectadas nesta versão."
            _render_pets()
    if current_screen == 0:
        _update_dungeon_hud()
    _hint.visible = not compact


func _render_pets() -> void:
    for pet in PETS:
        var block := VBoxContainer.new()
        block.custom_minimum_size = Vector2(125, 116)
        var picture := CreatureMotion.new()
        picture.custom_minimum_size = Vector2(110, 100)
        picture.configure(pet["id"], pet["path"], motion_enabled)
        block.add_child(picture)
        var title := Label.new()
        title.text = pet["name"]
        title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        var is_selected: bool = current_screen == 1 and pet["id"] == PETS[selected_creature]["id"]
        title.add_theme_color_override("font_color", VisualTheme.GOLD if is_selected else VisualTheme.IVORY)
        block.add_child(title)
        _pet_row.add_child(block)
        if pet["id"] == "CR001" and current_screen == 1 and selected_creature == 0 and auto_demo_enabled and motion_enabled and not compact:
            picture.start_demo()


func _make_info_card(title_text: String, detail_text: String, selected: bool = false) -> PanelContainer:
    var panel := PanelContainer.new()
    panel.custom_minimum_size = Vector2(158, 60)
    var content := VBoxContainer.new()
    content.add_theme_constant_override("separation", 3)
    panel.add_child(content)
    var heading := Label.new()
    heading.text = title_text
    heading.add_theme_font_size_override("font_size", 12)
    heading.add_theme_color_override("font_color", VisualTheme.GOLD if selected else VisualTheme.MUTED)
    content.add_child(heading)
    var detail := Label.new()
    detail.text = detail_text
    detail.add_theme_font_size_override("font_size", 13)
    detail.add_theme_color_override("font_color", VisualTheme.IVORY)
    content.add_child(detail)
    return panel


func _render_creature_details() -> void:
    var stats := HFlowContainer.new()
    stats.add_theme_constant_override("h_separation", 7)
    stats.add_theme_constant_override("v_separation", 7)
    for name in ["Força", "Velocidade", "Resistência", "Inteligência"]:
        stats.add_child(_make_info_card(name, "A definir"))
    _detail_cards.add_child(stats)
    var title := Label.new()
    title.text = "TÉCNICAS AUTOMÁTICAS   /   3 ESPAÇOS"
    title.add_theme_font_size_override("font_size", 11)
    title.add_theme_color_override("font_color", VisualTheme.JADE)
    _detail_cards.add_child(title)
    var cards := HFlowContainer.new()
    cards.add_theme_constant_override("h_separation", 7)
    for index in range(3):
        cards.add_child(_make_info_card("CARTA %02d" % (index + 1), "Sem técnica"))
    _detail_cards.add_child(cards)


func _render_evolution_details() -> void:
    for child in _detail_cards.get_children():
        _detail_cards.remove_child(child)
        child.queue_free()
    var species_id: String = String(PETS[preview_evolution_species]["id"])
    var info: Dictionary = EvolutionPreviewData.node_by_id(species_id, selected_preview_form_id)
    if info.is_empty():
        return
    var row := HBoxContainer.new()
    row.add_theme_constant_override("separation", 12)
    _detail_cards.add_child(row)
    var picture := TextureRect.new()
    picture.custom_minimum_size = Vector2(114, 88)
    picture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    picture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    picture.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
    var slot: int = int(info.get("art_slot", -1))
    var atlas_path := "res://assets/01_creatures/evolution_concepts_preview.png"
    if slot >= 0 and ResourceLoader.exists(atlas_path):
        var atlas_texture: Texture2D = load(atlas_path)
        var portrait := AtlasTexture.new()
        portrait.atlas = atlas_texture
        portrait.region = Rect2(slot * 48, 0, 48, 40)
        picture.texture = portrait
    row.add_child(picture)
    var copy := VBoxContainer.new()
    copy.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    row.add_child(copy)
    var heading := Label.new()
    heading.text = "G%d   %s" % [int(info.get("grade", 1)), String(info.get("label", ""))]
    heading.add_theme_color_override("font_color", VisualTheme.GOLD)
    copy.add_child(heading)
    var details := Label.new()
    details.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    var artwork: String = String(info.get("art_status", "undrawn"))
    details.text = "Arte: %s. Caminhos candidatos; condições ainda não definidas. Nenhuma forma foi desbloqueada." % (
        "recorte conceitual, sem animação" if artwork == "concept_crop" else "G1 existente" if artwork == "existing_g1" else "não produzida"
    )
    details.add_theme_color_override("font_color", VisualTheme.MUTED)
    copy.add_child(details)


func _on_preview_form_selected(info: Dictionary) -> void:
    selected_preview_form_id = String(info.get("form_id", ""))
    if current_screen == 2 and _detail_cards != null:
        _render_evolution_details()


func _render_bestiary_details() -> void:
    var selected: Dictionary = PETS[preview_registry_species]
    var species_id: String = String(selected["id"])
    var entry: Dictionary = BestiaryCatalog.species_by_id(species_id)
    var graph_info: Dictionary = EvolutionPreviewData.species_graph(species_id)
    var node_count: int = graph_info.get("nodes", []).size()
    _detail_cards.add_child(_make_info_card(
        "%s   /   %s" % [species_id, String(entry.get("display_name", ""))],
        "%d formas/caminhos em prévia visual; o jogo ainda não registra descobertas." % node_count, true
    ))
    var hint := Label.new()
    hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    hint.text = "Catálogo ≠ formas disponíveis. O desbloqueio será por indivíduo; o rancho registrará formas distintas permanentemente."
    hint.add_theme_color_override("font_color", VisualTheme.MUTED)
    _detail_cards.add_child(hint)


func _next_evolution_species() -> void:
    preview_evolution_species = wrapi(preview_evolution_species + 1, 0, PETS.size())
    selected_preview_form_id = ""
    _render()


func _previous_evolution_species() -> void:
    preview_evolution_species = wrapi(preview_evolution_species - 1, 0, PETS.size())
    selected_preview_form_id = ""
    _render()


func _next_registry_species() -> void:
    preview_registry_species = wrapi(preview_registry_species + 1, 0, PETS.size())
    _render()


func _add_action(label: String, handler: Callable) -> Button:
    var action := Button.new()
    action.text = label
    if _action_bar.get_child_count() == 0:
        VisualTheme.primary(action)
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


func _update_dungeon_hud() -> void:
    var phase_label: String = _stage.preview_phase_label()
    if not motion_enabled:
        phase_label = "Movimento reduzido"
    _compact_status.text = "Andar %d   ·   %s\n%s" % [preview_floor, phase_label, "Teste pausado no compacto" if trial != null else "Prévia automática"]
    if current_screen == 0 and trial != null:
        _page_body.text = "TESTE EXPERIMENTAL · ANDAR %d · EQUIPE %d/%d · ALVO %d/%d · %s\n%s" % [trial.floor_number, trial.team_hp, trial.MAX_TEAM_HP, trial.enemy_hp, trial.MAX_ENEMY_HP, "ENCERRADO" if trial.finished else phase_label, trial.last_event]
    elif current_screen == 0:
        _page_body.text = "RUÍNAS DO PRIMEIRO ECO  ·  ANDAR %d  ·  %s  ·  %dx  /  SIMULAÇÃO VISUAL" % [
            preview_floor, phase_label, int(_stage.preview_speed())
        ]


func _on_stage_phase_changed(_phase: String) -> void:
    if _page_body != null and _compact_status != null:
        _update_dungeon_hud()


func _on_stage_cycle_completed() -> void:
    if trial != null:
        trial.resolve_round()
        preview_floor = trial.floor_number
        _stage.set_floor_preview(preview_floor)
        if trial.finished:
            _stage.set_paused(true)
            _render()
        else:
            _update_dungeon_hud()
        return
    # Preview-only floor: the creature roster and forms remain untouched.
    preview_floor += 1
    _stage.set_floor_preview(preview_floor)
    _update_dungeon_hud()


func _toggle_dungeon_pause() -> void:
    if trial != null and trial.finished:
        return
    _stage.set_paused(not _stage.is_paused())
    _render()


func _toggle_dungeon_speed() -> void:
    var value: float = 2.0 if _stage.preview_speed() == 1.0 else 1.0
    _stage.set_preview_speed(value)
    _render()


func _start_trial() -> void:
    trial = DungeonTrial.new()
    preview_floor = trial.floor_number
    _stage.set_trial_visible(true)
    _stage.set_paused(false)
    _stage.reset_preview_cycle()
    _render()


func _exit_trial() -> void:
    trial = null
    _stage.set_trial_visible(false)
    _stage.set_paused(false)
    _reset_preview()


func _toggle_trial_stance() -> void:
    if trial == null or trial.finished:
        return
    trial.set_stance("protecao" if trial.stance == "pressao" else "pressao")
    _render()


func _reset_preview() -> void:
    if trial != null:
        _start_trial()
        return
    preview_floor = 1
    _stage.set_floor_preview(1)
    _stage.reset_preview_cycle()
    _render()


func _show_motion_state(state: String, manual: bool = true) -> void:
    # A motion preview, not combat. Manual selection overrides the autoplay schedule.
    if manual:
        auto_demo_enabled = false
    for block in _pet_row.get_children():
        if block.get_child_count() > 0:
            var picture := block.get_child(0)
            if picture is CreatureMotion and picture.creature_id == PETS[selected_creature]["id"]:
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
    _update_dungeon_hud()
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
    _update_dungeon_hud()
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
