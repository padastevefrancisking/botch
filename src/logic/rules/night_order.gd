class_name NightOrder
extends RefCounted

const FIRST_NIGHT: Array[String] = [
	Roles.POISONER,
	Roles.SPY,
	Roles.WASHERWOMAN,
	Roles.LIBRARIAN,
	Roles.INVESTIGATOR,
	Roles.CHEF,
	Roles.EMPATH,
	Roles.FORTUNE_TELLER,
	Roles.BUTLER
]

const OTHER_NIGHTS: Array[String] = [
	Roles.POISONER,
	Roles.MONK,
	Roles.SPY,
	Roles.SCARLET_WOMAN,
	Roles.IMP,
	Roles.RAVENKEEPER,
	Roles.UNDERTAKER,
	Roles.EMPATH,
	Roles.FORTUNE_TELLER,
	Roles.BUTLER
]

static func wake_up_night(ctx, night_number: int) -> void:
	for members in (FIRST_NIGHT if night_number < 2 else OTHER_NIGHTS):
		pass
		

func _find_player_by_role(ctx, role_name: String):
	pass
