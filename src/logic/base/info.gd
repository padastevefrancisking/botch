@abstract class_name Info
extends RefCounted


class InfoKind:
	const COUNT := &"INFO_COUNT"
	const IDENTITY := &"INFO_IDENTITY"


var receiver: PlayerState

@abstract func kind() -> StringName
@abstract func to_dict() -> Dictionary
