class_name PlayerView
extends RefCounted

class PlayerEntry:
	var id: StringName
	var username: String
	var reveal: Reveal
	var seat_no: int
	var is_alive: bool
	var is_departed: bool
	
	func reveal_id() -> StringName:
		return reveal.id() if reveal else &""
		
	func reveal_kind() -> StringName:
		return reveal.kind() if reveal else &""
	

var observer_id: StringName
var players : Array[PlayerEntry]

static func build(state: GameState, observer: PlayerState) -> PlayerView:
	var view := PlayerView.new()
	view.observer_id = observer.id
	for p in state.players:
		var entry := PlayerEntry.new()
		entry.id = p.id
		entry.username = p.username
		entry.seat_no = p.seat_no
		entry.is_alive = p.alive
		entry.is_departed = p.departed
		
		if p == observer:
			entry.reveal = RoleReveal.new(p.shown_role.id)
		
		elif Teams.is_evil(observer.role.team) and Teams.is_evil(p.role.team):
			if p.role.team == Teams.Kind.MINION:
				entry.reveal = TeamReveal.new(p.role.team)
			else:
				entry.reveal = RoleReveal.new(p.shown_role.id)
		
		view.players.append(entry)
	
	return view
