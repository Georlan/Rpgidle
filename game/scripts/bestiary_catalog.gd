extends RefCounted
## Static bestiary catalog. No creature instances, player state or unlock writes.
const PATH := "res://assets/metadata/bestiary_catalog.json"


static func load_catalog() -> Dictionary:
    if not FileAccess.file_exists(PATH):
        push_error("Bestiary metadata missing: " + PATH)
        return {}
    var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(PATH))
    if not parsed is Dictionary:
        push_error("Invalid bestiary metadata")
        return {}
    return parsed


static func species_by_id(species_id: String) -> Dictionary:
    var catalog: Dictionary = load_catalog()
    for record in catalog.get("species", []):
        if record is Dictionary and record.get("species_id", "") == species_id:
            return record
    return {}


static func form_by_id(species_id: String, form_id: String) -> Dictionary:
    var species: Dictionary = species_by_id(species_id)
    for form in species.get("forms", []):
        if form is Dictionary and form.get("form_id", "") == form_id:
            return form
    return {}


static func known_species_count() -> int:
    var catalog: Dictionary = load_catalog()
    return catalog.get("species", []).size()
