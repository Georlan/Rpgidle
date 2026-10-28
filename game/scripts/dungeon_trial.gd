extends RefCounted
## Disposable deterministic playtest parameters, not approved game balance.
const MAX_TEAM_HP := 30
const MAX_ENEMY_HP := 12
var floor_number := 1
var team_hp := MAX_TEAM_HP
var enemy_hp := MAX_ENEMY_HP
var stance := "pressao"
var finished := false
var last_event := "Encontro iniciado."

func set_stance(value: String) -> void:
    if value == "pressao" or value == "protecao":
        stance = value

func resolve_round() -> void:
    if finished:
        return
    var damage := 5 if stance == "pressao" else 3
    var incoming := 4 if stance == "pressao" else 2
    enemy_hp = maxi(0, enemy_hp - damage)
    if enemy_hp == 0:
        floor_number += 1
        enemy_hp = MAX_ENEMY_HP
        last_event = "Vitória! A equipe avançou ao andar %d." % floor_number
        return
    team_hp = maxi(0, team_hp - incoming)
    if team_hp == 0:
        finished = true
        last_event = "Equipe derrotada. Reinicie o teste para tentar novamente."
    else:
        last_event = "Equipe causou %d; recebeu %d." % [damage, incoming]
