class_name TeamReveal
extends Reveal

var team_id: Teams.Kind

func _init(p_character: Teams.Kind) -> void:
	team_id = p_character 

func kind() -> StringName:
	return RevealKind.TEAM

func id() -> StringName:
	return StringName("TEAM_" + Teams.Kind.find_key(team_id)).to_upper()

func matches(p: PlayerState) -> bool:
	return team_id == p.role.team
