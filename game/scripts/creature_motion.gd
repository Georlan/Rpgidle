extends TextureRect
## Animation laboratory for creature previews, not a finished combat or sprite animation.
## All three G1 preview creatures now have individual six-pose atlases.
## This is animation art in review, not a released sprite standard.
const ATLAS_PATHS := {
    "CR001":"res://assets/01_creatures/CR001_Lunaro/sprite_sheets/CR001_G1_6poses_64x48.png",
    "CR002":"res://assets/01_creatures/CR002_Brumelo/sprite_sheets/CR002_G1_6poses_64x48.png",
    "CR003":"res://assets/01_creatures/CR003_Ferru/sprite_sheets/CR003_G1_6poses_64x48.png"
}
const CELL := Vector2i(64, 48)
const VALID_STATES := ["idle", "walk", "attack", "hurt", "skill"]
# A demonstration timeline, not a combat AI or final animation timing.
const DEMO_STATES := ["idle", "walk", "idle", "attack", "idle", "skill", "idle"]
const DEMO_SECONDS := [1.6, 1.2, 0.65, 0.48, 0.8, 0.7, 1.15]

var creature_id: String = ""
var motion_enabled: bool = true
var motion_state: String = "idle"
var has_pose_atlas: bool = false
var _sprite: AnimatedSprite2D
var _frames: SpriteFrames
var _motion: Tween
var _demo_tween: Tween
var _demo_running: bool = false
var _demo_index: int = -1
var _sprite_scale: float = 1.0
var _playback_speed: float = 1.0


func configure(id: String, resource_path: String, enabled: bool = true) -> void:
    creature_id = id
    motion_enabled = enabled
    texture = null

    if ATLAS_PATHS.has(creature_id):
        has_pose_atlas = _create_pose_sprite(String(ATLAS_PATHS[creature_id]))
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
    elif what == NOTIFICATION_VISIBILITY_CHANGED:
        if not is_visible_in_tree():
            stop_demo()
            _stop_motion()
            if _sprite != null:
                _sprite.pause()
        elif motion_enabled:
            play_state("idle")


func _create_pose_sprite(path: String) -> bool:
    if not ResourceLoader.exists(path):
        push_warning("Pose atlas missing for %s; using concept fallback" % creature_id)
        return false

    var atlas: Texture2D = load(path)
    if atlas == null or atlas.get_width() != CELL.x * 6 or atlas.get_height() != CELL.y:
        push_warning("Invalid atlas dimensions for %s; using concept fallback" % creature_id)
        return false

    _frames = SpriteFrames.new()
    _frames.clear_all()
    # Slower idle and more evenly paced alternating steps. No interpolated pixels.
    _add_animation("idle", [0, 0, 0, 1, 0, 0], 5.0, true, atlas)
    _add_animation("walk", [0, 1, 0, 1], 6.5, true, atlas)
    _add_animation("attack", [0, 0, 2, 3, 0], 12.0, false, atlas)
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


func set_playback_speed(value: float) -> void:
    if value != 1.0 and value != 2.0:
        return
    _playback_speed = value
    if _sprite != null:
        _sprite.speed_scale = value
    if _motion != null and _motion.is_valid():
        _motion.set_speed_scale(value)


func set_motion_enabled(enabled: bool) -> void:
    motion_enabled = enabled
    if not enabled:
        stop_demo()
    play_state("idle")


func start_demo() -> void:
    if not has_pose_atlas or not motion_enabled or not is_visible_in_tree():
        return
    stop_demo()
    _demo_running = true
    _demo_index = -1
    _advance_demo()


func stop_demo() -> void:
    _demo_running = false
    if _demo_tween != null and _demo_tween.is_valid():
        _demo_tween.kill()
    _demo_tween = null


func demo_is_running() -> bool:
    return _demo_running


func demo_current_step() -> int:
    return _demo_index


func _advance_demo() -> void:
    if not _demo_running or not motion_enabled or not is_visible_in_tree():
        stop_demo()
        return
    _demo_index = wrapi(_demo_index + 1, 0, DEMO_STATES.size())
    play_state(DEMO_STATES[_demo_index])
    _demo_tween = create_tween()
    _demo_tween.tween_interval(DEMO_SECONDS[_demo_index])
    _demo_tween.tween_callback(_advance_demo)


func _exit_tree() -> void:
    stop_demo()
    _stop_motion()


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
        _sprite.speed_scale = _playback_speed
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
        _motion.set_speed_scale(_playback_speed)
        return

    # Fallback for missing atlas: gentle breathing on original concept SVG.
    if not motion_enabled or not is_visible_in_tree():
        return
    _motion = create_tween().set_trans(Tween.TRANS_SINE)
    match requested:
        "idle", "walk":
            # Species have different breathing cadence and amplitudes.
            # No additional atlas or animation frames are claimed for these silhouettes.
            var stretch := Vector2(1.025, 0.980) if creature_id == "CR002" else Vector2(1.012, 0.990)
            var duration := 1.05 if creature_id == "CR002" else 0.77
            _motion.set_loops()
            _motion.tween_property(self, "scale", stretch, duration)
            _motion.tween_property(self, "scale", Vector2.ONE, duration)
        "hurt":
            _motion.tween_property(self, "modulate", Color("#f3b1a8"), 0.14)
            _motion.tween_property(self, "modulate", Color.WHITE, 0.20)
    _motion.set_speed_scale(_playback_speed)


func _on_animation_finished() -> void:
    if motion_enabled and is_visible_in_tree() and motion_state != "idle":
        play_state("idle")


func sprite_frame_count(state: String) -> int:
    if _frames == null or not _frames.has_animation(state):
        return 0
    return _frames.get_frame_count(state)


func sprite_animation_name() -> String:
    return String(_sprite.animation) if _sprite != null else ""
