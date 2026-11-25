class_name ExecutedEvent
extends GameEvent

var player: PlayerState


func _init(p_player: PlayerState) -> void:
	player = p_player


func kind() -> StringName:
	return GameEventKind.EXECUTED


func to_dict() -> Dictionary:
	return {"player": player.id}
