class_name CountInfo
extends Info

var reveal: Reveal
var count: int
var among: Array[PlayerState]


func _init(
	p_receiver: PlayerState,
	p_reveal: Reveal,
	p_count: int,
	p_among: Array[PlayerState] = []  # For revealing only the count with no selected people
) -> void:
	receiver = p_receiver
	reveal = p_reveal
	count = p_count
	among = p_among


func kind() -> StringName:
	return InfoKind.COUNT


func to_dict() -> Dictionary:
	return {
		"kind": kind(),
		"receiver": receiver.id,
		"reveal_kind": reveal.kind(),
		"reveal_id": reveal.id(),
		"count": count,
		"among": among.map(func(p: PlayerState): return p.id)
	}
