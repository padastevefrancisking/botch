@abstract class_name Announcement
extends RefCounted


class AnnouncementKind:
	const DEATH_ANNOUNCEMENT := &"ANNOUNCEMENT_DEATH"
	const NO_DEATH_ANNOUNCEMENT := &"ANNOUNCEMENT_NODEATH"


@abstract func kind() -> StringName
@abstract func to_dict() -> Dictionary
