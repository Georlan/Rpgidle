extends Control
## Idle-first visual prototype: no enemy, combat math, loot or progression is simulated.
## Separates the visual loop state from each creature's sprite animation.
signal visual_phase_changed(phase: String)
signal visual_cycle_completed

const CreatureMotion = preload("res://game/scripts/creature_motion.gd")
const BACKDROP: Texture2D = preload("res://assets/03_world/dungeon/exports/ruins_backdrop_448x160.png")
const CREATURES = [
    {"id":"CR001","path":"res://assets/01_creatures/CR001_Lunaro/concept_forms/CR001_G1_concept_preview.png"},
    {"id":"CR002","path":"res://assets/01_creatures/CR002_Brumelo/CR002_G1_placeholder.svg"},
    {"id":"CR003","path":"res://assets/01_creatures/CR003_Ferru/CR003_G1_placeholder.svg"}
]
const CYCLE_SECONDS := 8.0
const PHASES := ["explore", "engage", "resolve", "advance"]
const PHASE_LABELS := {
    "explore":"Explorando",
    "engage":"Ação automática",
    "resolve":"Concluindo ciclo",
    "advance":"Avançando"
}
const FORMATION_X := [0.375, 0.255, 0.145]
const FOOT_OFFSETS := [-1.0, 1.0, 2.0]

var _actors: Array = []
var _playing: bool = false
var _paused: bool = false
var _speed: float = 1.0
var _elapsed: float = 0.0
var _phase: String = "explore"
var _floor_preview: int = 36


func _ready() -> void:
    clip_contents = true
    texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
    mouse_filter = Control.MOUSE_FILTER_IGNORE
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
    _set_phase(_phase, true)
    queue_redraw()


func set_floor_preview(value: int) -> void:
    _floor_preview = maxi(value, 1)


func floor_preview() -> int:
    return _floor_preview


func set_playing(enabled: bool) -> void:
    if _playing == enabled:
        return
    _playing = enabled
    set_process(enabled and not _paused)
    _set_phase(phase_for_time(_elapsed), true)
    queue_redraw()


func is_preview_running() -> bool:
    return _playing and not _paused


func set_paused(value: bool) -> void:
    if _paused == value:
        return
    _paused = value
    set_process(_playing and not _paused)
    _set_phase(phase_for_time(_elapsed), true)
    queue_redraw()


func is_paused() -> bool:
    return _paused


func set_preview_speed(value: float) -> void:
    if value != 1.0 and value != 2.0:
        return
    _speed = value
    for actor in _actors:
        actor.set_playback_speed(_speed)


func preview_speed() -> float:
    return _speed


func preview_phase() -> String:
    return _phase


func preview_phase_label() -> String:
    return "Pausado" if _paused else PHASE_LABELS.get(_phase, "Explorando")


func preview_progress() -> float:
    return clampf(_elapsed / CYCLE_SECONDS, 0.0, 1.0)


func preview_fx_visible() -> bool:
    return is_preview_running() and _phase == "engage" and _elapsed >= 3.6 and _elapsed < 4.35


func creature_count() -> int:
    return _actors.size()


func phase_for_time(seconds: float) -> String:
    var t: float = fposmod(seconds, CYCLE_SECONDS)
    if t < 3.2:
        return "explore"
    if t < 4.4:
        return "engage"
    if t < 5.75:
        return "resolve"
    return "advance"


func reset_preview_cycle() -> void:
    _elapsed = 0.0
    _set_phase("explore", true)
    _position_actors()
    queue_redraw()


func _process(delta: float) -> void:
    if not is_preview_running():
        return
    _elapsed += maxf(delta, 0.0) * _speed
    if _elapsed >= CYCLE_SECONDS:
        var completed: int = floori(_elapsed / CYCLE_SECONDS)
        _elapsed = fposmod(_elapsed, CYCLE_SECONDS)
        for index in range(completed):
            visual_cycle_completed.emit()
    _set_phase(phase_for_time(_elapsed))
    _position_actors()
    # One background texture + three contact shadows; cheap enough for the
    # preview. Remove redraws altogether when hidden or paused.
    queue_redraw()


