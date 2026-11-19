extends GutTest
## UT-STATE-07..20: GameState.living_neighbours. Seats form a ring.


func _neighbour_seats(state: GameState, seat: int) -> Array:
	return TestFixtures.seats(state.living_neighbours(state.players[seat]))


func _kill(state: GameState, seats: Array) -> void:
	for s in seats:
		state.players[s].alive = false


func test_ut_state_07_middle_seat_all_alive() -> void:
	assert_eq(_neighbour_seats(TestFixtures.town(5), 2), [1, 3])


func test_ut_state_08_wraps_around_from_first_seat() -> void:
	assert_eq(_neighbour_seats(TestFixtures.town(5), 0), [1, 4])


func test_ut_state_09_last_seat_wraps_to_first() -> void:
	assert_eq(_neighbour_seats(TestFixtures.town(5), 4), [0, 3])


func test_ut_state_10_uses_seat_order_not_list_order() -> void:
	var state := GameState.new()
	for seat in [3, 0, 4, 2, 1]:
		state.players.append(TestFixtures.player(seat))
	var seat_two := state.find_player_by_id(&"p2")
	assert_eq(TestFixtures.seats(state.living_neighbours(seat_two)), [1, 3])


func test_ut_state_11_skips_dead_player() -> void:
	var state := TestFixtures.town(5)
	_kill(state, [3])
	assert_eq(_neighbour_seats(state, 2), [1, 4])


func test_ut_state_12_skips_departed_player() -> void:
	var state := TestFixtures.town(5)
	state.players[1].departed = true
	assert_eq(_neighbour_seats(state, 2), [0, 3])


func test_ut_state_13_skips_several_in_a_row() -> void:
	var state := TestFixtures.town(7)
	_kill(state, [3, 4, 5])
	assert_eq(_neighbour_seats(state, 2), [1, 6])


func test_ut_state_14_two_players_in_play() -> void:
	var state := TestFixtures.town(5)
	_kill(state, [1, 3, 4])
	var out := state.living_neighbours(state.players[0])
	assert_eq(out.size(), 1, "the only other player should be listed once")
	assert_eq(TestFixtures.seats(out), [2])


func test_ut_state_15_nobody_else_in_play() -> void:
	var state := TestFixtures.town(5)
	_kill(state, [1, 2, 3, 4])
	assert_eq(_neighbour_seats(state, 0), [])


func test_ut_state_16_one_player_game() -> void:
	assert_eq(_neighbour_seats(TestFixtures.town(1), 0), [])


func test_ut_state_17_target_is_dead() -> void:
	var state := TestFixtures.town(5)
	_kill(state, [2])
	assert_eq(_neighbour_seats(state, 2), [1, 3])


func test_ut_state_18_does_not_reorder_players() -> void:
	var state := GameState.new()
	for seat in [3, 0, 4, 2, 1]:
		state.players.append(TestFixtures.player(seat))
	state.living_neighbours(state.players[0])
	var order := []
	for p in state.players:
		order.append(p.seat_no)
	assert_eq(order, [3, 0, 4, 2, 1])


func test_ut_state_19_never_includes_target() -> void:
	var state := TestFixtures.town(5)
	for p in state.players:
		assert_does_not_have(state.living_neighbours(p), p, "seat %d" % p.seat_no)


func test_ut_state_20_at_most_two_neighbours() -> void:
	var state := TestFixtures.town(9)
	for p in state.players:
		assert_eq(state.living_neighbours(p).size(), 2, "seat %d" % p.seat_no)
