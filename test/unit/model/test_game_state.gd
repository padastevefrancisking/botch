extends GutTest
## UT-STATE-01..06: src/logic/model/game_state.gd (defaults and lookup)


func test_ut_state_01_defaults() -> void:
	var state := GameState.new()
	assert_eq(state.phase, GameState.Phase.SETUP)
	assert_eq(state.day_number, 0)
	assert_eq(state.night_number, 0)
	assert_null(state.result)
	assert_eq(state.players.size(), 0)


func test_ut_state_02_find_player_by_id() -> void:
	var state := TestFixtures.town(5)
	assert_same(state.find_player_by_id(&"p2"), state.players[2])


func test_ut_state_03_unknown_id_returns_null() -> void:
	var state := TestFixtures.town(5)
	assert_null(state.find_player_by_id(&"nobody"))


func test_ut_state_04_empty_game_returns_null() -> void:
	assert_null(GameState.new().find_player_by_id(&"p0"))


func test_ut_state_05_duplicate_ids_return_first() -> void:
	var state := GameState.new()
	var first := TestFixtures.player(0)
	var second := TestFixtures.player(0)
	state.players.append(first)
	state.players.append(second)
	assert_same(state.find_player_by_id(&"p0"), first)


func test_ut_state_06_lookup_finds_dead_players() -> void:
	var state := TestFixtures.town(5)
	state.players[2].alive = false
	assert_same(state.find_player_by_id(&"p2"), state.players[2])
