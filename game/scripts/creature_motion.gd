extends TextureRect
## Animation laboratory for creature previews, not a finished combat or sprite animation.
## CR001 has six distinct source poses driven by AnimatedSprite2D/SpriteFrames.
## CR002/CR003 are static silhouettes with an optional soft breathing motion.
const ATLAS_PATH := "res://assets/01_creatures/CR001_Lunaro/sprite_sheets/CR001_G1_6poses_64x48.png"
const CELL := Vector2i(64, 48)
const VALID_STATES := ["idle", "walk", "attack", "hurt", "skill"]

var creature_id: String = ""
var motion_enabled: bool = true
var motion_state: String = "idle"
var has_pose_atlas: bool = false
var _sprite: AnimatedSprite2D
var _frames: SpriteFrames
var _motion: Tween
var _sprite_scale: float = 1.0


func configure(id: String, resource_path: String, enabled: bool = true) -> void:
    creature_id = id
    motion_enabled = enabled
    texture = null

    if creature_id == "CR001":
        has_pose_atlas = _create_pose_sprite()
    if not has_pose_atlas and ResourceLoader.exists(resource_path):
        texture = load(resource_path)
        expand_mode = TextureRect.EXPAND_IGNORE_SIZE
        stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
        texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

    if is_inside_tree():
        play_state("idle")


func _ready() -> void:
    _layout_sprite()
    play_state("idle")


func _notification(what: int) -> void:
    if what == NOTIFICATION_RESIZED:
        _layout_sprite()
    elif what == NOTIFICATION_VISIBILITY_CHANGED and _sprite != null:
        if not is_visible_in_tree():
            _stop_motion()
            _sprite.pause()
        elif motion_enabled:
            play_state("idle")


func _create_pose_sprite() -> bool:
    if not ResourceLoader.exists(ATLAS_PATH):
        push_warning("CR001 pose atlas missing; using static concept fallback")
        return false

    var atlas: Texture2D = load(ATLAS_PATH)
    if atlas == null or atlas.get_width() != CELL.x * 6 or atlas.get_height() != CELL.y:
        push_warning("Invalid CR001 atlas dimensions; using static concept fallback")
        return false

    _frames = SpriteFrames.new()
    _frames.clear_all()
    _add_animation("idle", [0, 0, 1, 0, 0], 5.0, true, atlas)
    _add_animation("walk", [0, 1, 0, 1], 8.0, true, atlas)
    _add_animation("attack", [0, 2, 3, 0], 11.0, false, atlas)
    _add_animation("hurt", [0, 4, 0], 8.0, false, atlas)
    _add_animation("skill", [0, 5, 0], 7.0, false, atlas)

    _sprite = AnimatedSprite2D.new()
    _sprite.centered = true
    _sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
    _sprite.sprite_frames = _frames
    _sprite.animation_finished.connect(_on_animation_finished)
    add_child(_sprite)
    _layout_sprite()
    return true


func _add_animation(name: StringName, indexes: Array, fps: float, looping: bool, atlas: Texture2D) -> void:
    _frames.add_animation(name)
    _frames.set_animation_speed(name, fps)
    _frames.set_animation_loop(name, looping)
    for index in indexes:
        var region := AtlasTexture.new()
        region.atlas = atlas
        region.region = Rect2(int(index) * CELL.x, 0, CELL.x, CELL.y)
        region.filter_clip = true
        _frames.add_frame(name, region)


func _layout_sprite() -> void:
    if _sprite == null or size.x <= 0.0 or size.y <= 0.0:
        return
    # Source poses share a baseline: all opaque pixels end at Y≈45.
    # Keep feet planted when changing animation frames and control dimensions.
    _sprite_scale = minf(size.x / 54.0, size.y / 45.0)
    _sprite.scale = Vector2.ONE * _sprite_scale
    _sprite.position = Vector2(size.x * 0.5, size.y - 5.0 - 21.0 * _sprite_scale)


func _stop_motion() -> void:
    if _motion != null and _motion.is_valid():
        _motion.kill()
    _motion = null
    scale = Vector2.ONE
    rotation_degrees = 0.0
    modulate = Color.WHITE
    if _sprite != null:
        _layout_sprite()
        _sprite.modulate = Color.WHITE
        _sprite.rotation_degrees = 0.0


func set_motion_enabled(enabled: bool) -> void:
    motion_enabled = enabled
    play_state("idle")


func play_state(requested: String) -> void:
    if not VALID_STATES.has(requested):
        return
    _stop_motion()
    motion_state = requested
    if has_pose_atlas and _sprite != null:
        _sprite.stop()
        if not motion_enabled or not is_visible_in_tree():
            _sprite.animation = &"idle"
            _sprite.frame = 0
            return
        _sprite.play(requested)
        # Subtle motion between key poses makes the animation less abrupt.
        _motion = create_tween().set_trans(Tween.TRANS_SINE)
        match requested:
            "idle":
                _motion.set_loops()
                _motion.tween_property(_sprite, "scale", _sprite.scale * Vector2(1.018, 0.985), 0.65)
                _motion.tween_property(_sprite, "scale", _sprite.scale, 0.65)
            "walk":
                _motion.set_loops()
                _motion.tween_property(_sprite, "rotation_degrees", 2.0, 0.25)
                _motion.tween_property(_sprite, "rotation_degrees", -2.0, 0.25)
                _motion.tween_property(_sprite, "rotation_degrees", 0.0, 0.25)
            "attack":
                _motion.tween_property(_sprite, "position:x", _sprite.position.x + 7.0, 0.13)
                _motion.tween_property(_sprite, "position:x", _sprite.position.x - 3.0, 0.16)
                _motion.tween_property(_sprite, "position:x", _sprite.position.x, 0.10)
            "hurt":
                _motion.tween_property(_sprite, "modulate", Color("#f3b1a8"), 0.13)
                _motion.tween_property(_sprite, "modulate", Color.WHITE, 0.22)
            "skill":
                _motion.tween_property(_sprite, "modulate", Color("#a2f2e6"), 0.18)
                _motion.tween_property(_sprite, "modulate", Color.WHITE, 0.22)
        return

    # Temporary silhouettes: breathe gently but do not pretend to have sprite frames.
    if not motion_enabled or not is_visible_in_tree():
        return
    _motion = create_tween().set_trans(Tween.TRANS_SINE)
    match requested:
        "idle", "walk":
            _motion.set_loops()
            _motion.tween_property(self, "scale", Vector2(1.015, 0.985), 0.85)
            _motion.tween_property(self, "scale", Vector2.ONE, 0.85)
        "hurt":
            _motion.tween_property(self, "modulate", Color("#f3b1a8"), 0.14)
            _motion.tween_property(self, "modulate", Color.WHITE, 0.20)


func _on_animation_finished() -> void:
    if motion_enabled and is_visible_in_tree() and motion_state != "idle":
        play_state("idle")


func sprite_frame_count(state: String) -> int:
    if _frames == null or not _frames.has_animation(state):
        return 0
    return _frames.get_frame_count(state)


func sprite_animation_name() -> String:
    return String(_sprite.animation) if _sprite != null else ""
