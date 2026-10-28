extends Control
## Dungeon stage v0.6 — visual-only loop. No enemies, health, damage or rewards.
## Uses existing CreatureMotion previews; Godot 4.6.1 CanvasItem drawing.
const CreatureMotion = preload("res://game/scripts/creature_motion.gd")
const BACKDROP: Texture2D = preload("res://assets/03_world/dungeon/exports/ruins_backdrop_448x160.png")
const CREATURES = [
    {"id":"CR001","path":"res://assets/01_creatures/CR001_Lunaro/concept_forms/CR001_G1_concept_preview.png"},
    {"id":"CR002","path":"res://assets/01_creatures/CR002_Brumelo/CR002_G1_placeholder.svg"},
    {"id":"CR003","path":"res://assets/01_creatures/CR003_Ferru/CR003_G1_placeholder.svg"}
]
const CYCLE_SECONDS := 6.0

var _actors: Array = []
var _playing: bool = false
var _elapsed: float = 0.0
var _phase: String = "idle"
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
    var baseline: float = size.y * 0.82
    var travel: float = 0.0
    if _playing:
        if _elapsed < 1.8:
            travel = _elapsed / 1.8 * 34.0
        elif _elapsed < 2.95:
            travel = 34.0
        elif _elapsed < 4.45:
            travel = 34.0 * (1.0 - (_elapsed - 2.95) / 1.5)
    for i in _actors.size():
        var actor = _actors[i]
        var x: float = width * 0.09 + float(i) * minf(width * 0.165, 118.0) + travel
        actor.position = Vector2(roundf(x), roundf(baseline - actor.size.y))


func backdrop_size() -> Vector2i:
    return Vector2i(BACKDROP.get_width(), BACKDROP.get_height())

func backdrop_source_rect(viewport_size: Vector2) -> Rect2:
    # Aspect-cover with feet/floor retained, never stretch artwork.
    # This is a compositional preview; final layers may use parallax later.
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
    # Original hand-authored indexed pixel art, not a screenshot of another game.
    # Keep detail crisp even at non-integer desktop window sizes.
    draw_texture_rect_region(BACKDROP, Rect2(Vector2.ZERO, size), backdrop_source_rect(size))
    var w: float = size.x
    var h: float = size.y
    # Very light ground contact gives each creature a place in the world.
    # Drawn beneath the child sprites, no per-creature textures.
    var travel: float = 0.0
    if _playing:
        if _elapsed < 1.8:
            travel = _elapsed / 1.8 * 34.0
        elif _elapsed < 2.95:
            travel = 34.0
        elif _elapsed < 4.45:
            travel = 34.0 * (1.0 - (_elapsed - 2.95) / 1.5)
    for i in range(_actors.size()):
        var x: float = w * 0.09 + float(i) * minf(w * 0.165, 118.0) + travel + 46.0
        draw_circle(Vector2(x, h * 0.82), 11.0 - float(i), Color(0.03, 0.08, 0.10, 0.35))
    # One readable impact, deliberately short. No damage or ability logic.
    if preview_fx_visible():
        var t: float = clampf((_elapsed - 2.45) / 0.50, 0.0, 1.0)
        var origin := Vector2(w * 0.83, h * 0.47)
        draw_arc(origin, 14.0 + 30.0 * t, -0.85, 1.9, 18, Color(0.84, 0.75, 0.50, 1.0 - t), 2.0)
        draw_line(origin + Vector2(-17, 14), origin + Vector2(18, -18), Color(0.92, 0.83, 0.63, 1.0 - t), 3.0)

