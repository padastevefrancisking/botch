class_name RoleDef
extends RefCounted

var id: StringName
var display_name: String
var team: Teams.Kind
var ability: Ability


func _init(p_id: StringName, p_name: String, p_team: Teams.Kind, p_ability: Ability) -> void:
	id = p_id
	display_name = p_name
	team = p_team
	ability = p_ability
