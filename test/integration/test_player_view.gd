extends GutTest
## IT-VIEW: PlayerView.build over a real GameState. Who sees what.
## Seats: 0 Demon, 1-2 Minions, 3 Outsider, 4-6 Townsfolk.

const DEMON := 0
const MINIONS := [1, 2]
const GOOD := [3, 4, 5, 6]

var state: GameState


func before_each() -> void:
	state = TestFixtures.game(TestFixtures.SEVEN_PLAYERS)


func _view(seat: int) -> PlayerView:
	return PlayerView.build(state, state.players[seat])


func _entry(view: PlayerView, seat: int) -> PlayerView.PlayerEntry:
	for e in view.players:
		if e.seat_no == seat:
			return e
	return null


func test_it_view_01_one_entry_per_player() -> void:
	var view := _view(4)
	assert_eq(view.players.size(), 7)
	assert_eq(view.observer_id, &"p4")


func test_it_view_02_public_fields_copied() -> void:
	state.players[5].alive = false
	state.players[6].departed = true
	var view := _view(4)
	for p in state.players:
		var e := _entry(view, p.seat_no)
		assert_not_null(e, "seat %d missing" % p.seat_no)
		if e == null:
			continue
		assert_eq(e.id, p.id)
		assert_eq(e.username, p.username)
		assert_eq(e.is_alive, p.alive)
		assert_eq(e.is_departed, p.departed)


func test_it_view_03_player_sees_own_role() -> void:
	var e := _entry(_view(4), 4)
	assert_eq(e.reveal_kind(), Reveal.RevealKind.ROLE)
	assert_eq(e.reveal_id(), state.players[4].role.id)


func test_it_view_04_player_sees_shown_role_not_real_role() -> void:
	var shown := TestFixtures.role(Teams.Kind.TOWNSFOLK, &"ROLE_SHOWN")
	state.players[3] = TestFixtures.player(3, Teams.Kind.OUTSIDER, shown)
	var e := _entry(_view(3), 3)
	assert_eq(e.reveal_id(), &"ROLE_SHOWN")
	assert_ne(e.reveal_id(), state.players[3].role.id)


func test_it_view_05_townsfolk_sees_no_one_else(seat = use_parameters([4, 5, 6])) -> void:
	var view := _view(seat)
	for e in view.players:
		if e.seat_no != seat:
			assert_null(e.reveal, "seat %d leaked to seat %d" % [e.seat_no, seat])


func test_it_view_06_outsider_sees_no_one_else() -> void:
	var view := _view(3)
	for e in view.players:
		if e.seat_no != 3:
			assert_null(e.reveal, "seat %d leaked to the Outsider" % e.seat_no)


func test_it_view_07_demon_sees_minions_as_team_only() -> void:
	var view := _view(DEMON)
	for seat in MINIONS:
		var e := _entry(view, seat)
		assert_eq(e.reveal_kind(), Reveal.RevealKind.TEAM, "seat %d" % seat)
		assert_eq(e.reveal_id(), Teams.get_id(Teams.Kind.MINION), "seat %d" % seat)


func test_it_view_08_minion_sees_demon_role() -> void:
	var e := _entry(_view(1), DEMON)
	assert_eq(e.reveal_kind(), Reveal.RevealKind.ROLE)
	assert_eq(e.reveal_id(), state.players[DEMON].role.id)


func test_it_view_09_minion_sees_other_minion_as_team() -> void:
	var e := _entry(_view(1), 2)
	assert_eq(e.reveal_kind(), Reveal.RevealKind.TEAM)
	assert_eq(e.reveal_id(), Teams.get_id(Teams.Kind.MINION))


func test_it_view_10_evil_sees_no_good_roles(observer = use_parameters([0, 1, 2])) -> void:
	var view := _view(observer)
	for seat in GOOD:
		assert_null(_entry(view, seat).reveal, "seat %d leaked to seat %d" % [seat, observer])


func test_it_view_11_reveals_are_true(observer = use_parameters([0, 1, 2])) -> void:
	var view := _view(observer)
	for e in view.players:
		if e.reveal:
			var p := state.find_player_by_id(e.id)
			if e.seat_no == observer:
				continue  # own entry shows the shown role, covered by IT-VIEW-03/04
			assert_true(e.reveal.matches(p), "reveal on seat %d is false" % e.seat_no)


func test_it_view_12_dead_evil_still_known() -> void:
	state.players[2].alive = false
	var e := _entry(_view(DEMON), 2)
	assert_eq(e.reveal_id(), Teams.get_id(Teams.Kind.MINION))
	assert_false(e.is_alive)


func test_it_view_13_building_a_view_changes_nothing() -> void:
	state.players[5].statuses[&"hexed"] = true
	var before := _snapshot()
	for p in state.players:
		PlayerView.build(state, p)
	assert_eq(_snapshot(), before)


func test_it_view_14_views_are_separate() -> void:
	var a := _view(DEMON)
	var b := _view(4)
	for i in a.players.size():
		assert_not_same(a.players[i], b.players[i], "entry %d is shared" % i)


func _snapshot() -> Array:
	var out := []
	for p in state.players:
		out.append([p.id, p.seat_no, p.alive, p.departed, p.statuses.duplicate()])
	return out
