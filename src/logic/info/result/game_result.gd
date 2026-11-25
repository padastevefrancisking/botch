class_name GameResult
extends RefCounted

var good_won: bool
var winners: Array[PlayerState]


func _init(g_good_won: bool, g_winners: Array[PlayerState]):
	good_won = g_good_won
	winners = g_winners
