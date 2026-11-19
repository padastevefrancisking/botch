extends GutTest
## IT-HEALTH: HealthComponent with real nodes in the scene tree.

var actor: Node2D
var component: HealthComponent


func before_each() -> void:
	actor = Node2D.new()
	component = HealthComponent.new()
	component.max_health = 10
	actor.add_child(component)
	add_child_autoqfree(actor)


func test_it_health_01_ready_builds_health_from_export() -> void:
	assert_eq(component.health.maximum, 10)


func test_it_health_02_lethal_damage_emits_died() -> void:
	watch_signals(component)
	component.take_damage(10)
	assert_signal_emitted(component, "died")


func test_it_health_03_lethal_damage_frees_the_owner() -> void:
	component.take_damage(10)
	await wait_process_frames(2)
	assert_freed(actor, "actor")


func test_it_health_04_non_lethal_damage_keeps_the_owner() -> void:
	watch_signals(component)
	component.take_damage(5)
	await wait_process_frames(2)
	assert_true(is_instance_valid(actor))
	assert_signal_not_emitted(component, "died")
