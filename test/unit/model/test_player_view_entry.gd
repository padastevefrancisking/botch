extends GutTest
## UT-VIEW: PlayerView.PlayerEntry helpers (src/logic/model/player_view.gd)

var entry: PlayerView.PlayerEntry


func before_each() -> void:
	entry = PlayerView.PlayerEntry.new()


func test_ut_view_01_net_07_no_reveal_gives_empty_id() -> void:
	assert_eq(entry.reveal_id(), &"")


func test_ut_view_02_net_07_no_reveal_gives_empty_kind() -> void:
	assert_eq(entry.reveal_kind(), &"")


func test_ut_view_03_role_reveal_passes_through() -> void:
	entry.reveal = RoleReveal.new(&"ROLE_A")
	assert_eq(entry.reveal_id(), &"ROLE_A")
	assert_eq(entry.reveal_kind(), Reveal.RevealKind.ROLE)


func test_ut_view_04_team_reveal_passes_through() -> void:
	entry.reveal = TeamReveal.new(Teams.Kind.MINION)
	assert_eq(entry.reveal_id(), &"TEAM_MINION")
	assert_eq(entry.reveal_kind(), Reveal.RevealKind.TEAM)
