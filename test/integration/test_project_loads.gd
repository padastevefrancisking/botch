extends GutTest
## IT-LOAD: every script and scene in the project loads.


func _files(dir_path: String, extension: String) -> Array:
	var out := []
	var dir := DirAccess.open(dir_path)
	if dir == null:
		return out
	for file in dir.get_files():
		if file.get_extension() == extension:
			out.append(dir_path.path_join(file))
	for sub in dir.get_directories():
		out.append_array(_files(dir_path.path_join(sub), extension))
	return out


func test_it_load_01_all_scripts_load() -> void:
	var scripts := _files("res://src", "gd") + _files("res://constants", "gd")
	assert_gt(scripts.size(), 0, "no scripts found")
	for path in scripts:
		assert_not_null(load(path), path)


func test_it_load_02_all_scenes_instantiate() -> void:
	var scenes := _files("res://scenes", "tscn")
	assert_gt(scenes.size(), 0, "no scenes found")
	for path in scenes:
		var packed: PackedScene = load(path)
		assert_not_null(packed, path)
		if packed:
			var node := packed.instantiate()
			assert_not_null(node, path)
			autofree(node)
