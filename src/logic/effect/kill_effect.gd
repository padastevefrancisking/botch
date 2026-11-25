class_name KillEffect
extends Effect

var actor: PlayerState
var target: PlayerState
var cause: StringName


func _init(p_actor: PlayerState, p_target: PlayerState, p_cause: StringName) -> void:
	actor = p_actor
	target = p_target
	cause = p_cause


func apply(engine: GameEngine) -> void:
	if not target.is_in_play():
		return

	if cause == Causes.DEMON:
		if target.has_status(Statuses.PROTECTED):
			return

		var attack_query := engine.ask(AttackQuery.new(actor, target)) as AttackQuery
		if attack_query.prevented:
			engine.apply(attack_query.consequences)
			return

	target.alive = false
	engine.emit(DeathEvent.new(target, cause))
