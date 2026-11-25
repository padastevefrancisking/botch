class_name CanVoteQuery
extends Query

var voter: PlayerState
var allowed: bool


func _init(p_voter: PlayerState) -> void:
	voter = p_voter
	allowed = not voter.departed and (voter.alive or voter.has_ghost_vote)
