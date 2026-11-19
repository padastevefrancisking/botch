extends GutTest
## UT-HEALTH: src/logic/health.gd. Pure logic only, no scene tree.

var health: Health


func before_each() -> void:
	health = Health.new(100)


func test_ut_health_01_starts_at_max() -> void:
	assert_eq(health.current, 100)


func test_ut_health_02_damage_reduces_health() -> void:
	health.take_damage(30)
	assert_eq(health.current, 70)


func test_ut_health_03_damage_never_goes_below_zero() -> void:
	health.take_damage(999)
	assert_eq(health.current, 0)


func test_ut_health_04_heal_never_exceeds_max() -> void:
	health.take_damage(10)
	health.heal(50)
	assert_eq(health.current, 100)


func test_ut_health_05_non_positive_amounts_are_ignored(amount = use_parameters([-5, 0])) -> void:
	health.take_damage(amount)
	health.heal(amount)
	assert_eq(health.current, 100)


func test_ut_health_06_emits_died_once_when_reaching_zero() -> void:
	watch_signals(health)
	health.take_damage(100)
	health.take_damage(10)
	assert_signal_emit_count(health, "died", 1)


func test_ut_health_07_cannot_heal_when_dead() -> void:
	health.take_damage(100)
	health.heal(50)
	assert_true(health.is_dead())


func test_ut_health_08_changed_carries_values() -> void:
	watch_signals(health)
	health.take_damage(30)
	assert_signal_emitted_with_parameters(health, "changed", [70, 100])


func test_ut_health_09_max_is_at_least_one(max_health = use_parameters([0, -10])) -> void:
	var h := Health.new(max_health)
	assert_eq(h.maximum, 1)
	assert_eq(h.current, 1)


func test_ut_health_10_ignored_amounts_emit_nothing() -> void:
	watch_signals(health)
	health.take_damage(0)
	health.heal(-5)
	assert_signal_not_emitted(health, "changed")


func test_ut_health_11_alive_at_start() -> void:
	assert_false(health.is_dead())
