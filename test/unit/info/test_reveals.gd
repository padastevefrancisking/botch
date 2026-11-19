extends GutTest
## UT-REVEAL: src/logic/info/reveal/role_reveal.gd and team_reveal.gd


func test_ut_reveal_01_role_reveal_kind() -> void:
	assert_eq(RoleReveal.new(&"ROLE_A").kind(), Reveal.RevealKind.ROLE)


func test_ut_reveal_02_role_reveal_id() -> void:
	assert_eq(RoleReveal.new(&"ROLE_A").id(), &"ROLE_A")


func test_ut_reveal_03_role_reveal_matches_same_role() -> void:
	var p := TestFixtures.player(0)
	assert_true(RoleReveal.new(p.role.id).matches(p))


func test_ut_reveal_04_role_reveal_rejects_other_role() -> void:
	var p := TestFixtures.player(0)
	assert_false(RoleReveal.new(&"ROLE_SOMETHING_ELSE").matches(p))


func test_ut_reveal_05_role_reveal_uses_real_role() -> void:
	var shown := TestFixtures.role(Teams.Kind.TOWNSFOLK, &"ROLE_SHOWN")
	var p := TestFixtures.player(0, Teams.Kind.OUTSIDER, shown)
	assert_true(RoleReveal.new(p.role.id).matches(p), "real role should match")
	assert_false(RoleReveal.new(&"ROLE_SHOWN").matches(p), "shown role should not match")


func test_ut_reveal_06_team_reveal_kind() -> void:
	assert_eq(TeamReveal.new(Teams.Kind.MINION).kind(), Reveal.RevealKind.TEAM)


func test_ut_reveal_07_team_reveal_id(kind = use_parameters(Teams.Kind.values())) -> void:
	assert_eq(TeamReveal.new(kind).id(), Teams.get_id(kind))


func test_ut_reveal_08_team_reveal_matches_same_team() -> void:
	var p := TestFixtures.player(0, Teams.Kind.MINION)
	assert_true(TeamReveal.new(Teams.Kind.MINION).matches(p))


func test_ut_reveal_09_team_reveal_rejects_other_team() -> void:
	var p := TestFixtures.player(0, Teams.Kind.TOWNSFOLK)
	assert_false(TeamReveal.new(Teams.Kind.MINION).matches(p))


func test_ut_reveal_10_team_reveal_uses_real_team() -> void:
	var shown := TestFixtures.role(Teams.Kind.TOWNSFOLK)
	var p := TestFixtures.player(0, Teams.Kind.OUTSIDER, shown)
	assert_true(TeamReveal.new(Teams.Kind.OUTSIDER).matches(p), "real team should match")
	assert_false(TeamReveal.new(Teams.Kind.TOWNSFOLK).matches(p), "shown team should not match")


func test_ut_reveal_11_reveals_are_reveal_instances() -> void:
	assert_is(RoleReveal.new(&"ROLE_A"), Reveal)
	assert_is(TeamReveal.new(Teams.Kind.DEMON), Reveal)
