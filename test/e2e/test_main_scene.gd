extends GutTest
## E2E layer: boot the real main scene and drive it like a player would.
## Add flows here as the game grows (start -> play -> win/lose), using
## InputSender to press real input actions.

var main: Node
var sender = InputSender.new(Input)


func before_each() -> void:
	var path: String = ProjectSettings.get_setting("application/run/main_scene")
	main = load(path).instantiate()
	add_child_autoqfree(main)


func after_each() -> void:
	sender.release_all()
	sender.clear()


func test_main_scene_boots() -> void:
	assert_not_null(main)
	assert_true(main.is_inside_tree())


func test_survives_a_second_of_play() -> void:
	await wait_seconds(1.0)
	assert_true(is_instance_valid(main))
