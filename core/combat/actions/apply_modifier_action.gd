extends Action
class_name ApplyModifierAction

## Action para agregar un modifier a un target 

var target
var modifier: Modifier

func _init(_target,_modifier:Modifier) -> void:
	target = _target
	modifier = _modifier

func execute(game_magener:GameManager) -> void:
	target.add_modifier(modifier)
