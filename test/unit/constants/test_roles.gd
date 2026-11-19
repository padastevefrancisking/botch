extends GutTest
## UT-ROLEID: constants/players/roles.gd. Checks the id list only, not role behaviour.

var ids: Dictionary


func before_all() -> void:
	ids = load("res://constants/players/roles.gd").get_script_constant_map()


func test_ut_roleid_01_ids_are_not_empty() -> void:
	assert_gt(ids.size(), 0, "Roles should define at least one id")
	for name in ids:
		assert_ne(String(ids[name]), "", "%s is empty" % name)


func test_ut_roleid_02_ids_are_unique() -> void:
	var seen := {}
	for name in ids:
		var value := String(ids[name])
		assert_false(seen.has(value), "%s reuses %s from %s" % [name, value, seen.get(value)])
		seen[value] = name


func test_ut_roleid_03_ids_use_role_prefix() -> void:
	for name in ids:
		assert_string_starts_with(String(ids[name]), "ROLE_", name)


func test_ut_roleid_04_id_format() -> void:
	var pattern := RegEx.create_from_string("^ROLE_[A-Z]+$")
	for name in ids:
		var value := String(ids[name])
		assert_not_null(pattern.search(value), "%s = %s" % [name, value])
