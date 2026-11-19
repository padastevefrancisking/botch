class_name TeamReveal
extends Reveal

var team_id: Teams.Kind


func _init(p_team: Teams.Kind) -> void:
	team_id = p_team


func kind() -> StringName:
	return RevealKind.TEAM


func id() -> StringName:
	return Teams.get_id(team_id)


func matches(p: PlayerState) -> bool:
	return team_id == p.role.team
