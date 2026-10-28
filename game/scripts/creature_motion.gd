extends TextureRect
## Reusable native Godot motion proxy. Does NOT replace hand-drawn animation frames.
## Only CR001 moves. Other species intentionally remain static concept silhouettes.

const VALID_STATES := ["idle", "walk", "attack", "hurt", "skill"]
var creature_id: String = ""
var motion_enabled: bool = true
var motion_state: String = "idle"
var _motion: Tween


func configure(id: String, resource_path: String, enabled: bool = true) -> void:
    creature_id = id
    motion_enabled = enabled
    expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
    if ResourceLoader.exists(resource_path):
        texture = load(resource_path)
    if is_inside_tree():
        play_state("idle")


func _ready() -> void:
    play_state("idle")


func _notification(what: int) -> void:
    if what == NOTIFICATION_RESIZED:
        # Stay anchored near the foot of the original sprite.
        pivot_offset = size * Vector2(0.5, 0.88)


func set_motion_enabled(enabled: bool) -> void:
    motion_enabled = enabled
    play_state("idle")


func play_state(requested: String) -> void:
    if not VALID_STATES.has(requested):
        return

    if _motion != null and _motion.is_valid():
        _motion.kill()
    _motion = null
    motion_state = requested
    scale = Vector2.ONE
    rotation_degrees = 0.0
    modulate = Color.WHITE

    if creature_id != "CR001" or not motion_enabled or not is_inside_tree():
        return

    _motion = create_tween().set_trans(Tween.TRANS_SINE)
    match requested:
        "idle":
            _motion.set_loops()
            _motion.tween_property(self, "scale", Vector2(1.025, 0.97), 0.72)
            _motion.tween_property(self, "scale", Vector2.ONE, 0.72)
        "walk":
            _motion.set_loops()
            _motion.tween_property(self, "rotation_degrees", 2.5, 0.24)
            _motion.tween_property(self, "rotation_degrees", -2.5, 0.24)
            _motion.tween_property(self, "rotation_degrees", 0.0, 0.24)
        "attack":
            _motion.tween_property(self, "scale", Vector2(1.13, 0.9), 0.12)
            _motion.tween_property(self, "scale", Vector2(0.95, 1.06), 0.12)
            _motion.tween_property(self, "scale", Vector2.ONE, 0.19)
            _motion.tween_callback(Callable(self, "play_state").bind("idle"))
        "hurt":
            _motion.tween_property(self, "modulate", Color("#ffb5a0"), 0.12)
            _motion.tween_property(self, "modulate", Color.WHITE, 0.23)
            _motion.tween_callback(Callable(self, "play_state").bind("idle"))
        "skill":
            _motion.tween_property(self, "modulate", Color("#b5fff2"), 0.15)
            _motion.parallel().tween_property(self, "scale", Vector2(1.075, 1.075), 0.15)
            _motion.tween_property(self, "modulate", Color.WHITE, 0.23)
            _motion.parallel().tween_property(self, "scale", Vector2.ONE, 0.23)
            _motion.tween_callback(Callable(self, "play_state").bind("idle"))
