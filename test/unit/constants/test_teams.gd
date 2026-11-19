extends GutTest
## UT-TEAM: constants/players/teams.gd


func test_ut_team_01_good_teams_are_not_evil(
	kind = use_parameters([Teams.Kind.TOWNSFOLK, Teams.Kind.OUTSIDER])
) -> void:
	assert_false(Teams.is_evil(kind))


func test_ut_team_02_evil_teams_are_evil(
	kind = use_parameters([Teams.Kind.MINION, Teams.Kind.DEMON])
) -> void:
	assert_true(Teams.is_evil(kind))


func test_ut_team_03_id_format() -> void:
	assert_eq(Teams.get_id(Teams.Kind.TOWNSFOLK), &"TEAM_TOWNSFOLK")
	assert_eq(Teams.get_id(Teams.Kind.OUTSIDER), &"TEAM_OUTSIDER")
	assert_eq(Teams.get_id(Teams.Kind.MINION), &"TEAM_MINION")
	assert_eq(Teams.get_id(Teams.Kind.DEMON), &"TEAM_DEMON")


func test_ut_team_04_ids_are_unique() -> void:
	var ids := {}
	for kind in Teams.Kind.values():
		ids[Teams.get_id(kind)] = true
	assert_eq(ids.size(), Teams.Kind.size())


func test_ut_team_05_id_is_string_name() -> void:
	assert_typeof(Teams.get_id(Teams.Kind.TOWNSFOLK), TYPE_STRING_NAME)
