extends RefCounted
## Deterministic and disposable combat experiment; values are not approved balance.
const MAX_TEAM_HP := 30
const MAX_ENEMY_HP := 12
const MAX_CREATURE_HP := 10
const TEAM := ["CR001", "CR002", "CR003"]
const PRESSURE_DAMAGE := [2, 2, 1]
var floor_number := 1
var team_hp := MAX_TEAM_HP
var enemy_hp := MAX_ENEMY_HP
var creature_hp := {"CR001": 10, "CR002": 10, "CR003": 10}
var next_target := 0
var stance := "pressao"
var finished := false
var last_event := "Encontro iniciado."
var last_round_events: Array = []

func set_stance(value: String) -> void:
    if value == "pressao" or value == "protecao":
        stance = value

func resolve_round() -> Array:
    var events: Array = []
    if finished:
        return events
    var damage_total := 0
    for i in range(TEAM.size()):
        if creature_hp[TEAM[i]] <= 0:
            continue
        var damage: int = PRESSURE_DAMAGE[i] if stance == "pressao" else 1
        damage = mini(damage, enemy_hp)
        enemy_hp -= damage
        damage_total += damage
        events.append({"type": "team_attack", "actor": TEAM[i], "damage": damage, "target_hp": enemy_hp})
        if enemy_hp == 0:
            events.append({"type": "victory", "floor": floor_number})
            floor_number += 1
            enemy_hp = MAX_ENEMY_HP
            last_event = "Vitória! A equipe avançou ao andar %d." % floor_number
            last_round_events = events.duplicate(true)
            return events
    var target_index := next_target
    for offset in range(TEAM.size()):
        var candidate: int = (next_target + offset) % TEAM.size()
        if creature_hp[TEAM[candidate]] > 0:
            target_index = candidate
            break
    var target: String = TEAM[target_index]
    next_target = (target_index + 1) % TEAM.size()
    var incoming := 4 if stance == "pressao" else 2
    incoming = mini(incoming, int(creature_hp[target]))
    creature_hp[target] -= incoming
    team_hp -= incoming
    events.append({"type": "enemy_attack", "target": target, "damage": incoming, "target_hp": creature_hp[target], "team_hp": team_hp})
    if team_hp == 0:
        finished = true
        events.append({"type": "defeat", "floor": floor_number})
        last_event = "Equipe derrotada. Reinicie o teste para tentar novamente."
    else:
        last_event = "Equipe causou %d; recebeu %d." % [damage_total, incoming]
    last_round_events = events.duplicate(true)
    return events