func _set_phase(next_phase: String, force: bool = false) -> void:
    if not PHASES.has(next_phase):
        return
    if _phase == next_phase and not force:
        return
    _phase = next_phase
    for actor in _actors:
        var should_animate: bool = _playing and not _paused
        actor.set_motion_enabled(should_animate)
        var anim := "idle"
        if next_phase == "explore" or next_phase == "advance":
            anim = "walk"
        elif next_phase == "engage" and actor.creature_id == "CR001":
            anim = "attack"
        actor.play_state(anim)
    visual_phase_changed.emit(_phase)


func _travel_offset() -> float:
    var t: float = _elapsed
    if t < 3.2:
        return 28.0 * t / 3.2
    if t < 5.75:
        return 28.0
    return 28.0 * (1.0 - (t - 5.75) / (CYCLE_SECONDS - 5.75))


func _position_actors() -> void:
    if _actors.is_empty() or size.x <= 0.0 or size.y <= 0.0:
        return
    var w: float = size.x
    var baseline: float = size.y * 0.805
    for i in range(_actors.size()):
        var actor = _actors[i]
        var center_x: float = w * FORMATION_X[i] + _travel_offset()
        var foot_y: float = baseline + FOOT_OFFSETS[i]
        actor.position = Vector2(roundf(center_x - actor.size.x / 2.0), roundf(foot_y - actor.size.y))


func backdrop_size() -> Vector2i:
    return Vector2i(BACKDROP.get_width(), BACKDROP.get_height())


func backdrop_source_rect(viewport_size: Vector2) -> Rect2:
    var tw: float = float(BACKDROP.get_width())
    var th: float = float(BACKDROP.get_height())
    if viewport_size.x <= 0.0 or viewport_size.y <= 0.0:
        return Rect2(0.0, 0.0, tw, th)
    var viewport_ratio: float = viewport_size.x / viewport_size.y
    var source_ratio: float = tw / th
    if viewport_ratio >= source_ratio:
        var crop_h: float = tw / viewport_ratio
        return Rect2(0.0, th - crop_h, tw, crop_h)
    var crop_w: float = th * viewport_ratio
    return Rect2((tw - crop_w) * 0.5, 0.0, crop_w, th)


func _draw() -> void:
    if size.x < 1.0 or size.y < 1.0:
        return
    draw_texture_rect_region(BACKDROP, Rect2(Vector2.ZERO, size), backdrop_source_rect(size))
    # Grounded shadows use each actor's actual contact point, not duplicated
    # position formulas that drift when the formation changes.
    for i in range(_actors.size()):
        var actor = _actors[i]
        var center: Vector2 = Vector2(actor.position.x + actor.size.x * 0.5, actor.position.y + actor.size.y - 1.5)
        var radius: float = 24.0 if i == 0 else 27.0
        draw_set_transform(center, 0.0, Vector2(1.0, 0.21))
        draw_circle(Vector2.ZERO, radius, Color(0.02, 0.07, 0.09, 0.24))
    draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
    if preview_fx_visible():
        var fx_t: float = clampf((_elapsed - 3.6) / 0.75, 0.0, 1.0)
        var lunaro = _actors[0]
        var center: Vector2 = lunaro.position + Vector2(lunaro.size.x + 18.0, lunaro.size.y * 0.55)
        draw_arc(center, 10.0 + fx_t * 15.0, -0.8, 1.6, 15, Color(0.55, 0.83, 0.77, 1.0 - fx_t), 2.0)
    # 3px progress bar belongs to visual loop, not to real character progress.
    var left: float = 13.0
    var bar_y: float = size.y - 7.0
    var total: float = maxf(1.0, size.x - 26.0)
    draw_rect(Rect2(left, bar_y, total, 3.0), Color(0.04, 0.12, 0.15, 0.85))
    draw_rect(Rect2(left, bar_y, total * preview_progress(), 3.0), Color("#6aae9f"))
