class_name GameState
extends RefCounted

enum Phase { SETUP, NIGHT, DAY, OVER }

var players: Array[PlayerState]
var phase: Phase = Phase.SETUP
var day_number := 0
var night_number := 0
var result : GameResult

func living_players() -> Array[PlayerState]:
	return []

func find_player_by_id(id: StringName) -> PlayerState:
	for p in players:
		if p.id == id:
			return p

	return null

func living_neighbours(p: PlayerState) -> Array[PlayerState]:
	var ps = players.duplicate()
	ps.sort_custom(
		func(a: PlayerState, b: PlayerState):
			return a.seat_no < b.seat_no
	)

	var n := ps.size()
	var idx := ps.find(p)

	var out: Array[PlayerState]
	var directions: Array[int] = [-1, 1]
	for d in directions:
		for i in range (1, n):
			var q: PlayerState = ps.get(posmod(idx+(d*i), n))
			if q.is_in_play():
				if not out.has(q):
					out.append(q)
				break

	return out
