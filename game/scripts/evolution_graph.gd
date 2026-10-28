extends Control
## Light, focusable non-linear evolution map. No forms unlock here.
signal candidate_selected(node_info: Dictionary)

const NODE_W := 142.0
const NODE_H := 52.0
const EDGE_COLOR := Color("#466b6a")
const ACTIVE_COLOR := Color("#c69d66")
var graph: Dictionary = {}
var _buttons: Dictionary = {}
var selected_id: String = ""


func _ready() -> void:
    clip_contents = true
    resized.connect(_position_buttons)
    _position_buttons()


func configure(data: Dictionary) -> void:
    for child in get_children():
        remove_child(child)
        child.queue_free()
    _buttons.clear()
    graph = data
    var nodes: Array = graph.get("nodes", [])
    selected_id = String(nodes[0].get("form_id", "")) if not nodes.is_empty() else ""
    for info in nodes:
        var button := Button.new()
        var grade: int = int(info.get("grade", 1))
        var label_text: String = String(info.get("label", "A definir"))
        button.text = "G%d  %s" % [grade, label_text]
        button.clip_text = true
        button.custom_minimum_size = Vector2(NODE_W, NODE_H)
        button.focus_mode = Control.FOCUS_ALL
        button.tooltip_text = "Prévia de caminho, condições não definidas"
        button.pressed.connect(select_form.bind(String(info["form_id"])))
        add_child(button)
        _buttons[String(info["form_id"])] = button
    _position_buttons()
    queue_redraw()


func select_form(form_id: String) -> void:
    var found: Dictionary = {}
    for info in graph.get("nodes", []):
        if String(info.get("form_id", "")) == form_id:
            found = info
            break
    if found.is_empty():
        return
    selected_id = form_id
    for key in _buttons.keys():
        var button: Button = _buttons[key]
        button.add_theme_color_override("font_color", ACTIVE_COLOR if key == form_id else Color("#ece3d2"))
    candidate_selected.emit(found)
    queue_redraw()


func node_count() -> int:
    return _buttons.size()


func _center_of(info: Dictionary) -> Vector2:
    var grade: int = int(info.get("grade", 1))
    var lane: float = float(info.get("lane", 0.5))
    var chart_w: float = maxf(size.x, 620.0)
    var chart_h: float = maxf(size.y, 196.0)
    var cx: float = 83.0 + float(grade - 1) * (chart_w - 166.0) / 3.0
    var cy: float = 26.0 + lane * (chart_h - 48.0)
    return Vector2(cx, cy)


func _position_buttons() -> void:
    if _buttons.is_empty():
        return
    for info in graph.get("nodes", []):
        var button: Button = _buttons.get(String(info.get("form_id", "")))
        if button != null:
            button.size = Vector2(NODE_W, NODE_H)
            button.position = _center_of(info) - Vector2(NODE_W * 0.5, NODE_H * 0.5)
    queue_redraw()


func _draw() -> void:
    var nodes: Array = graph.get("nodes", [])
    var by_id: Dictionary = {}
    for info in nodes:
        by_id[String(info["form_id"])] = info
    for info in nodes:
        var to_point: Vector2 = _center_of(info) - Vector2(NODE_W * 0.5 + 4.0, 0.0)
        for parent_id in info.get("parents", []):
            if not by_id.has(parent_id):
                continue
            var from_point: Vector2 = _center_of(by_id[parent_id]) + Vector2(NODE_W * 0.5 + 4.0, 0.0)
            var highlight: bool = String(info["form_id"]) == selected_id or String(parent_id) == selected_id
            draw_line(from_point, to_point, ACTIVE_COLOR if highlight else EDGE_COLOR, 2.0 if highlight else 1.0, true)
    # Grade guides are subtle and do not imply a linear progression.
    for grade in range(4):
        var x: float = 83.0 + float(grade) * (maxf(size.x, 620.0) - 166.0) / 3.0
        draw_line(Vector2(x, 6), Vector2(x, 13), Color("#58716f"), 2.0)
