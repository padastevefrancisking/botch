extends GutTest
## UT-ROLEDEF: src/logic/model/role_def.gd


func test_ut_roledef_01_constructor_stores_fields() -> void:
	var ability := Ability.new()
	var role := RoleDef.new(&"ROLE_X", "X", Teams.Kind.MINION, ability)
	assert_eq(role.id, &"ROLE_X")
	assert_eq(role.display_name, "X")
	assert_eq(role.team, Teams.Kind.MINION)
	assert_same(role.ability, ability)


func test_ut_roledef_02_null_ability_allowed() -> void:
	var role := RoleDef.new(&"ROLE_X", "X", Teams.Kind.TOWNSFOLK, null)
	assert_not_null(role)
	assert_null(role.ability)


func test_ut_roledef_03_each_team_can_be_stored(kind = use_parameters(Teams.Kind.values())) -> void:
	var role := RoleDef.new(&"ROLE_X", "X", kind, null)
	assert_eq(role.team, kind)
