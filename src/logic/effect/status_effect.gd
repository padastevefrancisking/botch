class_name StatusEffect
extends Effect

var subject: PlayerState
var status: StringName


func _init(p_subject: PlayerState, p_status: StringName) -> void:
	subject = p_subject
	status = p_status


@warning_ignore("unused_parameter")
func apply(_engine: GameEngine) -> void:
	subject.statuses[status] = true
