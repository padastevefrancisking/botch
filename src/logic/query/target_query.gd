class_name TargetQuery
extends Query

var actor: PlayerState
var targets: Array[PlayerState]


func _init(p_actor: PlayerState, p_targets: Array[PlayerState]) -> void:
	actor = p_actor
	targets = p_targets.duplicate()
