class_name NoDeathAnnouncement
extends Announcement


func kind() -> StringName:
	return AnnouncementKind.NO_DEATH_ANNOUNCEMENT


func to_dict() -> Dictionary:
	return {"kind": kind()}
