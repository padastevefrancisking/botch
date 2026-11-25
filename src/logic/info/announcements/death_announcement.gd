class_name DeathAnnouncement
extends Announcement

var player_ids: Array[PlayerState]


func _init(players: Array[PlayerState]) -> void:
	player_ids = players.duplicate()


func kind() -> StringName:
	return AnnouncementKind.DEATH_ANNOUNCEMENT


func to_dict() -> Dictionary:
	return {"kind": kind(), "player_ids": player_ids.map(func(p: PlayerState): return p.id)}
