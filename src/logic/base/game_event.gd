@abstract
class_name GameEvent
extends RefCounted

class GameEventKind:
	const DEATH := &"EVENT_DEATH"
	const NOMINATED := &"EVENT_NOMINATED"
	const EXECUTED := &"EVENT_EXECUTED"

@abstract
func kind() -> StringName
@abstract
func to_dict() -> Dictionary
