extends GutTest
## E2E-BOOT: boot the real main scene and drive it like a player would.
## Add flows here as the game grows (start -> play -> win/lose), using
## InputSender to press real input actions.

var main: Node
var sender = InputSender.new(Input)


func before_each() -> void:
	main = load(_main_scene_path()).instantiate()
	add_child_autoqfree(main)


func after_each() -> void:
	sender.release_all()
	sender.clear()


func _main_scene_path() -> String:
	return ProjectSettings.get_setting("application/run/main_scene", "")


func test_e2e_boot_01_main_scene_is_set() -> void:
	var path := _main_scene_path()
	assert_ne(path, "", "application/run/main_scene is not set")
	assert_is(load(path), PackedScene)


func test_e2e_boot_02_main_scene_boots() -> void:
	assert_not_null(main)
	assert_true(main.is_inside_tree())


func test_e2e_boot_03_survives_a_second_of_play() -> void:
	await wait_seconds(1.0)
	assert_true(is_instance_valid(main))


func test_e2e_boot_04_boots_without_errors() -> void:
	await wait_seconds(1.0)
	assert_engine_error_count(0, "engine errors while running the main scene")
	assert_push_error_count(0, "push_error calls while running the main scene")


func test_e2e_boot_05_clean_teardown() -> void:
	main.queue_free()
	await wait_process_frames(2)
	assert_freed(main, "main scene")
	assert_engine_error_count(0, "engine errors while freeing the main scene")
