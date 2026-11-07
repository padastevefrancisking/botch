extends GutTest
## Unit layer: pure logic only, no scene tree.

var health: Health


func before_each() -> void:
	health = Health.new(100)


func test_starts_at_max() -> void:
	assert_eq(health.current, 100)


func test_damage_reduces_health() -> void:
	health.take_damage(30)
	assert_eq(health.current, 70)


func test_damage_never_goes_below_zero() -> void:
	health.take_damage(999)
	assert_eq(health.current, 0)


func test_heal_never_exceeds_max() -> void:
	health.take_damage(10)
	health.heal(50)
	assert_eq(health.current, 100)


func test_negative_amounts_are_ignored(amount = use_parameters([-5, 0])) -> void:
	health.take_damage(amount)
	health.heal(amount)
	assert_eq(health.current, 100)


func test_emits_died_once_when_reaching_zero() -> void:
	watch_signals(health)
	health.take_damage(100)
	health.take_damage(10)
	assert_signal_emit_count(health, "died", 1)


func test_cannot_heal_when_dead() -> void:
	health.take_damage(100)
	health.heal(50)
	assert_true(health.is_dead())
