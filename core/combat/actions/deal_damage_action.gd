extends Action
class_name DealDamageAction

##TODO Crear grupo o algun metadata para diferenciar y crear polimorfismo 
var source
var target
var damage: int

func _init(_source,_target,_damage:int) -> void:
	source = _source
	target = _target
	damage = _damage

func execute(game_manager:GameManager) -> void:
	
	target.hp -= damage
	game_manager.emit_event(EventType.DAMAGE_TAKEN, {
		"source": source,
		"target": target,
		"amount": damage
	})
	
	if target.hp <= 0:
		game_manager.emit_event(EventType.ENEMY_KILLED,{
			"enemy": target,
			"killer": source
		})
