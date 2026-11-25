class_name AlignmentReveal
extends Reveal

var alignment: StringName


func _init(p_team: Teams.Kind) -> void:
	alignment = _assign_alignment_string_name(Teams.is_evil(p_team))


func kind() -> StringName:
	return RevealKind.ALIGNMENT


func id() -> StringName:
	return _create_id()


func matches(player: PlayerState) -> bool:
	var p2_alignment = _assign_alignment_string_name(Teams.is_evil(player.role.team))
	return alignment == p2_alignment


func _assign_alignment_string_name(is_evil: bool) -> StringName:
	return &"EVIL" if is_evil else &"GOOD"


func _create_id() -> StringName:
	var out := &"ALIGNMENT_" + alignment
	return out
