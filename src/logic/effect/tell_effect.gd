class_name TellEffect
extends Effect

var info: Info
var may_be_false: bool


func _init(p_info: Info, p_may_be_false: bool) -> void:
	info = p_info
	may_be_false = p_may_be_false


func apply(engine: GameEngine) -> void:
	engine.tell(info, may_be_false)
