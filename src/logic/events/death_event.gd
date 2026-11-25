class_name DeathEvent
extends GameEvent

var player: PlayerState
var cause: StringName


func _init(p_player: PlayerState, p_cause: StringName) -> void:
	player = p_player
	cause = p_cause


func kind() -> StringName:
	return GameEventKind.DEATH


func to_dict() -> Dictionary:
	return {"player": player.id, "cause": cause}
