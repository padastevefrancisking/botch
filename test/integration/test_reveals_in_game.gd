extends GutTest
## IT-REVEAL: reveals checked against every player in a game.

var state: GameState


func before_each() -> void:
	state = TestFixtures.game(TestFixtures.SEVEN_PLAYERS)


func _count(reveal: Reveal) -> int:
	var n := 0
	for p in state.players:
		if reveal.matches(p):
			n += 1
	return n


func test_it_reveal_01_team_reveal_counts() -> void:
	assert_eq(_count(TeamReveal.new(Teams.Kind.TOWNSFOLK)), 3)
	assert_eq(_count(TeamReveal.new(Teams.Kind.OUTSIDER)), 1)
	assert_eq(_count(TeamReveal.new(Teams.Kind.MINION)), 2)
	assert_eq(_count(TeamReveal.new(Teams.Kind.DEMON)), 1)


func test_it_reveal_02_role_reveal_hits_one_player() -> void:
	for target in state.players:
		var reveal := RoleReveal.new(target.role.id)
		for p in state.players:
			assert_eq(reveal.matches(p), p == target, "%s vs seat %d" % [target.role.id, p.seat_no])


func test_it_reveal_03_exactly_one_demon() -> void:
	assert_eq(_count(TeamReveal.new(Teams.Kind.DEMON)), 1)
