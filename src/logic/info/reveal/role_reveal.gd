class_name RoleReveal
extends Reveal

var role_id: StringName

func _init(p_role_id: StringName) -> void:
	role_id = p_role_id

func kind() -> StringName:
	return RevealKind.ROLE

func id() -> StringName:
	return role_id

func matches(p: PlayerState) -> bool:
	return role_id == p.role.id
