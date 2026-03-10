extends EntityState
class_name  EntityDamagable

var hp:int

func _init(_data:EntityData,_position) -> void:
	super(_data,_position)
	hp = _data.max_hp

func take_damage(amount) -> int :
	return hp


func attack(player: Player):
	pass
