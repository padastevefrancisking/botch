class_name VoteWeightQuery
extends Query

var voter: PlayerState
var weight: int = 1


func _init(p_voter: PlayerState) -> void:
	voter = p_voter
