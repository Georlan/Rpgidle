extends RefCounted
## Rpgidle interface design tokens for Godot 4.6.1.
## Pixel-world + readable UI: shared colors, borders and focus feedback.
const INK := Color("#101920")
const SURFACE := Color("#182830")
const PANEL := Color("#142229")
const LINE := Color("#395259")
const IVORY := Color("#ece3d2")
const MUTED := Color("#a9c0bb")
const GOLD := Color("#c69d66")
const JADE := Color("#6aae9f")


static func make_theme() -> Theme:
    var t := Theme.new()
    t.set_color("font_color", "Label", IVORY)
    t.set_color("font_color", "Button", IVORY)
    t.set_color("font_hover_color", "Button", IVORY)
    t.set_color("font_pressed_color", "Button", INK)
    t.set_color("font_focus_color", "Button", IVORY)
    t.set_color("font_disabled_color", "Button", MUTED.darkened(0.35))
    t.set_font_size("font_size", "Button", 14)
    t.set_font_size("font_size", "Label", 14)
    t.set_stylebox("panel", "PanelContainer", _box(PANEL, LINE, 10, 14, 12))
    t.set_stylebox("normal", "Button", _box(SURFACE, LINE, 7, 12, 9))
    t.set_stylebox("hover", "Button", _box(Color("#254038"), JADE, 7, 12, 9))
    t.set_stylebox("pressed", "Button", _box(GOLD, GOLD, 7, 12, 9))
    t.set_stylebox("disabled", "Button", _box(Color("#1b262b"), Color("#344046"), 7, 12, 9))
    var focus := StyleBoxFlat.new()
    focus.bg_color = Color(0, 0, 0, 0)
    focus.border_color = JADE
    focus.set_border_width_all(2)
    focus.set_corner_radius_all(8)
    t.set_stylebox("focus", "Button", focus)
    return t


static func navigation(button: Button, selected: bool) -> void:
    var bg := Color("#203a37") if selected else Color("#182830")
    var stroke := JADE if selected else Color("#2b4348")
    button.add_theme_stylebox_override("normal", _box(bg, stroke, 7, 8, 8))
    button.add_theme_color_override("font_color", IVORY if selected else MUTED)
    button.add_theme_color_override("font_hover_color", IVORY)


static func primary(button: Button) -> void:
    button.add_theme_stylebox_override("normal", _box(GOLD, GOLD, 7, 14, 10))
    button.add_theme_stylebox_override("hover", _box(Color("#dfb776"), GOLD, 7, 14, 10))
    button.add_theme_color_override("font_color", INK)
    button.add_theme_color_override("font_hover_color", INK)


static func _box(fill: Color, stroke: Color, radius: int, px: int, py: int) -> StyleBoxFlat:
    var style := StyleBoxFlat.new()
    style.bg_color = fill
    style.border_color = stroke
    style.set_border_width_all(1)
    style.set_corner_radius_all(radius)
    style.content_margin_left = px
    style.content_margin_right = px
    style.content_margin_top = py
    style.content_margin_bottom = py
    return style
