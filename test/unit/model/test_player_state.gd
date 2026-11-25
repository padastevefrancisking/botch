extends GutTest
## UT-PLAYER: src/logic/model/player_state.gd

var player: PlayerState


func before_each() -> void:
	player = TestFixtures.player(0)


func test_ut_player_01_constructor_stores_fields() -> void:
	var role := TestFixtures.role(Teams.Kind.OUTSIDER, &"ROLE_REAL")
	var shown := TestFixtures.role(Teams.Kind.TOWNSFOLK, &"ROLE_SHOWN")
	var p := PlayerState.new(&"p1", "Ann", 3, role, shown)
	assert_eq(p.id, &"p1")
	assert_eq(p.username, "Ann")
	assert_eq(p.seat_no, 3)
	assert_same(p.role, role)
	assert_same(p.shown_role, shown)


func test_ut_player_02_defaults() -> void:
	assert_true(player.alive)
	assert_true(player.has_ghost_vote)
	assert_false(player.departed)
	assert_eq(player.statuses, {})


func test_ut_player_03_missing_status_is_false() -> void:
	assert_false(player.has_status(&"hexed"))


func test_ut_player_04_set_status_is_true() -> void:
	player.statuses[&"hexed"] = true
	assert_true(player.has_status(&"hexed"))


func test_ut_player_05_cleared_status_is_false() -> void:
	player.statuses[&"hexed"] = false
	assert_false(player.has_status(&"hexed"))


func test_ut_player_06_statuses_are_independent() -> void:
	player.statuses[&"hexed"] = true
	assert_false(player.has_status(&"protected"))


func test_ut_player_07_rule_40_in_play_when_alive_and_present() -> void:
	assert_true(player.is_in_play())


func test_ut_player_08_rule_40_not_in_play_when_dead() -> void:
	player.alive = false
	assert_false(player.is_in_play())


func test_ut_player_09_rule_40_not_in_play_when_departed() -> void:
	player.departed = true
	assert_false(player.is_in_play())


func test_ut_player_10_rule_40_not_in_play_when_dead_and_departed() -> void:
	player.alive = false
	player.departed = true
	assert_false(player.is_in_play())


func test_ut_player_11_rule_08_shown_role_can_differ() -> void:
	var shown := TestFixtures.role(Teams.Kind.TOWNSFOLK, &"ROLE_SHOWN")
	var p := TestFixtures.player(1, Teams.Kind.OUTSIDER, shown)
	assert_eq(p.role.team, Teams.Kind.OUTSIDER)
	assert_eq(p.shown_role.id, &"ROLE_SHOWN")
	assert_ne(p.role.id, p.shown_role.id)


func test_ut_player_12_players_do_not_share_statuses() -> void:
	var other := TestFixtures.player(1)
	player.statuses[&"hexed"] = true
	assert_eq(other.statuses, {})
