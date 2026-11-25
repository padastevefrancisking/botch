class_name NominatedEvent
extends GameEvent

var nominee: PlayerState
var nominator: PlayerState


func _init(p_nominee: PlayerState, p_nominator: PlayerState) -> void:
	nominee = p_nominee
	nominator = p_nominator


func kind() -> StringName:
	return GameEventKind.NOMINATED


func to_dict() -> Dictionary:
	return {"nominee": nominee.id, "nominator": nominator.id}
