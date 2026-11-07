class_name Health
extends RefCounted
## Pure health logic: no nodes, so it can be unit tested without a scene tree.

signal changed(current: int, maximum: int)
signal died

var maximum: int
var current: int


func _init(max_health: int = 100) -> void:
	maximum = max(1, max_health)
	current = maximum


func is_dead() -> bool:
	return current <= 0


func take_damage(amount: int) -> void:
	if amount <= 0 or is_dead():
		return
	current = max(0, current - amount)
	changed.emit(current, maximum)
	if is_dead():
		died.emit()


func heal(amount: int) -> void:
	if amount <= 0 or is_dead():
		return
	current = min(maximum, current + amount)
	changed.emit(current, maximum)
