class_name GameEngine
extends RefCounted


func announce() -> void:
	pass


@warning_ignore("unused_parameter")
func tell(_info: Info, _may_be_false: bool) -> void:
	pass


@warning_ignore("unused_parameter")
func ask(_query: Query) -> Query:
	return null


@warning_ignore("unused_parameter")
func apply(_effects: Array[Effect]) -> void:
	pass


@warning_ignore("unused_parameter")
func emit(_event: GameEvent) -> void:
	pass
