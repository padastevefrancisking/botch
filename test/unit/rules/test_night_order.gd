extends GutTest
## UT-NIGHT: src/logic/rules/night_order.gd. Checks the lists are well formed.


func _duplicates(list: Array) -> Array:
	var seen := {}
	var dupes := []
	for id in list:
		if seen.has(id):
			dupes.append(id)
		seen[id] = true
	return dupes


func test_ut_night_01_first_night_has_no_duplicates() -> void:
	assert_eq(_duplicates(NightOrder.FIRST_NIGHT), [])


func test_ut_night_02_other_nights_have_no_duplicates() -> void:
	assert_eq(_duplicates(NightOrder.OTHER_NIGHTS), [])


func test_ut_night_03_every_entry_is_a_known_role() -> void:
	var known: Array = load("res://constants/players/roles.gd").get_script_constant_map().values()
	for id in NightOrder.FIRST_NIGHT + NightOrder.OTHER_NIGHTS:
		assert_has(known, id, "%s is not in Roles" % id)


func test_ut_night_04_lists_are_not_empty() -> void:
	assert_gt(NightOrder.FIRST_NIGHT.size(), 0)
	assert_gt(NightOrder.OTHER_NIGHTS.size(), 0)
