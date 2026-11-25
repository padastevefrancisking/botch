class_name AttackQuery
extends Query

var actor: PlayerState
var target: PlayerState
var prevented: bool
var reason: StringName
var consequences: Array[Effect]


func _init(p_actor: PlayerState, p_target: PlayerState) -> void:
	actor = p_actor
	target = p_target
