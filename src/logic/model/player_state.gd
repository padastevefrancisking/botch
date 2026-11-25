class_name PlayerState
extends RefCounted

var id: StringName
var username: String
var seat_no: int
var role: RoleDef
var shown_role: RoleDef
var alive := true
var has_ghost_vote := true
var departed := false
var statuses: Dictionary[StringName, bool] = {}


func _init(
	p_id: StringName, p_username: String, p_seat_no: int, p_role: RoleDef, p_shown_role: RoleDef
) -> void:
	id = p_id
	username = p_username
	seat_no = p_seat_no
	role = p_role
	shown_role = p_shown_role


func has_status(status: StringName) -> bool:
	return statuses.get(status, false)


func is_in_play() -> bool:
	return alive and not departed
