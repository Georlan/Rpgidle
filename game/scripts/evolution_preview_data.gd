extends RefCounted
## Read-only candidate branching previews. Not game rules or saved discoveries.
const PATH := "res://assets/metadata/evolution_preview.json"


static func read() -> Dictionary:
    if not FileAccess.file_exists(PATH):
        push_error("Evolution preview metadata missing")
        return {}
    var data: Variant = JSON.parse_string(FileAccess.get_file_as_string(PATH))
    if not data is Dictionary:
        push_error("Invalid evolution preview JSON")
        return {}
    return data


static func species_graph(species_id: String) -> Dictionary:
    var data: Dictionary = read()
    for item in data.get("species", []):
        if item is Dictionary and item.get("species_id", "") == species_id:
            return item
    return {}


static func node_by_id(species_id: String, form_id: String) -> Dictionary:
    var graph: Dictionary = species_graph(species_id)
    for node in graph.get("nodes", []):
        if node is Dictionary and node.get("form_id", "") == form_id:
            return node
    return {}
