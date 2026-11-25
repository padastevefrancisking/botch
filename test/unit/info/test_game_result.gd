extends GutTest
## UT-RESULT: src/logic/info/result/game_result.gd


func test_ut_result_01_good_win_stores_winners() -> void:
	var winners: Array[PlayerState] = [TestFixtures.player(0), TestFixtures.player(1)]
	var result := GameResult.new(true, winners)
	assert_true(result.good_won)
	assert_eq(result.winners, winners)


func test_ut_result_02_evil_win_stores_winners() -> void:
	var winners: Array[PlayerState] = [TestFixtures.player(2, Teams.Kind.DEMON)]
	var result := GameResult.new(false, winners)
	assert_false(result.good_won)
	assert_eq(result.winners.size(), 1)
	assert_same(result.winners[0], winners[0])


func test_ut_result_03_empty_winners_allowed() -> void:
	var none: Array[PlayerState] = []
	var result := GameResult.new(true, none)
	assert_eq(result.winners.size(), 0)
