class_name IdentityInfo
extends Info

var subject: PlayerState
var reveal: Reveal


func _init(p_receiver: PlayerState, p_subject: PlayerState, p_reveal: Reveal) -> void:
	receiver = p_receiver
	subject = p_subject
	reveal = p_reveal


func kind() -> StringName:
	return InfoKind.IDENTITY


func to_dict() -> Dictionary:
	return {
		"kind": kind(),
		"receiver": receiver.id,
		"reveal_kind": reveal.kind(),
		"reveal_id": reveal.id(),
		"subject": subject.id
	}
