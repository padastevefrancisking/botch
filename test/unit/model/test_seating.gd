extends GutTest
## UT-SEAT: living neighbours as a game goes on.


func _seats_of(state: GameState, seat: int) -> Array:
	return TestFixtures.seats(state.living_neighbours(state.players[seat]))


func test_ut_seat_01_neighbours_update_as_players_die() -> void:
	var state := TestFixtures.town(7)
	var steps := [[1, [2, 6]], [6, [2, 5]], [2, [3, 5]], [5, [3, 4]]]
	for step in steps:
		state.players[step[0]].alive = false
		assert_eq(_seats_of(state, 0), step[1], "after seat %d died" % step[0])


func test_ut_seat_02_rule_40_departed_counts_like_dead() -> void:
	var killed := TestFixtures.town(7)
	killed.players[1].alive = false
	var departed := TestFixtures.town(7)
	departed.players[1].departed = true
	assert_eq(_seats_of(departed, 0), _seats_of(killed, 0))


func test_ut_seat_03_neighbours_are_mutual() -> void:
	var state := TestFixtures.town(9)
	for s in [1, 4, 5, 8]:
		state.players[s].alive = false
	state.players[6].departed = true
	for a in state.players:
		if not a.is_in_play():
			continue
		for b in state.living_neighbours(a):
			assert_has(
				state.living_neighbours(b), a, "seat %d -> %d not mutual" % [a.seat_no, b.seat_no]
			)


func test_ut_seat_04_revived_player_is_neighbour_again() -> void:
	var state := TestFixtures.town(5)
	state.players[1].alive = false
	assert_eq(_seats_of(state, 0), [2, 4])
	state.players[1].alive = true
	assert_eq(_seats_of(state, 0), [1, 4])
