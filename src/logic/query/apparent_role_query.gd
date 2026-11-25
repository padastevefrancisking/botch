class_name ApparentRoleQuery
extends Query

var subject: PlayerState
var observer: PlayerState
var role: RoleDef
var is_evil: bool


func _init(p_subject: PlayerState, p_observer: PlayerState) -> void:
	subject = p_subject
	observer = p_observer
	role = subject.role
	is_evil = Teams.is_evil(role.team)
