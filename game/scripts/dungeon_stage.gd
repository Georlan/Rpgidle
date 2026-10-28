extends Control
## Dungeon stage v0.6 — visual-only loop. No enemies, health, damage or rewards.
## Uses existing CreatureMotion previews; Godot 4.6.1 CanvasItem drawing.
const CreatureMotion = preload("res://game/scripts/creature_motion.gd")
const CREATURES = [
    {"id":"CR001","path":"res://assets/01_creatures/CR001_Lunaro/concept_forms/CR001_G1_concept_preview.png"},
    {"id":"CR002","path":"res://assets/01_creatures/CR002_Brumelo/CR002_G1_placeholder.svg"},
    {"id":"CR003","path":"res://assets/01_creatures/CR003_Ferru/CR003_G1_placeholder.svg"}
]
const CYCLE_SECONDS := 6.0

var _actors: Array[TextureRect] = []
var _playing: bool = false
var _elapsed: float = 0.0
var _phase: String = "idle"
var _floor_preview: int = 36
var _caption: Label


func _ready() -> void:
    clip_contents = true
    mouse_filter = Control.MOUSE_FILTER_IGNORE
    _caption = Label.new()
    _caption.text = "RUÍNAS DO PRIMEIRO ECO  ·  PRÉVIA VISUAL"
    _caption.position = Vector2(16, 11)
    _caption.add_theme_font_size_override("font_size", 13)
    _caption.add_theme_color_override("font_color", Color("#c8d7cd"))
    _caption.mouse_filter = Control.MOUSE_FILTER_IGNORE
    add_child(_caption)
    for info in CREATURES:
        var actor := CreatureMotion.new()
        actor.custom_minimum_size = Vector2(92, 96)
        actor.size = Vector2(92, 96)
        actor.mouse_filter = Control.MOUSE_FILTER_IGNORE
        actor.configure(info["id"], info["path"], true)
        add_child(actor)
        _actors.append(actor)
    resized.connect(_position_actors)
    set_process(false)
    _position_actors()
    queue_redraw()


func set_floor_preview(value: int) -> void:
    _floor_preview = maxi(value, 1)
    queue_redraw()


func floor_preview() -> int:
    return _floor_preview


func set_playing(enabled: bool) -> void:
    if _playing == enabled:
        return
    _playing = enabled
    set_process(enabled)
    _elapsed = 0.0
    _set_phase("walk" if enabled else "idle")
    _position_actors()
    queue_redraw()


func is_preview_running() -> bool:
    return _playing


func preview_phase() -> String:
    return _phase


func preview_fx_visible() -> bool:
    return _playing and _elapsed >= 2.45 and _elapsed < 2.95


func creature_count() -> int:
    return _actors.size()


func phase_for_time(seconds: float) -> String:
    # Pure timeline function makes the animation phases testable without a timer.
    var t: float = fposmod(seconds, CYCLE_SECONDS)
    if t < 1.8:
        return "walk"
    if t < 2.45:
        return "idle"
    if t < 2.95:
        return "attack"
    if t < 4.45:
        return "walk"
    return "idle"


func trigger_preview_action() -> void:
    if not _playing:
        return
    _elapsed = 2.47
    _set_phase("attack")
    queue_redraw()


func _process(delta: float) -> void:
    if not _playing:
        return
    _elapsed = fposmod(_elapsed + delta, CYCLE_SECONDS)
    _set_phase(phase_for_time(_elapsed))
    _position_actors()
    # Most of the scenery is static; redraw frequently only during the brief FX.
    if preview_fx_visible() or (_elapsed >= 2.95 and _elapsed < 3.05):
        queue_redraw()


func _set_phase(next_phase: String) -> void:
    if _phase == next_phase:
        return
    _phase = next_phase
    for actor in _actors:
        if actor.creature_id == "CR001":
            actor.play_state("attack" if next_phase == "attack" else next_phase)
        else:
            actor.play_state("idle")
    queue_redraw()


func _position_actors() -> void:
    if _actors.is_empty() or size.x <= 0.0 or size.y <= 0.0:
        return
    var width: float = size.x
    var baseline: float = size.y * 0.89
    var travel: float = 0.0
    if _playing:
        if _elapsed < 1.8:
            travel = _elapsed / 1.8 * 34.0
        elif _elapsed < 2.95:
            travel = 34.0
        elif _elapsed < 4.45:
            travel = 34.0 * (1.0 - (_elapsed - 2.95) / 1.5)
    for i in _actors.size():
        var actor := _actors[i]
        var x: float = width * 0.09 + float(i) * minf(width * 0.165, 118.0) + travel
        actor.position = Vector2(roundf(x), roundf(baseline - actor.size.y))


func _draw() -> void:
    var w: float = size.x
    var h: float = size.y
    if w <= 0.0 or h <= 0.0:
        return
    # Painterly pixel-styled architecture built from reusable rectangles and lines.
    draw_rect(Rect2(0, 0, w, h), Color("#172a34"))
    draw_rect(Rect2(0, h * 0.19, w, h * 0.29), Color("#213744"))
    draw_rect(Rect2(0, h * 0.48, w, h * 0.23), Color("#263a42"))
    draw_circle(Vector2(w * 0.78, h * 0.40), h * 0.23, Color("#416b72", 0.20))
    # Distance pillars and worn masonry.
    for i in range(7):
        var x: float = 34.0 + float(i) * w / 6.0
        draw_rect(Rect2(x, h * 0.18, 24, h * 0.47), Color("#374b50", 0.62))
        draw_rect(Rect2(x - 7, h * 0.20, 38, 9), Color("#50646a", 0.65))
    # Gate: the focus of the exploration, not a real target or enemy.
    var gate_x: float = w * 0.81
    var gate_y: float = h * 0.49
    draw_rect(Rect2(gate_x - 45, gate_y - 8, 90, h * 0.27), Color("#65746d"))
    draw_rect(Rect2(gate_x - 35, gate_y, 70, h * 0.28), Color("#132731"))
    draw_arc(Vector2(gate_x, gate_y), 37.0, PI, TAU, 25, Color("#83918a"), 8.0)
    draw_circle(Vector2(gate_x, gate_y + h * 0.11), 24.0, Color("#6aae9f", 0.11))
    # Ground and repeating pavers — very inexpensive draw calls.
    var floor_y: float = h * 0.72
    draw_rect(Rect2(0, floor_y, w, h - floor_y), Color("#344744"))
    draw_rect(Rect2(0, floor_y, w, 5.0), Color("#8b9277"))
    for i in range(int(ceil(w / 56.0)) + 1):
        var x: float = float(i) * 56.0
        draw_line(Vector2(x, floor_y + 17.0), Vector2(x + 37.0, floor_y + 17.0), Color("#597066", 0.6), 2.0)
        draw_line(Vector2(x + 25.0, floor_y + 47.0), Vector2(x + 57.0, floor_y + 47.0), Color("#576b60", 0.65), 2.0)
    draw_line(Vector2(0, h - 10), Vector2(w, h - 10), Color("#172b2d"), 7.0)
    # Gold/teal impact FX: only a stage cue, no combat state.
    if preview_fx_visible():
        var fx_t: float = (_elapsed - 2.45) / 0.50
        var point := Vector2(w * 0.73, h * 0.55)
        draw_arc(point, 16.0 + fx_t * 35.0, -0.9, 1.9, 22, Color("#c69d66", 1.0 - fx_t), 3.0)
        draw_line(point + Vector2(-17, 16), point + Vector2(18, -20), Color("#e3c99b", 1.0 - fx_t), 3.0)
