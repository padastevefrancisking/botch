class_name Teams
extends RefCounted

enum Kind { TOWNSFOLK, OUTSIDER, MINION, DEMON }


static func is_evil(kind: Kind) -> bool:
	return kind == Kind.MINION or kind == Kind.DEMON


static func get_id(kind: Kind) -> StringName:
	var out := "TEAM_" + String(Kind.find_key(kind))
	return StringName(out.to_upper())
