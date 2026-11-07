class_name HealthComponent
extends Node
## Thin node wrapper: attach to any actor, forwards to the pure Health logic.

signal died

@export var max_health: int = 100

var health: Health


func _ready() -> void:
	health = Health.new(max_health)
	health.died.connect(_on_died)


func take_damage(amount: int) -> void:
	health.take_damage(amount)


func _on_died() -> void:
	died.emit()
	get_parent().queue_free()
