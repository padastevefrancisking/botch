class_name TestFixtures
extends RefCounted
## Builders for role-agnostic test data. No `test_` prefix, so GUT does not run it.

## Team layout of the standard 7-player game: Demon, 2 Minions, 1 Outsider, 3 Townsfolk.
const SEVEN_PLAYERS := [
	Teams.Kind.DEMON,
	Teams.Kind.MINION,
	Teams.Kind.MINION,
	Teams.Kind.OUTSIDER,
	Teams.Kind.TOWNSFOLK,
	Teams.Kind.TOWNSFOLK,
	Teams.Kind.TOWNSFOLK,
]


## A role on [param team]. Without an id, one is made from the team.
static func role(team: Teams.Kind, id: StringName = &"") -> RoleDef:
	var rid: StringName = id
	if rid == &"":
		rid = StringName("ROLE_TEST_" + String(Teams.Kind.find_key(team)))
	return RoleDef.new(rid, String(rid), team, null)


## A player in [param seat] with a unique role on [param team]. Id is "p<seat>".
static func player(
	seat: int, team: Teams.Kind = Teams.Kind.TOWNSFOLK, shown: RoleDef = null
) -> PlayerState:
	var real := role(team, StringName("ROLE_TEST_%d" % seat))
	var shown_role := shown if shown != null else real
	return PlayerState.new(StringName("p%d" % seat), "Player %d" % seat, seat, real, shown_role)


## A game with one player per entry of [param teams]; the index is the seat number.
static func game(teams: Array) -> GameState:
	var state := GameState.new()
	for seat in teams.size():
		state.players.append(player(seat, teams[seat]))
	return state


## A game of [param count] Townsfolk.
static func town(count: int) -> GameState:
	var teams := []
	teams.resize(count)
	teams.fill(Teams.Kind.TOWNSFOLK)
	return game(teams)


## Sorted seat numbers of [param players], for order-free comparisons.
static func seats(players: Array) -> Array:
	var out := []
	for p in players:
		out.append(p.seat_no)
	out.sort()
	return out
